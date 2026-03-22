// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Home state notifier provider.
///
/// Manages the state for the home screen.

@ProviderFor(HomeNotifier)
final homeProvider = HomeNotifierProvider._();

/// Home state notifier provider.
///
/// Manages the state for the home screen.
final class HomeNotifierProvider
    extends $AsyncNotifierProvider<HomeNotifier, HomeEntity> {
  /// Home state notifier provider.
  ///
  /// Manages the state for the home screen.
  HomeNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'homeProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$homeNotifierHash();

  @$internal
  @override
  HomeNotifier create() => HomeNotifier();
}

String _$homeNotifierHash() => r'82e4a5a81ce41d41dbe5dc941096f9d20ac18a70';

/// Home state notifier provider.
///
/// Manages the state for the home screen.

abstract class _$HomeNotifier extends $AsyncNotifier<HomeEntity> {
  FutureOr<HomeEntity> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<HomeEntity>, HomeEntity>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<HomeEntity>, HomeEntity>,
        AsyncValue<HomeEntity>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// Provider for greeting message based on time of day.

@ProviderFor(greetingMessage)
final greetingMessageProvider = GreetingMessageProvider._();

/// Provider for greeting message based on time of day.

final class GreetingMessageProvider
    extends $FunctionalProvider<String, String, String> with $Provider<String> {
  /// Provider for greeting message based on time of day.
  GreetingMessageProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'greetingMessageProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$greetingMessageHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return greetingMessage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$greetingMessageHash() => r'23be66f00ce17b97edecd46dbf9e78e0d1ceee2a';
