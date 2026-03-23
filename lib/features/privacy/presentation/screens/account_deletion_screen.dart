/// Account deletion screen for account deletion flow.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/theme/breakpoints.dart';
import 'package:flutter_project_template/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_project_template/features/privacy/presentation/providers/privacy_provider.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_project_template/shared/widgets/dialog_util.dart';
import 'package:flutter_project_template/shared/widgets/responsive_layout.dart';
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

    if (confirmed ?? false) {
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
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(
          context,
          localizations,
          theme,
          colorScheme,
        ),
        tabletLandscape: _buildTabletLandscapeLayout(
          context,
          localizations,
          theme,
          colorScheme,
        ),
        desktop: _buildTabletLandscapeLayout(
          context,
          localizations,
          theme,
          colorScheme,
        ),
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    AppLocalizations localizations,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final spacing = context.spacing;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;

        // 手机横屏使用分栏布局
        if (isLandscape) {
          return _buildLandscapeLayout(
            context,
            localizations,
            theme,
            colorScheme,
            spacing,
          );
        }

        // 手机竖屏使用单列布局
        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(spacing.pagePadding),
            child: ConstrainedContent(
              maxWidth: ContentConstraints.form,
              child: _buildFormContent(
                context,
                localizations,
                theme,
                colorScheme,
                spacing,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLandscapeLayout(
    BuildContext context,
    AppLocalizations localizations,
    ThemeData theme,
    ColorScheme colorScheme,
    ResponsiveSpacing spacing,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.pagePadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side: Data list card
            Expanded(
              child: ConstrainedContent(
                child: SettingsCard(
                  colorScheme: colorScheme,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(spacing.cardPadding),
                      child: Text(
                        localizations.dataToBeDeleted,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SettingsDivider(colorScheme: colorScheme),
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
              ),
            ),
            SizedBox(width: spacing.cardSpacing),
            // Right side: Confirmation and action
            Expanded(
              child: ConstrainedContent(
                maxWidth: ContentConstraints.form,
                alignment: Alignment.centerRight,
                child: _buildConfirmationSection(
                  context,
                  localizations,
                  theme,
                  colorScheme,
                  spacing,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLandscapeLayout(
    BuildContext context,
    AppLocalizations localizations,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return _buildLandscapeLayout(
      context,
      localizations,
      theme,
      colorScheme,
      context.spacing,
    );
  }

  Widget _buildFormContent(
    BuildContext context,
    AppLocalizations localizations,
    ThemeData theme,
    ColorScheme colorScheme,
    ResponsiveSpacing spacing,
  ) {
    return Form(
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
          SizedBox(height: spacing.cardSpacing),
          _buildConfirmationSection(
            context,
            localizations,
            theme,
            colorScheme,
            spacing,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildConfirmationSection(
    BuildContext context,
    AppLocalizations localizations,
    ThemeData theme,
    ColorScheme colorScheme,
    ResponsiveSpacing spacing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Confirmations
        SettingsCard(
          colorScheme: colorScheme,
          children: [
            CheckboxListTile(
              value: _confirmedFirst,
              onChanged: (v) => setState(() => _confirmedFirst = v ?? false),
              title: Text(
                localizations.accountDeletionConfirm1,
                style: theme.textTheme.bodyMedium,
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.symmetric(
                horizontal: spacing.cardPadding,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SettingsDivider(colorScheme: colorScheme),
            CheckboxListTile(
              value: _confirmedSecond,
              onChanged: (v) => setState(() => _confirmedSecond = v ?? false),
              title: Text(
                localizations.accountDeletionConfirm2,
                style: theme.textTheme.bodyMedium,
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.symmetric(
                horizontal: spacing.cardPadding,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.cardSpacing),

        // Password field
        SettingsCard(
          colorScheme: colorScheme,
          child: Padding(
            padding: EdgeInsets.all(spacing.cardPadding),
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
        SizedBox(height: spacing.cardSpacing),

        // Action button
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _isDeleting ? null : _showDeleteConfirmationDialog,
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
      ],
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
    final spacing = context.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.cardPadding,
        vertical: 12,
      ),
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
