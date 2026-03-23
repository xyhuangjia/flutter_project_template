/// Auth local data source for caching authentication data.
library;

import 'package:flutter_project_template/core/logging/talker_config.dart';
import 'package:flutter_project_template/features/auth/domain/entities/user.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Authentication local data source.
///
/// Handles local storage of authentication data using SharedPreferences.
/// Registered as a lazy singleton in GetIt.
@lazySingleton
class AuthLocalDataSource {
  /// Creates an auth local data source.
  AuthLocalDataSource({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  /// Key for storing auth token.
  static const String _tokenKey = 'auth_token';

  /// Key for storing user ID.
  static const String _userIdKey = 'user_id';

  /// Key for storing user email.
  static const String _userEmailKey = 'user_email';

  /// Key for storing username.
  static const String _usernameKey = 'username';

  /// Key for storing display name.
  static const String _displayNameKey = 'display_name';

  /// Key for storing avatar URL.
  static const String _avatarUrlKey = 'avatar_url';

  /// Key for storing phone number.
  static const String _phoneNumberKey = 'phone_number';

  /// Key for storing gender.
  static const String _genderKey = 'gender';

  /// Saves the authentication token.
  Future<void> saveToken(String token) async {
    await _sharedPreferences.setString(_tokenKey, token);
    talker.log('[认证数据源] Token 已保存');
  }

  /// Gets the stored authentication token.
  String? getToken() {
    final token = _sharedPreferences.getString(_tokenKey);
    talker.log(
      '[认证数据源] 获取Token: ${token != null ? "已找到" : "未找到"}',
    );
    return token;
  }

  /// Saves user data locally.
  Future<void> saveUserData({
    required String userId,
    required String email,
    required String username,
    String? displayName,
    String? avatarUrl,
    String? phoneNumber,
    UserGender? gender,
  }) async {
    await Future.wait([
      _sharedPreferences.setString(_userIdKey, userId),
      _sharedPreferences.setString(_userEmailKey, email),
      _sharedPreferences.setString(_usernameKey, username),
      if (displayName != null)
        _sharedPreferences.setString(_displayNameKey, displayName),
      if (avatarUrl != null)
        _sharedPreferences.setString(_avatarUrlKey, avatarUrl),
      if (phoneNumber != null)
        _sharedPreferences.setString(_phoneNumberKey, phoneNumber),
      if (gender != null) _sharedPreferences.setString(_genderKey, gender.name),
    ]);
    talker.log('[认证数据源] 用户数据已保存: $username');
  }

  /// Gets stored user ID.
  String? getUserId() => _sharedPreferences.getString(_userIdKey);

  /// Gets stored user email.
  String? getUserEmail() => _sharedPreferences.getString(_userEmailKey);

  /// Gets stored username.
  String? getUsername() => _sharedPreferences.getString(_usernameKey);

  /// Gets stored display name.
  String? getDisplayName() => _sharedPreferences.getString(_displayNameKey);

  /// Gets stored avatar URL.
  String? getAvatarUrl() => _sharedPreferences.getString(_avatarUrlKey);

  /// Gets stored phone number.
  String? getPhoneNumber() => _sharedPreferences.getString(_phoneNumberKey);

  /// Gets stored gender.
  UserGender? getGender() {
    final genderStr = _sharedPreferences.getString(_genderKey);
    if (genderStr == null) return null;
    return switch (genderStr) {
      'male' => UserGender.male,
      'female' => UserGender.female,
      'unspecified' => UserGender.unspecified,
      _ => null,
    };
  }

  /// Clears all stored authentication data.
  Future<void> clearAuthData() async {
    await Future.wait([
      _sharedPreferences.remove(_tokenKey),
      _sharedPreferences.remove(_userIdKey),
      _sharedPreferences.remove(_userEmailKey),
      _sharedPreferences.remove(_usernameKey),
      _sharedPreferences.remove(_displayNameKey),
      _sharedPreferences.remove(_avatarUrlKey),
      _sharedPreferences.remove(_phoneNumberKey),
      _sharedPreferences.remove(_genderKey),
    ]);
    talker.log('[认证数据源] 认证数据已清除');
  }

  /// Checks if user is authenticated (has token).
  bool isAuthenticated() => getToken() != null;
}
