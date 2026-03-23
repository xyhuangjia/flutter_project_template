/// Device breakpoints and content constraints for responsive design.
///
/// This module provides:
/// - [Breakpoints]: Device width breakpoints for responsive layouts
/// - [ContentConstraints]: Maximum width constraints for content
/// - [DeviceType]: Enum for device classification
library;

import 'package:flutter/widgets.dart';

/// Device type classification based on screen width.
enum DeviceType {
  /// Mobile phones (width < 600px)
  mobile,

  /// Tablets in portrait mode (600px <= width <= 840px)
  tabletPortrait,

  /// Tablets in landscape mode (width > 840px)
  tabletLandscape,

  /// Desktop screens (width >= 1200px)
  desktop,
}

/// Device breakpoints for responsive layouts.
///
/// Based on Material Design 3 guidelines and common device sizes:
/// - Mobile: < 600px (phones)
/// - Tablet portrait: 600px - 840px
/// - Tablet landscape: 840px - 1200px
/// - Desktop: >= 1200px
///
/// Usage:
/// ```dart
/// LayoutBuilder(
///   builder: (context, constraints) {
///     if (constraints.maxWidth >= Breakpoints.tablet) {
///       return TabletLayout();
///     }
///     return MobileLayout();
///   },
/// )
/// ```
class Breakpoints {
  const Breakpoints._();

  /// Mobile devices maximum width (phones).
  ///
  /// Devices with width below this value are considered mobile phones.
  /// Typical phone widths: 320-600 logical pixels.
  static const double mobile = 600;

  /// Tablet portrait maximum width.
  ///
  /// Devices with width between [mobile] and this value are in
  /// tablet portrait mode.
  /// Typical tablet portrait widths: 600-840 logical pixels
  /// (e.g., iPad 768px).
  static const double tabletPortrait = 840;

  /// Tablet landscape / small desktop minimum width.
  ///
  /// Devices with width between [tabletPortrait] and this value
  /// are in tablet landscape.
  /// Typical tablet landscape widths: 840-1200 logical pixels.
  static const double tabletLandscape = 1200;

  /// Desktop minimum width.
  ///
  /// Devices with width >= this value are considered desktop.
  static const double desktop = 1200;

  /// Get device type from width.
  static DeviceType getDeviceType(double width) {
    if (width >= desktop) return DeviceType.desktop;
    if (width >= tabletPortrait) return DeviceType.tabletLandscape;
    if (width >= mobile) return DeviceType.tabletPortrait;
    return DeviceType.mobile;
  }

  /// Check if width is tablet or larger.
  static bool isTablet(double width) => width >= mobile;

  /// Check if width is desktop.
  static bool isDesktop(double width) => width >= desktop;

  /// Check if in landscape orientation.
  static bool isLandscape(double width, double height) => width > height;
}

/// Content width constraints for different content types.
///
/// These constraints ensure good readability and usability on larger screens.
/// Content should be centered and constrained to these maximum widths.
///
/// Usage:
/// ```dart
/// ConstrainedBox(
///   constraints: BoxConstraints(maxWidth: ContentConstraints.form),
///   child: MyForm(),
/// )
/// ```
class ContentConstraints {
  const ContentConstraints._();

  /// Maximum width for form content (login, signup, etc.)
  ///
  /// Forms should not be too wide for usability.
  /// Standard: 400px (fits well on phones and looks good on tablets)
  static const double form = 400;

  /// Maximum width for card content.
  ///
  /// Cards with text content should have limited width for readability.
  /// Standard: 600px
  static const double card = 600;

  /// Maximum width for text content (articles, posts).
  ///
  /// Based on typography research: 60-75 characters per line is optimal.
  /// At 16px font size, this translates to approximately 680px.
  static const double text = 680;

  /// Maximum width for list content.
  ///
  /// Lists can be slightly wider than cards.
  /// Standard: 840px
  static const double list = 840;

  /// Maximum width for master-detail layout.
  ///
  /// Two-column layouts with a list and detail pane.
  /// Standard: 1200px
  static const double masterDetail = 1200;
}

/// Responsive spacing values based on device type.
///
/// Usage:
/// ```dart
/// final spacing = ResponsiveSpacing.of(context);
/// padding: EdgeInsets.all(spacing.pagePadding),
/// ```
class ResponsiveSpacing {
  const ResponsiveSpacing({
    required this.pagePadding,
    required this.cardPadding,
    required this.cardSpacing,
    required this.listItemHeight,
  });

  /// Mobile spacing (default).
  const ResponsiveSpacing.mobile()
      : pagePadding = 16,
        cardPadding = 16,
        cardSpacing = 16,
        listItemHeight = 56;

  /// Tablet spacing.
  const ResponsiveSpacing.tablet()
      : pagePadding = 24,
        cardPadding = 20,
        cardSpacing = 20,
        listItemHeight = 64;

  /// Desktop spacing.
  const ResponsiveSpacing.desktop()
      : pagePadding = 32,
        cardPadding = 24,
        cardSpacing = 24,
        listItemHeight = 64;

  /// Get spacing based on device width.
  factory ResponsiveSpacing.of(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= Breakpoints.desktop) {
      return const ResponsiveSpacing.desktop();
    }
    if (width >= Breakpoints.mobile) {
      return const ResponsiveSpacing.tablet();
    }
    return const ResponsiveSpacing.mobile();
  }

  /// Get spacing based on device type.
  factory ResponsiveSpacing.fromType(DeviceType type) {
    switch (type) {
      case DeviceType.mobile:
        return const ResponsiveSpacing.mobile();
      case DeviceType.tabletPortrait:
      case DeviceType.tabletLandscape:
        return const ResponsiveSpacing.tablet();
      case DeviceType.desktop:
        return const ResponsiveSpacing.desktop();
    }
  }

  /// Page content padding.
  final double pagePadding;

  /// Card internal padding.
  final double cardPadding;

  /// Spacing between cards.
  final double cardSpacing;

  /// List item height.
  final double listItemHeight;
}

/// Extension on BuildContext for easy access to responsive utilities.
extension ResponsiveContext on BuildContext {
  /// Get current device type.
  DeviceType get deviceType {
    final width = MediaQuery.of(this).size.width;
    return Breakpoints.getDeviceType(width);
  }

  /// Check if current device is tablet or larger.
  bool get isTablet => deviceType != DeviceType.mobile;

  /// Check if current device is desktop.
  bool get isDesktop => deviceType == DeviceType.desktop;

  /// Check if in landscape orientation.
  bool get isLandscape {
    final size = MediaQuery.of(this).size;
    return size.width > size.height;
  }

  /// Get responsive spacing for current device.
  ResponsiveSpacing get spacing => ResponsiveSpacing.of(this);
}
