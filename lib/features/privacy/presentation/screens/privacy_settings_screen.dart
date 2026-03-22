/// Privacy settings screen for managing privacy preferences.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/router/routes.dart';
import 'package:flutter_project_template/features/privacy/data/models/region_config.dart';
import 'package:flutter_project_template/features/privacy/domain/entities/privacy_state.dart';
import 'package:flutter_project_template/features/privacy/presentation/providers/privacy_provider.dart';
import 'package:flutter_project_template/features/privacy/presentation/providers/region_provider.dart';
import 'package:flutter_project_template/features/privacy/presentation/widgets/permission_card.dart';
import 'package:flutter_project_template/features/settings/presentation/widgets/settings_tile.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_project_template/shared/widgets/dialog_util.dart';
import 'package:flutter_project_template/shared/widgets/settings_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Privacy settings screen for managing privacy preferences.
class PrivacySettingsScreen extends ConsumerWidget {
  /// Creates a privacy settings screen.
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final privacyState = ref.watch(privacyNotifierProvider);
    final regionConfig = ref.watch(regionConfigProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text(localizations.privacySettings),
      ),
      body: privacyState.when(
        data: (state) =>
            _buildContent(context, ref, localizations, state, regionConfig),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            _buildErrorState(context, localizations, error),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    AppLocalizations localizations,
    Object error,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              '${localizations.error}: $error',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
    PrivacyState state,
    RegionConfig regionConfig,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Legal documents section
          SettingsCard(
            colorScheme: colorScheme,
            children: [
              SettingsTile(
                title: localizations.privacyPolicy,
                subtitle: regionConfig.complianceStandard,
                icon: Icons.policy_rounded,
                iconColor: AppIconColors.privacyColor,
                iconBgColor: AppIconColors.privacyBgColor,
                onTap: () => _openWebView(
                  context,
                  localizations.privacyPolicy,
                  regionConfig.privacyPolicyUrl,
                ),
              ),
              SettingsDivider(colorScheme: colorScheme),
              SettingsTile(
                title: localizations.termsOfService,
                subtitle: localizations.termsOfServiceSubtitle,
                icon: Icons.description_rounded,
                iconColor: AppIconColors.infoColor,
                iconBgColor: AppIconColors.infoBgColor,
                onTap: () => _openWebView(
                  context,
                  localizations.termsOfService,
                  regionConfig.termsOfServiceUrl,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Data preferences section
          SettingsCard(
            colorScheme: colorScheme,
            children: [
              SettingsTile(
                title: localizations.dataCollection,
                subtitle: localizations.dataCollectionDescription,
                icon: Icons.storage_rounded,
                iconColor: AppIconColors.storageColor,
                iconBgColor: AppIconColors.storageBgColor,
                trailing: Switch(
                  value: state.dataCollectionEnabled,
                  onChanged: (value) {
                    ref
                        .read(privacyNotifierProvider.notifier)
                        .updateDataCollection(value);
                  },
                ),
                showChevron: false,
              ),
              SettingsDivider(colorScheme: colorScheme),
              SettingsTile(
                title: localizations.analytics,
                subtitle: localizations.analyticsDescription,
                icon: Icons.analytics_rounded,
                iconColor: AppIconColors.analyticsColor,
                iconBgColor: AppIconColors.analyticsBgColor,
                trailing: Switch(
                  value: state.analyticsEnabled,
                  onChanged: (value) {
                    ref
                        .read(privacyNotifierProvider.notifier)
                        .updateAnalytics(value);
                  },
                ),
                showChevron: false,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Permissions section
          SettingsCard(
            colorScheme: colorScheme,
            children: [
              SettingsTile(
                title: localizations.camera,
                icon: Icons.camera_alt_rounded,
                iconColor: AppIconColors.cameraColor,
                iconBgColor: AppIconColors.cameraBgColor,
                onTap: () => _handlePermission(
                  context,
                  PermissionType.camera,
                ),
              ),
              SettingsDivider(colorScheme: colorScheme),
              SettingsTile(
                title: localizations.photoLibrary,
                icon: Icons.photo_library_rounded,
                iconColor: AppIconColors.photoColor,
                iconBgColor: AppIconColors.photoBgColor,
                onTap: () => _handlePermission(
                  context,
                  PermissionType.photoLibrary,
                ),
              ),
              SettingsDivider(colorScheme: colorScheme),
              SettingsTile(
                title: localizations.location,
                icon: Icons.location_on_rounded,
                iconColor: AppIconColors.locationColor,
                iconBgColor: AppIconColors.locationBgColor,
                onTap: () => _handlePermission(
                  context,
                  PermissionType.location,
                ),
              ),
              SettingsDivider(colorScheme: colorScheme),
              SettingsTile(
                title: localizations.notifications,
                icon: Icons.notifications_rounded,
                iconColor: AppIconColors.notificationColor,
                iconBgColor: AppIconColors.notificationBgColor,
                onTap: () => _handlePermission(
                  context,
                  PermissionType.notification,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Region section
          SettingsCard(
            colorScheme: colorScheme,
            children: [
              SettingsTile(
                title: localizations.marketRegion,
                subtitle: state.region == MarketRegion.china
                    ? '${localizations.regionChina} (PIPL)'
                    : '${localizations.regionInternational} (GDPR)',
                icon: Icons.public_rounded,
                iconColor: AppIconColors.regionColor,
                iconBgColor: AppIconColors.regionBgColor,
                onTap: () => _showRegionDialog(
                  context,
                  ref,
                  localizations,
                  state,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Account section
          SettingsCard(
            colorScheme: colorScheme,
            children: [
              SettingsTile(
                title: localizations.deleteAccount,
                subtitle: localizations.deleteAccountSubtitle,
                icon: Icons.delete_forever_rounded,
                iconColor: colorScheme.error,
                iconBgColor: colorScheme.errorContainer,
                titleColor: colorScheme.error,
                onTap: () => context.push(Routes.accountDeletion),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _openWebView(BuildContext context, String title, String url) {
    context.push(
      '${Routes.webView}?url=${Uri.encodeComponent(url)}&title=${Uri.encodeComponent(title)}',
    );
  }

  Future<void> _handlePermission(
    BuildContext context,
    PermissionType permissionType,
  ) async {
    final isGranted = await PermissionHelper.isGranted(permissionType);
    if (context.mounted) {
      if (isGranted) {
        _showPermissionGrantedDialog(context);
      } else {
        final granted = await context.push<bool>(
          '${Routes.permissionRationale}?type=${permissionType.name}',
        );
        if (context.mounted && granted == true) {
          _showPermissionGrantedDialog(context);
        }
      }
    }
  }

  void _showPermissionGrantedDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    DialogUtil.showSuccessDialog(context, localizations.permissionAlreadyGranted);
  }

  void _showRegionDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
    PrivacyState state,
  ) {
    final theme = Theme.of(context);

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Text(
                        localizations.selectRegion,
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Options
                ...MarketRegion.values.map((region) {
                  return ListTile(
                    leading: Radio<MarketRegion>(
                      value: region,
                      groupValue: state.region,
                      onChanged: (value) {
                        if (value != null) {
                          ref
                              .read(privacyNotifierProvider.notifier)
                              .updateRegion(value);
                          Navigator.of(sheetContext).pop();
                        }
                      },
                    ),
                    title: Text(_getRegionName(localizations, region)),
                    subtitle: Text(
                      region == MarketRegion.china
                          ? 'PIPL 合规'
                          : 'GDPR Compliant',
                    ),
                    trailing: state.region == region
                        ? Icon(
                            Icons.check_circle,
                            color: theme.colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      ref
                          .read(privacyNotifierProvider.notifier)
                          .updateRegion(region);
                      Navigator.of(sheetContext).pop();
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getRegionName(AppLocalizations localizations, MarketRegion region) {
    return switch (region) {
      MarketRegion.china => localizations.regionChina,
      MarketRegion.international => localizations.regionInternational,
    };
  }
}