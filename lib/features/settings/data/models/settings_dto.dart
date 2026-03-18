/// Settings DTO for data transfer.
library;

import 'package:flutter_project_template/features/settings/domain/entities/settings_entity.dart';
import 'package:flutter_project_template/features/settings/domain/entities/user_preferences.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings_dto.g.dart';

/// Settings data transfer object.
@JsonSerializable()
class SettingsDto {
  /// Creates a settings DTO.
  const SettingsDto({
    this.themeMode = 'system',
    this.languageCode,
    this.notificationsEnabled = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
  });

  /// Creates a settings DTO from JSON.
  factory SettingsDto.fromJson(Map<String, dynamic> json) =>
      _$SettingsDtoFromJson(json);

  /// Theme mode string.
  final String themeMode;

  /// Language code.
  final String? languageCode;

  /// Whether notifications are enabled.
  final bool notificationsEnabled;

  /// Whether sound is enabled.
  final bool soundEnabled;

  /// Whether vibration is enabled.
  final bool vibrationEnabled;

  /// Converts this DTO to JSON.
  Map<String, dynamic> toJson() => _$SettingsDtoToJson(this);

  /// Converts this DTO to a domain entity.
  SettingsEntity toEntity() => SettingsEntity(
        themeMode: _parseThemeMode(themeMode),
        languageCode: languageCode,
        notificationsEnabled: notificationsEnabled,
        soundEnabled: soundEnabled,
        vibrationEnabled: vibrationEnabled,
      );

  /// Creates a DTO from an entity.
  factory SettingsDto.fromEntity(SettingsEntity entity) => SettingsDto(
        themeMode: entity.themeMode.name,
        languageCode: entity.languageCode,
        notificationsEnabled: entity.notificationsEnabled,
        soundEnabled: entity.soundEnabled,
        vibrationEnabled: entity.vibrationEnabled,
      );

  /// Parses theme mode string to enum.
  static AppThemeMode _parseThemeMode(String mode) {
    return switch (mode) {
      'light' => AppThemeMode.light,
      'dark' => AppThemeMode.dark,
      _ => AppThemeMode.system,
    };
  }
}

/// User preferences DTO.
@JsonSerializable()
class UserPreferencesDto {
  /// Creates a user preferences DTO.
  const UserPreferencesDto({
    this.displayName,
    this.avatarUrl,
    this.bio,
    this.phoneNumber,
    this.email,
  });

  /// Creates a user preferences DTO from JSON.
  factory UserPreferencesDto.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesDtoFromJson(json);

  /// The user's display name.
  final String? displayName;

  /// The user's avatar URL.
  final String? avatarUrl;

  /// The user's bio.
  final String? bio;

  /// The user's phone number.
  final String? phoneNumber;

  /// The user's email.
  final String? email;

  /// Converts this DTO to JSON.
  Map<String, dynamic> toJson() => _$UserPreferencesDtoToJson(this);

  /// Converts this DTO to a domain entity.
  UserPreferences toEntity() => UserPreferences(
        displayName: displayName,
        avatarUrl: avatarUrl,
        bio: bio,
        phoneNumber: phoneNumber,
        email: email,
      );

  /// Creates a DTO from an entity.
  factory UserPreferencesDto.fromEntity(UserPreferences entity) =>
      UserPreferencesDto(
        displayName: entity.displayName,
        avatarUrl: entity.avatarUrl,
        bio: entity.bio,
        phoneNumber: entity.phoneNumber,
        email: entity.email,
      );
}
