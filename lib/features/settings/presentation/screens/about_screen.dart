/// About screen displaying app information and legal links.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/router/routes.dart';
import 'package:flutter_project_template/features/settings/presentation/widgets/settings_tile.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
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
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
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
      pathParameters: {'title': title, 'url': url},
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.about),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  _buildAppIcon(theme),
                  const SizedBox(height: 16),
                  _buildAppInfo(localizations, theme),
                  const SizedBox(height: 24),
                  SettingsSectionHeader(title: localizations.legal),
                  SettingsTile(
                    title: localizations.privacyPolicy,
                    leading: const Icon(Icons.privacy_tip_outlined),
                    onTap: () => _navigateToWebView(
                      localizations.privacyPolicy,
                      'https://example.com/privacy',
                    ),
                  ),
                  const SettingsDivider(),
                  SettingsTile(
                    title: localizations.termsOfService,
                    leading: const Icon(Icons.description_outlined),
                    onTap: () => _navigateToWebView(
                      localizations.termsOfService,
                      'https://example.com/terms',
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildIcpInfo(theme, localizations),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAppIcon(ThemeData theme) => Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: theme.colorScheme.primaryContainer,
        ),
        child: Icon(
          Icons.flutter_dash,
          size: 60,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      );

  Widget _buildAppInfo(AppLocalizations localizations, ThemeData theme) =>
      Column(
        children: [
          Text(
            _packageInfo?.appName ?? localizations.appTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${localizations.version}: ${_packageInfo?.version ?? '1.0.0'}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${localizations.buildDate}: $_buildDate',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );

  Widget _buildIcpInfo(ThemeData theme, AppLocalizations localizations) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            InkWell(
              onTap: _launchBeianUrl,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.language,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
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
          ],
        ),
      );
}
