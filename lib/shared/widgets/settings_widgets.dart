/// Shared widgets for Chinese app style screens.
///
/// These widgets follow the design guidelines defined in
/// `.trellis/spec/frontend/chinese-app-style.md`.
library;

import 'package:flutter/material.dart';

/// Section title widget with accent bar.
///
/// Used to separate different sections in settings and profile screens.
class SectionTitle extends StatelessWidget {
  /// Creates a section title.
  const SectionTitle({
    required this.title,
    required this.colorScheme,
    super.key,
  });

  /// The title text to display.
  final String title;

  /// The color scheme to use for the accent bar.
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      );
}

/// Settings card with rounded corners and shadow.
///
/// A container widget that groups related settings items together.
class SettingsCard extends StatelessWidget {
  /// Creates a settings card.
  const SettingsCard({
    required this.colorScheme,
    this.children,
    this.child,
    super.key,
  });

  /// The color scheme to use.
  final ColorScheme colorScheme;

  /// The children to display in the card.
  final List<Widget>? children;

  /// Alternative: a single child widget.
  final Widget? child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child ?? Column(children: children ?? []),
      );
}

/// Settings divider widget.
///
/// A thin divider line used between settings items.
class SettingsDivider extends StatelessWidget {
  /// Creates a settings divider.
  const SettingsDivider({
    required this.colorScheme,
    super.key,
  });

  /// The color scheme to use.
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 60),
        child: Divider(
          height: 1,
          color: colorScheme.surfaceContainerHighest,
        ),
      );
}

/// Predefined icon color pairs for common use cases.
///
/// Follows the color palette defined in chinese-app-style.md.
class AppIconColors {
  AppIconColors._();

  /// Language/Internationalization - Blue
  static const Color languageColor = Color(0xFF3B82F6);
  static const Color languageBgColor = Color(0xFFEBF5FF);

  /// Theme - Orange
  static const Color themeColor = Color(0xFFF97316);
  static const Color themeBgColor = Color(0xFFFFF7ED);

  /// Notification - Pink
  static const Color notificationColor = Color(0xFFEC4899);
  static const Color notificationBgColor = Color(0xFFFDF2F8);

  /// AI Assistant - Purple
  static const Color aiColor = Color(0xFF8B5CF6);
  static const Color aiBgColor = Color(0xFFF5F3FF);

  /// Info/About - Cyan
  static const Color infoColor = Color(0xFF0EA5E9);
  static const Color infoBgColor = Color(0xFFF0F9FF);

  /// Privacy/Security - Teal
  static const Color privacyColor = Color(0xFF14B8A6);
  static const Color privacyBgColor = Color(0xFFF0FDFA);

  /// Developer - Slate
  static const Color developerColor = Color(0xFF64748B);
  static const Color developerBgColor = Color(0xFFF1F5F9);

  /// Network - Blue
  static const Color networkColor = Color(0xFF3B82F6);
  static const Color networkBgColor = Color(0xFFEBF5FF);

  /// Performance - Pink
  static const Color performanceColor = Color(0xFFEC4899);
  static const Color performanceBgColor = Color(0xFFFDF2F8);

  /// Logging - Teal
  static const Color loggingColor = Color(0xFF14B8A6);
  static const Color loggingBgColor = Color(0xFFF0FDFA);

  /// Gender - Pink
  static const Color genderColor = Color(0xFFEC4899);
  static const Color genderBgColor = Color(0xFFFDF2F8);

  /// Phone - Teal
  static const Color phoneColor = Color(0xFF14B8A6);
  static const Color phoneBgColor = Color(0xFFF0FDFA);

  /// Password - Orange
  static const Color passwordColor = Color(0xFFF97316);
  static const Color passwordBgColor = Color(0xFFFFF7ED);
}
