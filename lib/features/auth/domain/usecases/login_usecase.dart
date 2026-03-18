/// Login use case for user authentication.
library;

import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/auth/domain/entities/user.dart';
import 'package:flutter_project_template/features/auth/domain/repositories/auth_repository.dart';

/// Login use case.
///
/// Encapsulates the business logic for user login.
class LoginUseCase {
  /// Creates a login use case.
  LoginUseCase({required AuthRepository repository}) : _repository = repository;

  final AuthRepository _repository;

  /// Executes the login with email.
  Future<Result<User>> executeWithEmail({
    required String email,
    required String password,
  }) {
    return _repository.loginWithEmail(email: email, password: password);
  }

  /// Executes the login with username.
  Future<Result<User>> executeWithUsername({
    required String username,
    required String password,
  }) {
    return _repository.loginWithUsername(
      username: username,
      password: password,
    );
  }
}
