/// Developer options local data source.
library;

import 'dart:convert';

import 'package:flutter_project_template/features/settings/data/models/developer_options_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Developer options local data source.
///
/// Handles local storage of developer options using SharedPreferences.
class DeveloperOptionsLocalDataSource {
  /// Creates developer options local data source.
  DeveloperOptionsLocalDataSource({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  /// Key for storing developer options.
  static const String _developerOptionsKey = 'developer_options';

  /// Gets the stored developer options.
  DeveloperOptionsDto? getDeveloperOptions() {
    final jsonString = _sharedPreferences.getString(_developerOptionsKey);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return DeveloperOptionsDto.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  /// Saves the developer options.
  Future<void> saveDeveloperOptions(DeveloperOptionsDto options) async {
    final jsonString = jsonEncode(options.toJson());
    await _sharedPreferences.setString(_developerOptionsKey, jsonString);
  }

  /// Clears developer options.
  Future<void> clearDeveloperOptions() async {
    await _sharedPreferences.remove(_developerOptionsKey);
  }

  /// Gets the total cache size in bytes.
  Future<int> getCacheSize() async {
    // This is a simplified implementation.
    // In a real app, you would calculate the actual cache size.
    return 0;
  }

  /// Clears all app cache.
  Future<void> clearCache() async {
    await _sharedPreferences.clear();
  }
}
