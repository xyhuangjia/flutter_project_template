/// Keyboard dismiss wrapper for handling tap-to-dismiss keyboard globally.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/widgets/keyboard_dismiss_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Wrapper widget that enables tap-to-dismiss keyboard globally.
///
/// Usage:
/// ```dart
/// KeyboardDismissWrapper(
///   child: MaterialApp(...),
/// )
/// ```
///
/// To disable keyboard dismiss on a specific page:
/// ```dart
/// ref.read(keyboardDismissControllerProvider.notifier).disable();
/// // ... later
/// ref.read(keyboardDismissControllerProvider.notifier).enable();
/// ```
class KeyboardDismissWrapper extends ConsumerWidget {
  /// Creates the keyboard dismiss wrapper.
  const KeyboardDismissWrapper({
    required this.child,
    super.key,
  });

  /// The child widget to wrap.
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled = ref.watch(keyboardDismissControllerProvider);

    return Listener(
      onPointerDown: isEnabled
          ? (_) => FocusScope.of(context).unfocus()
          : null,
      child: child,
    );
  }
}
