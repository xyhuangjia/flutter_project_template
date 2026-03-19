/// Message bubble widget for chat messages.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/features/chat/domain/entities/chat_message.dart';
import 'package:flutter_project_template/features/chat/presentation/widgets/typing_indicator.dart';
import 'package:flutter_project_template/features/chat/utils/chat_colors.dart';
import 'package:intl/intl.dart';

/// Message bubble widget displaying a single chat message.
class MessageBubble extends StatelessWidget {
  /// Creates a message bubble.
  const MessageBubble({
    required this.message,
    super.key,
    this.showTimestamp = true,
  });

  /// The message to display.
  final ChatMessage message;

  /// Whether to show the timestamp.
  final bool showTimestamp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
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
                    color: _getBubbleColor(isDark),
                    borderRadius: _getBorderRadius(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.content.isEmpty && message.isFromAI)
                        const TypingIndicator()
                      else
                        Text(
                          message.content,
                          style: TextStyle(
                            color: _getTextColor(isDark),
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
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
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                      if (!message.isFromAI) ...[
                        const SizedBox(width: 4),
                        _buildStatusIcon(),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (!message.isFromAI) ...[
            const SizedBox(width: 8),
            _buildUserAvatar(),
          ],
        ],
      ),
    );
  }

  Widget _buildAIAvatar() => Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: ChatColors.aiAvatarAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.smart_toy_outlined,
          size: 18,
          color: Colors.white,
        ),
      );

  Widget _buildUserAvatar() => Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: ChatColors.userAvatarAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.person_outline,
          size: 18,
          color: Colors.white,
        ),
      );

  Color _getBubbleColor(bool isDark) => message.isFromAI
      ? (isDark ? ChatColors.aiMessageDark : ChatColors.aiMessageLight)
      : (isDark ? ChatColors.userMessageDark : ChatColors.userMessageLight);

  Color _getTextColor(bool isDark) => message.isFromAI
      ? (isDark ? ChatColors.aiMessageTextDark : ChatColors.aiMessageTextLight)
      : (isDark
          ? ChatColors.userMessageTextDark
          : ChatColors.userMessageTextLight);

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

  Widget _buildStatusIcon() {
    switch (message.status) {
      case MessageStatus.sending:
        return Icon(
          Icons.access_time,
          size: 12,
          color: Colors.grey.shade400,
        );
      case MessageStatus.sent:
        return const Icon(
          Icons.check,
          size: 12,
          color: ChatColors.sentIndicator,
        );
      case MessageStatus.read:
        return const Icon(
          Icons.done_all,
          size: 12,
          color: ChatColors.sentIndicator,
        );
      case MessageStatus.error:
        return const Icon(
          Icons.error_outline,
          size: 12,
          color: ChatColors.errorAccent,
        );
    }
  }

  String _formatTime(DateTime time) => DateFormat.jm().format(time);
}
