/// Auth remote data source for API calls.
library;

import 'package:flutter_project_template/features/auth/data/models/user_dto.dart';
import 'package:injectable/injectable.dart';

/// Verification code storage for mock implementation.
class _VerificationCodeStorage {
  static final Map<String, _CodeInfo> _codes = {};

  /// Stores a verification code.
  static void store(String target, String code) {
    _codes[target] = _CodeInfo(
      code: code,
      expiresAt: DateTime.now().add(const Duration(minutes: 5)),
    );
  }

  /// Gets and validates a verification code.
  static _CodeInfo? get(String target) {
    final info = _codes[target];
    if (info == null) return null;

    if (DateTime.now().isAfter(info.expiresAt)) {
      _codes.remove(target);
      return null;
    }

    return info;
  }

  /// Removes a verification code.
  static void remove(String target) {
    _codes.remove(target);
  }
}

/// Verification code info.
class _CodeInfo {
  _CodeInfo({required this.code, required this.expiresAt});

  final String code;
  final DateTime expiresAt;
}

/// Authentication remote data source.
///
/// Handles remote API calls for authentication.
/// This implementation uses mock data for development.
/// Registered as a lazy singleton in GetIt.
@lazySingleton
class AuthRemoteDataSource {
  /// Simulates network delay.
  Future<void> _simulateNetworkDelay() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
  }

  /// Simulates longer network delay for registration.
  Future<void> _simulateRegistrationDelay() async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));
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

  /// Validates Chinese phone number format.
  bool _isValidChinesePhone(String phone) {
    return RegExp(r'^1[3-9]\d{9}$').hasMatch(phone);
  }

  /// Sends a verification code to phone number.
  ///
  /// Mock implementation - stores code and always succeeds.
  Future<void> sendVerificationCodeToPhone(String phoneNumber) async {
    await _simulateNetworkDelay();

    if (!_isValidChinesePhone(phoneNumber)) {
      throw AuthException('Invalid phone number format');
    }

    // Generate 6-digit code
    final code =
        (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString();
    _VerificationCodeStorage.store(phoneNumber, code);

    // In real implementation, this would send SMS
    // For mock, we'll log it (in production, remove this)
    // ignore: avoid_print
    print('Mock SMS to $phoneNumber: Your verification code is $code');
  }

  /// Sends a verification code to email.
  ///
  /// Mock implementation - stores code and always succeeds.
  Future<void> sendVerificationCodeToEmail(String email) async {
    await _simulateNetworkDelay();

    if (!_isValidEmail(email)) {
      throw AuthException('Invalid email format');
    }

    // Generate 6-digit code
    final code =
        (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString();
    _VerificationCodeStorage.store(email, code);

    // In real implementation, this would send email
    // For mock, we'll log it (in production, remove this)
    // ignore: avoid_print
    print('Mock Email to $email: Your verification code is $code');
  }

  /// Verifies the code sent to phone number.
  ///
  /// Mock implementation - checks stored code.
  Future<bool> verifyPhoneCode({
    required String phoneNumber,
    required String code,
  }) async {
    await _simulateNetworkDelay();

    final info = _VerificationCodeStorage.get(phoneNumber);
    if (info == null) {
      throw AuthException('Verification code has expired');
    }

    if (info.code != code) {
      throw AuthException('Invalid verification code');
    }

    // Remove code after successful verification
    _VerificationCodeStorage.remove(phoneNumber);
    return true;
  }

  /// Verifies the code sent to email.
  ///
  /// Mock implementation - checks stored code.
  Future<bool> verifyEmailCode({
    required String email,
    required String code,
  }) async {
    await _simulateNetworkDelay();

    final info = _VerificationCodeStorage.get(email);
    if (info == null) {
      throw AuthException('Verification code has expired');
    }

    if (info.code != code) {
      throw AuthException('Invalid verification code');
    }

    // Remove code after successful verification
    _VerificationCodeStorage.remove(email);
    return true;
  }

  /// Registers a new user with phone verification.
  ///
  /// Mock implementation - always succeeds with mock user.
  Future<UserDto> registerWithPhone({
    required String phoneNumber,
    required String username,
    required String password,
    required String verificationCode,
    String? avatarUrl,
  }) async {
    await _simulateRegistrationDelay();

    // Validate phone format
    if (!_isValidChinesePhone(phoneNumber)) {
      throw AuthException('Invalid phone number format');
    }

    // Validate username
    if (username.length < 2 || username.length > 20) {
      throw AuthException('Nickname must be between 2-20 characters');
    }

    // Validate password
    if (!_isValidPassword(password)) {
      throw AuthException(
        'Password must be at least 8 characters with letters and numbers',
      );
    }

    // Verify code (already verified in flow, but double-check)
    final codeInfo = _VerificationCodeStorage.get(phoneNumber);
    if (codeInfo == null) {
      throw AuthException('Please verify your phone number first');
    }

    // Return mock user
    return UserDto(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: '$phoneNumber@phone.mock',
      username: username,
      displayName: username,
      avatarUrl: avatarUrl ?? 'https://i.pravatar.cc/150?u=$username',
      phoneNumber: phoneNumber,
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  /// Registers a new user with email verification.
  ///
  /// Mock implementation - always succeeds with mock user.
  Future<UserDto> registerWithEmail({
    required String email,
    required String username,
    required String password,
    required String verificationCode,
    String? avatarUrl,
  }) async {
    await _simulateRegistrationDelay();

    // Validate email format
    if (!_isValidEmail(email)) {
      throw AuthException('Invalid email format');
    }

    // Validate username
    if (username.length < 2 || username.length > 20) {
      throw AuthException('Nickname must be between 2-20 characters');
    }

    // Validate password
    if (!_isValidPassword(password)) {
      throw AuthException(
        'Password must be at least 8 characters with letters and numbers',
      );
    }

    // Verify code (already verified in flow, but double-check)
    final codeInfo = _VerificationCodeStorage.get(email);
    if (codeInfo == null) {
      throw AuthException('Please verify your email first');
    }

    // Return mock user
    return UserDto(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      username: username,
      displayName: username,
      avatarUrl: avatarUrl ?? 'https://i.pravatar.cc/150?u=$username',
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  /// Validates password strength.
  /// At least 8 characters with both letters and numbers.
  bool _isValidPassword(String password) {
    if (password.length < 8) return false;
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    return hasLetter && hasNumber;
  }

  /// Updates user profile.
  ///
  /// Mock implementation - always succeeds.
  Future<UserDto> updateUserProfile({
    required String userId,
    String? displayName,
    String? avatarUrl,
    String? phoneNumber,
    String? gender,
  }) async {
    await _simulateNetworkDelay();

    // Mock validation for phone number
    if (phoneNumber != null && !_isValidChinesePhone(phoneNumber)) {
      throw AuthException('Invalid phone number format');
    }

    // Mock: Return updated user
    return UserDto(
      id: userId,
      email: 'user@mock.com',
      username: 'mock_user',
      displayName: displayName ?? 'Mock User',
      avatarUrl: avatarUrl ?? 'https://i.pravatar.cc/150?u=$userId',
      phoneNumber: phoneNumber,
      gender: gender,
    );
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
