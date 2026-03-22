/// Change password screen with Chinese app style design.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_project_template/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_project_template/shared/widgets/dialog_util.dart';
import 'package:flutter_project_template/shared/widgets/settings_widgets.dart';
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
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text(localizations.changePassword),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Requirements card
            SectionTitle(
              title: localizations.passwordRequirements,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            SettingsCard(
              colorScheme: colorScheme,
              children: [
                _RequirementTile(
                  text: localizations.passwordMinLengthReq,
                  isMet: _newPasswordController.text.length >= 8,
                  colorScheme: colorScheme,
                ),
                SettingsDivider(colorScheme: colorScheme),
                _RequirementTile(
                  text: localizations.passwordComplexityReq,
                  isMet: _isPasswordValid(_newPasswordController.text),
                  colorScheme: colorScheme,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Form card
            SectionTitle(
              title: localizations.newPassword,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            SettingsCard(
              colorScheme: colorScheme,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Current password
                    _PasswordField(
                      controller: _currentPasswordController,
                      labelText: localizations.currentPassword,
                      obscureText: _obscureCurrentPassword,
                      onToggle: () {
                        setState(() {
                          _obscureCurrentPassword = !_obscureCurrentPassword;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // New password
                    _PasswordField(
                      controller: _newPasswordController,
                      labelText: localizations.newPassword,
                      obscureText: _obscureNewPassword,
                      onChanged: (_) => setState(() {}),
                      onToggle: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Confirm password
                    _PasswordField(
                      controller: _confirmPasswordController,
                      labelText: localizations.confirmPassword,
                      obscureText: _obscureConfirmPassword,
                      onToggle: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ],
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
}

/// Requirement tile widget.
class _RequirementTile extends StatelessWidget {
  const _RequirementTile({
    required this.text,
    required this.isMet,
    required this.colorScheme,
  });

  final String text;
  final bool isMet;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isMet
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isMet ? Icons.check : Icons.circle_outlined,
                size: 18,
                color:
                    isMet ? colorScheme.primary : colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isMet
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          ],
        ),
      );
}

/// Password field widget.
class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.labelText,
    required this.obscureText,
    required this.onToggle,
    this.onChanged,
  });

  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final VoidCallback onToggle;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
            onPressed: onToggle,
          ),
        ),
      );
}
