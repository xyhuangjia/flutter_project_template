/// Settings screen for application settings.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/config/environment.dart';
import 'package:flutter_project_template/core/config/environment_provider.dart';
import 'package:flutter_project_template/core/providers/locale_provider.dart';
import 'package:flutter_project_template/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_project_template/features/settings/domain/entities/settings_entity.dart';
import 'package:flutter_project_template/features/settings/presentation/providers/settings_provider.dart';
import 'package:flutter_project_template/features/settings/presentation/widgets/environment_selector.dart';
import 'package:flutter_project_template/features/settings/presentation/widgets/language_selector.dart';
import 'package:flutter_project_template/features/settings/presentation/widgets/settings_tile.dart';
import 'package:flutter_project_template/features/settings/presentation/widgets/theme_selector.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_project_template/shared/widgets/dialog_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Settings screen widget.
class SettingsScreen extends ConsumerWidget {
  /// Creates the settings screen.
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(settingsNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    final localeAsync = ref.watch(localeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
      ),
      body: settingsAsync.when(
        data: (settings) => _buildContent(
          context,
          ref,
          localizations,
          theme,
          settings,
          authState.valueOrNull?.isAuthenticated ?? false,
          localeAsync.valueOrNull?.languageCode,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('${localizations.error}: $error'),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
    ThemeData theme,
    SettingsEntity settings,
    bool isAuthenticated,
    String? currentLanguageCode,
  ) {
    final showDeveloperOptions = ref.watch(showDeveloperOptionsProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preferences section
          SettingsSectionHeader(title: localizations.preferences),
          ThemeSelector(
            currentTheme: settings.themeMode,
            onThemeChanged: (mode) {
              ref.read(settingsNotifierProvider.notifier).updateThemeMode(mode);
            },
          ),
          const SettingsDivider(),
          LanguageSelector(
            currentLanguage: currentLanguageCode,
            onLanguageChanged: (code) {
              ref.read(settingsNotifierProvider.notifier).updateLanguage(code);
            },
            languages: const [
              LanguageOption(code: 'en', name: 'English'),
              LanguageOption(code: 'zh', name: '中文'),
            ],
          ),
          const SettingsDivider(),
          SettingsTile(
            title: localizations.notifications,
            leading: const Icon(Icons.notifications_outlined),
            trailing: Switch(
              value: settings.notificationsEnabled,
              onChanged: (value) {
                ref
                    .read(settingsNotifierProvider.notifier)
                    .updateNotifications(enabled: value);
              },
            ),
            showChevron: false,
          ),
          const SizedBox(height: 24),

          // AI section
          SettingsSectionHeader(title: localizations.aiAssistant),
          SettingsTile(
            title: localizations.aiConfiguration,
            leading: const Icon(Icons.smart_toy_outlined),
            onTap: () {
              context.push('/settings/ai-config');
            },
          ),
          const SizedBox(height: 24),

          // Security section (only if authenticated)
          if (isAuthenticated) ...[
            SettingsSectionHeader(title: localizations.security),
            SettingsTile(
              title: localizations.changePassword,
              leading: const Icon(Icons.lock_outline),
              onTap: () {
                // TODO: Navigate to change password screen
              },
            ),
            const SettingsDivider(),
            SettingsTile(
              title: localizations.logout,
              leading: Icon(
                Icons.logout,
                color: theme.colorScheme.error,
              ),
              titleColor: theme.colorScheme.error,
              onTap: () async {
                final success =
                    await ref.read(authNotifierProvider.notifier).logout();
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(localizations.success)),
                  );
                }
              },
            ),
            const SizedBox(height: 24),
          ],

          // About section
          SettingsSectionHeader(title: localizations.about),
          SettingsTile(
            title: localizations.aboutApp,
            leading: const Icon(Icons.info_outline),
            onTap: () {
              context.push('/about');
            },
          ),
          const SettingsDivider(),
          SettingsTile(
            title: localizations.privacySettings,
            leading: const Icon(Icons.privacy_tip_outlined),
            onTap: () {
              context.push('/privacy/settings');
            },
          ),
          const SizedBox(height: 24),

          // Developer options section (only in debug mode)
          if (showDeveloperOptions) ...[
            SettingsSectionHeader(title: localizations.developerOptions),
            SettingsTile(
              title: localizations.developerOptions,
              subtitle: localizations.currentEnvironment,
              leading: const Icon(Icons.developer_mode),
              onTap: () {
                context.push('/settings/developer-options');
              },
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  /// Shows a confirmation dialog when changing environment.
  void _showEnvironmentChangeDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
    EnvironmentType newEnvironment,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(localizations.restartRequired),
        content: Text(localizations.restartRequiredMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(localizations.restartLater),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();

              // Save the new environment
              await ref
                  .read(environmentProvider.notifier)
                  .switchEnvironment(newEnvironment);

              // Show a success dialog
              if (context.mounted) {
                DialogUtil.showSuccessDialog(
                  context,
                  localizations.saveSuccess,
                );
              }

              // In a real app, you would restart the app here
              // For example, using: SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            child: Text(localizations.restartNow),
          ),
        ],
      ),
    );
  }
}
