/// Privacy local data source for storing privacy settings.
library;

import 'dart:convert';

import 'package:flutter_project_template/core/logging/talker_config.dart';
import 'package:flutter_project_template/features/privacy/data/models/privacy_consent_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Privacy local data source.
/// Registered as a lazy singleton in GetIt.
@lazySingleton
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
      '[隐私数据源] 获取隐私同意: ${jsonString != null ? "已找到" : "未找到"}',
    );
    if (jsonString == null) {
      return null;
    }
    try {
      final dto = PrivacyConsentDto.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
      talker.log(
        '[隐私数据源] 获取隐私同意 - 已同意: ${dto.hasConsented}',
      );
      return dto;
    } catch (e) {
      talker.error('[隐私数据源] 获取隐私同意 - 解析错误: $e');
      return null;
    }
  }

  /// Saves privacy consent.
  Future<void> savePrivacyConsent(PrivacyConsentDto consent) async {
    final jsonString = jsonEncode(consent.toJson());
    talker.log(
      '[隐私数据源] 保存隐私同意: 已同意=${consent.hasConsented}',
    );
    await _sharedPreferences.setString(_privacyConsentKey, jsonString);
    talker.log('[隐私数据源] 保存隐私同意: 已保存');

    // Verify save
    final saved = _sharedPreferences.getString(_privacyConsentKey);
    talker.log(
      '[隐私数据源] 保存隐私同意 - 验证: ${saved != null ? "成功" : "失败"}',
    );
  }

  /// Clears privacy consent.
  Future<void> clearPrivacyConsent() async {
    await _sharedPreferences.remove(_privacyConsentKey);
  }
}
