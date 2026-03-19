import 'package:flutter/material.dart';

class DialogUtil {
  static void showMessage(BuildContext context, String? msg) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Center(
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
              msg ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );

    Future<void>.delayed(const Duration(milliseconds: 1500), () {
      if (Navigator.canPop(context)) Navigator.pop(context);
    });
  }

  static Future<void> showSuccessDialog(
    BuildContext context,
    String message, {
    Duration duration = const Duration(milliseconds: 1200),
    Widget iconWidget = const Icon(Icons.check, color: Colors.white, size: 40),
  }) =>
      _showBaseDialog(context, message,
          iconWidget: iconWidget, duration: duration);

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
      _showBaseDialog(context, message,
          iconWidget: iconWidget, duration: duration);

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
      _showBaseDialog(context, message,
          iconWidget: iconWidget, duration: duration);

  static void showLoadingDialog(BuildContext context, [String? message]) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Center(
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
                if (message != null && message.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
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
      builder: (ctx) => Center(
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
                  message ?? '',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await Future<void>.delayed(duration);
    if (Navigator.canPop(context)) Navigator.pop(context);
    await dialogFuture;
  }
}
