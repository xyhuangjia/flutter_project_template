/// Responsive layout widgets for adaptive UI design.
///
/// This module provides:
/// - [ResponsiveLayout]: Switch between mobile/tablet/desktop layouts
/// - [ConstrainedContent]: Center content with max width constraint
/// - [AdaptiveBuilder]: Build widgets based on device type
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/theme/breakpoints.dart';

/// Responsive layout that switches between different device layouts.
///
/// Automatically selects the appropriate layout based on screen width:
/// - [mobile]: Width < 600px (phones)
/// - [tablet]: 600px <= width < 1200px (tablets)
/// - [desktop]: Width >= 1200px (desktops)
///
/// Example:
/// ```dart
/// ResponsiveLayout(
///   mobile: MobileLayout(),
///   tablet: TabletLayout(),
///   desktop: DesktopLayout(),
/// )
/// ```
///
/// For tablet portrait vs landscape:
/// ```dart
/// ResponsiveLayout(
///   mobile: MobileLayout(),
///   tabletPortrait: TabletPortraitLayout(),
///   tabletLandscape: TabletLandscapeLayout(),
///   desktop: DesktopLayout(),
/// )
/// ```
class ResponsiveLayout extends StatelessWidget {
  /// Creates a responsive layout.
  const ResponsiveLayout({
    required this.mobile,
    this.tablet,
    this.tabletPortrait,
    this.tabletLandscape,
    this.desktop,
    super.key,
  });

  /// Layout for mobile devices (width < 600px).
  final Widget mobile;

  /// Layout for tablets (600px <= width < 1200px).
  /// Used when [tabletPortrait] and [tabletLandscape] are not provided.
  final Widget? tablet;

  /// Layout for tablets in portrait mode.
  final Widget? tabletPortrait;

  /// Layout for tablets in landscape mode.
  final Widget? tabletLandscape;

  /// Layout for desktop screens (width >= 1200px).
  final Widget? desktop;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          final isLandscape = width > height;

          // Desktop
          if (width >= Breakpoints.desktop && desktop != null) {
            return desktop!;
          }

          // Tablet landscape
          if (width >= Breakpoints.tabletPortrait && isLandscape) {
            if (tabletLandscape != null) {
              return tabletLandscape!;
            }
            if (tablet != null) {
              return tablet!;
            }
          }

          // Tablet portrait
          if (width >= Breakpoints.mobile) {
            if (tabletPortrait != null) {
              return tabletPortrait!;
            }
            if (tablet != null) {
              return tablet!;
            }
          }

          // Mobile (default)
          return mobile;
        },
      );
}

/// A widget that centers its child with a maximum width constraint.
///
/// Use this to prevent content from becoming too wide on larger screens.
/// Common use cases:
/// - Forms: maxWidth = ContentConstraints.form
/// - Cards: maxWidth = ContentConstraints.card
/// - Lists: maxWidth = ContentConstraints.list
///
/// Example:
/// ```dart
/// ConstrainedContent(
///   maxWidth: ContentConstraints.form,
///   child: LoginForm(),
/// )
/// ```
class ConstrainedContent extends StatelessWidget {
  /// Creates constrained content.
  const ConstrainedContent({
    required this.child,
    this.maxWidth = ContentConstraints.card,
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  /// The child widget to be constrained.
  final Widget child;

  /// Maximum width for the content.
  /// Defaults to [ContentConstraints.card].
  final double maxWidth;

  /// How to align the content within the available space.
  final Alignment alignment;

  /// Padding around the constrained content.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Align(
        alignment: alignment,
        child: Padding(
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: child,
          ),
        ),
      );
}

/// Builder that provides device type information.
///
/// Use this when you need conditional logic based on device type,
/// but don't need completely different layouts.
///
/// Example:
/// ```dart
/// AdaptiveBuilder(
///   builder: (context, deviceType) {
///     final crossAxisCount = deviceType == DeviceType.mobile ? 3 : 4;
///     return GridView.count(
///       crossAxisCount: crossAxisCount,
///       children: items,
///     );
///   },
/// )
/// ```
class AdaptiveBuilder extends StatelessWidget {
  /// Creates an adaptive builder.
  const AdaptiveBuilder({
    required this.builder,
    super.key,
  });

  /// Builder function that receives device type.
  final Widget Function(BuildContext context, DeviceType deviceType) builder;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final deviceType = Breakpoints.getDeviceType(constraints.maxWidth);
          return builder(context, deviceType);
        },
      );
}

/// Extension methods for responsive values.
extension ResponsiveValue<T> on T {
  /// Returns this value for mobile, or [tabletValue] for tablet/desktop.
  T responsive(T tabletValue, {T? desktopValue}) =>
      this; // Placeholder - use context.selectValue instead
}

/// Extension on num for responsive sizing.
extension ResponsiveNum on num {
  /// Scale value for tablet (1.1x) and desktop (1.2x).
  ///
  /// Usage:
  /// ```dart
  /// padding: EdgeInsets.all(16.responsive(context))
  /// ```
  double responsive(BuildContext context) {
    final deviceType = context.deviceType;
    switch (deviceType) {
      case DeviceType.desktop:
        return toDouble() * 1.2;
      case DeviceType.tabletPortrait:
      case DeviceType.tabletLandscape:
        return toDouble() * 1.1;
      case DeviceType.mobile:
        return toDouble();
    }
  }

  /// Get value based on device type.
  ///
  /// Usage:
  /// ```dart
  /// columns: 3.deviceValue(tablet: 4, desktop: 6)
  /// ```
  num deviceValue({num? tablet, num? desktop}) =>
      this; // Placeholder - use context.selectValue instead
}

/// Extension on BuildContext for responsive values.
extension ResponsiveContextValues on BuildContext {
  /// Select value based on device type.
  ///
  /// Usage:
  /// ```dart
  /// final columns = context.selectValue(mobile: 3, tablet: 4, desktop: 6);
  /// ```
  T selectValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final deviceType = this.deviceType;
    switch (deviceType) {
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.tabletPortrait:
      case DeviceType.tabletLandscape:
        return tablet ?? mobile;
      case DeviceType.mobile:
        return mobile;
    }
  }

  /// Get responsive padding based on device type.
  EdgeInsets get responsivePadding => EdgeInsets.all(spacing.pagePadding);
}

/// A scaffold that automatically applies responsive padding.
///
/// Use this for simple pages that just need responsive padding
/// without complex layout changes.
///
/// Example:
/// ```dart
/// ResponsiveScaffold(
///   appBar: AppBar(title: Text('Settings')),
///   body: Column(children: [...]),
/// )
/// ```
class ResponsiveScaffold extends StatelessWidget {
  /// Creates a responsive scaffold.
  const ResponsiveScaffold({
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.maxWidth,
    this.centerContent = false,
    super.key,
  });

  /// The primary content of the scaffold.
  final Widget body;

  /// App bar to display at the top of the scaffold.
  final PreferredSizeWidget? appBar;

  /// Floating action button.
  final Widget? floatingActionButton;

  /// Location of the floating action button.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Animator for the floating action button.
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  /// Drawer (side menu).
  final Widget? drawer;

  /// End drawer (right side menu).
  final Widget? endDrawer;

  /// Bottom navigation bar.
  final Widget? bottomNavigationBar;

  /// Bottom sheet.
  final Widget? bottomSheet;

  /// Background color.
  final Color? backgroundColor;

  /// Maximum width for body content.
  /// If null, content fills available width.
  final double? maxWidth;

  /// Whether to center content horizontally.
  final bool centerContent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.surfaceContainerLow;
    final spacing = context.spacing;

    var content = body;

    // Apply max width constraint if specified
    if (maxWidth != null) {
      content = ConstrainedContent(
        maxWidth: maxWidth!,
        child: content,
      );
    }

    // Apply responsive padding
    content = Padding(
      padding: EdgeInsets.all(spacing.pagePadding),
      child: content,
    );

    // Center content if requested
    if (centerContent) {
      content = Center(child: content);
    }

    return Scaffold(
      appBar: appBar,
      body: content,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      drawer: drawer,
      endDrawer: endDrawer,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
      backgroundColor: bgColor,
    );
  }
}
