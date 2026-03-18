/// Settings tile widget.
library;

import 'package:flutter/material.dart';

/// Settings tile widget for displaying a settings item.
class SettingsTile extends StatelessWidget {
  /// Creates a settings tile.
  const SettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.showChevron = true,
    this.titleColor,
  });

  /// The title of the tile.
  final String title;

  /// The optional subtitle of the tile.
  final String? subtitle;

  /// The optional leading widget.
  final Widget? leading;

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

    return ListTile(
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: titleColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      leading: leading,
      trailing: trailing ??
          (showChevron && onTap != null
              ? Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurfaceVariant,
                )
              : null),
      onTap: onTap,
    );
  }
}

/// Settings section header widget.
class SettingsSectionHeader extends StatelessWidget {
  /// Creates a settings section header.
  const SettingsSectionHeader({
    super.key,
    required this.title,
  });

  /// The title of the section.
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Settings divider widget.
class SettingsDivider extends StatelessWidget {
  /// Creates a settings divider.
  const SettingsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1);
  }
}
