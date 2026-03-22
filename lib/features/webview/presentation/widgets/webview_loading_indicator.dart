/// WebView loading indicator widget.
library;

import 'package:flutter/material.dart';

/// WebView loading indicator widget.
///
/// Displays a linear progress indicator for WebView loading progress.
class WebViewLoadingIndicator extends StatelessWidget {
  /// Creates a loading indicator.
  const WebViewLoadingIndicator({
    required this.progress,
    super.key,
    this.height = 3.0,
  });

  /// The loading progress (0-100).
  final int progress;

  /// The height of the progress indicator.
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LinearProgressIndicator(
      value: progress / 100.0,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      valueColor: AlwaysStoppedAnimation<Color>(
        theme.colorScheme.primary,
      ),
      minHeight: height,
    );
  }
}
