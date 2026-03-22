/// Account deletion screen for account deletion flow.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_project_template/features/privacy/presentation/providers/privacy_provider.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_project_template/shared/widgets/dialog_util.dart';
import 'package:flutter_project_template/shared/widgets/settings_widgets.dart';
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

  Future<void> _showDeleteConfirmationDialog() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_confirmedFirst || !_confirmedSecond) {
      _showSnackBar(AppLocalizations.of(context)!.pleaseConfirmAllCheckboxes);
      return;
    }

    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_rounded,
              color: colorScheme.error,
            ),
            const SizedBox(width: 8),
            Text(localizations.accountDeletionWarningTitle),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.accountDeletionWarningDescription,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              localizations.actionCannotBeUndone,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(localizations.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(localizations.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deleteAccount();
    }
  }

  Future<void> _deleteAccount() async {
    setState(() => _isDeleting = true);

    try {
      final success = await ref
          .read(privacyProvider.notifier)
          .deleteAccount(_passwordController.text);

      if (!mounted) return;

      if (success) {
        await Future.wait([
          ref.read(authProvider.notifier).logout(),
          ref.read(privacyProvider.notifier).clearPrivacyData(),
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
    DialogUtil.showMessage(context, message);
  }

  void _showErrorSnackBar(String message) {
    DialogUtil.showErrorDialog(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text(localizations.deleteAccount),
      ),
      body: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Data list
                  SettingsCard(
                    colorScheme: colorScheme,
                    children: [
                      _DataItem(
                        icon: Icons.person_rounded,
                        text: localizations.profileInformation,
                        colorScheme: colorScheme,
                      ),
                      SettingsDivider(colorScheme: colorScheme),
                      _DataItem(
                        icon: Icons.chat_rounded,
                        text: localizations.chatHistory,
                        colorScheme: colorScheme,
                      ),
                      SettingsDivider(colorScheme: colorScheme),
                      _DataItem(
                        icon: Icons.settings_rounded,
                        text: localizations.settingsAndPreferences,
                        colorScheme: colorScheme,
                      ),
                      SettingsDivider(colorScheme: colorScheme),
                      _DataItem(
                        icon: Icons.storage_rounded,
                        text: localizations.savedData,
                        colorScheme: colorScheme,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Confirmations
                  SettingsCard(
                    colorScheme: colorScheme,
                    children: [
                      CheckboxListTile(
                        value: _confirmedFirst,
                        onChanged: (v) =>
                            setState(() => _confirmedFirst = v ?? false),
                        title: Text(
                          localizations.accountDeletionConfirm1,
                          style: theme.textTheme.bodyMedium,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      SettingsDivider(colorScheme: colorScheme),
                      CheckboxListTile(
                        value: _confirmedSecond,
                        onChanged: (v) =>
                            setState(() => _confirmedSecond = v ?? false),
                        title: Text(
                          localizations.accountDeletionConfirm2,
                          style: theme.textTheme.bodyMedium,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  SettingsCard(
                    colorScheme: colorScheme,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: localizations.password,
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
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
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed:
                          _isDeleting ? null : _showDeleteConfirmationDialog,
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.error,
                        foregroundColor: colorScheme.onError,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: _isDeleting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.delete_forever_rounded),
                      label: Text(
                        _isDeleting
                            ? localizations.deleting
                            : localizations.deleteAccountPermanently,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== Shared Widgets ====================

class _DataItem extends StatelessWidget {
  const _DataItem({
    required this.icon,
    required this.text,
    required this.colorScheme,
  });

  final IconData icon;
  final String text;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: colorScheme.onSurfaceVariant,
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
            color: colorScheme.error,
          ),
        ],
      ),
    );
  }
}
