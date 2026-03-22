/// WebView navigation controls widget.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';

/// WebView navigation controls widget.
///
/// Provides back, forward, and refresh buttons for WebView navigation.
class WebViewNavigationControls extends StatelessWidget {
  /// Creates navigation controls.
  const WebViewNavigationControls({
    required this.canGoBack,
    required this.canGoForward,
    required this.onBack,
    required this.onForward,
    required this.onRefresh,
    super.key,
    this.showRefresh = true,
  });

  /// Whether the WebView can go back.
  final bool canGoBack;

  /// Whether the WebView can go forward.
  final bool canGoForward;

  /// Callback when back button is pressed.
  final VoidCallback onBack;

  /// Callback when forward button is pressed.
  final VoidCallback onForward;

  /// Callback when refresh button is pressed.
  final VoidCallback onRefresh;

  /// Whether to show the refresh button.
  final bool showRefresh;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: canGoBack ? onBack : null,
          tooltip: localizations.back,
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: canGoForward ? onForward : null,
          tooltip: localizations.next,
        ),
        if (showRefresh)
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: onRefresh,
            tooltip: localizations.retry,
          ),
      ],
    );
  }
}
