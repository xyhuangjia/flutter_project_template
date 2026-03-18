/// Theme selector widget.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/features/settings/domain/entities/settings_entity.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';

/// Theme selector widget for changing app theme.
class ThemeSelector extends StatelessWidget {
  /// Creates a theme selector.
  const ThemeSelector({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  /// The current theme mode.
  final AppThemeMode currentTheme;

  /// Callback when theme is changed.
  final ValueChanged<AppThemeMode> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            localizations.theme,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _ThemeOption(
          icon: Icons.brightness_auto,
          title: localizations.themeSystem,
          isSelected: currentTheme == AppThemeMode.system,
          onTap: () => onThemeChanged(AppThemeMode.system),
        ),
        _ThemeOption(
          icon: Icons.light_mode,
          title: localizations.themeLight,
          isSelected: currentTheme == AppThemeMode.light,
          onTap: () => onThemeChanged(AppThemeMode.light),
        ),
        _ThemeOption(
          icon: Icons.dark_mode,
          title: localizations.themeDark,
          isSelected: currentTheme == AppThemeMode.dark,
          onTap: () => onThemeChanged(AppThemeMode.dark),
        ),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: isSelected
          ? Icon(
              Icons.check,
              color: theme.colorScheme.primary,
            )
          : null,
      onTap: onTap,
    );
  }
}
