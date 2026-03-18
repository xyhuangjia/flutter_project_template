/// Login form widget for authentication.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';

/// Login form widget.
///
/// Provides email and password input fields for login.
class LoginForm extends StatefulWidget {
  /// Creates a login form.
  const LoginForm({
    super.key,
    required this.onEmailLogin,
    required this.onUsernameLogin,
    this.isLoading = false,
  });

  /// Callback when email login is submitted.
  final Future<bool> Function(String email, String password) onEmailLogin;

  /// Callback when username login is submitted.
  final Future<bool> Function(String username, String password) onUsernameLogin;

  /// Whether the form is in loading state.
  final bool isLoading;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrUsernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isEmailMode = true;

  @override
  void dispose() {
    _emailOrUsernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final value = _emailOrUsernameController.text.trim();
    final password = _passwordController.text;

    if (_isEmailMode) {
      await widget.onEmailLogin(value, password);
    } else {
      await widget.onUsernameLogin(value, password);
    }
  }

  String? _validateEmailOrUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email or username';
    }

    if (_isEmailMode) {
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        return 'Please enter a valid email';
      }
    } else {
      if (value.length < 3) {
        return 'Username must be at least 3 characters';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Toggle between email and username
          Row(
            children: [
              ChoiceChip(
                label: const Text('Email'),
                selected: _isEmailMode,
                onSelected: (selected) {
                  setState(() => _isEmailMode = true);
                },
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Username'),
                selected: !_isEmailMode,
                onSelected: (selected) {
                  setState(() => _isEmailMode = false);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Email or Username field
          TextFormField(
            controller: _emailOrUsernameController,
            keyboardType: _isEmailMode
                ? TextInputType.emailAddress
                : TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: _isEmailMode ? localizations.email : 'Username',
              prefixIcon: Icon(
                _isEmailMode ? Icons.email_outlined : Icons.person_outline,
              ),
              border: const OutlineInputBorder(),
            ),
            validator: _validateEmailOrUsername,
            enabled: !widget.isLoading,
          ),
          const SizedBox(height: 16),
          // Password field
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: localizations.password,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
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
            onFieldSubmitted: (_) => _handleSubmit(),
            enabled: !widget.isLoading,
          ),
          const SizedBox(height: 24),
          // Login button
          FilledButton(
            onPressed: widget.isLoading ? null : _handleSubmit,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: widget.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(localizations.login),
          ),
        ],
      ),
    );
  }
}
