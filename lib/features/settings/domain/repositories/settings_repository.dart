/// Settings repository interface.
library;

import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/settings/domain/entities/settings_entity.dart';
import 'package:flutter_project_template/features/settings/domain/entities/user_preferences.dart';

/// Settings repository interface.
abstract class SettingsRepository {
  /// Gets the current settings.
  Future<Result<SettingsEntity>> getSettings();

  /// Updates the settings.
  Future<Result<SettingsEntity>> updateSettings(SettingsEntity settings);

  /// Gets the user preferences.
  Future<Result<UserPreferences>> getUserPreferences();

  /// Updates the user preferences.
  Future<Result<UserPreferences>> updateUserPreferences(
    UserPreferences preferences,
  );

  /// Updates the theme mode.
  Future<Result<SettingsEntity>> updateThemeMode(AppThemeMode themeMode);

  /// Updates the language code.
  Future<Result<SettingsEntity>> updateLanguage(String? languageCode);

  /// Updates notification settings.
  Future<Result<SettingsEntity>> updateNotifications(bool enabled);

  /// Clears all settings.
  Future<Result<void>> clearSettings();
}
