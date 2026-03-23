/// Developer options entity.
library;

import 'package:flutter/foundation.dart';

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

/// Developer options entity.
@immutable
class DeveloperOptions {
  /// Creates developer options.
  const DeveloperOptions({
    this.customApiBaseUrl,
    this.logLevel = LogLevel.debug,
    this.loggingEnabled = true,
    this.networkLogEnabled = true,
    this.performanceMonitorEnabled = false,
    this.showDebugInfo = false,
    this.experimentalFeatures = const {},
  });

  /// Custom API base URL (null means use environment default).
  final String? customApiBaseUrl;

  /// Log level for the application.
  final LogLevel logLevel;

  /// Whether logging is enabled.
  final bool loggingEnabled;

  /// Whether network request logging is enabled.
  final bool networkLogEnabled;

  /// Whether performance monitoring is enabled.
  final bool performanceMonitorEnabled;

  /// Whether to show debug info overlay.
  final bool showDebugInfo;

  /// Experimental features flags.
  final Map<String, bool> experimentalFeatures;

  /// Default developer options.
  static const DeveloperOptions defaults = DeveloperOptions();

  /// Creates a copy with optionally overridden fields.
  DeveloperOptions copyWith({
    String? customApiBaseUrl,
    bool clearCustomApiBaseUrl = false,
    LogLevel? logLevel,
    bool? loggingEnabled,
    bool? networkLogEnabled,
    bool? performanceMonitorEnabled,
    bool? showDebugInfo,
    Map<String, bool>? experimentalFeatures,
  }) => DeveloperOptions(
      customApiBaseUrl: clearCustomApiBaseUrl
          ? null
          : customApiBaseUrl ?? this.customApiBaseUrl,
      logLevel: logLevel ?? this.logLevel,
      loggingEnabled: loggingEnabled ?? this.loggingEnabled,
      networkLogEnabled: networkLogEnabled ?? this.networkLogEnabled,
      performanceMonitorEnabled:
          performanceMonitorEnabled ?? this.performanceMonitorEnabled,
      showDebugInfo: showDebugInfo ?? this.showDebugInfo,
      experimentalFeatures: experimentalFeatures ?? this.experimentalFeatures,
    );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeveloperOptions &&
        other.customApiBaseUrl == customApiBaseUrl &&
        other.logLevel == logLevel &&
        other.loggingEnabled == loggingEnabled &&
        other.networkLogEnabled == networkLogEnabled &&
        other.performanceMonitorEnabled == performanceMonitorEnabled &&
        other.showDebugInfo == showDebugInfo &&
        _mapEquals(other.experimentalFeatures, experimentalFeatures);
  }

  @override
  int get hashCode => Object.hash(
      customApiBaseUrl,
      logLevel,
      loggingEnabled,
      networkLogEnabled,
      performanceMonitorEnabled,
      showDebugInfo,
      Object.hashAll(experimentalFeatures.entries),
    );

  @override
  String toString() => 'DeveloperOptions(customApiBaseUrl: $customApiBaseUrl, '
        'logLevel: $logLevel, loggingEnabled: $loggingEnabled, '
        'networkLogEnabled: $networkLogEnabled, '
        'performanceMonitorEnabled: $performanceMonitorEnabled, '
        'showDebugInfo: $showDebugInfo, '
        'experimentalFeatures: $experimentalFeatures)';

  static bool _mapEquals(Map<String, bool> a, Map<String, bool> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
  }
}
