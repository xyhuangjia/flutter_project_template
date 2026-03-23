/// 聊天详情页面。
///
/// 显示单个会话的消息列表，支持发送文本和图片消息。
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_template/features/chat/data/converters/message_converter.dart';
import 'package:flutter_project_template/features/chat/domain/entities/chat_message.dart'
    as domain;
import 'package:flutter_project_template/features/chat/domain/entities/message.dart';
import 'package:flutter_project_template/features/chat/presentation/providers/ai_config_provider.dart';
import 'package:flutter_project_template/features/chat/presentation/providers/chat_provider.dart';
import 'package:flutter_project_template/features/chat/presentation/widgets/chat_input_field.dart';
import 'package:flutter_project_template/features/chat/presentation/widgets/message_bubble.dart';
import 'package:flutter_project_template/features/chat/presentation/widgets/typing_indicator.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_project_template/shared/widgets/dialog_util.dart';
import 'package:flutter_project_template/shared/widgets/settings_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

/// 聊天详情页面。
class ChatDetailScreen extends ConsumerStatefulWidget {
  /// 创建聊天详情页面。
  const ChatDetailScreen({
    required this.conversationId,
    super.key,
  });

  /// 会话 ID。
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
    final colorScheme = theme.colorScheme;
    final conversation = ref.watch(chatProvider).when(
          data: (state) => state.conversations
              .where((c) => c.id == widget.conversationId)
              .firstOrNull,
          loading: () => null,
          error: (_, __) => null,
        );
    final isTyping = ref.watch(isTypingProvider);
    final aiConfig = ref.watch(aIConfigProvider).value?.defaultConfig;

    // 获取当前会话选择的模型
    final selectedModel =
        ref.watch(selectedModelProvider(widget.conversationId));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(conversation?.title ?? localizations.chat),
            if (aiConfig != null)
              Text(
                _getSubtitle(aiConfig, selectedModel),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        actions: [
          // 模型选择器（仅当配置有多个模型时显示）
          if (aiConfig != null && aiConfig.models.length > 1)
            _buildModelSelectorButton(
                aiConfig, selectedModel, colorScheme, localizations,),
          IconButton(
            icon: const Icon(Icons.more_vert),
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
                    conversation, colorScheme, localizations, isTyping,),
          ),
          if (aiConfig == null)
            _buildNoConfigBanner(context, localizations, colorScheme),
          ChatInputField(
            onSend: _handleSend,
            hintText: localizations.typeMessage,
            enabled: aiConfig != null,
          ),
        ],
      ),
    );
  }

  String _getSubtitle(AIConfigEntity config, String? selectedModel) {
    final modelName =
        _getModelDisplayName(config, selectedModel ?? config.currentModel);
    return '${config.name} • $modelName';
  }

  String _getModelDisplayName(AIConfigEntity config, String modelId) {
    if (config.provider == 'custom') return modelId;

    final models = {
      'openai': {
        'gpt-4o': 'GPT-4o',
        'gpt-4o-mini': 'GPT-4o Mini',
        'gpt-4-turbo': 'GPT-4 Turbo',
      },
      'claude': {
        'claude-3-5-sonnet-20241022': 'Claude 3.5 Sonnet',
        'claude-3-5-haiku-20241022': 'Claude 3.5 Haiku',
      },
    };
    return models[config.provider]?[modelId] ?? modelId;
  }

  Widget _buildModelSelectorButton(
    AIConfigEntity config,
    String? selectedModel,
    ColorScheme colorScheme,
    AppLocalizations localizations,
  ) => PopupMenuButton<String>(
      icon: const Icon(Icons.tune),
      tooltip: localizations.switchModel,
      initialValue: selectedModel ?? config.currentModel,
      onSelected: (modelId) {
        ref
            .read(selectedModelProvider(widget.conversationId).notifier)
            .setModel(modelId);
      },
      itemBuilder: (context) => config.models.map((modelId) {
          final isDefault = config.defaultModel == modelId;
          final displayName = _getModelDisplayName(config, modelId);
          return PopupMenuItem(
            value: modelId,
            child: Row(
              children: [
                Expanded(child: Text(displayName)),
                if (isDefault)
                  const Icon(
                    Icons.star,
                    size: 16,
                    color: AppIconColors.aiColor,
                  ),
              ],
            ),
          );
        }).toList(),
    );

  Widget _buildNoConfigBanner(
    BuildContext context,
    AppLocalizations localizations,
    ColorScheme colorScheme,
  ) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppIconColors.aiColor.withValues(alpha: 0.1),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: AppIconColors.aiColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              localizations.noAIConfigMessage,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          TextButton(
            onPressed: () => context.push('/settings/ai-config'),
            style: TextButton.styleFrom(
              foregroundColor: AppIconColors.aiColor,
            ),
            child: Text(localizations.configureAI),
          ),
        ],
      ),
    );

  Widget _buildMessagesList(
    domain.ChatConversation conversation,
    ColorScheme colorScheme,
    AppLocalizations localizations,
    bool isTyping,
  ) {
    final messages = conversation.messages;

    if (messages.isEmpty && !isTyping) {
      return _buildEmptyState(colorScheme, localizations);
    }

    // 构建完成后滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    final itemCount = messages.length + (isTyping ? 1 : 0);

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // 在最后显示打字指示器
        if (isTyping && index == messages.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TypingIndicator(),
          );
        }

        final message = messages[index];
        // 将旧版消息转换为新版以便使用插件系统
        final newMessage = MessageConverter.fromLegacyChatMessage(
          message,
          conversationId: widget.conversationId,
        );

        // 显示流式内容的 AI 消息
        if (message.id == _streamingMessageId && _streamingContent.isNotEmpty) {
          final streamingMessage = newMessage.copyWith(
            content: _streamingContent,
            status: MessageStatus.sending,
          );
          return MessageBubble(
            message: streamingMessage,
            showTimestamp: false,
            onLongPress: () => _showMessageMenu(
              context,
              message,
              isUserMessage: false,
            ),
          );
        }

        return MessageBubble(
          message: newMessage,
          showTimestamp: index == messages.length - 1 ||
              _shouldShowTimestamp(messages, index),
          onLongPress: message.isFromAI
              ? () => _showMessageMenu(context, message, isUserMessage: false)
              : () => _showMessageMenu(context, message, isUserMessage: true),
        );
      },
    );
  }

  Widget _buildEmptyState(
          ColorScheme colorScheme, AppLocalizations localizations,) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppIconColors.aiBgColor,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.smart_toy_outlined,
                size: 40,
                color: AppIconColors.aiColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              localizations.startConversation,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              localizations.sendMessageToBegin,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );

  bool _shouldShowTimestamp(List<domain.ChatMessage> messages, int index) {
    if (index == messages.length - 1) return true;
    final currentMessage = messages[index];
    final nextMessage = messages[index + 1];
    final difference =
        nextMessage.timestamp.difference(currentMessage.timestamp);
    return difference.inMinutes > 5;
  }

  /// 处理发送内容（文本或图片）。
  Future<void> _handleSend(InputContent content) async {
    if (content.isEmpty) return;

    switch (content.type) {
      case InputContentType.text:
        await _sendTextMessage(content.text!);
      case InputContentType.image:
        await _sendImageMessage(content.imagePaths, content.text);
    }
  }

  /// 发送文本消息。
  Future<void> _sendTextMessage(String text) async {
    final chatNotifier = ref.read(chatProvider.notifier);
    final isTypingNotifier = ref.read(isTypingProvider.notifier);
    final selectedModel =
        ref.read(selectedModelProvider(widget.conversationId));

    isTypingNotifier.setTyping(true);
    _streamingContent = '';
    _streamingMessageId = null;

    try {
      await for (final event in chatNotifier.sendMessageStream(
        widget.conversationId,
        text,
        selectedModel: selectedModel,
      )) {
        if (event is ChatUserMessageCreated) {
          // 用户消息已创建，滚动到底部
          _scrollToBottom();
        } else if (event is ChatAIResponseChunk) {
          // AI 响应块
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
          // 发生错误
          if (mounted) {
            DialogUtil.showErrorDialog(context, event.message);
          }
        }
      }
    } finally {
      isTypingNotifier.setTyping(false);
    }
  }

  /// 发送图片消息。
  ///
  /// 目前仅显示提示，图片上传功能需要在后续实现。
  Future<void> _sendImageMessage(
    List<String> imagePaths,
    String? caption,
  ) async {
    // TODO: 实现图片上传和发送
    // 当前仅显示提示
    if (mounted) {
      DialogUtil.showInfoDialog(
        context,
        '图片消息功能开发中：已选择 ${imagePaths.length} 张图片'
            '${caption != null ? '，说明：$caption' : ''}',
      );
    }

    // 未来实现步骤：
    // 1. 上传图片到服务器/云存储
    // 2. 获取图片 URL
    // 3. 创建 ImageMessage 并保存
    // 4. 如果是 AI 对话，发送给 AI 进行分析
  }

  void _showOptionsMenu(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.ios_share),
              title: Text(localizations.exportChat),
              onTap: () {
                Navigator.pop(context);
                _exportConversation();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text(localizations.deleteConversation),
              onTap: () {
                Navigator.pop(context);
                _deleteConversation();
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(localizations.rename),
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
    final chatNotifier = ref.read(chatProvider.notifier);

    try {
      final markdown =
          await chatNotifier.exportConversation(widget.conversationId);
      await Share.share(markdown, subject: localizations.exportChat);
      if (mounted) {
        DialogUtil.showSuccessDialog(context, localizations.chatExported);
      }
    } catch (e) {
      if (mounted) {
        DialogUtil.showErrorDialog(context, localizations.exportFailed);
      }
    }
  }

  Future<void> _deleteConversation() async {
    final chatNotifier = ref.read(chatProvider.notifier);
    await chatNotifier.deleteConversation(widget.conversationId);
    if (mounted) {
      context.pop();
    }
  }

  /// 长按显示消息菜单。
  void _showMessageMenu(
    BuildContext context,
    domain.ChatMessage message, {
    required bool isUserMessage,
  }) {
    final localizations = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 复制选项
            ListTile(
              leading: Icon(Icons.copy_outlined, color: colorScheme.onSurface),
              title: Text(localizations.copy),
              onTap: () {
                Navigator.pop(context);
                _copyMessage(context, message);
              },
            ),
            // 删除选项（仅用户消息或未发送的 AI 消息）
            if (isUserMessage || message.status == domain.MessageStatus.sending)
              ListTile(
                leading: Icon(Icons.delete_outline, color: colorScheme.error),
                title: Text(
                  localizations.delete,
                  style: TextStyle(color: colorScheme.error),
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

  /// 复制消息内容到剪贴板。
  Future<void> _copyMessage(BuildContext context, domain.ChatMessage message) async {
    final localizations = AppLocalizations.of(context)!;
    await Clipboard.setData(ClipboardData(text: message.content));
    if (mounted) {
      DialogUtil.showSuccessDialog(context, localizations.messageCopied);
    }
  }

  /// 删除消息。
  Future<void> _deleteMessage(BuildContext context, String messageId) async {
    final localizations = AppLocalizations.of(context)!;
    final chatNotifier = ref.read(chatProvider.notifier);
    await chatNotifier.deleteMessage(messageId);
    if (mounted) {
      DialogUtil.showSuccessDialog(context, localizations.messageDeleted);
    }
  }

  /// 重命名会话。
  Future<void> _renameConversation(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    final chatNotifier = ref.read(chatProvider.notifier);
    final conversation = chatNotifier.getConversation(widget.conversationId);
    if (conversation == null) return;

    final controller = TextEditingController(text: conversation.title);

    final newTitle = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.renameConversation),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 100,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: localizations.enterNewTitle,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
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
        DialogUtil.showSuccessDialog(
            context, localizations.conversationRenamed,);
      }
    }
  }
}
