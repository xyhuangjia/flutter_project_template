/// Forgot password provider using Riverpod code generation.
library;

import 'dart:async';

import 'package:flutter_project_template/core/errors/error_handler.dart';
import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/core/providers/locale_provider.dart';
import 'package:flutter_project_template/core/utils/validators.dart';
import 'package:flutter_project_template/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_project_template/features/auth/domain/entities/forgot_password_state.dart';
import 'package:flutter_project_template/features/auth/domain/repositories/forgot_password_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'forgot_password_provider.g.dart';

/// Provider for ForgotPasswordRepository.
@riverpod
ForgotPasswordRepository forgotPasswordRepository(
  ForgotPasswordRepositoryRef ref,
) {
  return ForgotPasswordRepositoryImpl();
}

/// Forgot password state notifier provider.
///
/// Manages the forgot password flow state.
@riverpod
class ForgotPasswordNotifier extends _$ForgotPasswordNotifier {
  Timer? _resendTimer;

  @override
  ForgotPasswordState build() {
    // Determine verification type based on locale
    final localeAsync = ref.watch(localeNotifierProvider);
    final isChinese = localeAsync.valueOrNull?.languageCode == 'zh';

    return ForgotPasswordState(
      verificationType:
          isChinese ? VerificationType.sms : VerificationType.email,
    );
  }

  /// Sets the account (email or phone).
  void setAccount(String account) {
    state = state.copyWith(
      account: account,
      clearError: true,
    );
  }

  /// Sets the verification code.
  void setVerificationCode(String code) {
    state = state.copyWith(
      verificationCode: code,
      clearError: true,
    );
  }

  /// Sets the new password.
  void setNewPassword(String password) {
    state = state.copyWith(
      newPassword: password,
      clearError: true,
    );
  }

  /// Sets the confirm password.
  void setConfirmPassword(String password) {
    state = state.copyWith(
      confirmPassword: password,
      clearError: true,
    );
  }

  /// Switches verification type.
  void switchVerificationType(VerificationType type) {
    state = state.copyWith(
      verificationType: type,
      account: '',
      verificationCode: '',
      clearError: true,
    );
  }

  /// Sends verification code.
  Future<bool> sendVerificationCode() async {
    if (state.account.isEmpty) {
      state = state.copyWith(
        errorMessage: _getAccountRequiredMessage(),
      );
      return false;
    }

    // Validate account format
    if (!_validateAccount(state.account)) {
      state = state.copyWith(
        errorMessage: _getInvalidAccountMessage(),
      );
      return false;
    }

    state = state.copyWith(isLoading: true);

    final repository = ref.read(forgotPasswordRepositoryProvider);

    final result = state.verificationType == VerificationType.email
        ? await repository.sendVerificationEmail(state.account)
        : await repository.sendVerificationSms(state.account);

    return result.when(
      failure: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        return false;
      },
      success: (_) {
        state = state.copyWith(
          isLoading: false,
          step: ForgotPasswordStep.enterCode,
          codeSentAt: DateTime.now(),
          canResendCode: false,
        );

        // Start resend timer (60 seconds)
        _startResendTimer();

        return true;
      },
    );
  }

  /// Verifies the code.
  Future<bool> verifyCode() async {
    if (state.verificationCode.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Please enter verification code',
      );
      return false;
    }

    if (state.verificationCode.length < 6) {
      state = state.copyWith(
        errorMessage: 'Verification code must be 6 digits',
      );
      return false;
    }

    state = state.copyWith(isLoading: true);

    final repository = ref.read(forgotPasswordRepositoryProvider);

    final result = await repository.verifyCode(
      account: state.account,
      code: state.verificationCode,
      type: state.verificationType,
    );

    return result.when(
      failure: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        return false;
      },
      success: (isValid) {
        if (isValid) {
          state = state.copyWith(
            isLoading: false,
            step: ForgotPasswordStep.resetPassword,
          );
          _cancelResendTimer();
          return true;
        } else {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'Invalid verification code',
          );
          return false;
        }
      },
    );
  }

  /// Resets the password.
  Future<bool> resetPassword() async {
    if (state.newPassword.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Please enter new password',
      );
      return false;
    }

    if (!Validators.isPasswordMinLengthMet(state.newPassword)) {
      state = state.copyWith(
        errorMessage: 'Password must be at least 8 characters',
      );
      return false;
    }

    // Check password complexity: at least one letter and one number
    if (!Validators.isPasswordComplexityMet(state.newPassword)) {
      state = state.copyWith(
        errorMessage: 'Password must contain letters and numbers',
      );
      return false;
    }

    if (state.confirmPassword.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Please confirm your password',
      );
      return false;
    }

    if (state.newPassword != state.confirmPassword) {
      state = state.copyWith(
        errorMessage: 'Passwords do not match',
      );
      return false;
    }

    state = state.copyWith(isLoading: true);

    final repository = ref.read(forgotPasswordRepositoryProvider);

    final result = await repository.resetPassword(
      account: state.account,
      newPassword: state.newPassword,
      verificationCode: state.verificationCode,
      type: state.verificationType,
    );

    return result.when(
      failure: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        return false;
      },
      success: (_) {
        state = state.copyWith(
          isLoading: false,
          step: ForgotPasswordStep.success,
        );
        return true;
      },
    );
  }

  /// Goes back to the previous step.
  void goBack() {
    _cancelResendTimer();

    final newStep = switch (state.step) {
      ForgotPasswordStep.enterCode => ForgotPasswordStep.enterAccount,
      ForgotPasswordStep.resetPassword => ForgotPasswordStep.enterCode,
      ForgotPasswordStep.success => ForgotPasswordStep.resetPassword,
      ForgotPasswordStep.enterAccount => ForgotPasswordStep.enterAccount,
    };

    state = state.copyWith(
      step: newStep,
      clearError: true,
    );

    // Restart timer if going back to code step
    if (newStep == ForgotPasswordStep.enterCode && state.codeSentAt != null) {
      final elapsed = DateTime.now().difference(state.codeSentAt!).inSeconds;
      if (elapsed < 60) {
        _startResendTimer(60 - elapsed);
      }
    }
  }

  /// Resets the entire flow.
  void reset() {
    _cancelResendTimer();
    final localeAsync = ref.read(localeNotifierProvider);
    final isChinese = localeAsync.valueOrNull?.languageCode == 'zh';

    state = ForgotPasswordState(
      verificationType:
          isChinese ? VerificationType.sms : VerificationType.email,
    );
  }

  /// Clears error message.
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void _startResendTimer([int seconds = 60]) {
    _cancelResendTimer();
    state = state.copyWith(canResendCode: false);

    _resendTimer = Timer(Duration(seconds: seconds), () {
      state = state.copyWith(canResendCode: true);
    });
  }

  void _cancelResendTimer() {
    _resendTimer?.cancel();
    _resendTimer = null;
  }

  bool _validateAccount(String account) {
    if (state.verificationType == VerificationType.email) {
      return Validators.isEmailValid(account);
    } else {
      return Validators.isChinesePhoneValid(account);
    }
  }

  String _getAccountRequiredMessage() {
    return state.verificationType == VerificationType.email
        ? 'Please enter your email'
        : 'Please enter your phone number';
  }

  String _getInvalidAccountMessage() {
    return state.verificationType == VerificationType.email
        ? 'Please enter a valid email address'
        : 'Please enter a valid phone number';
  }
}

/// Mock implementation of ForgotPasswordRepository.
class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  /// Simulates network delay (1-2 seconds as per PRD).
  Future<void> _simulateNetworkDelay() async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));
  }

  @override
  Future<Result<void>> sendVerificationEmail(String email) async {
    try {
      await _simulateNetworkDelay();

      if (!Validators.isEmailValid(email)) {
        throw AuthException('Invalid email format');
      }

      // Mock: always succeed
      return const Success(null);
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(message: e.message));
    } on Exception catch (e) {
      return FailureResult(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<void>> sendVerificationSms(String phone) async {
    try {
      await _simulateNetworkDelay();

      if (!Validators.isChinesePhoneValid(phone)) {
        throw AuthException('Invalid phone number format');
      }

      // Mock: always succeed
      return const Success(null);
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(message: e.message));
    } on Exception catch (e) {
      return FailureResult(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<bool>> verifyCode({
    required String account,
    required String code,
    required VerificationType type,
  }) async {
    try {
      await _simulateNetworkDelay();

      // Mock: accept any 6-digit code
      if (code.length != 6) {
        throw AuthException('Invalid verification code');
      }

      // Mock: accept "123456" as valid code
      return Success(code == '123456');
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(message: e.message));
    } on Exception catch (e) {
      return FailureResult(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<void>> resetPassword({
    required String account,
    required String newPassword,
    required String verificationCode,
    required VerificationType type,
  }) async {
    try {
      await _simulateNetworkDelay();

      if (!Validators.isPasswordMinLengthMet(newPassword)) {
        throw AuthException('Password must be at least 8 characters');
      }

      if (!Validators.isPasswordComplexityMet(newPassword)) {
        throw AuthException('Password must contain letters and numbers');
      }

      // Mock: always succeed
      return const Success(null);
    } on AuthException catch (e) {
      return FailureResult(AuthFailure(message: e.message));
    } on Exception catch (e) {
      return FailureResult(ErrorHandler.handleException(e));
    }
  }
}
