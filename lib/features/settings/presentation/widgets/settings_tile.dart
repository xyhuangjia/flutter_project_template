/// Settings tile widget for Chinese app style.
library;

import 'package:flutter/material.dart';

/// Settings tile widget for displaying a settings item.
///
/// Features:
/// - Icon with background color
/// - Rounded corners
/// - Compact layout
class SettingsTile extends StatelessWidget {
  /// Creates a settings tile.
  const SettingsTile({
    required this.title,
    super.key,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.iconBgColor,
    this.trailing,
    this.onTap,
    this.showChevron = true,
    this.titleColor,
  });

  /// The title of the tile.
  final String title;

  /// The optional subtitle of the tile.
  final String? subtitle;

  /// The icon to display.
  final IconData? icon;

  /// The color of the icon.
  final Color? iconColor;

  /// The background color of the icon container.
  final Color? iconBgColor;

  /// The optional trailing widget.
  final Widget? trailing;

  /// Callback when tile is tapped.
  final VoidCallback? onTap;

  /// Whether to show a chevron icon at the end.
  final bool showChevron;

  /// The color of the title text.
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icon with background
            if (icon != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor ?? colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: iconColor ?? colorScheme.primary,
                ),
              ),
            const SizedBox(width: 12),
            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Trailing widget or chevron
            if (trailing != null)
              trailing!
            else if (showChevron && onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
          ],
        ),
      ),
    );
  }
}
