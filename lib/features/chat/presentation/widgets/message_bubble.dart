/// 消息气泡组件。
///
/// 支持新旧两种消息类型，使用插件系统渲染消息内容。
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/features/chat/domain/entities/chat_message.dart'
    as legacy;
import 'package:flutter_project_template/features/chat/domain/entities/message.dart';
import 'package:flutter_project_template/features/chat/presentation/providers/plugin_registry_provider.dart';
import 'package:flutter_project_template/features/chat/presentation/widgets/typing_indicator.dart';
import 'package:flutter_project_template/shared/widgets/settings_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:intl/intl.dart';

/// 消息气泡组件。
///
/// 支持两种使用方式：
/// 1. 使用新的 [Message] 类型和插件系统（推荐）
/// 2. 使用旧的 [legacy.ChatMessage] 类型（向后兼容）
///
/// 当提供 [message] 参数时，会使用插件系统渲染。
/// 当提供 [legacyMessage] 参数时，会使用旧的内联渲染逻辑。
class MessageBubble extends ConsumerWidget {
  /// 创建消息气泡（新版 Message 类型）。
  const MessageBubble({
    required Message this.message,
    super.key,
    this.showTimestamp = true,
    this.onLongPress,
  }) : legacyMessage = null;

  /// 创建消息气泡（旧版 ChatMessage 类型，向后兼容）。
  const MessageBubble.legacy({
    required legacy.ChatMessage this.legacyMessage,
    super.key,
    this.showTimestamp = true,
    this.onLongPress,
  }) : message = null;

  /// 新版消息对象。
  final Message? message;

  /// 旧版消息对象（向后兼容）。
  final legacy.ChatMessage? legacyMessage;

  /// 是否显示时间戳。
  final bool showTimestamp;

  /// 长按回调。
  final VoidCallback? onLongPress;

  /// 是否为 AI 消息。
  bool _isFromAI() {
    if (message != null) {
      return message!.sender == MessageSender.assistant;
    }
    return legacyMessage?.isFromAI ?? false;
  }

  /// 获取消息时间戳。
  DateTime _getTimestamp() {
    if (message != null) {
      return message!.timestamp;
    }
    return legacyMessage?.timestamp ?? DateTime.now();
  }

  /// 获取消息状态（新版）。
  MessageStatus _getStatus() {
    if (message != null) {
      return message!.status;
    }
    // 旧版消息状态转换
    final legacyStatus = legacyMessage?.status;
    if (legacyStatus == null) return MessageStatus.sent;
    return MessageStatus.values[legacyStatus.index];
  }

  /// 获取消息文本内容。
  String? _getTextContent() {
    if (message != null) {
      return message!.text;
    }
    return legacyMessage?.content;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 如果使用新版消息，尝试通过插件系统渲染
    if (message != null) {
      final registry = ref.watch(pluginRegistryProvider);
      final renderer = registry.getRenderer(message!);

      if (renderer != null) {
        // 使用插件渲染器渲染
        final rendered = renderer.render(message!, context);

        // 包装长按手势
        if (onLongPress != null) {
          return GestureDetector(
            onLongPress: onLongPress,
            child: rendered,
          );
        }
        return rendered;
      }
    }

    // 回退到旧版渲染逻辑
    return _buildLegacyBubble(context);
  }

  /// 构建旧版消息气泡。
  Widget _buildLegacyBubble(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isFromAI = _isFromAI();
    final textContent = _getTextContent() ?? '';

    final child = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment:
            isFromAI ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isFromAI) ...[
            _buildAIAvatar(),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isFromAI ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: _getBubbleColor(colorScheme, isFromAI),
                    borderRadius: _getBorderRadius(isFromAI),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (textContent.isEmpty && isFromAI)
                        const TypingIndicator()
                      else
                        _buildMessageContent(
                            context, colorScheme, isFromAI, textContent,),
                    ],
                  ),
                ),
                if (showTimestamp) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(_getTimestamp()),
                        style: TextStyle(
                          fontSize: 11,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (!isFromAI) ...[
                        const SizedBox(width: 4),
                        _buildStatusIcon(colorScheme),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (!isFromAI) ...[
            const SizedBox(width: 8),
            _buildUserAvatar(colorScheme),
          ],
        ],
      ),
    );

    return onLongPress != null
        ? GestureDetector(onLongPress: onLongPress, child: child)
        : child;
  }

  /// 构建消息内容。
  Widget _buildMessageContent(
    BuildContext context,
    ColorScheme colorScheme,
    bool isFromAI,
    String textContent,
  ) {
    if (isFromAI) {
      return SelectionArea(
        child: GptMarkdown(
          textContent,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      );
    }

    return Text(
      textContent,
      style: TextStyle(
        color: _getTextColor(colorScheme, isFromAI),
        fontSize: 15,
        height: 1.4,
      ),
    );
  }

  Widget _buildAIAvatar() => Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppIconColors.aiColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.smart_toy_outlined,
          size: 18,
          color: Colors.white,
        ),
      );

  Widget _buildUserAvatar(ColorScheme colorScheme) => Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.person_outline,
          size: 18,
          color: colorScheme.onPrimary,
        ),
      );

  Color _getBubbleColor(ColorScheme colorScheme, bool isFromAI) =>
      isFromAI ? colorScheme.surfaceContainerHighest : colorScheme.primary;

  Color _getTextColor(ColorScheme colorScheme, bool isFromAI) =>
      isFromAI ? colorScheme.onSurface : colorScheme.onPrimary;

  BorderRadius _getBorderRadius(bool isFromAI) => isFromAI
      ? const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        )
      : const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(4),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        );

  Widget _buildStatusIcon(ColorScheme colorScheme) {
    final status = _getStatus();
    return switch (status) {
      MessageStatus.sending => Icon(
          Icons.access_time,
          size: 12,
          color: colorScheme.onSurfaceVariant,
        ),
      MessageStatus.sent => Icon(
          Icons.check,
          size: 12,
          color: colorScheme.primary,
        ),
      MessageStatus.read => Icon(
          Icons.done_all,
          size: 12,
          color: colorScheme.primary,
        ),
      MessageStatus.error => Icon(
          Icons.error_outline,
          size: 12,
          color: colorScheme.error,
        ),
    };
  }

  String _formatTime(DateTime time) => DateFormat.jm().format(time);
}
