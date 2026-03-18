/// Environment configuration for the application.
///
/// This file defines environment types and their configurations.
library;

import 'package:flutter/foundation.dart';

/// Environment type enumeration.
enum EnvironmentType {
  /// Development environment.
  development,

  /// Staging environment.
  staging,

  /// Production environment.
  production,
}

/// Environment configuration.
///
/// Contains all configuration for a specific environment.
@immutable
class EnvironmentConfig {
  /// Creates an environment configuration.
  const EnvironmentConfig({
    required this.type,
    required this.baseUrl,
    required this.logLevel,
    required this.debugMode,
    this.analyticsEnabled = true,
    this.crashlyticsEnabled = true,
  });

  /// The environment type.
  final EnvironmentType type;

  /// API base URL for this environment.
  final String baseUrl;

  /// Log level for this environment.
  final LogLevel logLevel;

  /// Debug mode flag.
  final bool debugMode;

  /// Whether analytics is enabled.
  final bool analyticsEnabled;

  /// Whether crashlytics is enabled.
  final bool crashlyticsEnabled;

  /// Development environment configuration.
  static const EnvironmentConfig development = EnvironmentConfig(
    type: EnvironmentType.development,
    baseUrl: 'https://dev-api.example.com',
    logLevel: LogLevel.debug,
    debugMode: true,
    analyticsEnabled: false,
  );

  /// Staging environment configuration.
  static const EnvironmentConfig staging = EnvironmentConfig(
    type: EnvironmentType.staging,
    baseUrl: 'https://staging-api.example.com',
    logLevel: LogLevel.info,
    debugMode: true,
  );

  /// Production environment configuration.
  static const EnvironmentConfig production = EnvironmentConfig(
    type: EnvironmentType.production,
    baseUrl: 'https://api.example.com',
    logLevel: LogLevel.warning,
    debugMode: false,
  );

  /// Gets the configuration for the given environment type.
  static EnvironmentConfig fromType(EnvironmentType type) => switch (type) {
        EnvironmentType.development => development,
        EnvironmentType.staging => staging,
        EnvironmentType.production => production,
      };

  /// Returns a copy of this configuration with the given fields replaced.
  EnvironmentConfig copyWith({
    EnvironmentType? type,
    String? baseUrl,
    LogLevel? logLevel,
    bool? debugMode,
    bool? analyticsEnabled,
    bool? crashlyticsEnabled,
  }) =>
      EnvironmentConfig(
        type: type ?? this.type,
        baseUrl: baseUrl ?? this.baseUrl,
        logLevel: logLevel ?? this.logLevel,
        debugMode: debugMode ?? this.debugMode,
        analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
        crashlyticsEnabled: crashlyticsEnabled ?? this.crashlyticsEnabled,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EnvironmentConfig &&
        other.type == type &&
        other.baseUrl == baseUrl &&
        other.logLevel == logLevel &&
        other.debugMode == debugMode &&
        other.analyticsEnabled == analyticsEnabled &&
        other.crashlyticsEnabled == crashlyticsEnabled;
  }

  @override
  int get hashCode => Object.hash(
        type,
        baseUrl,
        logLevel,
        debugMode,
        analyticsEnabled,
        crashlyticsEnabled,
      );

  @override
  String toString() => 'EnvironmentConfig(type: $type, baseUrl: $baseUrl, '
      'logLevel: $logLevel, debugMode: $debugMode)';
}

/// Log level enumeration.
enum LogLevel {
  /// Debug level - verbose logging.
  debug,

  /// Info level - informational messages.
  info,

  /// Warning level - warning messages.
  warning,

  /// Error level - error messages only.
  error,

  /// None - no logging.
  none,
}
