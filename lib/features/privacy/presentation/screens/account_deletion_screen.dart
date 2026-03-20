/// Account deletion screen for account deletion flow.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_project_template/features/privacy/presentation/providers/privacy_provider.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Account deletion screen for deleting user account.
class AccountDeletionScreen extends ConsumerStatefulWidget {
  /// Creates an account deletion screen.
  const AccountDeletionScreen({super.key});

  @override
  ConsumerState<AccountDeletionScreen> createState() =>
      _AccountDeletionScreenState();
}

class _AccountDeletionScreenState extends ConsumerState<AccountDeletionScreen> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isDeleting = false;
  bool _confirmedFirst = false;
  bool _confirmedSecond = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _deleteAccount() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_confirmedFirst || !_confirmedSecond) {
      _showSnackBar(AppLocalizations.of(context)!.pleaseConfirmAllCheckboxes);
      return;
    }

    setState(() => _isDeleting = true);

    try {
      final success = await ref
          .read(privacyNotifierProvider.notifier)
          .deleteAccount(_passwordController.text);

      if (!mounted) return;

      if (success) {
        await Future.wait([
          ref.read(authNotifierProvider.notifier).logout(),
          ref.read(privacyNotifierProvider.notifier).clearPrivacyData(),
        ]);

        _showSnackBar(AppLocalizations.of(context)!.accountDeletedSuccess);
        context.go('/login');
      } else {
        _showErrorSnackBar(AppLocalizations.of(context)!.accountDeletedFailed);
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.deleteAccount),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Warning banner
                        _WarningBanner(localizations: localizations),
                        const SizedBox(height: 24),

                        // Description
                        Text(
                          localizations.accountDeletionWarningDescription,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Data list
                        _DataToDeleteCard(localizations: localizations),
                        const SizedBox(height: 24),

                        // Confirmations
                        _ConfirmationCheckboxes(
                          localizations: localizations,
                          theme: theme,
                          confirmedFirst: _confirmedFirst,
                          confirmedSecond: _confirmedSecond,
                          onChangedFirst: (v) =>
                              setState(() => _confirmedFirst = v ?? false),
                          onChangedSecond: (v) =>
                              setState(() => _confirmedSecond = v ?? false),
                        ),
                        const SizedBox(height: 24),

                        // Password field
                        _PasswordField(
                          controller: _passwordController,
                          obscurePassword: _obscurePassword,
                          localizations: localizations,
                          onToggleVisibility: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Action buttons
                        _ActionButtons(
                          localizations: localizations,
                          isDeleting: _isDeleting,
                          onDelete: _deleteAccount,
                          onCancel: () => context.pop(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== Shared Widgets ====================

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.localizations});

  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_rounded,
              color: colorScheme.onErrorContainer,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.accountDeletionWarningTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onErrorContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  localizations.actionCannotBeUndone,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onErrorContainer.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DataToDeleteCard extends StatelessWidget {
  const _DataToDeleteCard({required this.localizations});

  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.delete_sweep_rounded,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                localizations.dataToBeDeleted,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _DataItem(
              icon: Icons.person_rounded,
              text: localizations.profileInformation),
          _DataItem(icon: Icons.chat_rounded, text: localizations.chatHistory),
          _DataItem(
              icon: Icons.settings_rounded,
              text: localizations.settingsAndPreferences),
          _DataItem(icon: Icons.storage_rounded, text: localizations.savedData),
        ],
      ),
    );
  }
}

class _DataItem extends StatelessWidget {
  const _DataItem({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Icon(
            Icons.close_rounded,
            size: 18,
            color: theme.colorScheme.error,
          ),
        ],
      ),
    );
  }
}

class _ConfirmationCheckboxes extends StatelessWidget {
  const _ConfirmationCheckboxes({
    required this.localizations,
    required this.theme,
    required this.confirmedFirst,
    required this.confirmedSecond,
    required this.onChangedFirst,
    required this.onChangedSecond,
  });

  final AppLocalizations localizations;
  final ThemeData theme;
  final bool confirmedFirst;
  final bool confirmedSecond;
  final ValueChanged<bool?> onChangedFirst;
  final ValueChanged<bool?> onChangedSecond;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CheckboxListTile(
            value: confirmedFirst,
            onChanged: onChangedFirst,
            title: Text(
              localizations.accountDeletionConfirm1,
              style: theme.textTheme.bodyMedium,
            ),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const Divider(height: 1),
          CheckboxListTile(
            value: confirmedSecond,
            onChanged: onChangedSecond,
            title: Text(
              localizations.accountDeletionConfirm2,
              style: theme.textTheme.bodyMedium,
            ),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.obscurePassword,
    required this.localizations,
    required this.onToggleVisibility,
  });

  final TextEditingController controller;
  final bool obscurePassword;
  final AppLocalizations localizations;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscurePassword,
      decoration: InputDecoration(
        labelText: localizations.password,
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          icon: Icon(
            obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: onToggleVisibility,
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
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.localizations,
    required this.isDeleting,
    required this.onDelete,
    required this.onCancel,
  });

  final AppLocalizations localizations;
  final bool isDeleting;
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: isDeleting ? null : onDelete,
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: isDeleting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.delete_forever_rounded),
            label: Text(
              isDeleting
                  ? localizations.deleting
                  : localizations.deleteAccountPermanently,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: isDeleting ? null : onCancel,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(localizations.cancel),
          ),
        ),
      ],
    );
  }
}
