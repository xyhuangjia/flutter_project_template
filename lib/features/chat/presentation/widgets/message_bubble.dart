/// Message bubble widget for chat messages.
library;

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_project_template/features/chat/domain/entities/chat_message.dart';
import 'package:flutter_project_template/features/chat/presentation/widgets/typing_indicator.dart';
import 'package:flutter_project_template/shared/widgets/settings_widgets.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

/// Message bubble widget displaying a single chat message.
class MessageBubble extends StatelessWidget {
  /// Creates a message bubble.
  const MessageBubble({
    required this.message,
    super.key,
    this.showTimestamp = true,
    this.onLongPress,
  });

  /// The message to display.
  final ChatMessage message;

  /// Whether to show the timestamp.
  final bool showTimestamp;

  /// Callback for long press events.
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final child = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment:
            message.isFromAI ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (message.isFromAI) ...[
            _buildAIAvatar(),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isFromAI
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.content.isEmpty && message.isFromAI)
                        const TypingIndicator()
                      else
                        _buildMessageContent(context, colorScheme),
                    ],
                  ),
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
                      if (!message.isFromAI) ...[
                        const SizedBox(width: 4),
                        _buildStatusIcon(colorScheme),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (!message.isFromAI) ...[
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

  /// Builds the message content with Markdown support for AI messages.
  Widget _buildMessageContent(BuildContext context, ColorScheme colorScheme) {
    if (message.isFromAI) {
      return MarkdownBody(
        data: message.content,
        selectable: true,
        onTapLink: (text, href, title) {
          if (href != null) {
            _launchUrl(href);
          }
        },
        styleSheet: MarkdownStyleSheet(
          p: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 15,
            height: 1.4,
          ),
          code: TextStyle(
            color: colorScheme.primary,
            backgroundColor: colorScheme.surfaceContainerHighest,
            fontSize: 14,
          ),
          codeblockDecoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          codeblockPadding: const EdgeInsets.all(12),
          blockquote: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 15,
          ),
          blockquoteDecoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: colorScheme.primary,
                width: 4,
              ),
            ),
          ),
          blockquotePadding: const EdgeInsets.only(left: 12),
          listBullet: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 15,
          ),
          tableHead: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
          tableBody: TextStyle(
            color: colorScheme.onSurface,
          ),
          a: TextStyle(
            color: colorScheme.primary,
            decoration: TextDecoration.underline,
          ),
        ),
      );
    }

    // User messages use plain text
    return Text(
      message.content,
      style: TextStyle(
        color: _getTextColor(colorScheme),
        fontSize: 15,
        height: 1.4,
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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

  Color _getBubbleColor(ColorScheme colorScheme) => message.isFromAI
      ? colorScheme.surfaceContainerHighest
      : colorScheme.primary;

  Color _getTextColor(ColorScheme colorScheme) =>
      message.isFromAI ? colorScheme.onSurface : colorScheme.onPrimary;

  BorderRadius _getBorderRadius() => message.isFromAI
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
