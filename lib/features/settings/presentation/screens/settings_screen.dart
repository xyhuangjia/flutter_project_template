/// Settings screen with Chinese app style design.
///
/// Features:
/// - Standard AppBar for navigation
/// - Card-based section grouping
/// - Icon with background color
/// - Rounded corners and shadow effects
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/config/environment_provider.dart';
import 'package:flutter_project_template/core/providers/locale_provider.dart';
import 'package:flutter_project_template/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_project_template/features/settings/domain/entities/settings_entity.dart';
import 'package:flutter_project_template/features/settings/presentation/providers/settings_provider.dart';
import 'package:flutter_project_template/features/settings/presentation/widgets/language_selector.dart';
import 'package:flutter_project_template/features/settings/presentation/widgets/settings_tile.dart';
import 'package:flutter_project_template/features/settings/presentation/widgets/theme_selector.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_project_template/shared/widgets/dialog_util.dart';
import 'package:flutter_project_template/shared/widgets/settings_widgets.dart';
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
    final colorScheme = theme.colorScheme;
    final settingsAsync = ref.watch(settingsProvider);
    final authState = ref.watch(authProvider);
    final localeAsync = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text(localizations.settings),
      ),
      body: settingsAsync.when(
        data: (settings) => _SettingsContent(
          localizations: localizations,
          theme: theme,
          colorScheme: colorScheme,
          settings: settings,
          isAuthenticated: authState.value?.isAuthenticated ?? false,
          currentLanguageCode: localeAsync.value?.languageCode,
          showDeveloperOptions: ref.watch(showDeveloperOptionsProvider),
          ref: ref,
        ),
        loading: () => _LoadingState(
          localizations: localizations,
          colorScheme: colorScheme,
        ),
        error: (error, stack) => _ErrorState(
          error: error,
          localizations: localizations,
          colorScheme: colorScheme,
        ),
      ),
    );
  }
}

/// Loading state widget.
class _LoadingState extends StatelessWidget {
  const _LoadingState({
    required this.localizations,
    required this.colorScheme,
  });

  final AppLocalizations localizations;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(localizations.loading),
          ],
        ),
      );
}

/// Error state widget.
class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.error,
    required this.localizations,
    required this.colorScheme,
  });

  final Object error;
  final AppLocalizations localizations;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                localizations.error,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}

/// Settings content widget with Chinese app style.
class _SettingsContent extends StatelessWidget {
  const _SettingsContent({
    required this.localizations,
    required this.theme,
    required this.colorScheme,
    required this.settings,
    required this.isAuthenticated,
    required this.currentLanguageCode,
    required this.showDeveloperOptions,
    required this.ref,
  });

  final AppLocalizations localizations;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final SettingsEntity settings;
  final bool isAuthenticated;
  final String? currentLanguageCode;
  final bool showDeveloperOptions;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preferences section
            SettingsCard(
              colorScheme: colorScheme,
              children: [
                ThemeSelector(
                  currentTheme: settings.themeMode,
                  onThemeChanged: (mode) {
                    ref.read(settingsProvider.notifier).updateThemeMode(mode);
                  },
                ),
                SettingsDivider(colorScheme: colorScheme),
                LanguageSelector(
                  currentLanguage: currentLanguageCode,
                  onLanguageChanged: (code) {
                    ref.read(settingsProvider.notifier).updateLanguage(code);
                  },
                  languages: [
                    LanguageOption(
                      code: 'en',
                      name: localizations.languageEnglish,
                    ),
                    LanguageOption(
                      code: 'zh',
                      name: localizations.languageChinese,
                    ),
                  ],
                ),
                SettingsDivider(colorScheme: colorScheme),
                SettingsTile(
                  title: localizations.accessibilityMode,
                  subtitle: localizations.accessibilityModeDescription,
                  icon: Icons.accessibility_new_outlined,
                  iconColor: const Color(0xFF52C41A),
                  iconBgColor: const Color(0xFFF6FFED),
                  trailing: Switch(
                    value: settings.isElderlyMode,
                    onChanged: (value) {
                      ref
                          .read(settingsProvider.notifier)
                          .updateAccessibilityMode(
                            value
                                ? AccessibilityMode.elderly
                                : AccessibilityMode.standard,
                          );
                    },
                  ),
                  showChevron: false,
                ),
                SettingsDivider(colorScheme: colorScheme),
                SettingsTile(
                  title: localizations.notifications,
                  icon: Icons.notifications_outlined,
                  iconColor: AppIconColors.notificationColor,
                  iconBgColor: AppIconColors.notificationBgColor,
                  trailing: Switch(
                    value: settings.notificationsEnabled,
                    onChanged: (value) {
                      ref
                          .read(settingsProvider.notifier)
                          .updateNotifications(enabled: value);
                    },
                  ),
                  showChevron: false,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Security section (only if authenticated)
            if (isAuthenticated) ...[
              const SizedBox(height: 16),
              SettingsCard(
                colorScheme: colorScheme,
                children: [
                  SettingsTile(
                    title: localizations.logout,
                    icon: Icons.logout,
                    iconColor: colorScheme.error,
                    iconBgColor: colorScheme.errorContainer,
                    titleColor: colorScheme.error,
                    onTap: () async {
                      final confirmed = await DialogUtil.showConfirmDialog(
                        context,
                        title: localizations.logout,
                        message: localizations.logoutConfirmMessage,
                        confirmText: localizations.confirm,
                        cancelText: localizations.cancel,
                        isDestructive: true,
                      );
                      if (!confirmed || !context.mounted) return;

                      final success =
                          await ref.read(authProvider.notifier).logout();
                      if (success && context.mounted) {
                        await DialogUtil.showSuccessDialog(
                          context,
                          localizations.success,
                        );
                      }
                    },
                  ),
                ],
              ),
            ],

            const SizedBox(height: 16),

            // About section
            SettingsCard(
              colorScheme: colorScheme,
              children: [
                SettingsTile(
                  title: localizations.aboutApp,
                  icon: Icons.info_outline,
                  iconColor: AppIconColors.infoColor,
                  iconBgColor: AppIconColors.infoBgColor,
                  onTap: () {
                    context.push('/about');
                  },
                ),
                SettingsDivider(colorScheme: colorScheme),
                SettingsTile(
                  title: localizations.privacySettings,
                  icon: Icons.privacy_tip_outlined,
                  iconColor: AppIconColors.privacyColor,
                  iconBgColor: AppIconColors.privacyBgColor,
                  onTap: () {
                    context.push('/privacy/settings');
                  },
                ),
              ],
            ),

            // Developer options section (only in debug mode)
            if (showDeveloperOptions) ...[
              const SizedBox(height: 16),
              SettingsCard(
                colorScheme: colorScheme,
                children: [
                  SettingsTile(
                    title: localizations.developerOptions,
                    subtitle: localizations.currentEnvironment,
                    icon: Icons.developer_mode,
                    iconColor: AppIconColors.developerColor,
                    iconBgColor: AppIconColors.developerBgColor,
                    onTap: () {
                      context.push('/settings/developer-options');
                    },
                  ),
                ],
              ),
            ],

            // Bottom padding for safe area
            const SizedBox(height: 32),
          ],
        ),
      );
}
