// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyboard_dismiss_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(KeyboardDismissController)
final keyboardDismissControllerProvider = KeyboardDismissControllerProvider._();

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
final class KeyboardDismissControllerProvider
    extends $NotifierProvider<KeyboardDismissController, bool> {
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
  KeyboardDismissControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'keyboardDismissControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$keyboardDismissControllerHash();

  @$internal
  @override
  KeyboardDismissController create() => KeyboardDismissController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

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

abstract class _$KeyboardDismissController extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<bool, bool>, bool, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
