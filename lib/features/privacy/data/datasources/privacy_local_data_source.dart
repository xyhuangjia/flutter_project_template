/// Privacy local data source for storing privacy settings.
library;

import 'dart:convert';

import 'package:flutter_project_template/core/logging/talker_config.dart';
import 'package:flutter_project_template/features/privacy/data/models/privacy_consent_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Privacy local data source.
class PrivacyLocalDataSource {
  /// Creates a privacy local data source.
  PrivacyLocalDataSource({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  /// Key for storing privacy consent.
  static const String _privacyConsentKey = 'privacy_consent';

  /// Gets the stored privacy consent.
  PrivacyConsentDto? getPrivacyConsent() {
    final jsonString = _sharedPreferences.getString(_privacyConsentKey);
    talker.log(
      '[PrivacyLocalDataSource] getPrivacyConsent: ${jsonString != null ? "found" : "null"}',
    );
    if (jsonString == null) {
      return null;
    }
    try {
      final dto = PrivacyConsentDto.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
      talker.log(
        '[PrivacyLocalDataSource] getPrivacyConsent hasConsented: ${dto.hasConsented}',
      );
      return dto;
    } catch (e) {
      talker.error('[PrivacyLocalDataSource] getPrivacyConsent parse error: $e');
      return null;
    }
  }

  /// Saves privacy consent.
  Future<void> savePrivacyConsent(PrivacyConsentDto consent) async {
    final jsonString = jsonEncode(consent.toJson());
    talker.log(
      '[PrivacyLocalDataSource] savePrivacyConsent: hasConsented=${consent.hasConsented}',
    );
    await _sharedPreferences.setString(_privacyConsentKey, jsonString);
    talker.log('[PrivacyLocalDataSource] savePrivacyConsent: saved');

    // Verify save
    final saved = _sharedPreferences.getString(_privacyConsentKey);
    talker.log(
      '[PrivacyLocalDataSource] savePrivacyConsent verify: ${saved != null ? "OK" : "FAILED"}',
    );
  }

  /// Clears privacy consent.
  Future<void> clearPrivacyConsent() async {
    await _sharedPreferences.remove(_privacyConsentKey);
  }
}
