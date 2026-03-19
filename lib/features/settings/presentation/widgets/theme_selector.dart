library;

import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart' as pickers;
import 'package:flutter_pickers/style/default_style.dart';
import 'package:flutter_project_template/features/settings/domain/entities/settings_entity.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  final AppThemeMode currentTheme;
  final ValueChanged<AppThemeMode> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final themeOptions = {
      AppThemeMode.system: localizations.themeSystem,
      AppThemeMode.light: localizations.themeLight,
      AppThemeMode.dark: localizations.themeDark,
    };

    final currentName = themeOptions[currentTheme] ?? localizations.themeSystem;

    return ListTile(
      leading: const Icon(Icons.palette_outlined),
      title: Text(localizations.theme),
      subtitle: Text(currentName),
      trailing: const Icon(Icons.chevron_right),
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
    );
  }
}
