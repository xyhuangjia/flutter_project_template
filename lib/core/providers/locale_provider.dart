/// Locale provider for managing app language settings.
///
/// This provider manages the current locale state and persists
/// user preferences using SharedPreferences.
library;

import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_provider.g.dart';

/// Key for storing locale preference in SharedPreferences.
const String _localePreferenceKey = 'app_locale';

/// Async SharedPreferences provider for initialization.
@riverpod
class SharedPrefs extends _$SharedPrefs {
  @override
  Future<SharedPreferences> build() async {
    return SharedPreferences.getInstance();
  }
}

/// Locale notifier provider for managing app locale.
///
/// Supports:
/// - English (en)
/// - Chinese (zh)
/// - System default (null)
@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Future<Locale?> build() async {
    // Load saved locale preference
    final prefs = await ref.watch(sharedPrefsProvider.future);
    final savedLocale = prefs.getString(_localePreferenceKey);

    if (savedLocale == null || savedLocale == 'system') {
      // Follow system locale
      return null;
    }

    return Locale(savedLocale);
  }

  /// Sets the app locale.
  ///
  /// Pass `null` to follow system locale.
  Future<void> setLocale(Locale? locale) async {
    final prefs = await ref.read(sharedPrefsProvider.future);

    if (locale == null) {
      await prefs.setString(_localePreferenceKey, 'system');
    } else {
      await prefs.setString(_localePreferenceKey, locale.languageCode);
    }

    state = AsyncData(locale);
  }

  /// Returns the effective locale.
  ///
  /// If the saved locale is null, returns the system locale.
  /// Otherwise returns the saved locale.
  Locale get effectiveLocale {
    final savedLocale = state.valueOrNull;
    if (savedLocale != null) {
      return savedLocale;
    }
    // Return system locale or default to English
    return PlatformDispatcher.instance.locale;
  }

  /// Returns whether the current locale is Chinese.
  bool get isChinese {
    final locale = effectiveLocale;
    return locale.languageCode == 'zh';
  }

  /// Toggles between English and Chinese.
  Future<void> toggleLocale() async {
    final currentLocale = state.valueOrNull;
    if (currentLocale?.languageCode == 'zh') {
      await setLocale(const Locale('en'));
    } else {
      await setLocale(const Locale('zh'));
    }
  }

  /// Resets to system locale.
  Future<void> resetToSystem() async {
    await setLocale(null);
  }
}

/// Supported locales list.
const List<Locale> supportedLocales = [
  Locale('en'),
  Locale('zh'),
];

/// Locale option for language selection.
enum LocaleOption {
  /// Follow system locale.
  system,

  /// English locale.
  english,

  /// Chinese locale.
  chinese,
}

/// Extension on LocaleOption to get the locale.
extension LocaleOptionExtension on LocaleOption {
  /// Returns the locale for this option.
  Locale? get locale {
    switch (this) {
      case LocaleOption.system:
        return null;
      case LocaleOption.english:
        return const Locale('en');
      case LocaleOption.chinese:
        return const Locale('zh');
    }
  }

  /// Returns the display name for this option.
  String get displayName {
    switch (this) {
      case LocaleOption.system:
        return 'Follow System';
      case LocaleOption.english:
        return 'English';
      case LocaleOption.chinese:
        return '中文';
    }
  }
}
