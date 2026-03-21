/// Change password screen for updating user password.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_project_template/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_project_template/shared/widgets/dialog_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Change password screen widget.
class ChangePasswordScreen extends ConsumerStatefulWidget {
  /// Creates the change password screen.
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final localizations = AppLocalizations.of(context)!;

    // Validation
    if (_currentPasswordController.text.isEmpty) {
      _showError(localizations.enterPassword);
      return;
    }

    if (_newPasswordController.text.length < 8) {
      _showError(localizations.passwordMinLength8);
      return;
    }

    if (!_isPasswordValid(_newPasswordController.text)) {
      _showError(localizations.passwordStrength);
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showError(localizations.passwordsDoNotMatchError);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(authRepositoryProvider);
      final result = await repository.updatePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      if (!mounted) return;

      result.when(
        failure: (failure) {
          setState(() => _isLoading = false);
          unawaited(DialogUtil.showErrorDialog(context, failure.message));
        },
        success: (_) {
          setState(() => _isLoading = false);
          unawaited(
            DialogUtil.showSuccessDialog(
              context,
              localizations.saveSuccess,
            ).then((_) {
              if (mounted) context.pop();
            }),
          );
        },
      );
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      unawaited(DialogUtil.showErrorDialog(context, e.toString()));
    }
  }

  bool _isPasswordValid(String password) {
    if (password.length < 8) return false;
    final hasLetter = RegExp('[a-zA-Z]').hasMatch(password);
    final hasNumber = RegExp('[0-9]').hasMatch(password);
    return hasLetter && hasNumber;
  }

  void _showError(String message) {
    unawaited(DialogUtil.showErrorDialog(context, message));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.changePassword),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.passwordRequirements,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildRequirement(
              localizations.passwordMinLengthReq,
              _newPasswordController.text.length >= 8,
              colorScheme,
            ),
            const SizedBox(height: 8),
            _buildRequirement(
              localizations.passwordComplexityReq,
              _isPasswordValid(_newPasswordController.text),
              colorScheme,
            ),
            const SizedBox(height: 24),
            // Current password
            TextField(
              controller: _currentPasswordController,
              obscureText: _obscureCurrentPassword,
              decoration: InputDecoration(
                labelText: localizations.currentPassword,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureCurrentPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureCurrentPassword = !_obscureCurrentPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            // New password
            TextField(
              controller: _newPasswordController,
              obscureText: _obscureNewPassword,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: localizations.newPassword,
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNewPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Confirm password
            TextField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: localizations.confirmPassword,
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Submit button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isLoading ? null : _changePassword,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Text(localizations.save),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirement(
    String text,
    bool isMet,
    ColorScheme colorScheme,
  ) =>
      Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 20,
            color: isMet ? colorScheme.primary : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color:
                  isMet ? colorScheme.primary : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );
}
