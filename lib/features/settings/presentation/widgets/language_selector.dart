/// Language selector widget.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';

/// Language option for the selector.
class LanguageOption {
  /// Creates a language option.
  const LanguageOption({
    required this.code,
    required this.name,
  });

  /// The language code (e.g., 'en', 'zh').
  final String code;

  /// The display name of the language.
  final String name;
}

/// Language selector widget for changing app language.
class LanguageSelector extends StatelessWidget {
  /// Creates a language selector.
  const LanguageSelector({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
    required this.languages,
  });

  /// The current language code (null for system).
  final String? currentLanguage;

  /// Callback when language is changed.
  final ValueChanged<String?> onLanguageChanged;

  /// List of available languages.
  final List<LanguageOption> languages;

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
            localizations.selectLanguage,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _LanguageOption(
          icon: Icons.language,
          title: localizations.languageSystem,
          isSelected: currentLanguage == null,
          onTap: () => onLanguageChanged(null),
        ),
        ...languages.map(
          (lang) => _LanguageOption(
            icon: Icons.translate,
            title: lang.name,
            isSelected: currentLanguage == lang.code,
            onTap: () => onLanguageChanged(lang.code),
          ),
        ),
      ],
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
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
