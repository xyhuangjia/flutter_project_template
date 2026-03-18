/// Settings provider using Riverpod code generation.
library;

import 'dart:ui';

import 'package:flutter_project_template/core/providers/locale_provider.dart';
import 'package:flutter_project_template/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:flutter_project_template/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:flutter_project_template/features/settings/domain/entities/settings_entity.dart';
import 'package:flutter_project_template/features/settings/domain/entities/user_preferences.dart';
import 'package:flutter_project_template/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_provider.g.dart';

/// Provider for SettingsLocalDataSource.
@Riverpod(keepAlive: true)
SettingsLocalDataSource settingsLocalDataSource(
  SettingsLocalDataSourceRef ref,
) {
  return SettingsLocalDataSource(
    sharedPreferences: ref.watch(sharedPreferencesProvider),
  );
}

/// Provider for SharedPreferences.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  throw UnimplementedError('Override with SharedPreferences instance');
}

/// Provider for SettingsRepository.
@Riverpod(keepAlive: true)
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
    final repository = ref.read(settingsRepositoryProvider);
    final result = await repository.getSettings();

    final settings = result.when(
      failure: (failure) => SettingsEntity.defaultSettings,
      success: (settings) => settings,
    );

    // Sync with locale provider on initialization
    final currentLocale = ref.read(localeNotifierProvider).valueOrNull;
    if (currentLocale?.languageCode != settings.languageCode) {
      // Update locale provider to match settings
      final locale =
          settings.languageCode != null ? Locale(settings.languageCode!) : null;
      ref.read(localeNotifierProvider.notifier).setLocale(locale);
    }

    return settings;
  }

  /// Updates the theme mode.
  Future<bool> updateThemeMode(AppThemeMode themeMode) async {
    final repository = ref.read(settingsRepositoryProvider);
    final result = await repository.updateThemeMode(themeMode);

    result.when(
      failure: (failure) => null,
      success: (settings) {
        state = AsyncValue.data(settings);
      },
    );

    return !result.isFailure;
  }

  /// Updates the language.
  Future<bool> updateLanguage(String? languageCode) async {
    final repository = ref.read(settingsRepositoryProvider);
    final result = await repository.updateLanguage(languageCode);

    result.when(
      failure: (failure) => null,
      success: (settings) {
        state = AsyncValue.data(settings);
        // Sync with locale provider to update app language
        final locale = languageCode != null ? Locale(languageCode) : null;
        ref.read(localeNotifierProvider.notifier).setLocale(locale);
      },
    );

    return !result.isFailure;
  }

  /// Updates notification settings.
  Future<bool> updateNotifications(bool enabled) async {
    final repository = ref.read(settingsRepositoryProvider);
    final result = await repository.updateNotifications(enabled);

    result.when(
      failure: (failure) => null,
      success: (settings) {
        state = AsyncValue.data(settings);
      },
    );

    return !result.isFailure;
  }

  /// Clears all settings.
  Future<bool> clearSettings() async {
    final repository = ref.read(settingsRepositoryProvider);
    final result = await repository.clearSettings();

    result.when(
      failure: (failure) => null,
      success: (_) {
        state = const AsyncValue.data(SettingsEntity.defaultSettings);
      },
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
    final repository = ref.read(settingsRepositoryProvider);
    final result = await repository.getUserPreferences();

    return result.when(
      failure: (failure) => const UserPreferences(),
      success: (preferences) => preferences,
    );
  }

  /// Updates the user preferences.
  Future<bool> updatePreferences(UserPreferences preferences) async {
    final repository = ref.read(settingsRepositoryProvider);
    final result = await repository.updateUserPreferences(preferences);

    result.when(
      failure: (failure) => null,
      success: (updated) {
        state = AsyncValue.data(updated);
      },
    );

    return !result.isFailure;
  }
}
