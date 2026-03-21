// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyboard_dismiss_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$keyboardDismissControllerHash() =>
    r'f990a0113ee4625ced4a2207fa36576e3b9cba8f';

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
///
/// Copied from [KeyboardDismissController].
@ProviderFor(KeyboardDismissController)
final keyboardDismissControllerProvider =
    AutoDisposeNotifierProvider<KeyboardDismissController, bool>.internal(
  KeyboardDismissController.new,
  name: r'keyboardDismissControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$keyboardDismissControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$KeyboardDismissController = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
