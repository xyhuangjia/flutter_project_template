/// Privacy local data source for storing privacy settings.
library;

import 'dart:convert';

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
    if (jsonString == null) {
      return null;
    }
    try {
      return PrivacyConsentDto.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
    } catch (e) {
      return null;
    }
  }

  /// Saves privacy consent.
  Future<void> savePrivacyConsent(PrivacyConsentDto consent) async {
    final jsonString = jsonEncode(consent.toJson());
    await _sharedPreferences.setString(_privacyConsentKey, jsonString);
  }

  /// Clears privacy consent.
  Future<void> clearPrivacyConsent() async {
    await _sharedPreferences.remove(_privacyConsentKey);
  }
}
