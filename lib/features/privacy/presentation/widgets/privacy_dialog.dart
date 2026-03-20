/// Privacy dialog widget for showing privacy consent.
library;

import 'package:flutter/material.dart';
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Content(localizations: localizations),
                          const SizedBox(height: 24),
                          _Links(
                            localizations: localizations,
                            regionConfig: regionConfig,
                          ),
                        ],
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
  const _Content({required this.localizations});

  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.privacyConsentDescription,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  localizations.privacyConsentRequired,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Links extends StatelessWidget {
  const _Links({required this.localizations, required this.regionConfig});

  final AppLocalizations localizations;
  final RegionConfig regionConfig;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.privacyConsentReadMore,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        _LinkTile(
          icon: Icons.policy_rounded,
          title: localizations.privacyPolicy,
          url: regionConfig.privacyPolicyUrl,
        ),
        const SizedBox(height: 8),
        _LinkTile(
          icon: Icons.description_rounded,
          title: localizations.termsOfService,
          url: regionConfig.termsOfServiceUrl,
        ),
      ],
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.icon,
    required this.title,
    required this.url,
  });

  final IconData icon;
  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          context.push(
            '${Routes.webView}?url=${Uri.encodeComponent(url)}&title=${Uri.encodeComponent(title)}',
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.open_in_new_rounded,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
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
              Navigator.of(context).pop(false);
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
}

/// Shows the privacy consent dialog.
Future<bool?> showPrivacyConsentDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const PrivacyConsentDialog(),
  );
}
