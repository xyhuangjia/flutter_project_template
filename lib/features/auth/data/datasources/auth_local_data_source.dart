/// Auth local data source for caching authentication data.
library;

import 'package:shared_preferences/shared_preferences.dart';

/// Authentication local data source.
///
/// Handles local storage of authentication data using SharedPreferences.
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

  /// Saves the authentication token.
  Future<void> saveToken(String token) async {
    await _sharedPreferences.setString(_tokenKey, token);
  }

  /// Gets the stored authentication token.
  String? getToken() {
    return _sharedPreferences.getString(_tokenKey);
  }

  /// Saves user data locally.
  Future<void> saveUserData({
    required String userId,
    required String email,
    required String username,
    String? displayName,
    String? avatarUrl,
  }) async {
    await Future.wait([
      _sharedPreferences.setString(_userIdKey, userId),
      _sharedPreferences.setString(_userEmailKey, email),
      _sharedPreferences.setString(_usernameKey, username),
      if (displayName != null)
        _sharedPreferences.setString(_displayNameKey, displayName),
      if (avatarUrl != null)
        _sharedPreferences.setString(_avatarUrlKey, avatarUrl),
    ]);
  }

  /// Gets the stored user ID.
  String? getUserId() {
    return _sharedPreferences.getString(_userIdKey);
  }

  /// Gets the stored user email.
  String? getUserEmail() {
    return _sharedPreferences.getString(_userEmailKey);
  }

  /// Gets the stored username.
  String? getUsername() {
    return _sharedPreferences.getString(_usernameKey);
  }

  /// Gets the stored display name.
  String? getDisplayName() {
    return _sharedPreferences.getString(_displayNameKey);
  }

  /// Gets the stored avatar URL.
  String? getAvatarUrl() {
    return _sharedPreferences.getString(_avatarUrlKey);
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
    ]);
  }

  /// Checks if user is authenticated (has token).
  bool isAuthenticated() {
    return getToken() != null;
  }
}
