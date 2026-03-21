/// Chat detail screen for individual conversations.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_template/features/chat/domain/entities/chat_message.dart';
import 'package:flutter_project_template/features/chat/presentation/providers/ai_config_provider.dart';
import 'package:flutter_project_template/features/chat/presentation/providers/chat_provider.dart';
import 'package:flutter_project_template/features/chat/presentation/widgets/chat_input_field.dart';
import 'package:flutter_project_template/features/chat/presentation/widgets/message_bubble.dart';
import 'package:flutter_project_template/features/chat/presentation/widgets/typing_indicator.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

/// Chat detail screen.
class ChatDetailScreen extends ConsumerStatefulWidget {
  /// Creates the chat detail screen.
  const ChatDetailScreen({
    required this.conversationId,
    super.key,
  });

  /// The ID of the conversation.
  final String conversationId;

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final _scrollController = ScrollController();
  String? _streamingMessageId;
  String _streamingContent = '';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final conversation = ref.watch(chatNotifierProvider).when(
          data: (state) => state.conversations
              .where((c) => c.id == widget.conversationId)
              .firstOrNull,
          loading: () => null,
          error: (_, __) => null,
        );
    final isTyping = ref.watch(isTypingProvider);
    final aiConfig =
        ref.watch(aIConfigNotifierProvider).valueOrNull?.defaultConfig;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              conversation?.title ?? localizations.chat,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            if (aiConfig != null)
              Text(
                aiConfig.name,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? const Color(0xFF64748B)
                      : const Color(0xFF94A3B8),
                ),
              ),
          ],
        ),
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
          ),
          onPressed: context.pop,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
            ),
            onPressed: () => _showOptionsMenu(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: conversation == null
                ? const Center(child: CircularProgressIndicator())
                : _buildMessagesList(
                    conversation, isDark, localizations, isTyping),
          ),
          if (aiConfig == null)
            _buildNoConfigBanner(context, localizations, isDark),
          ChatInputField(
            onSend: _sendMessage,
            hintText: localizations.typeMessage,
            enabled: aiConfig != null,
          ),
        ],
      ),
    );
  }

  Widget _buildNoConfigBanner(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: const Color(0xFF8B5CF6),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              localizations.noAIConfigMessage,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
          ),
          TextButton(
            onPressed: () => context.push('/settings/ai-config'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF8B5CF6),
            ),
            child: Text(localizations.configureAI),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(
    ChatConversation conversation,
    bool isDark,
    AppLocalizations localizations,
    bool isTyping,
  ) {
    final messages = conversation.messages;

    if (messages.isEmpty && !isTyping) {
      return _buildEmptyState(isDark, localizations);
    }

    // Scroll to bottom after build
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    final itemCount = messages.length + (isTyping ? 1 : 0);

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // Show typing indicator at the end
        if (isTyping && index == messages.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TypingIndicator(),
          );
        }

        final message = messages[index];
        // Show streaming content for the AI message being generated
        if (message.id == _streamingMessageId && _streamingContent.isNotEmpty) {
          final streamingMessage = ChatMessage(
            id: message.id,
            content: _streamingContent,
            sender: message.sender,
            timestamp: message.timestamp,
            status: MessageStatus.sending,
          );
          return MessageBubble(
            message: streamingMessage,
            showTimestamp: false,
            onLongPress: () => _showMessageMenu(
              context,
              streamingMessage,
              isUserMessage: false,
            ),
          );
        }
        return MessageBubble(
          message: message,
          showTimestamp: index == messages.length - 1 ||
              _shouldShowTimestamp(messages, index),
          onLongPress: message.isFromAI
              ? () => _showMessageMenu(context, message, isUserMessage: false)
              : () => _showMessageMenu(context, message, isUserMessage: true),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDark, AppLocalizations localizations) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.smart_toy_outlined,
                size: 40,
                color: Color(0xFF8B5CF6),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              localizations.startConversation,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              localizations.sendMessageToBegin,
              style: TextStyle(
                fontSize: 14,
                color:
                    isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      );

  bool _shouldShowTimestamp(List<ChatMessage> messages, int index) {
    if (index == messages.length - 1) return true;
    final currentMessage = messages[index];
    final nextMessage = messages[index + 1];
    final difference =
        nextMessage.timestamp.difference(currentMessage.timestamp);
    return difference.inMinutes > 5;
  }

  Future<void> _sendMessage(String text) async {
    final chatNotifier = ref.read(chatNotifierProvider.notifier);
    final isTypingNotifier = ref.read(isTypingProvider.notifier);

    isTypingNotifier.setTyping(true);
    _streamingContent = '';
    _streamingMessageId = null;

    try {
      await for (final event
          in chatNotifier.sendMessageStream(widget.conversationId, text)) {
        if (event is ChatUserMessageCreated) {
          // User message created, scroll to bottom
          _scrollToBottom();
        } else if (event is ChatAIResponseChunk) {
          // AI response chunk received
          _streamingMessageId = event.messageId;
          if (event.content.isNotEmpty) {
            _streamingContent += event.content;
          }
          if (mounted) {
            setState(() {});
          }
          _scrollToBottom();

          if (event.isDone) {
            _streamingMessageId = null;
            _streamingContent = '';
          }
        } else if (event is ChatAIResponseError) {
          // Error occurred
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(event.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      }
    } finally {
      isTypingNotifier.setTyping(false);
    }
  }

  void _showOptionsMenu(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.ios_share,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
              title: Text(
                localizations.exportChat,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _exportConversation();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
              title: Text(
                localizations.deleteConversation,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _deleteConversation();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.edit_outlined,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
              title: Text(
                localizations.rename,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _renameConversation(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportConversation() async {
    final localizations = AppLocalizations.of(context)!;
    final chatNotifier = ref.read(chatNotifierProvider.notifier);

    try {
      final markdown =
          await chatNotifier.exportConversation(widget.conversationId);
      await Share.share(markdown, subject: localizations.exportChat);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.chatExported),
            backgroundColor: const Color(0xFF8B5CF6),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.exportFailed),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _deleteConversation() async {
    final chatNotifier = ref.read(chatNotifierProvider.notifier);
    await chatNotifier.deleteConversation(widget.conversationId);
    if (mounted) {
      context.pop();
    }
  }

  /// Shows the message options menu on long press.
  void _showMessageMenu(
    BuildContext context,
    ChatMessage message, {
    required bool isUserMessage,
  }) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Copy option
            ListTile(
              leading: Icon(
                Icons.copy_outlined,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
              title: Text(
                localizations.copy,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _copyMessage(context, message);
              },
            ),
            // Delete option (only for user messages or unsent AI messages)
            if (isUserMessage || message.status == MessageStatus.sending)
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: isDark ? Colors.red : const Color(0xFFE53935),
                ),
                title: Text(
                  localizations.delete,
                  style: TextStyle(
                    color: isDark ? Colors.red : const Color(0xFFE53935),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _deleteMessage(context, message.id);
                },
              ),
          ],
        ),
      ),
    );
  }

  /// Copies message content to clipboard.
  Future<void> _copyMessage(BuildContext context, ChatMessage message) async {
    final localizations = AppLocalizations.of(context)!;
    await Clipboard.setData(ClipboardData(text: message.content));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.messageCopied),
          backgroundColor: const Color(0xFF8B5CF6),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  /// Deletes a message.
  Future<void> _deleteMessage(BuildContext context, String messageId) async {
    final localizations = AppLocalizations.of(context)!;
    final chatNotifier = ref.read(chatNotifierProvider.notifier);
    await chatNotifier.deleteMessage(messageId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.messageDeleted),
          backgroundColor: const Color(0xFF8B5CF6),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Renames the conversation.
  Future<void> _renameConversation(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    final chatNotifier = ref.read(chatNotifierProvider.notifier);
    final conversation = chatNotifier.getConversation(widget.conversationId);
    if (conversation == null) return;

    final controller = TextEditingController(text: conversation.title);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final newTitle = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          localizations.renameConversation,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 100,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: localizations.enterNewTitle,
            border: const OutlineInputBorder(),
          ),
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              localizations.cancel,
              style: TextStyle(
                color:
                    isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(localizations.save),
          ),
        ],
      ),
    );

    if (newTitle != null &&
        newTitle.isNotEmpty &&
        newTitle != conversation.title) {
      await chatNotifier.renameConversation(widget.conversationId, newTitle);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.conversationRenamed),
            backgroundColor: const Color(0xFF8B5CF6),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
