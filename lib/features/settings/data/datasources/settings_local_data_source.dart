/// Settings local data source for caching settings.
library;

import 'dart:convert';

import 'package:flutter_project_template/features/settings/data/models/settings_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Settings local data source.
///
/// Handles local storage of settings using SharedPreferences.
class SettingsLocalDataSource {
  /// Creates a settings local data source.
  SettingsLocalDataSource({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  /// Key for storing settings.
  static const String _settingsKey = 'app_settings';

  /// Key for storing user preferences.
  static const String _userPreferencesKey = 'user_preferences';

  /// Gets the stored settings.
  SettingsDto? getSettings() {
    final jsonString = _sharedPreferences.getString(_settingsKey);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return SettingsDto.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  /// Saves the settings.
  Future<void> saveSettings(SettingsDto settings) async {
    final jsonString = jsonEncode(settings.toJson());
    await _sharedPreferences.setString(_settingsKey, jsonString);
  }

  /// Gets the stored user preferences.
  UserPreferencesDto? getUserPreferences() {
    final jsonString = _sharedPreferences.getString(_userPreferencesKey);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserPreferencesDto.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  /// Saves the user preferences.
  Future<void> saveUserPreferences(UserPreferencesDto preferences) async {
    final jsonString = jsonEncode(preferences.toJson());
    await _sharedPreferences.setString(_userPreferencesKey, jsonString);
  }

  /// Clears all settings.
  Future<void> clearSettings() async {
    await Future.wait([
      _sharedPreferences.remove(_settingsKey),
      _sharedPreferences.remove(_userPreferencesKey),
    ]);
  }
}
