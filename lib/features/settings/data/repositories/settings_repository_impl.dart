/// Settings repository implementation.
library;

import 'package:flutter_project_template/core/errors/error_handler.dart';
import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:flutter_project_template/features/settings/data/models/settings_dto.dart';
import 'package:flutter_project_template/features/settings/domain/entities/settings_entity.dart';
import 'package:flutter_project_template/features/settings/domain/entities/user_preferences.dart';
import 'package:flutter_project_template/features/settings/domain/repositories/settings_repository.dart';

/// Settings repository implementation.
class SettingsRepositoryImpl implements SettingsRepository {
  /// Creates a settings repository.
  SettingsRepositoryImpl({required SettingsLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  final SettingsLocalDataSource _localDataSource;

  @override
  Future<Result<SettingsEntity>> getSettings() async {
    try {
      final dto = _localDataSource.getSettings();
      if (dto == null) {
        return const Success(SettingsEntity.defaultSettings);
      }
      return Success(dto.toEntity());
    } on Exception catch (e) {
      return FailureResult(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<SettingsEntity>> updateSettings(SettingsEntity settings) async {
    try {
      final dto = SettingsDto.fromEntity(settings);
      await _localDataSource.saveSettings(dto);
      return Success(settings);
    } on Exception catch (e) {
      return FailureResult(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<UserPreferences>> getUserPreferences() async {
    try {
      final dto = _localDataSource.getUserPreferences();
      if (dto == null) {
        return const Success(UserPreferences());
      }
      return Success(dto.toEntity());
    } on Exception catch (e) {
      return FailureResult(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<UserPreferences>> updateUserPreferences(
    UserPreferences preferences,
  ) async {
    try {
      final dto = UserPreferencesDto.fromEntity(preferences);
      await _localDataSource.saveUserPreferences(dto);
      return Success(preferences);
    } on Exception catch (e) {
      return FailureResult(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<SettingsEntity>> updateThemeMode(AppThemeMode themeMode) async {
    try {
      final currentSettings = await getSettings();
      return currentSettings.when(
        success: (settings) async {
          final updated = settings.copyWith(themeMode: themeMode);
          final dto = SettingsDto.fromEntity(updated);
          await _localDataSource.saveSettings(dto);
          return Success(updated);
        },
        failure: (failure) => FailureResult(failure),
      );
    } on Exception catch (e) {
      return FailureResult(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<SettingsEntity>> updateLanguage(String? languageCode) async {
    try {
      final currentSettings = await getSettings();
      return currentSettings.when(
        success: (settings) async {
          final updated = settings.copyWith(languageCode: languageCode);
          final dto = SettingsDto.fromEntity(updated);
          await _localDataSource.saveSettings(dto);
          return Success(updated);
        },
        failure: (failure) => FailureResult(failure),
      );
    } on Exception catch (e) {
      return FailureResult(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<SettingsEntity>> updateNotifications(bool enabled) async {
    try {
      final currentSettings = await getSettings();
      return currentSettings.when(
        success: (settings) async {
          final updated = settings.copyWith(notificationsEnabled: enabled);
          final dto = SettingsDto.fromEntity(updated);
          await _localDataSource.saveSettings(dto);
          return Success(updated);
        },
        failure: (failure) => FailureResult(failure),
      );
    } on Exception catch (e) {
      return FailureResult(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<SettingsEntity>> updateAccessibilityMode(
    AccessibilityMode mode,
  ) async {
    try {
      final currentSettings = await getSettings();
      return currentSettings.when(
        success: (settings) async {
          final updated = settings.copyWith(accessibilityMode: mode);
          final dto = SettingsDto.fromEntity(updated);
          await _localDataSource.saveSettings(dto);
          return Success(updated);
        },
        failure: (failure) => FailureResult(failure),
      );
    } on Exception catch (e) {
      return FailureResult(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<void>> clearSettings() async {
    try {
      await _localDataSource.clearSettings();
      return const Success(null);
    } on Exception catch (e) {
      return FailureResult(ErrorHandler.handleException(e));
    }
  }
}
