/// Conversation list item widget.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/features/chat/domain/entities/chat_message.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_project_template/shared/widgets/settings_widgets.dart';
import 'package:intl/intl.dart';

/// Conversation list item for the chat list.
class ConversationListItem extends StatelessWidget {
  /// Creates a conversation list item.
  const ConversationListItem({
    required this.conversation,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  /// The conversation to display.
  final ChatConversation conversation;

  /// Callback when tapped.
  final VoidCallback onTap;

  /// Callback when delete is requested.
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dismissible(
      key: Key(conversation.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.delete_outline,
          color: colorScheme.onError,
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SettingsCard(
          colorScheme: colorScheme,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildAvatar(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              conversation.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: conversation.unreadCount > 0
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            _formatTime(conversation.updatedAt, localizations),
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              conversation.lastMessage,
                              style: TextStyle(
                                fontSize: 14,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (conversation.unreadCount > 0) ...[
                            const SizedBox(width: 8),
                            _buildUnreadBadge(),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() => Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: AppIconColors.aiBgColor,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Icon(
          Icons.chat_bubble_outline_rounded,
          size: 24,
          color: AppIconColors.aiColor,
        ),
      );

  Widget _buildUnreadBadge() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: AppIconColors.aiColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          conversation.unreadCount.toString(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      );

  String _formatTime(DateTime time, AppLocalizations localizations) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return localizations.justNow;
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return DateFormat.jm().format(time);
    } else if (difference.inDays < 7) {
      return DateFormat.E().format(time);
    } else {
      return DateFormat.MMMd().format(time);
    }
  }
}
