/// Forgot password state entity.
library;

/// Verification type for password reset.
enum VerificationType {
  /// Email verification (for international users).
  email,

  /// SMS verification (for Chinese users).
  sms,
}

/// Forgot password flow step.
enum ForgotPasswordStep {
  /// Initial step - enter account.
  enterAccount,

  /// Verification step - enter code.
  enterCode,

  /// Reset step - enter new password.
  resetPassword,

  /// Success step - password reset complete.
  success,
}

/// Forgot password state.
class ForgotPasswordState {
  /// Creates forgot password state.
  const ForgotPasswordState({
    this.step = ForgotPasswordStep.enterAccount,
    this.verificationType = VerificationType.email,
    this.account = '',
    this.verificationCode = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.errorMessage,
    this.codeSentAt,
    this.canResendCode = false,
  });

  /// Current step in the flow.
  final ForgotPasswordStep step;

  /// Type of verification (email or SMS).
  final VerificationType verificationType;

  /// User's account (email or phone).
  final String account;

  /// Verification code entered by user.
  final String verificationCode;

  /// New password.
  final String newPassword;

  /// Confirm password.
  final String confirmPassword;

  /// Loading state.
  final bool isLoading;

  /// Error message if any.
  final String? errorMessage;

  /// When verification code was sent.
  final DateTime? codeSentAt;

  /// Whether user can resend code.
  final bool canResendCode;

  /// Creates a copy with updated fields.
  ForgotPasswordState copyWith({
    ForgotPasswordStep? step,
    VerificationType? verificationType,
    String? account,
    String? verificationCode,
    String? newPassword,
    String? confirmPassword,
    bool? isLoading,
    String? errorMessage,
    DateTime? codeSentAt,
    bool? canResendCode,
    bool clearError = false,
  }) => ForgotPasswordState(
      step: step ?? this.step,
      verificationType: verificationType ?? this.verificationType,
      account: account ?? this.account,
      verificationCode: verificationCode ?? this.verificationCode,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      codeSentAt: codeSentAt ?? this.codeSentAt,
      canResendCode: canResendCode ?? this.canResendCode,
    );

  /// Returns masked account for display.
  String get maskedAccount {
    if (verificationType == VerificationType.email) {
      // Mask email: t***@example.com
      final parts = account.split('@');
      if (parts.length == 2) {
        final local = parts[0];
        final domain = parts[1];
        if (local.length > 2) {
          return '${local[0]}***@$domain';
        }
        return '$local***@$domain';
      }
      return account;
    } else {
      // Mask phone: 138****1234
      if (account.length >= 7) {
        return '${account.substring(0, 3)}****${account.substring(account.length - 4)}';
      }
      return account;
    }
  }

  /// Returns the label for account input.
  String get accountLabel => verificationType == VerificationType.email ? 'Email' : 'Phone';

  /// Returns the hint for account input.
  String get accountHint => verificationType == VerificationType.email
        ? 'Enter your email address'
        : 'Enter your phone number';
}
