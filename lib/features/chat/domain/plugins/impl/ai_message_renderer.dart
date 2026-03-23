/// AI 消息渲染器。
///
/// 渲染 AI 助手和用户的文本消息，支持 Markdown 格式。
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/features/chat/domain/entities/message.dart';
import 'package:flutter_project_template/features/chat/domain/plugins/message_renderer.dart';
import 'package:flutter_project_template/shared/widgets/settings_widgets.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:intl/intl.dart';

/// AI 消息渲染器。
///
/// 渲染文本消息，支持 Markdown 格式。
/// 支持用户消息和 AI 助手消息的差异化显示。
///
/// ## 使用示例
///
/// ```dart
/// final renderer = AIMessageRenderer();
///
/// if (renderer.canRender(message)) {
///   return renderer.render(message, context);
/// }
/// ```
class AIMessageRenderer extends MessageRenderer {
  /// 创建 AI 消息渲染器。
  AIMessageRenderer({
    this.showTimestamp = true,
    this.onLongPress,
  });

  /// 是否显示时间戳。
  final bool showTimestamp;

  /// 长按回调。
  final VoidCallback? onLongPress;

  @override
  String get id => 'ai_message';

  @override
  String get name => 'AI Message Renderer';

  @override
  int get priority => 100;

  @override
  bool canRender(Message message) => message is TextMessage;

  @override
  Widget render(Message message, BuildContext context) {
    if (message is! TextMessage) {
      return const SizedBox.shrink();
    }

    return _TextMessageBubble(
      message: message,
      showTimestamp: showTimestamp,
      onLongPress: onLongPress,
    );
  }
}

/// 文本消息气泡 Widget。
class _TextMessageBubble extends StatelessWidget {
  const _TextMessageBubble({
    required this.message,
    required this.showTimestamp,
    this.onLongPress,
  });

  final TextMessage message;
  final bool showTimestamp;
  final VoidCallback? onLongPress;

  bool get _isFromAI => message.sender == MessageSender.assistant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final child = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment:
            _isFromAI ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isFromAI) ...[
            _buildAIAvatar(),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: _isFromAI
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
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
                    color: _getBubbleColor(colorScheme),
                    borderRadius: _getBorderRadius(),
                  ),
                  child: _buildMessageContent(context, colorScheme),
                ),
                if (showTimestamp) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          fontSize: 11,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (!_isFromAI) ...[
                        const SizedBox(width: 4),
                        _buildStatusIcon(colorScheme),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (!_isFromAI) ...[
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

  Widget _buildMessageContent(BuildContext context, ColorScheme colorScheme) {
    if (message.content.isEmpty && _isFromAI) {
      return const _TypingIndicator();
    }

    if (_isFromAI) {
      // AI 消息支持 Markdown
      return SelectionArea(
        child: GptMarkdown(
          message.content,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      );
    }

    // 用户消息使用纯文本
    return Text(
      message.content,
      style: TextStyle(
        color: _getTextColor(colorScheme),
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

  Color _getBubbleColor(ColorScheme colorScheme) => _isFromAI
      ? colorScheme.surfaceContainerHighest
      : colorScheme.primary;

  Color _getTextColor(ColorScheme colorScheme) =>
      _isFromAI ? colorScheme.onSurface : colorScheme.onPrimary;

  BorderRadius _getBorderRadius() => _isFromAI
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
    switch (message.status) {
      case MessageStatus.sending:
        return Icon(
          Icons.access_time,
          size: 12,
          color: colorScheme.onSurfaceVariant,
        );
      case MessageStatus.sent:
        return Icon(
          Icons.check,
          size: 12,
          color: colorScheme.primary,
        );
      case MessageStatus.read:
        return Icon(
          Icons.done_all,
          size: 12,
          color: colorScheme.primary,
        );
      case MessageStatus.error:
        return Icon(
          Icons.error_outline,
          size: 12,
          color: colorScheme.error,
        );
    }
  }

  String _formatTime(DateTime time) => DateFormat.jm().format(time);
}

/// 打字指示器 Widget。
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final anim = Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: _controller,
                curve: Interval(delay, delay + 0.4, curve: Curves.easeInOut),
              ),
            );
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface
                    .withValues(alpha: 0.3 + anim.value * 0.4),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}