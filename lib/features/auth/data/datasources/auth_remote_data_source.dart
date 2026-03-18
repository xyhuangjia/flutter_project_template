/// Auth remote data source for API calls.
library;

import 'package:flutter_project_template/features/auth/data/models/user_dto.dart';

/// Authentication remote data source.
///
/// Handles remote API calls for authentication.
/// This implementation uses mock data for development.
class AuthRemoteDataSource {
  /// Simulates network delay.
  Future<void> _simulateNetworkDelay() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
  }

  /// Logs in with email and password.
  ///
  /// Mock implementation - always succeeds with mock user.
  Future<UserDto> loginWithEmail({
    required String email,
    required String password,
  }) async {
    await _simulateNetworkDelay();

    // Mock validation
    if (!_isValidEmail(email)) {
      throw AuthException('Invalid email format');
    }

    if (password.length < 6) {
      throw AuthException('Password must be at least 6 characters');
    }

    // Return mock user
    return UserDto(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      username: email.split('@').first,
      displayName: 'Mock User',
      avatarUrl: 'https://i.pravatar.cc/150?u=${email.hashCode}',
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  /// Logs in with username and password.
  ///
  /// Mock implementation - always succeeds with mock user.
  Future<UserDto> loginWithUsername({
    required String username,
    required String password,
  }) async {
    await _simulateNetworkDelay();

    // Mock validation
    if (username.length < 3) {
      throw AuthException('Username must be at least 3 characters');
    }

    if (password.length < 6) {
      throw AuthException('Password must be at least 6 characters');
    }

    // Return mock user
    return UserDto(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: '$username@mock.com',
      username: username,
      displayName: username,
      avatarUrl: 'https://i.pravatar.cc/150?u=$username',
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  /// Logs in with WeChat.
  ///
  /// Mock implementation - simulates WeChat OAuth flow.
  Future<UserDto> loginWithWeChat() async {
    await _simulateNetworkDelay();

    // Return mock WeChat user
    return UserDto(
      id: 'wechat_user_${DateTime.now().millisecondsSinceEpoch}',
      email: 'wechat_user@wechat.com',
      username: 'wechat_user',
      displayName: 'WeChat User',
      avatarUrl: 'https://i.pravatar.cc/150?u=wechat',
      token: 'wechat_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  /// Logs in with Apple.
  ///
  /// Mock implementation - simulates Apple Sign In flow.
  Future<UserDto> loginWithApple() async {
    await _simulateNetworkDelay();

    // Return mock Apple user
    return UserDto(
      id: 'apple_user_${DateTime.now().millisecondsSinceEpoch}',
      email: 'apple_user@privaterelay.appleid.com',
      username: 'apple_user',
      displayName: 'Apple User',
      avatarUrl: 'https://i.pravatar.cc/150?u=apple',
      token: 'apple_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  /// Logs in with Google.
  ///
  /// Mock implementation - simulates Google Sign In flow.
  Future<UserDto> loginWithGoogle() async {
    await _simulateNetworkDelay();

    // Return mock Google user
    return UserDto(
      id: 'google_user_${DateTime.now().millisecondsSinceEpoch}',
      email: 'google_user@gmail.com',
      username: 'google_user',
      displayName: 'Google User',
      avatarUrl: 'https://i.pravatar.cc/150?u=google',
      token: 'google_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  /// Registers a new user.
  ///
  /// Mock implementation - always succeeds with mock user.
  Future<UserDto> register({
    required String email,
    required String username,
    required String password,
  }) async {
    await _simulateNetworkDelay();

    // Mock validation
    if (!_isValidEmail(email)) {
      throw AuthException('Invalid email format');
    }

    if (username.length < 3) {
      throw AuthException('Username must be at least 3 characters');
    }

    if (password.length < 6) {
      throw AuthException('Password must be at least 6 characters');
    }

    // Return mock user
    return UserDto(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      username: username,
      displayName: username,
      avatarUrl: 'https://i.pravatar.cc/150?u=$username',
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  /// Sends a password reset email.
  ///
  /// Mock implementation - always succeeds.
  Future<void> sendPasswordResetEmail(String email) async {
    await _simulateNetworkDelay();

    if (!_isValidEmail(email)) {
      throw AuthException('Invalid email format');
    }

    // Mock: Do nothing, always succeed
  }

  /// Updates the user's password.
  ///
  /// Mock implementation - always succeeds.
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _simulateNetworkDelay();

    if (currentPassword.length < 6) {
      throw AuthException('Current password is incorrect');
    }

    if (newPassword.length < 6) {
      throw AuthException('New password must be at least 6 characters');
    }

    // Mock: Do nothing, always succeed
  }

  /// Validates email format.
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

/// Exception thrown during authentication operations.
class AuthException implements Exception {
  /// Creates an auth exception.
  AuthException(this.message);

  /// The error message.
  final String message;

  @override
  String toString() => 'AuthException: $message';
}
