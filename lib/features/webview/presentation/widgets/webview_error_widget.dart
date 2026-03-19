/// WebView error widget.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';

/// WebView error widget.
///
/// Displays an error message with retry button when WebView fails to load.
class WebViewErrorWidget extends StatelessWidget {
  /// Creates an error widget.
  const WebViewErrorWidget({
    super.key,
    this.errorCode,
    required this.errorMessage,
    required this.onRetry,
  });

  /// The error message to display.
  final String errorMessage;

  /// Callback when retry button is pressed.
  final VoidCallback onRetry;

  /// Optional error code.
  final int? errorCode;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              '${localizations.error}: $errorMessage',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            if (errorCode != null) ...[
              const SizedBox(height: 8),
              Text(
                '${localizations.error} Code: $errorCode',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(localizations.retry),
            ),
          ],
        ),
      ),
    );
  }
}
