/// BuildContext extension methods.
///
/// This file provides extension methods for BuildContext.
library;

import 'package:flutter/material.dart';

/// Extension methods for BuildContext.
extension ContextExtensions on BuildContext {
  /// Returns the current theme.
  ThemeData get theme => Theme.of(this);

  /// Returns the current text theme.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Returns the current color scheme.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Returns the media query.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Returns the screen size.
  Size get screenSize => mediaQuery.size;

  /// Returns the screen width.
  double get screenWidth => screenSize.width;

  /// Returns the screen height.
  double get screenHeight => screenSize.height;

  /// Returns the device pixel ratio.
  double get devicePixelRatio => mediaQuery.devicePixelRatio;

  /// Returns the padding.
  EdgeInsets get padding => mediaQuery.padding;

  /// Returns the view insets.
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// Returns the keyboard height.
  double get keyboardHeight => viewInsets.bottom;

  /// Returns true if the keyboard is visible.
  bool get isKeyboardVisible => viewInsets.bottom > 0;

  /// Returns true if the app is in dark mode.
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Returns the navigator state.
  NavigatorState get navigator => Navigator.of(this);

  /// Returns the scaffold messenger state.
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  /// Shows a snackbar.
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
      ),
    );
  }

  /// Hides the current snackbar.
  void hideSnackBar() {
    scaffoldMessenger.hideCurrentSnackBar();
  }

  /// Shows a dialog and returns the result.
  Future<T?> showAppDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) => child,
    );
  }

  /// Shows a modal bottom sheet and returns the result.
  Future<T?> showAppBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = false,
    bool isDismissible = true,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      backgroundColor: backgroundColor,
      builder: (context) => child,
    );
  }

  /// Focuses the next focus node.
  void focusNext() {
    FocusScope.of(this).nextFocus();
  }

  /// Focuses the previous focus node.
  void focusPrevious() {
    FocusScope.of(this).previousFocus();
  }

  /// Unfocuses the current focus node.
  void unfocus() {
    FocusScope.of(this).unfocus();
  }
}
