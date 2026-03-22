/// Dialog utility widgets for the application.
///
/// This file provides reusable dialog components used across features.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';

class DialogUtil {
  DialogUtil._();

  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String? cancelText,
    String? confirmText,
    bool isDestructive = false,
  }) async {
    final l10n = AppLocalizations.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(cancelText ?? l10n?.cancel ?? 'Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: isDestructive
                ? FilledButton.styleFrom(
                    backgroundColor: Theme.of(ctx).colorScheme.error,
                  )
                : null,
            child: Text(confirmText ?? l10n?.confirm ?? 'Confirm'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static void showMessage(BuildContext context, String? msg) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _ToastDialog(message: msg ?? ''),
    );

    Future<void>.delayed(const Duration(milliseconds: 1500), () {
      // ignore: use_build_context_synchronously
      if (Navigator.canPop(context)) Navigator.pop(context);
    });
  }

  static Future<void> showSuccessDialog(
    BuildContext context,
    String message, {
    Duration duration = const Duration(milliseconds: 1200),
    Widget iconWidget = const Icon(Icons.check, color: Colors.white, size: 40),
  }) =>
      _showBaseDialog(
        context,
        message,
        iconWidget: iconWidget,
        duration: duration,
      );

  static Future<void> showInfoDialog(
    BuildContext context,
    String message, {
    Duration duration = const Duration(milliseconds: 1200),
    Widget iconWidget = const Icon(
      Icons.info_outline,
      color: Colors.white,
      size: 40,
    ),
  }) =>
      _showBaseDialog(
        context,
        message,
        iconWidget: iconWidget,
        duration: duration,
      );

  static Future<void> showErrorDialog(
    BuildContext context,
    String? message, {
    Duration duration = const Duration(milliseconds: 1200),
    Widget iconWidget = const Icon(
      Icons.close_outlined,
      color: Colors.white,
      size: 40,
    ),
  }) =>
      _showBaseDialog(
        context,
        message,
        iconWidget: iconWidget,
        duration: duration,
      );

  static void showLoadingDialog(BuildContext context, [String? message]) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _LoadingDialog(message: message),
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  static Future<void> _showBaseDialog(
    BuildContext context,
    String? message, {
    Duration duration = const Duration(milliseconds: 1200),
    Widget iconWidget = const Icon(
      Icons.info_outline,
      color: Colors.white,
      size: 40,
    ),
  }) async {
    final dialogFuture = showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _IconDialog(
        iconWidget: iconWidget,
        message: message ?? '',
      ),
    );
    await Future<void>.delayed(duration);
    // ignore: use_build_context_synchronously
    if (Navigator.canPop(context)) Navigator.pop(context);
    await dialogFuture;
  }
}

class _ToastDialog extends StatelessWidget {
  const _ToastDialog({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      );
}

class _LoadingDialog extends StatelessWidget {
  const _LoadingDialog({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: Colors.white),
                if (message != null && message!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    message!,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
}

class _IconDialog extends StatelessWidget {
  const _IconDialog({
    required this.iconWidget,
    required this.message,
  });

  final Widget iconWidget;
  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                iconWidget,
                const SizedBox(height: 6),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );
}
