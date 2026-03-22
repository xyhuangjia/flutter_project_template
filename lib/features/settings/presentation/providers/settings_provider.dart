/// Settings provider using Riverpod code generation.
library;

import 'dart:ui';

import 'package:flutter_project_template/core/providers/locale_provider.dart';
import 'package:flutter_project_template/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:flutter_project_template/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:flutter_project_template/features/settings/domain/entities/settings_entity.dart';
import 'package:flutter_project_template/features/settings/domain/entities/user_preferences.dart';
import 'package:flutter_project_template/features/settings/domain/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

/// Provider for SettingsLocalDataSource.
@riverpod
SettingsLocalDataSource settingsLocalDataSource(
    SettingsLocalDataSourceRef ref) {
  final prefs = ref.watch(sharedPrefsProvider).valueOrNull;
  if (prefs == null) {
    throw StateError('SharedPreferences not initialized');
  }
  return SettingsLocalDataSource(sharedPreferences: prefs);
}

/// Provider for SettingsRepository.
@riverpod
SettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  return SettingsRepositoryImpl(
    localDataSource: ref.watch(settingsLocalDataSourceProvider),
  );
}

/// Settings state notifier provider.
///
/// Manages the application settings.
@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Future<SettingsEntity> build() async {
    await ref.watch(sharedPrefsProvider.future);
    final repository = ref.read(settingsRepositoryProvider);
    final result = await repository.getSettings();

    final settings = result.when(
      failure: (_) => SettingsEntity.defaultSettings,
      success: (s) => s,
    );

    final currentLocale = ref.read(localeNotifierProvider).valueOrNull;
    if (currentLocale?.languageCode != settings.languageCode) {
      final locale =
          settings.languageCode != null ? Locale(settings.languageCode!) : null;
      await ref.read(localeNotifierProvider.notifier).setLocale(locale);
    }

    return settings;
  }

  Future<bool> updateThemeMode(AppThemeMode themeMode) async {
    final repository = ref.read(settingsRepositoryProvider);
    final result = await repository.updateThemeMode(themeMode);

    result.when(
      failure: (_) => null,
      success: (s) => state = AsyncValue.data(s),
    );

    return !result.isFailure;
  }

  Future<bool> updateLanguage(String? languageCode) async {
    final repository = ref.read(settingsRepositoryProvider);
    final result = await repository.updateLanguage(languageCode);

    result.when(
      failure: (_) => null,
      success: (s) {
        state = AsyncValue.data(s);
        final locale = languageCode != null ? Locale(languageCode) : null;
        ref.read(localeNotifierProvider.notifier).setLocale(locale);
      },
    );

    return !result.isFailure;
  }

  Future<bool> updateNotifications({required bool enabled}) async {
    final repository = ref.read(settingsRepositoryProvider);
    final result = await repository.updateNotifications(enabled);

    result.when(
      failure: (_) => null,
      success: (s) => state = AsyncValue.data(s),
    );

    return !result.isFailure;
  }

  Future<bool> updateAccessibilityMode(AccessibilityMode mode) async {
    final repository = ref.read(settingsRepositoryProvider);
    final result = await repository.updateAccessibilityMode(mode);

    result.when(
      failure: (_) => null,
      success: (s) => state = AsyncValue.data(s),
    );

    return !result.isFailure;
  }

  Future<bool> clearSettings() async {
    final repository = ref.read(settingsRepositoryProvider);
    final result = await repository.clearSettings();

    result.when(
      failure: (_) => null,
      success: (_) =>
          state = const AsyncValue.data(SettingsEntity.defaultSettings),
    );

    return !result.isFailure;
  }
}

/// User preferences notifier provider.
///
/// Manages the user preferences.
@riverpod
class UserPreferencesNotifier extends _$UserPreferencesNotifier {
  @override
  Future<UserPreferences> build() async {
    await ref.watch(sharedPrefsProvider.future);
    final repository = ref.read(settingsRepositoryProvider);
    final result = await repository.getUserPreferences();

    return result.when(
      failure: (_) => const UserPreferences(),
      success: (p) => p,
    );
  }

  Future<bool> updatePreferences(UserPreferences preferences) async {
    final repository = ref.read(settingsRepositoryProvider);
    final result = await repository.updateUserPreferences(preferences);

    result.when(
      failure: (_) => null,
      success: (updated) => state = AsyncValue.data(updated),
    );

    return !result.isFailure;
  }
}
