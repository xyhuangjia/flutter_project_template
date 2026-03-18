/// Settings entity representing user settings.
library;

import 'package:flutter/foundation.dart';

/// Theme mode enum.
enum AppThemeMode {
  /// System theme.
  system,

  /// Light theme.
  light,

  /// Dark theme.
  dark,
}

/// Settings entity representing application settings.
@immutable
class SettingsEntity {
  /// Creates a settings entity.
  const SettingsEntity({
    this.themeMode = AppThemeMode.system,
    this.languageCode,
    this.notificationsEnabled = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
  });

  /// Default settings.
  static const defaultSettings = SettingsEntity();

  /// Theme mode.
  final AppThemeMode themeMode;

  /// Language code (null for system).
  final String? languageCode;

  /// Whether notifications are enabled.
  final bool notificationsEnabled;

  /// Whether sound is enabled.
  final bool soundEnabled;

  /// Whether vibration is enabled.
  final bool vibrationEnabled;

  /// Creates a copy of this entity with optionally overridden fields.
  SettingsEntity copyWith({
    AppThemeMode? themeMode,
    String? languageCode,
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    return SettingsEntity(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SettingsEntity &&
        other.themeMode == themeMode &&
        other.languageCode == languageCode &&
        other.notificationsEnabled == notificationsEnabled &&
        other.soundEnabled == soundEnabled &&
        other.vibrationEnabled == vibrationEnabled;
  }

  @override
  int get hashCode {
    return Object.hash(
      themeMode,
      languageCode,
      notificationsEnabled,
      soundEnabled,
      vibrationEnabled,
    );
  }

  @override
  String toString() {
    return 'SettingsEntity(themeMode: $themeMode, languageCode: $languageCode, '
        'notificationsEnabled: $notificationsEnabled, soundEnabled: $soundEnabled, '
        'vibrationEnabled: $vibrationEnabled)';
  }
}
