/// Controller for managing keyboard dismiss behavior.
///
/// This provider controls whether tapping outside of a text field
/// dismisses the keyboard globally.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'keyboard_dismiss_controller.g.dart';

/// Controller for managing keyboard dismiss behavior.
///
/// Default behavior: enabled (keyboard dismisses on tap).
///
/// To disable on a specific page:
/// ```dart
/// // Disable keyboard dismiss
/// ref.read(keyboardDismissControllerProvider.notifier).disable();
///
/// // Re-enable when done (e.g., in dispose or when navigating away)
/// ref.read(keyboardDismissControllerProvider.notifier).enable();
/// ```
///
/// To toggle:
/// ```dart
/// ref.read(keyboardDismissControllerProvider.notifier).toggle();
/// ```
///
/// To check current state:
/// ```dart
/// final isEnabled = ref.watch(keyboardDismissControllerProvider);
/// ```
@riverpod
class KeyboardDismissController extends _$KeyboardDismissController {
  @override
  bool build() => true; // Default: keyboard dismiss on tap is enabled

  /// Disables keyboard dismiss on tap.
  void disable() => state = false;

  /// Enables keyboard dismiss on tap.
  void enable() => state = true;

  /// Toggles keyboard dismiss on tap.
  void toggle() => state = !state;
}
