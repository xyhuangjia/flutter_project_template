/// Application color constants.
///
/// This file defines the color palette used throughout the application.
/// Colors are defined as static constants for easy access.
///
/// Design Reference: Ant Design color system
/// Target Users: 50+ age group (high contrast, accessible)
library;

import 'package:flutter/material.dart';

/// Application colors class.
///
/// Contains all color constants used in the application.
/// Based on Ant Design design system with accessibility in mind.
abstract final class AppColors {
  // ============================================
  // Brand Colors (Ant Design Blue)
  // ============================================

  /// Primary brand color - Ant Design Blue (#1677FF)
  /// 科技感、专业、可信赖
  static const Color primary = Color(0xFF1677FF);

  /// Primary hover/pressed state
  static const Color primaryHover = Color(0xFF4096FF);

  /// Primary container for light backgrounds
  static const Color primaryContainer = Color(0xFFE6F4FF);

  /// Primary variant (darker shade)
  static const Color primaryVariant = Color(0xFF0958D9);

  // ============================================
  // Secondary Colors (Cyan for tech feel)
  // ============================================

  /// Secondary brand color - Cyan
  static const Color secondary = Color(0xFF13C2C2);

  /// Secondary variant
  static const Color secondaryVariant = Color(0xFF006D75);

  // ============================================
  // Semantic Colors
  // ============================================

  /// Success color - Green
  static const Color success = Color(0xFF52C41A);

  /// Success background
  static const Color successContainer = Color(0xFFF6FFED);

  /// Warning color - Gold
  static const Color warning = Color(0xFFFAAD14);

  /// Warning background
  static const Color warningContainer = Color(0xFFFFFBE6);

  /// Error color - Red
  static const Color error = Color(0xFFFF4D4F);

  /// Error background
  static const Color errorContainer = Color(0xFFFFF2F0);

  /// Info color - Blue (same as primary for consistency)
  static const Color info = Color(0xFF1677FF);

  /// Info background
  static const Color infoContainer = Color(0xFFE6F4FF);

  // ============================================
  // Background Colors
  // ============================================

  /// Background color for light theme
  static const Color background = Color(0xFFF5F5F5);

  /// Background color for dark theme
  static const Color backgroundDark = Color(0xFF141414);

  /// Surface color (cards, dialogs)
  static const Color surface = Color(0xFFFFFFFF);

  /// Surface color for dark theme
  static const Color surfaceDark = Color(0xFF1F1F1F);

  /// Surface container low (page background)
  static const Color surfaceContainerLow = Color(0xFFFAFAFA);

  /// Surface container low for dark theme
  static const Color surfaceContainerLowDark = Color(0xFF1A1A1A);

  // ============================================
  // Text Colors (High Contrast for Accessibility)
  // ============================================

  /// Primary text color - High contrast (#1F1F1F instead of #212121)
  static const Color textPrimary = Color(0xFF1F1F1F);

  /// Secondary text color
  static const Color textSecondary = Color(0xFF595959);

  /// Tertiary text color
  static const Color textTertiary = Color(0xFF8C8C8C);

  /// Text color for dark theme
  static const Color textPrimaryDark = Color(0xFFF0F0F0);

  /// Secondary text color for dark theme
  static const Color textSecondaryDark = Color(0xFFBFBFBF);

  /// Tertiary text color for dark theme
  static const Color textTertiaryDark = Color(0xFF8C8C8C);

  // ============================================
  // Border & Divider Colors
  // ============================================

  /// Divider color
  static const Color divider = Color(0xFFE8E8E8);

  /// Divider color for dark theme
  static const Color dividerDark = Color(0xFF303030);

  /// Border color
  static const Color border = Color(0xFFD9D9D9);

  /// Border color for dark theme
  static const Color borderDark = Color(0xFF424242);

  // ============================================
  // Dark Theme Colors
  // ============================================

  /// Primary color for dark theme
  static const Color primaryDark = Color(0xFF3C89FF);

  /// Primary container for dark theme
  static const Color primaryContainerDark = Color(0xFF1A3A5C);

  /// Error color for dark theme
  static const Color errorDark = Color(0xFFFF7875);

  /// Error container for dark theme
  static const Color errorContainerDark = Color(0xFF5C1A1A);

  /// Switch track color for dark theme (off state)
  static const Color switchTrackDark = Color(0xFF3A3A3A);

  // ============================================
  // Other Colors
  // ============================================

  /// Disabled color
  static const Color disabled = Color(0xFFBFBFBF);

  /// Disabled background
  static const Color disabledBackground = Color(0xFFF5F5F5);

  /// Shadow color
  static const Color shadow = Color(0x1A000000);

  /// Default ripple color
  static const Color defaultRippleColor = Color(0x1A1677FF);

  // ============================================
  // Icon Background Colors (for Chinese App Style)
  // ============================================

  /// Language icon background
  static const Color iconBgBlue = Color(0xFFE6F4FF);

  /// Theme icon background
  static const Color iconBgOrange = Color(0xFFFFF7ED);

  /// Notification icon background
  static const Color iconBgPink = Color(0xFFFFF0F6);

  /// AI icon background
  static const Color iconBgPurple = Color(0xFFF9F0FF);

  /// Info icon background
  static const Color iconBgCyan = Color(0xFFE6FFFB);

  /// Privacy icon background
  static const Color iconBgGreen = Color(0xFFF6FFED);

  /// Developer icon background
  static const Color iconBgGray = Color(0xFFF0F0F0);
}
