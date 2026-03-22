/// Auth repository implementation.
library;

import 'package:flutter_project_template/core/errors/error_handler.dart';
import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_project_template/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_project_template/features/auth/data/models/user_dto.dart';
import 'package:flutter_project_template/features/auth/domain/entities/user.dart';
import 'package:flutter_project_template/features/auth/domain/repositories/auth_repository.dart';

/// Auth repository implementation.
///
/// Coordinates between local and remote data sources.
class AuthRepositoryImpl implements AuthRepository {
  /// Creates an auth repository.
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<Result<User>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return _handleAuthOperation(
      () => _remoteDataSource.loginWithEmail(email: email, password: password),
    );
  }

  @override
  Future<Result<User>> loginWithUsername({
    required String username,
    required String password,
  }) async {
    return _handleAuthOperation(
      () => _remoteDataSource.loginWithUsername(
        username: username,
        password: password,
      ),
    );
  }

  @override
  Future<Result<User>> loginWithWeChat() async {
    return _handleAuthOperation(() => _remoteDataSource.loginWithWeChat());
  }

  @override
  Future<Result<User>> loginWithApple() async {
    return _handleAuthOperation(() => _remoteDataSource.loginWithApple());
  }

  @override
  Future<Result<User>> loginWithGoogle() async {
    return _handleAuthOperation(() => _remoteDataSource.loginWithGoogle());
  }

  @override
  Future<Result<User>> register({
    required String email,
    required String username,
    required String password,
  }) async {
    return _handleAuthOperation(
      () => _remoteDataSource.register(
        email: email,
        username: username,
        password: password,
      ),
    );
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _localDataSource.clearAuthData();
      return const Success(null);
    } on Exception catch (e) {
      return FailureResult(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<User?>> getCurrentUser() async {
    try {
      final userId = _localDataSource.getUserId();

      if (userId == null) {
        return const Success(null);
      }

      final user = User(
        id: userId,
        email: _localDataSource.getUserEmail() ?? '',
        username: _localDataSource.getUsername() ?? '',
        displayName: _localDataSource.getDisplayName(),
        avatarUrl: _localDataSource.getAvatarUrl(),
        phoneNumber: _localDataSource.getPhoneNumber(),
        gender: _localDataSource.getGender() ?? UserGender.unspecified,
      );

      return Success(user);
    } on Exception catch (e) {
      return FailureResult(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return _localDataSource.isAuthenticated();
  }

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    return _handleVoidOperation(
      () => _remoteDataSource.sendPasswordResetEmail(email),
    );
  }

  @override
  Future<Result<void>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return _handleVoidOperation(
      () => _remoteDataSource.updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
  }

  @override
  Future<Result<void>> sendVerificationCodeToPhone(String phoneNumber) async {
    return _handleVoidOperation(
      () => _remoteDataSource.sendVerificationCodeToPhone(phoneNumber),
    );
  }

  @override
  Future<Result<void>> sendVerificationCodeToEmail(String email) async {
    return _handleVoidOperation(
      () => _remoteDataSource.sendVerificationCodeToEmail(email),
    );
  }

  @override
  Future<Result<bool>> verifyPhoneCode({
    required String phoneNumber,
    required String code,
  }) async {
    return _handleBoolOperation(
      () => _remoteDataSource.verifyPhoneCode(phoneNumber: phoneNumber, code: code),
    );
  }

  @override
  Future<Result<bool>> verifyEmailCode({
    required String email,
    required String code,
  }) async {
    return _handleBoolOperation(
      () => _remoteDataSource.verifyEmailCode(email: email, code: code),
    );
  }

  @override
  Future<Result<User>> registerWithPhone({
    required String phoneNumber,
    required String username,
    required String password,
    required String verificationCode,
    String? avatarUrl,
  }) async {
    return _handleAuthOperation(
      () => _remoteDataSource.registerWithPhone(
        phoneNumber: phoneNumber,
        username: username,
        password: password,
        verificationCode: verificationCode,
        avatarUrl: avatarUrl,
      ),
    );
  }

  @override
  Future<Result<User>> registerWithEmail({
    required String email,
    required String username,
    required String password,
    required String verificationCode,
    String? avatarUrl,
  }) async {
    return _handleAuthOperation(
      () => _remoteDataSource.registerWithEmail(
        email: email,
        username: username,
        password: password,
        verificationCode: verificationCode,
        avatarUrl: avatarUrl,
      ),
    );
  }

  @override
  Future<Result<User>> updateUserProfile({
    String? displayName,
    String? avatarUrl,
    String? phoneNumber,
    UserGender? gender,
  }) async {
    try {
      final userId = _localDataSource.getUserId();
      if (userId == null) {
        return FailureResult(AuthFailure(message: 'User not logged in'));
      }

      final userDto = await _remoteDataSource.updateUserProfile(
        userId: userId,
        displayName: displayName,
        avatarUrl: avatarUrl,
        phoneNumber: phoneNumber,
        gender: gender?.name,
      );

      // Update local storage
      await _localDataSource.saveUserData(
        userId: userId,
        email: _localDataSource.getUserEmail() ?? '',
        username: _localDataSource.getUsername() ?? '',
        displayName: userDto.displayName,
        avatarUrl: userDto.avatarUrl,
        phoneNumber: userDto.phoneNumber,
        gender: UserGender.values.firstWhere(
          (g) => g.name == userDto.gender,
          orElse: () => UserGender.unspecified,
        ),
      );

      return Success(userDto.toEntity());
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(message: e.message));
    } on Exception catch (e) {
      return FailureResult(ErrorHandler.handleException(e));
    }
  }

  /// Saves user data to local storage.
  Future<void> _saveUserData(UserDto userDto) async {
    if (userDto.token != null) {
      await _localDataSource.saveToken(userDto.token!);
    }

    await _localDataSource.saveUserData(
      userId: userDto.id,
      email: userDto.email,
      username: userDto.username,
      displayName: userDto.displayName,
      avatarUrl: userDto.avatarUrl,
    );
  }

  /// Handles auth operations that return a User.
  Future<Result<User>> _handleAuthOperation(
    Future<UserDto> Function() operation,
  ) async {
    try {
      final userDto = await operation();
      await _saveUserData(userDto);
      return Success(userDto.toEntity());
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(message: e.message));
    } on Exception catch (e) {
      return FailureResult(ErrorHandler.handleException(e));
    }
  }

  /// Handles operations that return void.
  Future<Result<void>> _handleVoidOperation(
    Future<void> Function() operation,
  ) async {
    try {
      await operation();
      return const Success(null);
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(message: e.message));
    } on Exception catch (e) {
      return FailureResult(ErrorHandler.handleException(e));
    }
  }

  /// Handles operations that return a boolean.
  Future<Result<bool>> _handleBoolOperation(
    Future<bool> Function() operation,
  ) async {
    try {
      final result = await operation();
      return Success(result);
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(message: e.message));
    } on Exception catch (e) {
      return FailureResult(ErrorHandler.handleException(e));
    }
  }
}
