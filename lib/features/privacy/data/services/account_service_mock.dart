/// Mock account service for account deletion.
library;

import 'package:flutter_project_template/core/errors/failures.dart';

/// Mock account service for testing account deletion flow.
class AccountServiceMock {
  /// Simulates account deletion API call.
  ///
  /// In production, this would call the actual backend API.
  Future<Result<void>> deleteAccount(String password) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(seconds: 2));

    // Mock validation: password must be at least 6 characters
    if (password.length < 6) {
      return FailureResult(
        ValidationFailure(message: 'Password must be at least 6 characters'),
      );
    }

    // Mock success (90% success rate for demo)
    if (DateTime.now().millisecond % 10 != 0) {
      return Success(null);
    }

    // Mock occasional failure
    return FailureResult(
      const ServerFailure(
          message: 'Account deletion failed. Please try again later.'),
    );
  }
}
