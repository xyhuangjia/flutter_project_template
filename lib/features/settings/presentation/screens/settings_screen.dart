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
    final settingsAsync = ref.watch(settingsNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    final localeAsync = ref.watch(localeNotifierProvider);

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
          isAuthenticated: authState.valueOrNull?.isAuthenticated ?? false,
          currentLanguageCode: localeAsync.valueOrNull?.languageCode,
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
            _SettingsCard(
              colorScheme: colorScheme,
              children: [
                ThemeSelector(
                  currentTheme: settings.themeMode,
                  onThemeChanged: (mode) {
                    ref
                        .read(settingsNotifierProvider.notifier)
                        .updateThemeMode(mode);
                  },
                ),
                _SettingsDivider(colorScheme: colorScheme),
                LanguageSelector(
                  currentLanguage: currentLanguageCode,
                  onLanguageChanged: (code) {
                    ref
                        .read(settingsNotifierProvider.notifier)
                        .updateLanguage(code);
                  },
                  languages: const [
                    LanguageOption(code: 'en', name: 'English'),
                    LanguageOption(code: 'zh', name: '中文'),
                  ],
                ),
                _SettingsDivider(colorScheme: colorScheme),
                SettingsTile(
                  title: localizations.notifications,
                  icon: Icons.notifications_outlined,
                  iconColor: const Color(0xFFEC4899),
                  iconBgColor: const Color(0xFFFDF2F8),
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
              ],
            ),
            const SizedBox(height: 16),

            // AI section
            _SectionTitle(
              title: localizations.aiAssistant,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            _SettingsCard(
              colorScheme: colorScheme,
              children: [
                SettingsTile(
                  title: localizations.aiConfiguration,
                  icon: Icons.smart_toy_outlined,
                  iconColor: const Color(0xFF8B5CF6),
                  iconBgColor: const Color(0xFFF5F3FF),
                  onTap: () {
                    context.push('/settings/ai-config');
                  },
                ),
              ],
            ),

            // Security section (only if authenticated)
            if (isAuthenticated) ...[
              const SizedBox(height: 16),
              _SectionTitle(
                title: localizations.security,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 12),
              _SettingsCard(
                colorScheme: colorScheme,
                children: [
                  SettingsTile(
                    title: localizations.logout,
                    icon: Icons.logout,
                    iconColor: colorScheme.error,
                    iconBgColor: colorScheme.errorContainer,
                    titleColor: colorScheme.error,
                    onTap: () async {
                      final success = await ref
                          .read(authNotifierProvider.notifier)
                          .logout();
                      if (success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(localizations.success)),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],

            const SizedBox(height: 16),

            // About section
            _SectionTitle(
              title: localizations.about,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            _SettingsCard(
              colorScheme: colorScheme,
              children: [
                SettingsTile(
                  title: localizations.aboutApp,
                  icon: Icons.info_outline,
                  iconColor: const Color(0xFF0EA5E9),
                  iconBgColor: const Color(0xFFF0F9FF),
                  onTap: () {
                    context.push('/about');
                  },
                ),
                _SettingsDivider(colorScheme: colorScheme),
                SettingsTile(
                  title: localizations.privacySettings,
                  icon: Icons.privacy_tip_outlined,
                  iconColor: const Color(0xFF14B8A6),
                  iconBgColor: const Color(0xFFF0FDFA),
                  onTap: () {
                    context.push('/privacy/settings');
                  },
                ),
              ],
            ),

            // Developer options section (only in debug mode)
            if (showDeveloperOptions) ...[
              const SizedBox(height: 16),
              _SectionTitle(
                title: localizations.developerOptions,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 12),
              _SettingsCard(
                colorScheme: colorScheme,
                children: [
                  SettingsTile(
                    title: localizations.developerOptions,
                    subtitle: localizations.currentEnvironment,
                    icon: Icons.developer_mode,
                    iconColor: const Color(0xFF64748B),
                    iconBgColor: const Color(0xFFF1F5F9),
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

/// Section title widget with accent bar.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.colorScheme,
  });

  final String title;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      );
}

/// Settings card with rounded corners and shadow.
class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.colorScheme,
    required this.children,
  });

  final ColorScheme colorScheme;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      );
}

/// Settings divider widget.
class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider({
    required this.colorScheme,
  });

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 60),
        child: Divider(
          height: 1,
          color: colorScheme.surfaceContainerHighest,
        ),
      );
}
