/// Application color constants.
///
/// This file defines the color palette used throughout the application.
/// Colors are defined as static constants for easy access.
library;

import 'package:flutter/material.dart';

/// Application colors class.
///
/// Contains all color constants used in the application.
abstract final class AppColors {
  /// Primary brand color.
  static const Color primary = Color(0xFF6200EE);

  /// Primary variant color.
  static const Color primaryVariant = Color(0xFF3700B3);

  /// Secondary brand color.
  static const Color secondary = Color(0xFF03DAC6);

  /// Secondary variant color.
  static const Color secondaryVariant = Color(0xFF018786);

  /// Background color for light theme.
  static const Color background = Color(0xFFFFFFFF);

  /// Background color for dark theme.
  static const Color backgroundDark = Color(0xFF121212);

  /// Surface color.
  static const Color surface = Color(0xFFFFFFFF);

  /// Surface color for dark theme.
  static const Color surfaceDark = Color(0xFF1E1E1E);

  /// Error color.
  static const Color error = Color(0xFFB00020);

  /// Success color.
  static const Color success = Color(0xFF4CAF50);

  /// Warning color.
  static const Color warning = Color(0xFFFF9800);

  /// Info color.
  static const Color info = Color(0xFF2196F3);

  /// Text color for light theme.
  static const Color textPrimary = Color(0xFF212121);

  /// Secondary text color.
  static const Color textSecondary = Color(0xFF757575);

  /// Text color for dark theme.
  static const Color textPrimaryDark = Color(0xFFFFFFFF);

  /// Secondary text color for dark theme.
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  /// Divider color.
  static const Color divider = Color(0xFFE0E0E0);

  /// Disabled color.
  static const Color disabled = Color(0xFF9E9E9E);

  /// Shadow color.
  static const Color shadow = Color(0x1F000000);

  static const Color defaultRippleColor = Color(0x0338686A);
}
