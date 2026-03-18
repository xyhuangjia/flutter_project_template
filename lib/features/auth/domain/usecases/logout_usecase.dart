/// Logout use case for user sign out.
library;

import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/auth/domain/repositories/auth_repository.dart';

/// Logout use case.
///
/// Encapsulates the business logic for user logout.
class LogoutUseCase {
  /// Creates a logout use case.
  LogoutUseCase({required AuthRepository repository})
    : _repository = repository;

  final AuthRepository _repository;

  /// Executes the logout.
  Future<Result<void>> execute() {
    return _repository.logout();
  }
}
