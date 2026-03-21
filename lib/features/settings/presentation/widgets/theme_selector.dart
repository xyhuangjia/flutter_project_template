library;

import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart' as pickers;
import 'package:flutter_pickers/style/default_style.dart';
import 'package:flutter_project_template/features/settings/domain/entities/settings_entity.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';

/// Theme selector widget with Chinese app style.
class ThemeSelector extends StatelessWidget {
  /// Creates a theme selector.
  const ThemeSelector({
    required this.currentTheme,
    required this.onThemeChanged,
    super.key,
  });

  final AppThemeMode currentTheme;
  final ValueChanged<AppThemeMode> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final themeOptions = {
      AppThemeMode.system: localizations.themeSystem,
      AppThemeMode.light: localizations.themeLight,
      AppThemeMode.dark: localizations.themeDark,
    };

    final currentName = themeOptions[currentTheme] ?? localizations.themeSystem;

    return InkWell(
      onTap: () {
        final themeNames = themeOptions.values.toList();
        final themeModes = themeOptions.keys.toList();

        pickers.Pickers.showSinglePicker(
          context,
          data: themeNames,
          selectData: currentName,
          pickerStyle: theme.brightness == Brightness.dark
              ? DefaultPickerStyle.dark()
              : DefaultPickerStyle(),
          onConfirm: (data, position) {
            onThemeChanged(themeModes[position]);
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icon with background
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF97316).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.palette_outlined,
                size: 22,
                color: Color(0xFFF97316),
              ),
            ),
            const SizedBox(width: 12),
            // Title
            Expanded(
              child: Text(
                localizations.theme,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Current value
            Text(
              currentName,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 4),
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
