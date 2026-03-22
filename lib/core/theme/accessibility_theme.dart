/// Accessibility theme extensions for elderly-friendly mode.
///
/// Provides larger fonts, icons, and touch targets for elderly users.
library;

import 'dart:ui';

import 'package:flutter/material.dart';

/// Accessibility theme data that scales text and icons.
class AccessibilityTheme extends ThemeExtension<AccessibilityTheme> {
  /// Creates accessibility theme data.
  const AccessibilityTheme({
    required this.scaleFactor,
    required this.isElderlyMode,
  });

  /// Default accessibility theme (standard mode).
  const AccessibilityTheme.standard()
      : scaleFactor = 1.0,
        isElderlyMode = false;

  /// Elderly-friendly accessibility theme.
  const AccessibilityTheme.elderly()
      : scaleFactor = 1.2,
        isElderlyMode = true;

  /// The scale factor applied to fonts and icons.
  final double scaleFactor;

  /// Whether elderly mode is enabled.
  final bool isElderlyMode;

  /// Scaled font sizes for elderly users.
  double get fontSizeScale => scaleFactor;

  /// Scaled icon sizes.
  double get iconScale => scaleFactor;

  // ============================================
  // Scaled Font Sizes
  // ============================================

  /// Display large (32 → 38.4)
  double get displayLarge => 32 * scaleFactor;

  /// Display medium (28 → 33.6)
  double get displayMedium => 28 * scaleFactor;

  /// Display small (24 → 28.8)
  double get displaySmall => 24 * scaleFactor;

  /// Headline large (22 → 26.4)
  double get headlineLarge => 22 * scaleFactor;

  /// Headline medium (20 → 24)
  double get headlineMedium => 20 * scaleFactor;

  /// Headline small (18 → 21.6)
  double get headlineSmall => 18 * scaleFactor;

  /// Title large (18 → 21.6)
  double get titleLarge => 18 * scaleFactor;

  /// Title medium (16 → 19.2)
  double get titleMedium => 16 * scaleFactor;

  /// Title small (14 → 16.8)
  double get titleSmall => 14 * scaleFactor;

  /// Body large (16 → 19.2)
  double get bodyLarge => 16 * scaleFactor;

  /// Body medium (14 → 16.8)
  double get bodyMedium => 14 * scaleFactor;

  /// Body small (12 → 14.4)
  double get bodySmall => 12 * scaleFactor;

  /// Label large (14 → 16.8)
  double get labelLarge => 14 * scaleFactor;

  /// Label medium (12 → 14.4)
  double get labelMedium => 12 * scaleFactor;

  /// Label small (11 → 13.2)
  double get labelSmall => 11 * scaleFactor;

  // ============================================
  // Scaled Icon Sizes
  // ============================================

  /// Small icon (16 → 19.2)
  double get iconSmall => 16 * iconScale;

  /// Default icon (24 → 28.8)
  double get iconDefault => 24 * iconScale;

  /// Large icon (32 → 38.4)
  double get iconLarge => 32 * iconScale;

  /// Extra large icon (48 → 57.6)
  double get iconExtraLarge => 48 * iconScale;

  // ============================================
  // Scaled Touch Targets
  // ============================================

  /// Minimum touch target size (48 → 56)
  double get minTouchTarget => isElderlyMode ? 56 : 48;

  /// Button height (48 → 56)
  double get buttonHeight => isElderlyMode ? 56 : 48;

  /// List item height (56 → 64)
  double get listItemHeight => isElderlyMode ? 64 : 56;

  /// Input field height (48 → 56)
  double get inputHeight => isElderlyMode ? 56 : 48;

  // ============================================
  // Scaled Spacing
  // ============================================

  /// Small padding (8 → 10)
  double get paddingSmall => isElderlyMode ? 10 : 8;

  /// Default padding (16 → 20)
  double get paddingDefault => isElderlyMode ? 20 : 16;

  /// Large padding (24 → 28)
  double get paddingLarge => isElderlyMode ? 28 : 24;

  // ============================================
  // Helper Methods
  // ============================================

  /// Scales a given size by the accessibility factor.
  double scale(double size) => size * scaleFactor;

  /// Scales a given icon size.
  double scaleIcon(double size) => size * iconScale;

  /// Gets scaled text style from base style.
  TextStyle scaleTextStyle(TextStyle base) {
    return base.copyWith(
      fontSize: base.fontSize != null ? base.fontSize! * scaleFactor : null,
      height: base.height,
    );
  }

  @override
  AccessibilityTheme copyWith({
    double? scaleFactor,
    bool? isElderlyMode,
  }) {
    return AccessibilityTheme(
      scaleFactor: scaleFactor ?? this.scaleFactor,
      isElderlyMode: isElderlyMode ?? this.isElderlyMode,
    );
  }

  @override
  AccessibilityTheme lerp(AccessibilityTheme? other, double t) {
    if (other is! AccessibilityTheme) {
      return this;
    }
    return AccessibilityTheme(
      scaleFactor: lerpDouble(scaleFactor, other.scaleFactor, t) ?? scaleFactor,
      isElderlyMode: t < 0.5 ? isElderlyMode : other.isElderlyMode,
    );
  }
}

/// Extension on ThemeData to access accessibility theme.
extension AccessibilityThemeExtension on ThemeData {
  /// Gets the accessibility theme from the theme data.
  AccessibilityTheme get accessibility {
    final data = extension<AccessibilityTheme>();
    return data ?? const AccessibilityTheme.standard();
  }
}

/// Extension on BuildContext for easy access to accessibility theme.
extension AccessibilityContextExtension on BuildContext {
  /// Gets the accessibility theme from the context.
  AccessibilityTheme get accessibility {
    return Theme.of(this).accessibility;
  }

  /// Checks if elderly mode is enabled.
  bool get isElderlyMode => accessibility.isElderlyMode;
}
