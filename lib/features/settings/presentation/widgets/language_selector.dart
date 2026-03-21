library;

import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart' as pickers;
import 'package:flutter_pickers/style/default_style.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';

/// Language option data class.
class LanguageOption {
  /// Creates a language option.
  const LanguageOption({
    required this.code,
    required this.name,
  });

  final String? code;
  final String name;
}

/// Language selector widget with Chinese app style.
class LanguageSelector extends StatelessWidget {
  /// Creates a language selector.
  const LanguageSelector({
    required this.currentLanguage,
    required this.onLanguageChanged,
    required this.languages,
    super.key,
  });

  final String? currentLanguage;
  final ValueChanged<String?> onLanguageChanged;
  final List<LanguageOption> languages;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final allOptions = [
      LanguageOption(code: null, name: localizations.languageSystem),
      ...languages,
    ];

    final currentOption = allOptions.firstWhere(
      (opt) => opt.code == currentLanguage,
      orElse: () => allOptions.first,
    );

    return InkWell(
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icon with background
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.language,
                size: 22,
                color: Color(0xFF3B82F6),
              ),
            ),
            const SizedBox(width: 12),
            // Title
            Expanded(
              child: Text(
                localizations.language,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Current value
            Text(
              currentOption.name,
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
