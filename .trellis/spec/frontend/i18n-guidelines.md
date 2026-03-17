# Internationalization (i18n) Guidelines

> Best practices for internationalization in this project.

---

## Overview

This project uses Flutter's built-in localization system with ARB files for managing translations.

---

## Dependencies

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  shared_preferences: ^2.3.3

dev_dependencies:
  intl_utils: ^2.8.0
```

---

## Configuration

### l10n.yaml

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
```

### MaterialApp Setup

```dart
MaterialApp(
  localizationsDelegates: [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: [
    Locale('en'),
    Locale('zh'),
  ],
  locale: ref.watch(localeNotifierProvider),
)
```

---

## ARB File Structure

### Location

```
lib/
└── l10n/
    ├── app_en.arb    # English (template)
    └── app_zh.arb    # Chinese
```

### ARB Format

```json
{
  "@@locale": "en",
  "appTitle": "Flutter Project Template",
  "@appTitle": {
    "description": "Application title"
  },
  "welcomeMessage": "Welcome!",
  "@welcomeMessage": {
    "description": "Welcome message displayed to users"
  }
}
```

---

## Using Translations

### Basic Usage

```dart
import 'package:flutter_project_template/l10n/app_localizations.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Text(l10n.appTitle);
  }
}
```

### In Provider/ViewModel

```dart
// Pass context or use via parameter
String getMessage(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return l10n.welcomeMessage;
}
```

---

## LocaleProvider Pattern

### Provider Definition

```dart
@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale? build() {
    // Return saved locale or system default
  }

  Future<void> setLocale(Locale locale) async {
    // Save and update state
  }

  void resetToSystem() {
    // Reset to system locale
  }
}
```

### Locale Options

```dart
enum LocaleOption {
  system(null, 'System'),
  english(Locale('en'), 'English'),
  chinese(Locale('zh'), '中文');

  final Locale? locale;
  final String label;
  const LocaleOption(this.locale, this.label);
}
```

---

## Adding New Translations

### Step 1: Add to ARB files

```json
// app_en.arb
{
  "newKey": "New String",
  "@newKey": {
    "description": "Description of the new string"
  }
}

// app_zh.arb
{
  "newKey": "新字符串"
}
```

### Step 2: Generate code

```bash
flutter gen-l10n
```

### Step 3: Use in code

```dart
Text(AppLocalizations.of(context)!.newKey)
```

---

## Best Practices

### Do's

1. **Always add descriptions** to ARB entries for context
2. **Use semantic keys** like `loginButton` instead of `button1`
3. **Keep translations in sync** across all ARB files
4. **Use placeholders** for interpolated strings:
   ```json
   {
     "greeting": "Hello, {name}!",
     "@greeting": {
       "placeholders": {
         "name": {}
       }
     }
   }
   ```

### Don'ts

1. **Don't hardcode strings** in UI code
2. **Don't use machine translations** without review
3. **Don't forget plural forms** when needed
4. **Don't reuse keys** for different contexts

---

## Language Switching

### Dialog Implementation

```dart
Future<void> showLanguageDialog(BuildContext context, WidgetRef ref) async {
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.selectLanguage),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: LocaleOption.values.map((option) {
          return RadioListTile<LocaleOption>(
            title: Text(option.label),
            value: option,
            groupValue: currentOption,
            onChanged: (value) {
              if (value != null) {
                if (value.locale == null) {
                  ref.read(localeNotifierProvider.notifier).resetToSystem();
                } else {
                  ref.read(localeNotifierProvider.notifier).setLocale(value.locale!);
                }
              }
            },
          );
        }).toList(),
      ),
    ),
  );
}
```

---

## Testing

### Widget Tests with Localization

```dart
testWidgets('MyWidget shows localized text', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en'), Locale('zh')],
      locale: Locale('en'),
      home: MyWidget(),
    ),
  );

  expect(find.text('Expected English Text'), findsOneWidget);
});
```

---

## Common Issues

### Missing Translation

**Problem**: `AppLocalizations.of(context)` returns null

**Solution**: Ensure MaterialApp has `localizationsDelegates` configured

### Key Not Found

**Problem**: Runtime error for missing key

**Solution**: 
1. Add key to ARB files
2. Run `flutter gen-l10n`
3. Restart app

### Language Not Changing

**Problem**: Language switch doesn't work

**Solution**: 
1. Check `localeNotifierProvider` is being watched
2. Verify `locale` parameter in MaterialApp uses the provider
3. Ensure SharedPreferences is working