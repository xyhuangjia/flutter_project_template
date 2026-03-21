/// Developer options screen for advanced settings.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/config/environment.dart';
import 'package:flutter_project_template/core/config/environment_provider.dart';
import 'package:flutter_project_template/features/settings/domain/entities/developer_options.dart' as dev;
import 'package:flutter_project_template/features/settings/presentation/providers/developer_options_provider.dart';
import 'package:flutter_project_template/features/settings/presentation/widgets/settings_tile.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_project_template/shared/widgets/dialog_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Developer options screen widget.
class DeveloperOptionsScreen extends ConsumerWidget {
  /// Creates the developer options screen.
  const DeveloperOptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final optionsAsync = ref.watch(developerOptionsNotifierProvider);
    final currentEnv = ref.watch(environmentProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.developerOptions),
      ),
      body: optionsAsync.when(
        data: (options) => _buildContent(
          context,
          ref,
          localizations,
          theme,
          options,
          currentEnv,
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
    dev.DeveloperOptions options,
    EnvironmentConfig currentEnv,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Environment section
          SettingsSectionHeader(title: localizations.environmentSection),
          _buildEnvironmentTile(
            context,
            ref,
            localizations,
            theme,
            currentEnv,
          ),
          const SettingsDivider(),
          SettingsTile(
            title: localizations.customApiUrl,
            subtitle: options.customApiBaseUrl ?? localizations.useDefault,
            leading: const Icon(Icons.dns_outlined),
            onTap: () => _showApiUrlDialog(
              context,
              ref,
              localizations,
              options.customApiBaseUrl,
            ),
          ),
          const SizedBox(height: 24),

          // Logging section
          SettingsSectionHeader(title: localizations.loggingSection),
          SettingsTile(
            title: localizations.enableLogging,
            leading: const Icon(Icons.article_outlined),
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
          const SettingsDivider(),
          SettingsTile(
            title: localizations.logLevel,
            subtitle: _getLogLevelName(options.logLevel, localizations),
            leading: const Icon(Icons.filter_list),
            onTap: () => _showLogLevelDialog(
              context,
              ref,
              localizations,
              options.logLevel,
            ),
          ),
          const SizedBox(height: 24),

          // Debug tools section
          SettingsSectionHeader(title: localizations.debugTools),
          SettingsTile(
            title: localizations.networkLogging,
            subtitle: localizations.networkLoggingDescription,
            leading: const Icon(Icons.network_check),
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
          const SettingsDivider(),
          SettingsTile(
            title: localizations.performanceMonitor,
            subtitle: localizations.performanceMonitorDescription,
            leading: const Icon(Icons.speed),
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
          const SettingsDivider(),
          SettingsTile(
            title: localizations.showDebugInfo,
            subtitle: localizations.showDebugInfoDescription,
            leading: const Icon(Icons.info_outline),
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
          const SizedBox(height: 24),

          // Cache & Data section
          SettingsSectionHeader(title: localizations.cacheAndData),
          SettingsTile(
            title: localizations.clearCache,
            subtitle: localizations.clearCacheDescription,
            leading: const Icon(Icons.cleaning_services_outlined),
            onTap: () => _confirmClearCache(context, ref, localizations),
          ),
          const SettingsDivider(),
          SettingsTile(
            title: localizations.clearDatabase,
            subtitle: localizations.clearDatabaseDescription,
            leading: Icon(
              Icons.delete_forever_outlined,
              color: theme.colorScheme.error,
            ),
            titleColor: theme.colorScheme.error,
            onTap: () => _confirmClearDatabase(context, ref, localizations, theme),
          ),
          const SizedBox(height: 24),

          // Reset section
          SettingsSectionHeader(title: localizations.resetOptions),
          SettingsTile(
            title: localizations.resetToDefaults,
            subtitle: localizations.resetToDefaultsDescription,
            leading: const Icon(Icons.restore),
            onTap: () => _confirmResetToDefaults(context, ref, localizations),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildEnvironmentTile(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
    ThemeData theme,
    EnvironmentConfig currentEnv,
  ) {
    return SettingsTile(
      title: localizations.currentEnvironment,
      subtitle: _getEnvironmentName(currentEnv.type, localizations),
      leading: const Icon(Icons.cloud_outlined),
      onTap: () => _showEnvironmentDialog(
        context,
        ref,
        localizations,
        currentEnv.type,
      ),
    );
  }

  String _getEnvironmentName(EnvironmentType type, AppLocalizations localizations) {
    return switch (type) {
      EnvironmentType.development => localizations.environmentDevelopment,
      EnvironmentType.staging => localizations.environmentStaging,
      EnvironmentType.production => localizations.environmentProduction,
    };
  }

  String _getLogLevelName(dev.LogLevel level, AppLocalizations localizations) {
    return switch (level) {
      dev.LogLevel.debug => localizations.logLevelDebug,
      dev.LogLevel.info => localizations.logLevelInfo,
      dev.LogLevel.warning => localizations.logLevelWarning,
      dev.LogLevel.error => localizations.logLevelError,
      dev.LogLevel.none => localizations.logLevelNone,
    };
  }

  void _showEnvironmentDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
    EnvironmentType currentType,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(localizations.selectEnvironment),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEnvironmentOption(
              dialogContext,
              ref,
              localizations,
              EnvironmentType.development,
              currentType,
            ),
            _buildEnvironmentOption(
              dialogContext,
              ref,
              localizations,
              EnvironmentType.staging,
              currentType,
            ),
            _buildEnvironmentOption(
              dialogContext,
              ref,
              localizations,
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
    AppLocalizations localizations,
    EnvironmentType type,
    EnvironmentType currentType,
  ) {
    final isSelected = type == currentType;
    return RadioListTile<EnvironmentType>(
      title: Text(_getEnvironmentName(type, localizations)),
      value: type,
      groupValue: currentType,
      selected: isSelected,
      onChanged: (value) {
        Navigator.of(context).pop();
        if (value != null && value != currentType) {
          _showEnvironmentChangeDialog(context, ref, localizations, value);
        }
      },
    );
  }

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
              await ref
                  .read(environmentProvider.notifier)
                  .switchEnvironment(newEnvironment);
              if (context.mounted) {
                DialogUtil.showSuccessDialog(
                  context,
                  localizations.saveSuccess,
                );
              }
            },
            child: Text(localizations.restartNow),
          ),
        ],
      ),
    );
  }

  void _showApiUrlDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
    String? currentUrl,
  ) {
    final controller = TextEditingController(text: currentUrl ?? '');
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(localizations.customApiUrl),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: localizations.apiBaseUrlHint,
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.url,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await ref
                  .read(developerOptionsNotifierProvider.notifier)
                  .updateCustomApiBaseUrl(null);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localizations.saveSuccess)),
                );
              }
            },
            child: Text(localizations.resetToDefault),
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
                    SnackBar(content: Text(localizations.saveSuccess)),
                  );
                }
              }
            },
            child: Text(localizations.save),
          ),
        ],
      ),
    );
  }

  void _showLogLevelDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
    dev.LogLevel currentLevel,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(localizations.logLevel),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: dev.LogLevel.values.map((level) {
            return RadioListTile<dev.LogLevel>(
              title: Text(_getLogLevelName(level, localizations)),
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
    AppLocalizations localizations,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(localizations.clearCache),
        content: Text(localizations.clearCacheConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(localizations.cancel),
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
                      success
                          ? localizations.cacheCleared
                          : localizations.operationFailed,
                    ),
                  ),
                );
              }
            },
            child: Text(localizations.confirm),
          ),
        ],
      ),
    );
  }

  void _confirmClearDatabase(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
    ThemeData theme,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          localizations.clearDatabase,
          style: TextStyle(color: theme.colorScheme.error),
        ),
        content: Text(localizations.clearDatabaseConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(localizations.cancel),
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
                      success
                          ? localizations.databaseCleared
                          : localizations.operationFailed,
                    ),
                  ),
                );
              }
            },
            child: Text(localizations.confirm),
          ),
        ],
      ),
    );
  }

  void _confirmResetToDefaults(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(localizations.resetToDefaults),
        content: Text(localizations.resetToDefaultsConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(localizations.cancel),
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
                      success
                          ? localizations.optionsReset
                          : localizations.operationFailed,
                    ),
                  ),
                );
              }
            },
            child: Text(localizations.confirm),
          ),
        ],
      ),
    );
  }
}