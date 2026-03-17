/// Shared widgets for the application.
///
/// This file provides reusable widgets used across features.
library;

import 'package:flutter/material.dart';

/// Loading indicator widget.
class LoadingIndicator extends StatelessWidget {
  /// Creates a loading indicator.
  const LoadingIndicator({
    super.key,
    this.size = 24.0,
    this.color,
  });

  /// The size of the indicator.
  final double size;

  /// The color of the indicator.
  final Color? color;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).colorScheme.primary,
          ),
        ),
      );
}

/// Error display widget.
class ErrorDisplay extends StatelessWidget {
  /// Creates an error display.
  const ErrorDisplay({
    super.key,
    required this.message,
    this.onRetry,
  });

  /// The error message to display.
  final String message;

  /// Optional retry callback.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Retry'),
                ),
              ],
            ],
          ),
        ),
      );
}

/// Empty state widget.
class EmptyStateWidget extends StatelessWidget {
  /// Creates an empty state widget.
  const EmptyStateWidget({
    super.key,
    required this.message,
    this.icon,
    this.action,
  });

  /// The message to display.
  final String message;

  /// Optional icon to display.
  final IconData? icon;

  /// Optional action button.
  final Widget? action;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 16),
              ],
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (action != null) ...[
                const SizedBox(height: 24),
                action!,
              ],
            ],
          ),
        ),
      );
}
