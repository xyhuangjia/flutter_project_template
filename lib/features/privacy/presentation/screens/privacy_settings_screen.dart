/// Privacy settings screen for managing privacy preferences.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/router/routes.dart';
import 'package:flutter_project_template/features/privacy/data/models/region_config.dart';
import 'package:flutter_project_template/features/privacy/domain/entities/privacy_state.dart';
import 'package:flutter_project_template/features/privacy/presentation/providers/privacy_provider.dart';
import 'package:flutter_project_template/features/privacy/presentation/providers/region_provider.dart';
import 'package:flutter_project_template/features/privacy/presentation/widgets/permission_card.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.privacySettings),
        centerTitle: true,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use wider layout for tablets
        final isTablet = constraints.maxWidth > 600;
        final contentWidth = isTablet ? 600.0 : constraints.maxWidth;

        return Center(
          child: SizedBox(
            width: contentWidth,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                // Legal documents section
                _SectionHeader(title: localizations.legalDocuments),
                _PolicyCard(
                  icon: Icons.policy_rounded,
                  title: localizations.privacyPolicy,
                  subtitle: regionConfig.complianceStandard,
                  url: regionConfig.privacyPolicyUrl,
                ),
                _PolicyCard(
                  icon: Icons.description_rounded,
                  title: localizations.termsOfService,
                  subtitle: localizations.termsOfServiceSubtitle,
                  url: regionConfig.termsOfServiceUrl,
                ),
                const SizedBox(height: 16),

                // Data preferences section
                _SectionHeader(title: localizations.dataPreferences),
                _ToggleCard(
                  icon: Icons.storage_rounded,
                  title: localizations.dataCollection,
                  subtitle: localizations.dataCollectionDescription,
                  value: state.dataCollectionEnabled,
                  onChanged: (value) {
                    ref
                        .read(privacyNotifierProvider.notifier)
                        .updateDataCollection(value);
                  },
                ),
                _ToggleCard(
                  icon: Icons.analytics_rounded,
                  title: localizations.analytics,
                  subtitle: localizations.analyticsDescription,
                  value: state.analyticsEnabled,
                  onChanged: (value) {
                    ref
                        .read(privacyNotifierProvider.notifier)
                        .updateAnalytics(value);
                  },
                ),
                const SizedBox(height: 16),

                // Permissions section
                _SectionHeader(title: localizations.appPermissions),
                _PermissionCard(
                  icon: Icons.camera_alt_rounded,
                  title: localizations.camera,
                  permissionType: PermissionType.camera,
                ),
                _PermissionCard(
                  icon: Icons.photo_library_rounded,
                  title: localizations.photoLibrary,
                  permissionType: PermissionType.photoLibrary,
                ),
                _PermissionCard(
                  icon: Icons.location_on_rounded,
                  title: localizations.location,
                  permissionType: PermissionType.location,
                ),
                _PermissionCard(
                  icon: Icons.notifications_rounded,
                  title: localizations.notifications,
                  permissionType: PermissionType.notification,
                ),
                const SizedBox(height: 16),

                // Region section
                _SectionHeader(title: localizations.regionSettings),
                _RegionCard(
                  region: state.region,
                  onTap: () =>
                      _showRegionDialog(context, ref, localizations, state),
                ),
                const SizedBox(height: 16),

                // Account section
                _SectionHeader(title: localizations.account),
                _DeleteAccountCard(
                  onTap: () => context.push(Routes.accountDeletion),
                ),
                const SizedBox(height: 16),

                // Consent info
                if (state.hasConsented) ...[
                  const SizedBox(height: 8),
                  _ConsentInfoCard(state: state),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
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

// ==================== Shared Widgets ====================

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}

class _PolicyCard extends StatelessWidget {
  const _PolicyCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.url,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String url;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 24,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall,
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      onTap: () {
        context.push(
          '${Routes.webView}?url=${Uri.encodeComponent(url)}&title=${Uri.encodeComponent(title)}',
        );
      },
    );
  }
}

class _ToggleCard extends StatelessWidget {
  const _ToggleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: value
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 24,
          color: value
              ? theme.colorScheme.onPrimaryContainer
              : theme.colorScheme.onSurfaceVariant,
        ),
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall,
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.permissionType,
  });

  final IconData icon;
  final String title;
  final PermissionType permissionType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 24,
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
      title: Text(title),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      onTap: () async {
        final isGranted = await PermissionHelper.isGranted(permissionType);
        if (context.mounted) {
          if (isGranted) {
            _showPermissionGrantedDialog(context);
          } else {
            // Use go_router for navigation
            context
                .push<bool>(
              '${Routes.permissionRationale}?type=${permissionType.name}',
            )
                .then((granted) {
              if (context.mounted && granted == true) {
                _showPermissionGrantedDialog(context);
              }
            });
          }
        }
      },
    );
  }

  void _showPermissionGrantedDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations.permissionAlreadyGranted),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _RegionCard extends StatelessWidget {
  const _RegionCard({
    required this.region,
    required this.onTap,
  });

  final MarketRegion region;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.public_rounded,
          size: 24,
          color: theme.colorScheme.onTertiaryContainer,
        ),
      ),
      title: Text(localizations.marketRegion),
      subtitle: Text(
        region == MarketRegion.china
            ? '${localizations.regionChina} (PIPL)'
            : '${localizations.regionInternational} (GDPR)',
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}

class _DeleteAccountCard extends StatelessWidget {
  const _DeleteAccountCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.delete_forever_rounded,
          size: 24,
          color: theme.colorScheme.onErrorContainer,
        ),
      ),
      title: Text(
        localizations.deleteAccount,
        style: TextStyle(color: theme.colorScheme.error),
      ),
      subtitle: Text(
        localizations.deleteAccountSubtitle,
        style: theme.textTheme.bodySmall,
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: theme.colorScheme.error,
      ),
      onTap: onTap,
    );
  }
}

class _ConsentInfoCard extends StatelessWidget {
  const _ConsentInfoCard({required this.state});

  final PrivacyState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified_user_rounded,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.privacyConsentStatus,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  localizations.privacyConsentDate(
                    state.consentedAt?.toString().split('.').first ?? '',
                  ),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
