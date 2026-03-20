/// Forgot password repository interface.
library;

import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/auth/domain/entities/forgot_password_state.dart';

/// Forgot password repository interface.
///
/// Defines the contract for forgot password operations.
abstract class ForgotPasswordRepository {
  /// Sends verification email.
  Future<Result<void>> sendVerificationEmail(String email);

  /// Sends verification SMS.
  Future<Result<void>> sendVerificationSms(String phone);

  /// Verifies the code.
  Future<Result<bool>> verifyCode({
    required String account,
    required String code,
    required VerificationType type,
  });

  /// Resets the password.
  Future<Result<void>> resetPassword({
    required String account,
    required String newPassword,
    required String verificationCode,
    required VerificationType type,
  });
}
