/// Forgot password screen for password recovery.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/router/routes.dart';
import 'package:flutter_project_template/features/auth/domain/entities/forgot_password_state.dart';
import 'package:flutter_project_template/features/auth/presentation/providers/forgot_password_provider.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Forgot password screen widget.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  /// Creates the forgot password screen.
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _accountController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  int _countdown = 0;
  Timer? _countdownTimer;

  @override
  void dispose() {
    _accountController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _countdown = 60;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  Future<void> _handleSendCode() async {
    final success = await ref
        .read(forgotPasswordNotifierProvider.notifier)
        .sendVerificationCode();
    if (success && mounted) {
      _startCountdown();
    }
  }

  Future<void> _handleVerifyCode() async {
    await ref.read(forgotPasswordNotifierProvider.notifier).verifyCode();
  }

  Future<void> _handleResetPassword() async {
    final success =
        await ref.read(forgotPasswordNotifierProvider.notifier).resetPassword();
    if (success && mounted) {
      // Show success for 2 seconds then go back to login
      await Future<void>.delayed(const Duration(seconds: 2));
      if (mounted) {
        context.go(Routes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(forgotPasswordNotifierProvider);

    // Listen for errors
    ref.listen<ForgotPasswordState>(forgotPasswordNotifierProvider,
        (previous, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (state.step != ForgotPasswordStep.enterAccount &&
                state.step != ForgotPasswordStep.success) {
              ref.read(forgotPasswordNotifierProvider.notifier).goBack();
            } else {
              context.go(Routes.login);
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              _HeaderSection(
                theme: theme,
                colorScheme: colorScheme,
                step: state.step,
                localizations: localizations,
              ),
              const SizedBox(height: 32),
              _buildStepContent(
                  context, state, localizations, theme, colorScheme),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(
    BuildContext context,
    ForgotPasswordState state,
    AppLocalizations localizations,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    switch (state.step) {
      case ForgotPasswordStep.enterAccount:
        return _EnterAccountForm(
          accountController: _accountController,
          state: state,
          localizations: localizations,
          theme: theme,
          colorScheme: colorScheme,
          onAccountChanged: (value) {
            ref.read(forgotPasswordNotifierProvider.notifier).setAccount(value);
          },
          onVerificationTypeChanged: (type) {
            ref
                .read(forgotPasswordNotifierProvider.notifier)
                .switchVerificationType(type);
            _accountController.clear();
          },
          onSendCode: _handleSendCode,
          isLoading: state.isLoading,
          countdown: _countdown,
        );
      case ForgotPasswordStep.enterCode:
        return _EnterCodeForm(
          codeController: _codeController,
          state: state,
          localizations: localizations,
          theme: theme,
          colorScheme: colorScheme,
          onCodeChanged: (value) {
            ref
                .read(forgotPasswordNotifierProvider.notifier)
                .setVerificationCode(value);
          },
          onVerify: _handleVerifyCode,
          onResendCode: () async {
            await _handleSendCode();
          },
          isLoading: state.isLoading,
          canResend: state.canResendCode && _countdown == 0,
        );
      case ForgotPasswordStep.resetPassword:
        return _ResetPasswordForm(
          passwordController: _passwordController,
          confirmPasswordController: _confirmPasswordController,
          state: state,
          localizations: localizations,
          theme: theme,
          colorScheme: colorScheme,
          obscurePassword: _obscurePassword,
          obscureConfirmPassword: _obscureConfirmPassword,
          onPasswordChanged: (value) {
            ref
                .read(forgotPasswordNotifierProvider.notifier)
                .setNewPassword(value);
          },
          onConfirmPasswordChanged: (value) {
            ref
                .read(forgotPasswordNotifierProvider.notifier)
                .setConfirmPassword(value);
          },
          onTogglePassword: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
          onToggleConfirmPassword: () {
            setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
          },
          onResetPassword: _handleResetPassword,
          isLoading: state.isLoading,
        );
      case ForgotPasswordStep.success:
        return _SuccessSection(
          theme: theme,
          colorScheme: colorScheme,
          localizations: localizations,
        );
    }
  }
}

// ==================== Header Section ====================

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({
    required this.theme,
    required this.colorScheme,
    required this.step,
    required this.localizations,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final ForgotPasswordStep step;
  final AppLocalizations localizations;

  String get _title {
    return switch (step) {
      ForgotPasswordStep.enterAccount => localizations.forgotPasswordTitle,
      ForgotPasswordStep.enterCode => localizations.enterVerificationCode,
      ForgotPasswordStep.resetPassword => localizations.setNewPassword,
      ForgotPasswordStep.success => localizations.passwordResetSuccess,
    };
  }

  String get _subtitle {
    return switch (step) {
      ForgotPasswordStep.enterAccount => localizations.forgotPasswordSubtitle,
      ForgotPasswordStep.enterCode => localizations.verificationCodeSent,
      ForgotPasswordStep.resetPassword => localizations.createNewPassword,
      ForgotPasswordStep.success => localizations.passwordResetSuccessMessage,
    };
  }

  IconData get _icon {
    return switch (step) {
      ForgotPasswordStep.enterAccount => Icons.lock_reset_rounded,
      ForgotPasswordStep.enterCode => Icons.mark_email_read_outlined,
      ForgotPasswordStep.resetPassword => Icons.password_rounded,
      ForgotPasswordStep.success => Icons.check_circle_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            _icon,
            size: 48,
            color: step == ForgotPasswordStep.success
                ? Colors.green
                : colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          _title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _subtitle,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ==================== Enter Account Form ====================

class _EnterAccountForm extends StatelessWidget {
  const _EnterAccountForm({
    required this.accountController,
    required this.state,
    required this.localizations,
    required this.theme,
    required this.colorScheme,
    required this.onAccountChanged,
    required this.onVerificationTypeChanged,
    required this.onSendCode,
    required this.isLoading,
    required this.countdown,
  });

  final TextEditingController accountController;
  final ForgotPasswordState state;
  final AppLocalizations localizations;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final ValueChanged<String> onAccountChanged;
  final ValueChanged<VerificationType> onVerificationTypeChanged;
  final VoidCallback onSendCode;
  final bool isLoading;
  final int countdown;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Verification type toggle
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: _TypeToggleButton(
                  label: localizations.email,
                  icon: Icons.email_outlined,
                  isSelected: state.verificationType == VerificationType.email,
                  onTap: () =>
                      onVerificationTypeChanged(VerificationType.email),
                ),
              ),
              Expanded(
                child: _TypeToggleButton(
                  label: localizations.phone,
                  icon: Icons.phone_outlined,
                  isSelected: state.verificationType == VerificationType.sms,
                  onTap: () => onVerificationTypeChanged(VerificationType.sms),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Account input
        TextFormField(
          controller: accountController,
          keyboardType: state.verificationType == VerificationType.email
              ? TextInputType.emailAddress
              : TextInputType.phone,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: state.verificationType == VerificationType.email
                ? localizations.email
                : localizations.phoneNumber,
            prefixIcon: Icon(
              state.verificationType == VerificationType.email
                  ? Icons.email_outlined
                  : Icons.phone_outlined,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onChanged: onAccountChanged,
          onFieldSubmitted: (_) => onSendCode(),
        ),
        const SizedBox(height: 24),
        // Send code button
        SizedBox(
          height: 52,
          child: FilledButton(
            onPressed: isLoading ? null : onSendCode,
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    localizations.sendVerificationCode,
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        ),
      ],
    );
  }
}

// ==================== Enter Code Form ====================

class _EnterCodeForm extends StatelessWidget {
  const _EnterCodeForm({
    required this.codeController,
    required this.state,
    required this.localizations,
    required this.theme,
    required this.colorScheme,
    required this.onCodeChanged,
    required this.onVerify,
    required this.onResendCode,
    required this.isLoading,
    required this.canResend,
  });

  final TextEditingController codeController;
  final ForgotPasswordState state;
  final AppLocalizations localizations;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final ValueChanged<String> onCodeChanged;
  final VoidCallback onVerify;
  final VoidCallback onResendCode;
  final bool isLoading;
  final bool canResend;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Show masked account
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                state.verificationType == VerificationType.email
                    ? Icons.email_outlined
                    : Icons.phone_outlined,
                size: 20,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  localizations.codeSentTo(state.maskedAccount),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Code input
        TextFormField(
          controller: codeController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 6,
          style: const TextStyle(
            fontSize: 24,
            letterSpacing: 8,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            labelText: localizations.verificationCode,
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onChanged: onCodeChanged,
          onFieldSubmitted: (_) => onVerify(),
        ),
        const SizedBox(height: 16),
        // Resend button
        Center(
          child: TextButton(
            onPressed: canResend && !isLoading ? onResendCode : null,
            child: Text(
              canResend
                  ? localizations.resendCode
                  : localizations
                      .resendCodeIn('${60 - (DateTime.now().second % 60)}'),
              style: TextStyle(
                color: canResend ? colorScheme.primary : colorScheme.outline,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Verify button
        SizedBox(
          height: 52,
          child: FilledButton(
            onPressed: isLoading ? null : onVerify,
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    localizations.verify,
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        ),
      ],
    );
  }
}

// ==================== Reset Password Form ====================

class _ResetPasswordForm extends StatelessWidget {
  const _ResetPasswordForm({
    required this.passwordController,
    required this.confirmPasswordController,
    required this.state,
    required this.localizations,
    required this.theme,
    required this.colorScheme,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onPasswordChanged,
    required this.onConfirmPasswordChanged,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onResetPassword,
    required this.isLoading,
  });

  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final ForgotPasswordState state;
  final AppLocalizations localizations;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onConfirmPasswordChanged;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final VoidCallback onResetPassword;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Password requirements
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.passwordRequirements,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _RequirementItem(
                text: localizations.passwordMinLengthReq,
                isMet: state.newPassword.length >= 8,
              ),
              _RequirementItem(
                text: localizations.passwordComplexityReq,
                isMet: RegExp(r'^(?=.*[A-Za-z])(?=.*\d).+$')
                    .hasMatch(state.newPassword),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // New password
        TextFormField(
          controller: passwordController,
          obscureText: obscurePassword,
          decoration: InputDecoration(
            labelText: localizations.newPassword,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: onTogglePassword,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onChanged: onPasswordChanged,
        ),
        const SizedBox(height: 16),
        // Confirm password
        TextFormField(
          controller: confirmPasswordController,
          obscureText: obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: localizations.confirmNewPassword,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                obscureConfirmPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: onToggleConfirmPassword,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onChanged: onConfirmPasswordChanged,
          onFieldSubmitted: (_) => onResetPassword(),
        ),
        const SizedBox(height: 24),
        // Reset button
        SizedBox(
          height: 52,
          child: FilledButton(
            onPressed: isLoading ? null : onResetPassword,
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    localizations.resetPassword,
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        ),
      ],
    );
  }
}

// ==================== Success Section ====================

class _SuccessSection extends StatelessWidget {
  const _SuccessSection({
    required this.theme,
    required this.colorScheme,
    required this.localizations,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 64,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              Text(
                localizations.passwordResetSuccess,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                localizations.passwordResetSuccessMessage,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 52,
          width: double.infinity,
          child: FilledButton(
            onPressed: () => context.go(Routes.login),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              localizations.backToLogin,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}

// ==================== Helper Widgets ====================

class _TypeToggleButton extends StatelessWidget {
  const _TypeToggleButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequirementItem extends StatelessWidget {
  const _RequirementItem({
    required this.text,
    required this.isMet,
  });

  final String text;
  final bool isMet;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isMet ? Colors.green : colorScheme.outline,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isMet ? Colors.green : colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
