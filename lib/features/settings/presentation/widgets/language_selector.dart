library;

import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart' as pickers;
import 'package:flutter_pickers/style/default_style.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';

class LanguageOption {
  const LanguageOption({
    required this.code,
    required this.name,
  });

  final String? code;
  final String name;
}

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
    required this.languages,
  });

  final String? currentLanguage;
  final ValueChanged<String?> onLanguageChanged;
  final List<LanguageOption> languages;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final allOptions = [
      LanguageOption(code: null, name: localizations.languageSystem),
      ...languages,
    ];

    final currentOption = allOptions.firstWhere(
      (opt) => opt.code == currentLanguage,
      orElse: () => allOptions.first,
    );

    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(localizations.language),
      subtitle: Text(currentOption.name),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        pickers.Pickers.showSinglePicker(
          context,
          data: allOptions.map((e) => e.name).toList(),
          selectData: currentOption.name,
          pickerStyle: theme.brightness == Brightness.dark
              ? DefaultPickerStyle.dark()
              : DefaultPickerStyle(),
          onConfirm: (data, position) {
            onLanguageChanged(allOptions[position].code);
          },
        );
      },
    );
  }
}
