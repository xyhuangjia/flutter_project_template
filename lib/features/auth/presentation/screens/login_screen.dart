/// Login screen for user authentication.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/router/routes.dart';
import 'package:flutter_project_template/features/auth/domain/entities/auth_state.dart';
import 'package:flutter_project_template/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Login screen widget.
class LoginScreen extends ConsumerStatefulWidget {
  /// Creates the login screen.
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success =
        await ref.read(authNotifierProvider.notifier).loginWithEmail(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            );

    setState(() => _isLoading = false);

    if (success && mounted) {
      context.go(Routes.home);
    }
  }

  Future<void> _handleThirdPartyLogin(Future<bool> Function() loginFn) async {
    setState(() => _isLoading = true);

    final success = await loginFn();

    setState(() => _isLoading = false);

    if (success && mounted) {
      context.go(Routes.home);
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _HeaderSection(theme: theme),
                    const SizedBox(height: 32),
                    _EmailField(
                      controller: _emailController,
                      localizations: localizations,
                    ),
                    const SizedBox(height: 16),
                    _PasswordField(
                      controller: _passwordController,
                      obscurePassword: _obscurePassword,
                      onToggleObscure: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                      localizations: localizations,
                    ),
                    const SizedBox(height: 8),
                    _ForgotPasswordLink(localizations: localizations),
                    const SizedBox(height: 24),
                    _LoginButton(
                      isLoading: _isLoading || authState.isLoading,
                      onPressed: _handleLogin,
                      localizations: localizations,
                    ),
                    const SizedBox(height: 24),
                    _DividerWithText(localizations: localizations),
                    const SizedBox(height: 24),
                    _ThirdPartyLoginButtons(
                      isLoading: _isLoading || authState.isLoading,
                      onWeChatLogin: () => _handleThirdPartyLogin(
                        () => ref
                            .read(authNotifierProvider.notifier)
                            .loginWithWeChat(),
                      ),
                      onAppleLogin: () => _handleThirdPartyLogin(
                        () => ref
                            .read(authNotifierProvider.notifier)
                            .loginWithApple(),
                      ),
                      onGoogleLogin: () => _handleThirdPartyLogin(
                        () => ref
                            .read(authNotifierProvider.notifier)
                            .loginWithGoogle(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _RegisterLink(
                      localizations: localizations,
                      onRegisterTap: () => context.go(Routes.register),
                    ),
                  ],
                ),
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
  const _HeaderSection({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.lock_open_rounded,
          size: 64,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Welcome Back',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to continue',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Email input field.
class _EmailField extends StatelessWidget {
  const _EmailField({required this.controller, required this.localizations});

  final TextEditingController controller;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: localizations.email,
        prefixIcon: const Icon(Icons.email_outlined),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
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
      textInputAction: TextInputAction.done,
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
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}

/// Forgot password link.
class _ForgotPasswordLink extends StatelessWidget {
  const _ForgotPasswordLink({required this.localizations});

  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // TODO: Navigate to forgot password screen
        },
        child: Text(localizations.forgotPassword),
      ),
    );
  }
}

/// Login button.
class _LoginButton extends StatelessWidget {
  const _LoginButton({
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
          : Text(localizations.login),
    );
  }
}

/// Divider with text.
class _DividerWithText extends StatelessWidget {
  const _DividerWithText({required this.localizations});

  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

/// Third-party login buttons.
class _ThirdPartyLoginButtons extends StatelessWidget {
  const _ThirdPartyLoginButtons({
    required this.isLoading,
    required this.onWeChatLogin,
    required this.onAppleLogin,
    required this.onGoogleLogin,
  });

  final bool isLoading;
  final VoidCallback onWeChatLogin;
  final VoidCallback onAppleLogin;
  final VoidCallback onGoogleLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SocialLoginButton(
          icon: Icons.chat,
          label: 'Continue with WeChat',
          onPressed: isLoading ? null : onWeChatLogin,
          backgroundColor: const Color(0xFF07C160),
        ),
        const SizedBox(height: 12),
        _SocialLoginButton(
          icon: Icons.apple,
          label: 'Continue with Apple',
          onPressed: isLoading ? null : onAppleLogin,
          backgroundColor: Colors.black,
        ),
        const SizedBox(height: 12),
        _SocialLoginButton(
          icon: Icons.g_mobiledata,
          label: 'Continue with Google',
          onPressed: isLoading ? null : onGoogleLogin,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          borderColor: Colors.grey.shade300,
        ),
      ],
    );
  }
}

/// Social login button widget.
class _SocialLoginButton extends StatelessWidget {
  const _SocialLoginButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.borderColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        side: borderColor != null ? BorderSide(color: borderColor!) : null,
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      icon: Icon(icon, size: 24),
      label: Text(label),
    );
  }
}

/// Register link.
class _RegisterLink extends StatelessWidget {
  const _RegisterLink({
    required this.localizations,
    required this.onRegisterTap,
  });

  final AppLocalizations localizations;
  final VoidCallback onRegisterTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        TextButton(
          onPressed: onRegisterTap,
          child: Text(localizations.register),
        ),
      ],
    );
  }
}
