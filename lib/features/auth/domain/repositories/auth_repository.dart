/// Auth repository interface.
///
/// This file defines the repository contract for auth feature.
library;

import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/auth/domain/entities/user.dart';

/// Authentication repository interface.
///
/// Defines the contract for authentication operations.
/// This is part of the domain layer and has no external dependencies.
abstract class AuthRepository {
  /// Logs in with email and password.
  ///
  /// Returns either a [User] on success or a [Failure] on error.
  Future<Result<User>> loginWithEmail({
    required String email,
    required String password,
  });

  /// Logs in with username and password.
  ///
  /// Returns either a [User] on success or a [Failure] on error.
  Future<Result<User>> loginWithUsername({
    required String username,
    required String password,
  });

  /// Logs in with WeChat.
  ///
  /// Returns either a [User] on success or a [Failure] on error.
  Future<Result<User>> loginWithWeChat();

  /// Logs in with Apple.
  ///
  /// Returns either a [User] on success or a [Failure] on error.
  Future<Result<User>> loginWithApple();

  /// Logs in with Google.
  ///
  /// Returns either a [User] on success or a [Failure] on error.
  Future<Result<User>> loginWithGoogle();

  /// Registers a new user with email and password.
  ///
  /// Returns either a [User] on success or a [Failure] on error.
  Future<Result<User>> register({
    required String email,
    required String username,
    required String password,
  });

  /// Logs out the current user.
  ///
  /// Returns either void on success or a [Failure] on error.
  Future<Result<void>> logout();

  /// Gets the current authenticated user.
  ///
  /// Returns either a [User] on success or a [Failure] on error.
  Future<Result<User?>> getCurrentUser();

  /// Checks if the user is authenticated.
  ///
  /// Returns true if authenticated, false otherwise.
  Future<bool> isAuthenticated();

  /// Sends a password reset email.
  ///
  /// Returns either void on success or a [Failure] on error.
  Future<Result<void>> sendPasswordResetEmail(String email);

  /// Updates the user's password.
  ///
  /// Returns either void on success or a [Failure] on error.
  Future<Result<void>> updatePassword({
    required String currentPassword,
    required String newPassword,
  });
}
