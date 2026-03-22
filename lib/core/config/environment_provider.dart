/// Environment provider for managing app environment configuration.
library;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_project_template/core/config/environment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'environment_provider.g.dart';

/// SharedPreferences provider.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
}

/// Environment local data source.
class EnvironmentLocalDataSource {
  /// Creates an environment local data source.
  EnvironmentLocalDataSource({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  /// Key for storing environment type.
  static const String _environmentKey = 'app_environment';

  /// Gets the stored environment type.
  EnvironmentType? getEnvironmentType() {
    final typeString = _sharedPreferences.getString(_environmentKey);
    if (typeString == null) return null;

    // Find the matching environment type, return null if not found
    for (final type in EnvironmentType.values) {
      if (type.name == typeString) {
        return type;
      }
    }
    return null;
  }

  /// Saves the environment type.
  Future<void> saveEnvironmentType(EnvironmentType type) async {
    await _sharedPreferences.setString(_environmentKey, type.name);
  }

  /// Gets the stored custom environment config (if any).
  EnvironmentConfig? getCustomEnvironmentConfig() {
    final jsonString =
        _sharedPreferences.getString('${_environmentKey}_custom');
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return EnvironmentConfig(
        type: EnvironmentType.values.firstWhere(
          (type) => type.name == json['type'] as String,
        ),
        baseUrl: json['baseUrl'] as String,
        logLevel: LogLevel.values.firstWhere(
          (level) => level.name == json['logLevel'] as String,
        ),
        debugMode: json['debugMode'] as bool,
        analyticsEnabled: json['analyticsEnabled'] as bool? ?? true,
        crashlyticsEnabled: json['crashlyticsEnabled'] as bool? ?? true,
      );
    } on Exception {
      return null;
    }
  }

  /// Saves a custom environment config.
  Future<void> saveCustomEnvironmentConfig(EnvironmentConfig config) async {
    final json = {
      'type': config.type.name,
      'baseUrl': config.baseUrl,
      'logLevel': config.logLevel.name,
      'debugMode': config.debugMode,
      'analyticsEnabled': config.analyticsEnabled,
      'crashlyticsEnabled': config.crashlyticsEnabled,
    };
    await _sharedPreferences.setString(
      '${_environmentKey}_custom',
      jsonEncode(json),
    );
  }

  /// Clears all environment settings.
  Future<void> clearEnvironment() async {
    await Future.wait([
      _sharedPreferences.remove(_environmentKey),
      _sharedPreferences.remove('${_environmentKey}_custom'),
    ]);
  }
}

/// Environment local data source provider.
@Riverpod(keepAlive: true)
EnvironmentLocalDataSource environmentLocalDataSource(Ref ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return EnvironmentLocalDataSource(sharedPreferences: sharedPreferences);
}

/// Environment configuration provider.
///
/// This provider manages the current environment configuration.
/// It loads the saved environment on startup and provides
/// methods to switch environments.
@Riverpod(keepAlive: true)
class Environment extends _$Environment {
  late EnvironmentLocalDataSource _dataSource;

  @override
  EnvironmentConfig build() {
    _dataSource = ref.read(environmentLocalDataSourceProvider);

    // In release mode, always use production environment
    if (!bool.fromEnvironment('dart.vm.product')) {
      // In debug mode, load saved environment or use development as default
      final savedType = _dataSource.getEnvironmentType();
      if (savedType != null) {
        return EnvironmentConfig.fromType(savedType);
      }
    }

    // Default to production environment
    return EnvironmentConfig.production;
  }

  /// Switches to a different environment.
  ///
  /// After calling this method, the app should be restarted
  /// for changes to take full effect.
  Future<void> switchEnvironment(EnvironmentType type) async {
    await _dataSource.saveEnvironmentType(type);
    state = EnvironmentConfig.fromType(type);
  }

  /// Sets a custom environment configuration.
  ///
  /// This is useful for testing or custom environments.
  Future<void> setCustomConfig(EnvironmentConfig config) async {
    await _dataSource.saveCustomEnvironmentConfig(config);
    await _dataSource.saveEnvironmentType(config.type);
    state = config;
  }

  /// Resets to the default environment for the current build mode.
  Future<void> resetToDefault() async {
    await _dataSource.clearEnvironment();

    // Reset to production in release mode, development in debug
    if (bool.fromEnvironment('dart.vm.product')) {
      state = EnvironmentConfig.production;
    } else {
      state = EnvironmentConfig.development;
    }
  }

  /// Gets the current environment type.
  EnvironmentType get currentType => state.type;

  /// Gets the current base URL.
  String get baseUrl => state.baseUrl;

  /// Checks if the current environment is development.
  bool get isDevelopment => state.type == EnvironmentType.development;

  /// Checks if the current environment is staging.
  bool get isStaging => state.type == EnvironmentType.staging;

  /// Checks if the current environment is production.
  bool get isProduction => state.type == EnvironmentType.production;

  /// Checks if debug mode is enabled.
  bool get isDebugMode => state.debugMode;

  /// Gets the current log level.
  LogLevel get logLevel => state.logLevel;
}

/// Provider for checking if developer options should be visible.
///
/// Developer options are only shown in debug mode.
@riverpod
bool showDeveloperOptions(Ref ref) => kDebugMode;
