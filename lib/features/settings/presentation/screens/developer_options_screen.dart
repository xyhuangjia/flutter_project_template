/// Developer options screen with Chinese app style design.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/config/environment.dart';
import 'package:flutter_project_template/core/config/environment_provider.dart';
import 'package:flutter_project_template/features/settings/domain/entities/developer_options.dart'
    as dev;
import 'package:flutter_project_template/features/settings/presentation/providers/developer_options_provider.dart';
import 'package:flutter_project_template/features/settings/presentation/widgets/settings_tile.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_project_template/shared/widgets/dialog_util.dart';
import 'package:flutter_project_template/shared/widgets/settings_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Developer options screen widget.
class DeveloperOptionsScreen extends ConsumerWidget {
  /// Creates the developer options screen.
  const DeveloperOptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final optionsAsync = ref.watch(developerOptionsNotifierProvider);
    final currentEnv = ref.watch(environmentProvider);

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text(localizations.developerOptions),
      ),
      body: optionsAsync.when(
        data: (options) => _DeveloperOptionsContent(
          localizations: localizations,
          theme: theme,
          colorScheme: colorScheme,
          options: options,
          currentEnv: currentEnv,
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

/// Developer options content widget.
class _DeveloperOptionsContent extends StatelessWidget {
  const _DeveloperOptionsContent({
    required this.localizations,
    required this.theme,
    required this.colorScheme,
    required this.options,
    required this.currentEnv,
    required this.ref,
  });

  final AppLocalizations localizations;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final dev.DeveloperOptions options;
  final EnvironmentConfig currentEnv;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Environment section
            SectionTitle(
              title: localizations.environmentSection,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            SettingsCard(
              colorScheme: colorScheme,
              children: [
                SettingsTile(
                  title: localizations.currentEnvironment,
                  subtitle: _getEnvironmentName(
                    currentEnv.type,
                    localizations,
                  ),
                  icon: Icons.cloud_outlined,
                  iconColor: AppIconColors.infoColor,
                  iconBgColor: AppIconColors.infoBgColor,
                  onTap: () => _showEnvironmentDialog(
                    context,
                    ref,
                    localizations,
                    currentEnv.type,
                  ),
                ),
                SettingsDivider(colorScheme: colorScheme),
                SettingsTile(
                  title: localizations.customApiUrl,
                  subtitle:
                      options.customApiBaseUrl ?? localizations.useDefault,
                  icon: Icons.dns_outlined,
                  iconColor: AppIconColors.aiColor,
                  iconBgColor: AppIconColors.aiBgColor,
                  onTap: () => _showApiUrlDialog(
                    context,
                    ref,
                    localizations,
                    options.customApiBaseUrl,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Logging section
            SectionTitle(
              title: localizations.loggingSection,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            SettingsCard(
              colorScheme: colorScheme,
              children: [
                SettingsTile(
                  title: localizations.enableLogging,
                  icon: Icons.article_outlined,
                  iconColor: AppIconColors.loggingColor,
                  iconBgColor: AppIconColors.loggingBgColor,
                  trailing: Switch(
                    value: options.loggingEnabled,
                    onChanged: (value) {
                      ref
                          .read(developerOptionsNotifierProvider.notifier)
                          .updateLoggingEnabled(value);
                    },
                  ),
                  showChevron: false,
                ),
                SettingsDivider(colorScheme: colorScheme),
                SettingsTile(
                  title: localizations.logLevel,
                  subtitle: _getLogLevelName(
                    options.logLevel,
                    localizations,
                  ),
                  icon: Icons.filter_list,
                  iconColor: AppIconColors.themeColor,
                  iconBgColor: AppIconColors.themeBgColor,
                  onTap: () => _showLogLevelDialog(
                    context,
                    ref,
                    localizations,
                    options.logLevel,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Debug tools section
            SectionTitle(
              title: localizations.debugTools,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            SettingsCard(
              colorScheme: colorScheme,
              children: [
                SettingsTile(
                  title: localizations.networkLogging,
                  subtitle: localizations.networkLoggingDescription,
                  icon: Icons.network_check,
                  iconColor: AppIconColors.networkColor,
                  iconBgColor: AppIconColors.networkBgColor,
                  trailing: Switch(
                    value: options.networkLogEnabled,
                    onChanged: (value) {
                      ref
                          .read(developerOptionsNotifierProvider.notifier)
                          .updateNetworkLogEnabled(value);
                    },
                  ),
                  showChevron: false,
                ),
                SettingsDivider(colorScheme: colorScheme),
                SettingsTile(
                  title: localizations.performanceMonitor,
                  subtitle: localizations.performanceMonitorDescription,
                  icon: Icons.speed,
                  iconColor: AppIconColors.performanceColor,
                  iconBgColor: AppIconColors.performanceBgColor,
                  trailing: Switch(
                    value: options.performanceMonitorEnabled,
                    onChanged: (value) {
                      ref
                          .read(developerOptionsNotifierProvider.notifier)
                          .updatePerformanceMonitorEnabled(value);
                    },
                  ),
                  showChevron: false,
                ),
                SettingsDivider(colorScheme: colorScheme),
                SettingsTile(
                  title: localizations.showDebugInfo,
                  subtitle: localizations.showDebugInfoDescription,
                  icon: Icons.info_outline,
                  iconColor: AppIconColors.developerColor,
                  iconBgColor: AppIconColors.developerBgColor,
                  trailing: Switch(
                    value: options.showDebugInfo,
                    onChanged: (value) {
                      ref
                          .read(developerOptionsNotifierProvider.notifier)
                          .updateShowDebugInfo(value);
                    },
                  ),
                  showChevron: false,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Cache & Data section
            SectionTitle(
              title: localizations.cacheAndData,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            SettingsCard(
              colorScheme: colorScheme,
              children: [
                SettingsTile(
                  title: localizations.clearCache,
                  subtitle: localizations.clearCacheDescription,
                  icon: Icons.cleaning_services_outlined,
                  iconColor: AppIconColors.loggingColor,
                  iconBgColor: AppIconColors.loggingBgColor,
                  onTap: () => _confirmClearCache(context, ref, localizations),
                ),
                SettingsDivider(colorScheme: colorScheme),
                SettingsTile(
                  title: localizations.clearDatabase,
                  subtitle: localizations.clearDatabaseDescription,
                  icon: Icons.delete_forever_outlined,
                  iconColor: colorScheme.error,
                  iconBgColor: colorScheme.errorContainer,
                  titleColor: colorScheme.error,
                  onTap: () => _confirmClearDatabase(
                    context,
                    ref,
                    localizations,
                    theme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Reset section
            SectionTitle(
              title: localizations.resetOptions,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            SettingsCard(
              colorScheme: colorScheme,
              children: [
                SettingsTile(
                  title: localizations.resetToDefaults,
                  subtitle: localizations.resetToDefaultsDescription,
                  icon: Icons.restore,
                  iconColor: AppIconColors.infoColor,
                  iconBgColor: AppIconColors.infoBgColor,
                  onTap: () =>
                      _confirmResetToDefaults(context, ref, localizations),
                ),
              ],
            ),

            // Bottom padding
            const SizedBox(height: 32),
          ],
        ),
      );

  String _getEnvironmentName(
    EnvironmentType type,
    AppLocalizations loc,
  ) =>
      switch (type) {
        EnvironmentType.development => loc.environmentDevelopment,
        EnvironmentType.staging => loc.environmentStaging,
        EnvironmentType.production => loc.environmentProduction,
      };

  String _getLogLevelName(dev.LogLevel level, AppLocalizations loc) =>
      switch (level) {
        dev.LogLevel.debug => loc.logLevelDebug,
        dev.LogLevel.info => loc.logLevelInfo,
        dev.LogLevel.warning => loc.logLevelWarning,
        dev.LogLevel.error => loc.logLevelError,
        dev.LogLevel.none => loc.logLevelNone,
      };

  void _showEnvironmentDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations loc,
    EnvironmentType currentType,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(loc.selectEnvironment),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEnvironmentOption(
              dialogContext,
              ref,
              loc,
              EnvironmentType.development,
              currentType,
            ),
            _buildEnvironmentOption(
              dialogContext,
              ref,
              loc,
              EnvironmentType.staging,
              currentType,
            ),
            _buildEnvironmentOption(
              dialogContext,
              ref,
              loc,
              EnvironmentType.production,
              currentType,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnvironmentOption(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations loc,
    EnvironmentType type,
    EnvironmentType currentType,
  ) {
    final isSelected = type == currentType;
    return RadioListTile<EnvironmentType>(
      title: Text(_getEnvironmentName(type, loc)),
      value: type,
      groupValue: currentType,
      selected: isSelected,
      onChanged: (value) {
        Navigator.of(context).pop();
        if (value != null && value != currentType) {
          _showEnvironmentChangeDialog(context, ref, loc, value);
        }
      },
    );
  }

  void _showEnvironmentChangeDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations loc,
    EnvironmentType newEnvironment,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(loc.restartRequired),
        content: Text(loc.restartRequiredMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(loc.restartLater),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await ref
                  .read(environmentProvider.notifier)
                  .switchEnvironment(newEnvironment);
              if (context.mounted) {
                DialogUtil.showSuccessDialog(
                  context,
                  loc.saveSuccess,
                );
              }
            },
            child: Text(loc.restartNow),
          ),
        ],
      ),
    );
  }

  void _showApiUrlDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations loc,
    String? currentUrl,
  ) {
    final controller = TextEditingController(text: currentUrl ?? '');
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(loc.customApiUrl),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: loc.apiBaseUrlHint,
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.url,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(loc.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await ref
                  .read(developerOptionsNotifierProvider.notifier)
                  .updateCustomApiBaseUrl(null);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loc.saveSuccess)),
                );
              }
            },
            child: Text(loc.resetToDefault),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final url = controller.text.trim();
              if (url.isNotEmpty) {
                await ref
                    .read(developerOptionsNotifierProvider.notifier)
                    .updateCustomApiBaseUrl(url);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.saveSuccess)),
                  );
                }
              }
            },
            child: Text(loc.save),
          ),
        ],
      ),
    );
  }

  void _showLogLevelDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations loc,
    dev.LogLevel currentLevel,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(loc.logLevel),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: dev.LogLevel.values.map((level) {
            return RadioListTile<dev.LogLevel>(
              title: Text(_getLogLevelName(level, loc)),
              value: level,
              groupValue: currentLevel,
              selected: level == currentLevel,
              onChanged: (value) {
                Navigator.of(dialogContext).pop();
                if (value != null) {
                  ref
                      .read(developerOptionsNotifierProvider.notifier)
                      .updateLogLevel(value);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _confirmClearCache(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations loc,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(loc.clearCache),
        content: Text(loc.clearCacheConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(loc.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final success = await ref
                  .read(developerOptionsNotifierProvider.notifier)
                  .clearCache();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? loc.cacheCleared : loc.operationFailed,
                    ),
                  ),
                );
              }
            },
            child: Text(loc.confirm),
          ),
        ],
      ),
    );
  }

  void _confirmClearDatabase(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations loc,
    ThemeData theme,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          loc.clearDatabase,
          style: TextStyle(color: theme.colorScheme.error),
        ),
        content: Text(loc.clearDatabaseConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(loc.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final success = await ref
                  .read(developerOptionsNotifierProvider.notifier)
                  .clearDatabase();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? loc.databaseCleared : loc.operationFailed,
                    ),
                  ),
                );
              }
            },
            child: Text(loc.confirm),
          ),
        ],
      ),
    );
  }

  void _confirmResetToDefaults(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations loc,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(loc.resetToDefaults),
        content: Text(loc.resetToDefaultsConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(loc.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final success = await ref
                  .read(developerOptionsNotifierProvider.notifier)
                  .resetToDefaults();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? loc.optionsReset : loc.operationFailed,
                    ),
                  ),
                );
              }
            },
            child: Text(loc.confirm),
          ),
        ],
      ),
    );
  }
}
