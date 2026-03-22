/// Register screen for user registration with verification code.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/router/routes.dart';
import 'package:flutter_project_template/features/auth/domain/entities/auth_state.dart';
import 'package:flutter_project_template/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_project_template/shared/widgets/dialog_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Region type for registration.
enum RegionType {
  /// China region - uses phone number.
  china,

  /// International region - uses email.
  international,
}

/// Register screen widget.
class RegisterScreen extends ConsumerStatefulWidget {
  /// Creates the register screen.
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late RegionType _regionType;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _isSendingCode = false;
  bool _isVerifyingCode = false;
  bool _isCodeVerified = false;
  int _countdown = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _regionType = _detectRegion();
  }

  /// Detects region based on device locale.
  RegionType _detectRegion() {
    // Get device locale
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    final languageCode = locale.languageCode.toLowerCase();

    // If Chinese (zh), use China region with phone number
    if (languageCode == 'zh' || languageCode == 'cn') {
      return RegionType.china;
    }

    // Otherwise, use international region with email
    return RegionType.international;
  }

  @override
  void dispose() {
    _accountController.dispose();
    _verificationCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  /// Validates phone number format (Chinese phone).
  bool _isValidPhone(String phone) {
    return RegExp(r'^1[3-9]\d{9}$').hasMatch(phone);
  }

  /// Validates email format.
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Sends verification code.
  Future<void> _sendVerificationCode() async {
    final account = _accountController.text.trim();

    // Validate account first
    if (_regionType == RegionType.china) {
      if (!_isValidPhone(account)) {
        _showError('Please enter a valid phone number');
        return;
      }
    } else {
      if (!_isValidEmail(account)) {
        _showError('Please enter a valid email');
        return;
      }
    }

    setState(() => _isSendingCode = true);

    final success = _regionType == RegionType.china
        ? await ref
            .read(authNotifierProvider.notifier)
            .sendVerificationCodeToPhone(account)
        : await ref
            .read(authNotifierProvider.notifier)
            .sendVerificationCodeToEmail(account);

    setState(() => _isSendingCode = false);

    if (success && mounted) {
      final localizations = AppLocalizations.of(context)!;
      DialogUtil.showSuccessDialog(
        context,
        localizations.verificationCodeSentTo(account),
      );
      _startCountdown();
    } else if (mounted) {
      _showError('Failed to send verification code');
    }
  }

  /// Starts countdown timer.
  void _startCountdown() {
    setState(() => _countdown = 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
      }
    });
  }

  /// Verifies the code.
  Future<void> _verifyCode() async {
    final account = _accountController.text.trim();
    final code = _verificationCodeController.text.trim();

    if (code.isEmpty) {
      _showError('Please enter verification code');
      return;
    }

    setState(() => _isVerifyingCode = true);

    final success = _regionType == RegionType.china
        ? await ref.read(authNotifierProvider.notifier).verifyPhoneCode(
              phoneNumber: account,
              code: code,
            )
        : await ref.read(authNotifierProvider.notifier).verifyEmailCode(
              email: account,
              code: code,
            );

    setState(() {
      _isVerifyingCode = false;
      if (success) {
        _isCodeVerified = true;
      }
    });

    if (success && mounted) {
      final localizations = AppLocalizations.of(context)!;
      DialogUtil.showSuccessDialog(context, localizations.verificationSuccessful);
    } else if (mounted) {
      _showError('Verification failed');
    }
  }

  /// Handles registration.
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isCodeVerified) {
      final localizations = AppLocalizations.of(context)!;
      _showError(localizations.pleaseVerifyAccountFirst);
      return;
    }

    setState(() => _isLoading = true);

    final account = _accountController.text.trim();
    final password = _passwordController.text;
    final code = _verificationCodeController.text.trim();

    final success = _regionType == RegionType.china
        ? await ref.read(authNotifierProvider.notifier).registerWithPhone(
              phoneNumber: account,
              username: account,
              password: password,
              verificationCode: code,
            )
        : await ref.read(authNotifierProvider.notifier).registerWithEmail(
              email: account,
              username: account,
              password: password,
              verificationCode: code,
            );

    setState(() => _isLoading = false);

    if (success && mounted) {
      // Registration successful, navigate directly to home
      context.go(Routes.home);
    }
  }

  /// Shows error message.
  void _showError(String message) {
    if (mounted) {
      DialogUtil.showErrorDialog(context, message);
    }
  }

  /// Handles logout for already logged in users.
  Future<void> _handleLogout() async {
    final success = await ref.read(authNotifierProvider.notifier).logout();
    if (success && mounted) {
      // User is now logged out, the widget will rebuild automatically
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);

    // Show error if any
    ref.listen<AsyncValue<AuthState>>(authNotifierProvider, (previous, next) {
      if (next.hasError) {
        _showError(next.error.toString());
      }
    });

    // If user is already logged in, show a dialog to logout first
    final isAuthenticated = authState.valueOrNull?.isAuthenticated ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.register)),
      body: isAuthenticated
          ? _AlreadyLoggedInView(
              localizations: localizations,
              theme: theme,
              onLogout: _handleLogout,
            )
          : _RegisterFormView(
              formKey: _formKey,
              accountController: _accountController,
              verificationCodeController: _verificationCodeController,
              passwordController: _passwordController,
              confirmPasswordController: _confirmPasswordController,
              regionType: _regionType,
              obscurePassword: _obscurePassword,
              obscureConfirmPassword: _obscureConfirmPassword,
              isLoading: _isLoading,
              isSendingCode: _isSendingCode,
              isVerifyingCode: _isVerifyingCode,
              isCodeVerified: _isCodeVerified,
              countdown: _countdown,
              authState: authState,
              onTogglePassword: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              onToggleConfirmPassword: () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword,
              ),
              onSendCode: _sendVerificationCode,
              onVerifyCode: _verifyCode,
              onRegister: _handleRegister,
              localizations: localizations,
              theme: theme,
            ),
    );
  }
}

/// View shown when user is already logged in.
class _AlreadyLoggedInView extends StatelessWidget {
  const _AlreadyLoggedInView({
    required this.localizations,
    required this.theme,
    required this.onLogout,
  });

  final AppLocalizations localizations;
  final ThemeData theme;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'You are already logged in',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'To register a new account, please logout first.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go(Routes.home),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

/// View containing the registration form.
class _RegisterFormView extends StatelessWidget {
  const _RegisterFormView({
    required this.formKey,
    required this.accountController,
    required this.verificationCodeController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.regionType,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.isLoading,
    required this.isSendingCode,
    required this.isVerifyingCode,
    required this.isCodeVerified,
    required this.countdown,
    required this.authState,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onSendCode,
    required this.onVerifyCode,
    required this.onRegister,
    required this.localizations,
    required this.theme,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController accountController;
  final TextEditingController verificationCodeController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final RegionType regionType;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool isLoading;
  final bool isSendingCode;
  final bool isVerifyingCode;
  final bool isCodeVerified;
  final int countdown;
  final AsyncValue<AuthState> authState;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final VoidCallback onSendCode;
  final VoidCallback onVerifyCode;
  final VoidCallback onRegister;
  final AppLocalizations localizations;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HeaderSection(theme: theme, localizations: localizations),
                  const SizedBox(height: 16),
                  _RegionIndicator(
                    regionType: regionType,
                    localizations: localizations,
                  ),
                  const SizedBox(height: 24),
                  _AccountField(
                    controller: accountController,
                    regionType: regionType,
                    localizations: localizations,
                  ),
                  const SizedBox(height: 16),
                  _VerificationCodeSection(
                    controller: verificationCodeController,
                    countdown: countdown,
                    isSendingCode: isSendingCode,
                    isVerifyingCode: isVerifyingCode,
                    isCodeVerified: isCodeVerified,
                    onSendCode: onSendCode,
                    onVerifyCode: onVerifyCode,
                    localizations: localizations,
                  ),
                  const SizedBox(height: 16),
                  _PasswordField(
                    controller: passwordController,
                    obscurePassword: obscurePassword,
                    onToggleObscure: onTogglePassword,
                    localizations: localizations,
                  ),
                  const SizedBox(height: 16),
                  _ConfirmPasswordField(
                    controller: confirmPasswordController,
                    passwordController: passwordController,
                    obscurePassword: obscureConfirmPassword,
                    onToggleObscure: onToggleConfirmPassword,
                    localizations: localizations,
                  ),
                  const SizedBox(height: 24),
                  _RegisterButton(
                    isLoading: isLoading || authState.isLoading,
                    onPressed: onRegister,
                    localizations: localizations,
                  ),
                  const SizedBox(height: 24),
                  _LoginLink(
                    localizations: localizations,
                    onLoginTap: () => context.go(Routes.login),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Header section with logo and title.
class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.theme, required this.localizations});

  final ThemeData theme;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.person_add_rounded,
          size: 64,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          localizations.createAccount,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          localizations.signUpToGetStarted,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Region indicator showing detected region.
class _RegionIndicator extends StatelessWidget {
  const _RegionIndicator({
    required this.regionType,
    required this.localizations,
  });

  final RegionType regionType;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final regionName = regionType == RegionType.china
        ? localizations.chinaRegion
        : localizations.internationalRegion;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 18,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            localizations.regionDetected(regionName),
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

/// Account input field (phone or email based on region).
class _AccountField extends StatelessWidget {
  const _AccountField({
    required this.controller,
    required this.regionType,
    required this.localizations,
  });

  final TextEditingController controller;
  final RegionType regionType;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final isPhone = regionType == RegionType.china;

    return TextFormField(
      controller: controller,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: isPhone ? localizations.phoneNumber : localizations.email,
        prefixIcon: Icon(
          isPhone ? Icons.phone_outlined : Icons.email_outlined,
        ),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return isPhone
              ? localizations.enterPhoneNumber
              : localizations.enterEmail;
        }
        if (isPhone) {
          if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value)) {
            return localizations.enterValidPhoneNumber;
          }
        } else {
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return localizations.enterValidEmail;
          }
        }
        return null;
      },
    );
  }
}

/// Verification code section with input and buttons.
class _VerificationCodeSection extends StatelessWidget {
  const _VerificationCodeSection({
    required this.controller,
    required this.countdown,
    required this.isSendingCode,
    required this.isVerifyingCode,
    required this.isCodeVerified,
    required this.onSendCode,
    required this.onVerifyCode,
    required this.localizations,
  });

  final TextEditingController controller;
  final int countdown;
  final bool isSendingCode;
  final bool isVerifyingCode;
  final bool isCodeVerified;
  final VoidCallback onSendCode;
  final VoidCallback onVerifyCode;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                enabled: !isCodeVerified,
                decoration: InputDecoration(
                  labelText: localizations.verificationCode,
                  prefixIcon: const Icon(Icons.verified_outlined),
                  suffixIcon: isCodeVerified
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        )
                      : null,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.enterVerificationCode;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 120,
              height: 56,
              child: ElevatedButton(
                onPressed: countdown > 0 || isSendingCode ? null : onSendCode,
                child: isSendingCode
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        countdown > 0
                            ? localizations.resendIn(countdown)
                            : localizations.sendCode,
                        style: const TextStyle(fontSize: 12),
                      ),
              ),
            ),
          ],
        ),
        if (!isCodeVerified) ...[
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: TextButton.icon(
              onPressed: isVerifyingCode ? null : onVerifyCode,
              icon: isVerifyingCode
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.verified_user_outlined),
              label: Text(localizations.verifyCode),
            ),
          ),
        ],
      ],
    );
  }
}

/// Password input field.
class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.localizations,
  });

  final TextEditingController controller;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscurePassword,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: localizations.password,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: onToggleObscure,
        ),
        border: const OutlineInputBorder(),
        helperText: localizations.passwordRequirement,
        helperMaxLines: 1,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return localizations.enterPassword;
        }
        if (value.length < 8) {
          return localizations.passwordMinLength8;
        }
        if (!RegExp(r'[a-zA-Z]').hasMatch(value) ||
            !RegExp(r'[0-9]').hasMatch(value)) {
          return localizations.passwordStrength;
        }
        return null;
      },
    );
  }
}

/// Confirm password input field.
class _ConfirmPasswordField extends StatelessWidget {
  const _ConfirmPasswordField({
    required this.controller,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.localizations,
  });

  final TextEditingController controller;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscurePassword,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: localizations.confirmPassword,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: onToggleObscure,
        ),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return localizations.confirmYourPassword;
        }
        if (value != passwordController.text) {
          return localizations.passwordsDoNotMatch;
        }
        return null;
      },
    );
  }
}

/// Register button.
class _RegisterButton extends StatelessWidget {
  const _RegisterButton({
    required this.isLoading,
    required this.onPressed,
    required this.localizations,
  });

  final bool isLoading;
  final VoidCallback onPressed;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(localizations.register),
    );
  }
}

/// Login link.
class _LoginLink extends StatelessWidget {
  const _LoginLink({
    required this.localizations,
    required this.onLoginTap,
  });

  final AppLocalizations localizations;
  final VoidCallback onLoginTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${localizations.haveAccount} ',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        TextButton(onPressed: onLoginTap, child: Text(localizations.login)),
      ],
    );
  }
}
