/// Privacy consent screen for first launch.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_template/core/router/routes.dart';
import 'package:flutter_project_template/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_project_template/features/privacy/data/models/region_config.dart';
import 'package:flutter_project_template/features/privacy/presentation/providers/privacy_provider.dart';
import 'package:flutter_project_template/features/privacy/presentation/providers/region_provider.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Privacy consent screen shown on first launch.
class PrivacyConsentScreen extends ConsumerStatefulWidget {
  /// Creates a privacy consent screen.
  const PrivacyConsentScreen({super.key});

  @override
  ConsumerState<PrivacyConsentScreen> createState() =>
      _PrivacyConsentScreenState();
}

class _PrivacyConsentScreenState extends ConsumerState<PrivacyConsentScreen> {
  bool _dialogShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dialogShown) {
      _dialogShown = true;
      // Use addPostFrameCallback to show dialog after build is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showConsentDialog();
      });
    }
  }

  Future<void> _showConsentDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (dialogContext) => _PrivacyConsentDialog(
        ref: ref,
        localizations: AppLocalizations.of(context)!,
      ),
    );

    // Handle result after dialog closes
    // Note: If user disagrees, app will exit via SystemNavigator.pop()
    if (mounted && result == true) {
      _navigateAfterConsent();
    }
  }

  void _navigateAfterConsent() {
    final isAuthenticated =
        ref.read(authNotifierProvider.notifier).isAuthenticated;
    if (isAuthenticated) {
      context.go(Routes.chat);
    } else {
      context.go(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Simple background while dialog shows
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// Privacy consent dialog widget.
class _PrivacyConsentDialog extends StatelessWidget {
  const _PrivacyConsentDialog({
    required this.ref,
    required this.localizations,
  });

  final WidgetRef ref;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final regionConfig = ref.watch(regionConfigProvider);

    return PopScope(
      canPop: false,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.shield_rounded,
                            color: colorScheme.onPrimaryContainer,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            localizations.privacyConsentTitle,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Rich text with clickable links
                          _buildConsentText(
                            context,
                            theme,
                            colorScheme,
                            localizations,
                            regionConfig,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Actions
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () => _handleAgree(context),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(localizations.agree),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () => _handleDisagree(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(localizations.disagree),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleAgree(BuildContext context) async {
    final success = await ref
        .read(privacyNotifierProvider.notifier)
        .saveConsent(hasConsented: true);

    if (success && context.mounted) {
      // Close dialog with true result
      Navigator.of(context).pop(true);
    }
  }

  void _handleDisagree(BuildContext context) {
    final theme = Theme.of(context);

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        icon: Icon(
          Icons.exit_to_app_rounded,
          size: 48,
          color: theme.colorScheme.error,
        ),
        title: Text(localizations.privacyConsentExitTitle),
        content: Text(localizations.privacyConsentExitMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(localizations.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // Exit the app
              SystemNavigator.pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: Text(localizations.confirm),
          ),
        ],
      ),
    );
  }

  Widget _buildConsentText(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations localizations,
    RegionConfig regionConfig,
  ) {
    // Build rich text with clickable privacy policy and terms links
    return RichText(
      text: TextSpan(
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
          height: 1.6,
        ),
        children: [
          TextSpan(text: localizations.privacyConsentPart1),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GestureDetector(
              onTap: () => _openUrl(context, regionConfig.privacyPolicyUrl,
                  localizations.privacyPolicy),
              child: Text(
                localizations.privacyConsentLinkPrivacy,
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          TextSpan(text: localizations.privacyConsentPart2),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GestureDetector(
              onTap: () => _openUrl(context, regionConfig.termsOfServiceUrl,
                  localizations.termsOfService),
              child: Text(
                localizations.privacyConsentLinkTerms,
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          TextSpan(text: localizations.privacyConsentPart3),
        ],
      ),
    );
  }

  void _openUrl(BuildContext context, String url, String title) {
    context.push(
      '${Routes.webView}?url=${Uri.encodeComponent(url)}&title=${Uri.encodeComponent(title)}',
    );
  }
}
