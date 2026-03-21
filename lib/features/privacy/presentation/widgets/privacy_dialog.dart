/// Privacy dialog widget for showing privacy consent.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_template/core/router/routes.dart';
import 'package:flutter_project_template/features/privacy/data/models/region_config.dart';
import 'package:flutter_project_template/features/privacy/domain/entities/privacy_state.dart';
import 'package:flutter_project_template/features/privacy/presentation/providers/privacy_provider.dart';
import 'package:flutter_project_template/features/privacy/presentation/providers/region_provider.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Privacy consent dialog widget.
class PrivacyConsentDialog extends ConsumerWidget {
  /// Creates a privacy consent dialog.
  const PrivacyConsentDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final regionConfig = ref.watch(regionConfigProvider);
    final privacyState = ref.watch(privacyNotifierProvider);

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
              constraints: const BoxConstraints(maxWidth: 500, maxHeight: 650),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Header(theme: theme, localizations: localizations),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: _Content(
                        localizations: localizations,
                        regionConfig: regionConfig,
                      ),
                    ),
                  ),
                  _Actions(
                    ref: ref,
                    localizations: localizations,
                    privacyState: privacyState,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.theme, required this.localizations});

  final ThemeData theme;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shield_rounded,
              color: theme.colorScheme.onPrimaryContainer,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              localizations.privacyConsentTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.localizations,
    required this.regionConfig,
  });

  final AppLocalizations localizations;
  final RegionConfig regionConfig;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
              onTap: () => _openUrl(
                context,
                regionConfig.privacyPolicyUrl,
                localizations.privacyPolicy,
              ),
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
              onTap: () => _openUrl(
                context,
                regionConfig.termsOfServiceUrl,
                localizations.termsOfService,
              ),
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
      '${Routes.webView}?url=${Uri.encodeComponent(url)}'
      '&title=${Uri.encodeComponent(title)}',
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({
    required this.ref,
    required this.localizations,
    required this.privacyState,
  });

  final WidgetRef ref;
  final AppLocalizations localizations;
  final AsyncValue<PrivacyState> privacyState;

  @override
  Widget build(BuildContext context) {
    final isLoading = privacyState.isLoading;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      final success = await ref
                          .read(privacyNotifierProvider.notifier)
                          .saveConsent(hasConsented: true);

                      if (success && context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(localizations.agree),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: isLoading
                  ? null
                  : () => _showExitConfirmation(context, localizations),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(localizations.disagree),
            ),
          ),
        ],
      ),
    );
  }

  void _showExitConfirmation(BuildContext context, AppLocalizations loc) {
    final theme = Theme.of(context);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        icon: Icon(
          Icons.exit_to_app_rounded,
          size: 48,
          color: theme.colorScheme.error,
        ),
        title: Text(loc.privacyConsentExitTitle),
        content: Text(loc.privacyConsentExitMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(loc.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // Close the main consent dialog first, then exit
              Navigator.of(context).pop(false);
              _exitApp();
            },
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: Text(loc.confirm),
          ),
        ],
      ),
    );
  }

  /// Exits the app in a platform-appropriate way.
  void _exitApp() {
    if (Platform.isIOS) {
      // On iOS, exit(0) is the most reliable way to exit
      // ignore: avoid_slow_async_io
      exit(0);
    } else {
      // On Android and other platforms, use SystemNavigator
      SystemNavigator.pop();
    }
  }
}

/// Shows the privacy consent dialog.
Future<bool?> showPrivacyConsentDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const PrivacyConsentDialog(),
  );
}
