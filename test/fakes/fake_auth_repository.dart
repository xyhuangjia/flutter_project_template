/// Fake implementation of AuthRepository for testing.
library;

import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/auth/domain/entities/user.dart';
import 'package:flutter_project_template/features/auth/domain/repositories/auth_repository.dart';

/// Fake implementation of AuthRepository for testing purposes.
///
/// Allows controlling the behavior of authentication operations in tests.
class FakeAuthRepository implements AuthRepository {
  /// Creates a fake auth repository.
  FakeAuthRepository();

  /// The current user (null if not authenticated).
  User? currentUser;

  /// Whether to simulate failure on next operation.
  bool shouldFail = false;

  /// The failure to return when shouldFail is true.
  Failure failureToReturn = const AuthFailure(message: 'Test failure');

  /// Delay before operations complete (simulates network).
  Duration operationDelay = Duration.zero;

  /// Tracks method calls for verification.
  final List<String> methodCalls = [];

  /// Email used in last login attempt.
  String? lastLoginEmail;

  /// Password used in last login attempt.
  String? lastLoginPassword;

  /// Username used in last login attempt.
  String? lastLoginUsername;

  /// Resets the repository to initial state.
  void reset() {
    currentUser = null;
    shouldFail = false;
    failureToReturn = const AuthFailure(message: 'Test failure');
    operationDelay = Duration.zero;
    methodCalls.clear();
    lastLoginEmail = null;
    lastLoginPassword = null;
    lastLoginUsername = null;
  }

  /// Sets up a successful login with the given user.
  void setupSuccessfulLogin(User user) {
    currentUser = user;
    shouldFail = false;
  }

  /// Sets up a failed login with the given failure.
  void setupFailedLogin(Failure failure) {
    shouldFail = true;
    failureToReturn = failure;
  }

  Future<void> _simulateDelay() async {
    if (operationDelay > Duration.zero) {
      await Future<void>.delayed(operationDelay);
    }
  }

  @override
  Future<Result<User>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    methodCalls.add('loginWithEmail');
    lastLoginEmail = email;
    lastLoginPassword = password;
    await _simulateDelay();

    if (shouldFail) {
      return FailureResult(failureToReturn);
    }

    currentUser ??= User(
      id: 'test-user-id',
      email: email,
      username: email.split('@').first,
      displayName: 'Test User',
    );

    return Success(currentUser!);
  }

  @override
  Future<Result<User>> loginWithUsername({
    required String username,
    required String password,
  }) async {
    methodCalls.add('loginWithUsername');
    lastLoginUsername = username;
    lastLoginPassword = password;
    await _simulateDelay();

    if (shouldFail) {
      return FailureResult(failureToReturn);
    }

    currentUser ??= User(
      id: 'test-user-id',
      email: '$username@test.com',
      username: username,
      displayName: username,
    );

    return Success(currentUser!);
  }

  @override
  Future<Result<User>> loginWithWeChat() async {
    methodCalls.add('loginWithWeChat');
    await _simulateDelay();

    if (shouldFail) {
      return FailureResult(failureToReturn);
    }

    currentUser ??= const User(
      id: 'wechat-user-id',
      email: 'wechat@test.com',
      username: 'wechat_user',
      displayName: 'WeChat User',
    );

    return Success(currentUser!);
  }

  @override
  Future<Result<User>> loginWithApple() async {
    methodCalls.add('loginWithApple');
    await _simulateDelay();

    if (shouldFail) {
      return FailureResult(failureToReturn);
    }

    currentUser ??= const User(
      id: 'apple-user-id',
      email: 'apple@privaterelay.appleid.com',
      username: 'apple_user',
      displayName: 'Apple User',
    );

    return Success(currentUser!);
  }

  @override
  Future<Result<User>> loginWithGoogle() async {
    methodCalls.add('loginWithGoogle');
    await _simulateDelay();

    if (shouldFail) {
      return FailureResult(failureToReturn);
    }

    currentUser ??= const User(
      id: 'google-user-id',
      email: 'google@gmail.com',
      username: 'google_user',
      displayName: 'Google User',
    );

    return Success(currentUser!);
  }

  @override
  Future<Result<User>> register({
    required String email,
    required String username,
    required String password,
  }) async {
    methodCalls.add('register');
    lastLoginEmail = email;
    lastLoginUsername = username;
    lastLoginPassword = password;
    await _simulateDelay();

    if (shouldFail) {
      return FailureResult(failureToReturn);
    }

    currentUser = User(
      id: 'new-user-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      username: username,
      displayName: username,
    );

    return Success(currentUser!);
  }

  @override
  Future<Result<void>> logout() async {
    methodCalls.add('logout');
    await _simulateDelay();

    if (shouldFail) {
      return FailureResult(failureToReturn);
    }

    currentUser = null;
    return const Success(null);
  }

  @override
  Future<Result<User?>> getCurrentUser() async {
    methodCalls.add('getCurrentUser');
    await _simulateDelay();

    if (shouldFail) {
      return FailureResult(failureToReturn);
    }

    return Success(currentUser);
  }

  @override
  Future<bool> isAuthenticated() async {
    methodCalls.add('isAuthenticated');
    return currentUser != null;
  }

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    methodCalls.add('sendPasswordResetEmail');
    await _simulateDelay();

    if (shouldFail) {
      return FailureResult(failureToReturn);
    }

    return const Success(null);
  }

  @override
  Future<Result<void>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    methodCalls.add('updatePassword');
    await _simulateDelay();

    if (shouldFail) {
      return FailureResult(failureToReturn);
    }

    return const Success(null);
  }

  @override
  Future<Result<void>> sendVerificationCodeToPhone(String phoneNumber) async {
    methodCalls.add('sendVerificationCodeToPhone');
    await _simulateDelay();

    if (shouldFail) {
      return FailureResult(failureToReturn);
    }

    return const Success(null);
  }

  @override
  Future<Result<void>> sendVerificationCodeToEmail(String email) async {
    methodCalls.add('sendVerificationCodeToEmail');
    await _simulateDelay();

    if (shouldFail) {
      return FailureResult(failureToReturn);
    }

    return const Success(null);
  }

  @override
  Future<Result<bool>> verifyPhoneCode({
    required String phoneNumber,
    required String code,
  }) async {
    methodCalls.add('verifyPhoneCode');
    await _simulateDelay();

    if (shouldFail) {
      return FailureResult(failureToReturn);
    }

    return const Success(true);
  }

  @override
  Future<Result<bool>> verifyEmailCode({
    required String email,
    required String code,
  }) async {
    methodCalls.add('verifyEmailCode');
    await _simulateDelay();

    if (shouldFail) {
      return FailureResult(failureToReturn);
    }

    return const Success(true);
  }

  @override
  Future<Result<User>> registerWithPhone({
    required String phoneNumber,
    required String username,
    required String password,
    required String verificationCode,
    String? avatarUrl,
  }) async {
    methodCalls.add('registerWithPhone');
    await _simulateDelay();

    if (shouldFail) {
      return FailureResult(failureToReturn);
    }

    currentUser = User(
      id: 'new-user-${DateTime.now().millisecondsSinceEpoch}',
      email: '$phoneNumber@phone.mock',
      username: username,
      displayName: username,
      avatarUrl: avatarUrl,
      phoneNumber: phoneNumber,
    );

    return Success(currentUser!);
  }

  @override
  Future<Result<User>> registerWithEmail({
    required String email,
    required String username,
    required String password,
    required String verificationCode,
    String? avatarUrl,
  }) async {
    methodCalls.add('registerWithEmail');
    await _simulateDelay();

    if (shouldFail) {
      return FailureResult(failureToReturn);
    }

    currentUser = User(
      id: 'new-user-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      username: username,
      displayName: username,
      avatarUrl: avatarUrl,
    );

    return Success(currentUser!);
  }

  @override
  Future<Result<User>> updateUserProfile({
    String? displayName,
    String? avatarUrl,
    String? phoneNumber,
    UserGender? gender,
  }) async {
    methodCalls.add('updateUserProfile');
    await _simulateDelay();

    if (shouldFail) {
      return FailureResult(failureToReturn);
    }

    if (currentUser != null) {
      currentUser = User(
        id: currentUser!.id,
        email: currentUser!.email,
        username: currentUser!.username,
        displayName: displayName ?? currentUser!.displayName,
        avatarUrl: avatarUrl ?? currentUser!.avatarUrl,
        phoneNumber: phoneNumber ?? currentUser!.phoneNumber,
        gender: gender ?? currentUser!.gender,
      );
    }

    return Success(currentUser!);
  }
}
