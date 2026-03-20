/// Chat detail screen for individual conversations.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_template/features/chat/domain/entities/chat_message.dart';
import 'package:flutter_project_template/features/chat/presentation/providers/chat_provider.dart';
import 'package:flutter_project_template/features/chat/presentation/widgets/chat_input_field.dart';
import 'package:flutter_project_template/features/chat/presentation/widgets/message_bubble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final conversation = ref.watch(chatNotifierProvider).when(
          data: (state) => state.conversations
              .where((c) => c.id == widget.conversationId)
              .firstOrNull,
          loading: () => null,
          error: (_, __) => null,
        );

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      appBar: AppBar(
        title: Text(
          conversation?.title ?? 'Chat',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
          ),
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
                : _buildMessagesList(conversation, isDark),
          ),
          ChatInputField(
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(ChatConversation conversation, bool isDark) {
    final messages = conversation.messages;

    if (messages.isEmpty) {
      return _buildEmptyState(isDark);
    }

    // Scroll to bottom after build
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
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

  Widget _buildEmptyState(bool isDark) => Center(
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
              'Start a conversation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Send a message to begin chatting with AI',
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
    await chatNotifier.sendMessage(widget.conversationId, text);
    _scrollToBottom();
  }

  void _showOptionsMenu(BuildContext context) {
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
                Icons.delete_outline,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
              title: Text(
                'Delete Conversation',
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
                'Rename',
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
                'Copy',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _copyMessage(message);
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
                  'Delete',
                  style: TextStyle(
                    color: isDark ? Colors.red : const Color(0xFFE53935),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _deleteMessage(message.id);
                },
              ),
          ],
        ),
      ),
    );
  }

  /// Copies message content to clipboard.
  Future<void> _copyMessage(ChatMessage message) async {
    await Clipboard.setData(ClipboardData(text: message.content));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Message copied'),
          backgroundColor: const Color(0xFF8B5CF6),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  /// Deletes a message.
  Future<void> _deleteMessage(String messageId) async {
    final chatNotifier = ref.read(chatNotifierProvider.notifier);
    await chatNotifier.deleteMessage(messageId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Message deleted'),
          backgroundColor: const Color(0xFF8B5CF6),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Renames the conversation.
  Future<void> _renameConversation(BuildContext context) async {
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
          'Rename Conversation',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 100,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            hintText: 'Enter new title',
            border: OutlineInputBorder(),
          ),
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color:
                    isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
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
            content: const Text('Conversation renamed'),
            backgroundColor: const Color(0xFF8B5CF6),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
