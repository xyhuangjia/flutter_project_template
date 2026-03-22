/// About screen with Chinese app style design.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/router/routes.dart';
import 'package:flutter_project_template/features/settings/presentation/widgets/settings_tile.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_project_template/shared/widgets/settings_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// About screen widget.
class AboutScreen extends StatefulWidget {
  /// Creates the about screen.
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  PackageInfo? _packageInfo;
  String _buildDate = '';

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _packageInfo = info;
        _buildDate = _getBuildDate();
      });
    }
  }

  String _getBuildDate() {
    // Note: In production, this should read from a build config file
    // or be injected at build time. For now, we use a placeholder.
    return '2024-01-01';
  }

  Future<void> _launchBeianUrl() async {
    final uri = Uri.parse('https://beian.miit.gov.cn/');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _navigateToWebView(String title, String url) {
    context.pushNamed(
      RouteNames.webView,
      queryParameters: {'title': title, 'url': url},
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text(localizations.about),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Main content - fills available space
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App info card - full width
                    _AppInfoCard(
                      packageInfo: _packageInfo,
                      buildDate: _buildDate,
                      localizations: localizations,
                      theme: theme,
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(height: 16),

                    // Legal links (no title)
                    SettingsCard(
                      colorScheme: colorScheme,
                      children: [
                        SettingsTile(
                          title: localizations.privacyPolicy,
                          icon: Icons.privacy_tip_outlined,
                          iconColor: AppIconColors.privacyColor,
                          iconBgColor: AppIconColors.privacyBgColor,
                          onTap: () => _navigateToWebView(
                            localizations.privacyPolicy,
                            'https://example.com/privacy',
                          ),
                        ),
                        SettingsDivider(colorScheme: colorScheme),
                        SettingsTile(
                          title: localizations.termsOfService,
                          icon: Icons.description_outlined,
                          iconColor: AppIconColors.infoColor,
                          iconBgColor: AppIconColors.infoBgColor,
                          onTap: () => _navigateToWebView(
                            localizations.termsOfService,
                            'https://example.com/terms',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Footer - fixed at bottom
            _Footer(
              theme: theme,
              localizations: localizations,
              onBeianTap: _launchBeianUrl,
            ),
          ],
        ),
      ),
    );
  }
}

/// App info card with icon and version - fills width.
class _AppInfoCard extends StatelessWidget {
  const _AppInfoCard({
    required this.packageInfo,
    required this.buildDate,
    required this.localizations,
    required this.theme,
    required this.colorScheme,
  });

  final PackageInfo? packageInfo;
  final String buildDate;
  final AppLocalizations localizations;
  final ThemeData theme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
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
          children: [
            // App icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: colorScheme.primaryContainer,
              ),
              child: Icon(
                Icons.flutter_dash,
                size: 48,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 16),

            // App name
            Text(
              packageInfo?.appName ?? localizations.appTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Version
            Text(
              '${localizations.version}: ${packageInfo?.version ?? '1.0.0'}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),

            // Build date
            Text(
              '${localizations.buildDate}: $buildDate',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
}

/// Footer widget with ICP and D&B info - fixed at bottom.
class _Footer extends StatelessWidget {
  const _Footer({
    required this.theme,
    required this.localizations,
    required this.onBeianTap,
  });

  final ThemeData theme;
  final AppLocalizations localizations;
  final VoidCallback onBeianTap;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ICP info
            InkWell(
              onTap: onBeianTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.language,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      localizations.icpNumber,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // D&B info (邓白氏信息)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  localizations.dunsNumber,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
