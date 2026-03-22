/// Login screen for user authentication.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/router/routes.dart';
import 'package:flutter_project_template/features/auth/domain/entities/auth_state.dart';
import 'package:flutter_project_template/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_project_template/shared/widgets/dialog_util.dart';
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
    final colorScheme = theme.colorScheme;
    final authState = ref.watch(authNotifierProvider);

    // Show error if any
    ref.listen<AsyncValue<AuthState>>(authNotifierProvider, (previous, next) {
      if (next.hasError) {
        DialogUtil.showErrorDialog(context, next.error.toString());
      }
    });

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth > 600;
            final isLandscape = constraints.maxWidth > constraints.maxHeight;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: isTablet
                      ? _buildTabletLayout(
                          context,
                          theme,
                          colorScheme,
                          localizations,
                          authState,
                          isLandscape,
                        )
                      : _buildMobileLayout(
                          context,
                          theme,
                          colorScheme,
                          localizations,
                          authState,
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Mobile layout - single column
  Widget _buildMobileLayout(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations localizations,
    AsyncValue<AuthState> authState,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Spacer(flex: 2),
          _HeaderSection(theme: theme, colorScheme: colorScheme),
          const Spacer(),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: _LoginForm(
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
              obscurePassword: _obscurePassword,
              onTogglePassword: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              onLogin: _handleLogin,
              onThirdPartyLogin: _handleThirdPartyLogin,
              localizations: localizations,
              isLoading: _isLoading || authState.isLoading,
              ref: ref,
            ),
          ),
          const Spacer(flex: 2),
          _RegisterLink(
            localizations: localizations,
            onRegisterTap: () => context.push(Routes.register),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Tablet layout - two columns for landscape, centered for portrait
  Widget _buildTabletLayout(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations localizations,
    AsyncValue<AuthState> authState,
    bool isLandscape,
  ) {
    if (isLandscape) {
      // Two-column layout for landscape tablets
      return Row(
        children: [
          // Left side - branding
          Expanded(
            flex: 5,
            child: Container(
              color: colorScheme.primaryContainer,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: _HeaderSection(
                    theme: theme,
                    colorScheme: colorScheme,
                    isLarge: true,
                  ),
                ),
              ),
            ),
          ),
          // Right side - form
          Expanded(
            flex: 5,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(48),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: _LoginForm(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    obscurePassword: _obscurePassword,
                    onTogglePassword: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    onLogin: _handleLogin,
                    onThirdPartyLogin: _handleThirdPartyLogin,
                    localizations: localizations,
                    isLoading: _isLoading || authState.isLoading,
                    ref: ref,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Portrait tablet - centered layout with larger spacing
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        children: [
          const Spacer(flex: 2),
          _HeaderSection(theme: theme, colorScheme: colorScheme, isLarge: true),
          const Spacer(),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: _LoginForm(
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
              obscurePassword: _obscurePassword,
              onTogglePassword: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              onLogin: _handleLogin,
              onThirdPartyLogin: _handleThirdPartyLogin,
              localizations: localizations,
              isLoading: _isLoading || authState.isLoading,
              ref: ref,
            ),
          ),
          const Spacer(flex: 2),
          _RegisterLink(
            localizations: localizations,
            onRegisterTap: () => context.push(Routes.register),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ==================== Shared Widgets ====================

/// Header section with logo and title.
class _HeaderSection extends StatelessWidget {
  const _HeaderSection({
    required this.theme,
    required this.colorScheme,
    this.isLarge = false,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(isLarge ? 24 : 20),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.lock_open_rounded,
            size: isLarge ? 56 : 48,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        SizedBox(height: isLarge ? 24 : 20),
        Text(
          localizations.welcomeBack,
          style: (isLarge
                  ? theme.textTheme.headlineMedium
                  : theme.textTheme.headlineSmall)
              ?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          localizations.signInToContinue,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Login form widget.
class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onLogin,
    required this.onThirdPartyLogin,
    required this.localizations,
    required this.isLoading,
    required this.ref,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;
  final Future<void> Function(Future<bool> Function() loginFn)
      onThirdPartyLogin;
  final AppLocalizations localizations;
  final bool isLoading;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email field
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: localizations.email,
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return localizations.enterEmail;
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return localizations.enterValidEmail;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Password field
          TextFormField(
            controller: passwordController,
            obscureText: obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => onLogin(),
            decoration: InputDecoration(
              labelText: localizations.password,
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return localizations.enterPassword;
              }
              if (value.length < 6) {
                return localizations.passwordMinLength;
              }
              return null;
            },
          ),
          // Forgot password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed:
                  isLoading ? null : () => context.push(Routes.forgotPassword),
              child: Text(localizations.forgotPassword),
            ),
          ),
          const SizedBox(height: 8),
          // Login button
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: isLoading ? null : onLogin,
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
                      localizations.login,
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ),
          const SizedBox(height: 24),
          // Divider
          Row(
            children: [
              Expanded(child: Divider(color: colorScheme.outlineVariant)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  localizations.or,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(child: Divider(color: colorScheme.outlineVariant)),
            ],
          ),
          const SizedBox(height: 24),
          // Social login buttons
          _SocialLoginButton(
            icon: Icons.chat_rounded,
            label: localizations.continueWithWeChat,
            onPressed: isLoading
                ? null
                : () => onThirdPartyLogin(
                      () => ref
                          .read(authNotifierProvider.notifier)
                          .loginWithWeChat(),
                    ),
            backgroundColor: const Color(0xFF07C160),
          ),
          const SizedBox(height: 12),
          _SocialLoginButton(
            icon: Icons.apple,
            label: localizations.continueWithApple,
            onPressed: isLoading
                ? null
                : () => onThirdPartyLogin(
                      () => ref
                          .read(authNotifierProvider.notifier)
                          .loginWithApple(),
                    ),
            backgroundColor: Colors.black,
          ),
          const SizedBox(height: 12),
          _SocialLoginButton(
            icon: Icons.g_mobiledata_rounded,
            label: localizations.continueWithGoogle,
            onPressed: isLoading
                ? null
                : () => onThirdPartyLogin(
                      () => ref
                          .read(authNotifierProvider.notifier)
                          .loginWithGoogle(),
                    ),
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.onSurface,
            borderColor: colorScheme.outline,
          ),
        ],
      ),
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
    return SizedBox(
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          side: borderColor != null ? BorderSide(color: borderColor!) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: Icon(icon, size: 24),
        label: Text(label, style: const TextStyle(fontSize: 15)),
      ),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${localizations.noAccount} ',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        TextButton(
          onPressed: onRegisterTap,
          child: Text(localizations.register),
        ),
      ],
    );
  }
}
