// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Region config provider.

@ProviderFor(regionConfig)
final regionConfigProvider = RegionConfigProvider._();

/// Region config provider.

final class RegionConfigProvider
    extends $FunctionalProvider<RegionConfig, RegionConfig, RegionConfig>
    with $Provider<RegionConfig> {
  /// Region config provider.
  RegionConfigProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'regionConfigProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$regionConfigHash();

  @$internal
  @override
  $ProviderElement<RegionConfig> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RegionConfig create(Ref ref) {
    return regionConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegionConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegionConfig>(value),
    );
  }
}

String _$regionConfigHash() => r'4122498664489139aa309db5ee92ca9f59b366fe';

/// Region notifier provider for managing region selection.

@ProviderFor(RegionNotifier)
final regionProvider = RegionNotifierProvider._();

/// Region notifier provider for managing region selection.
final class RegionNotifierProvider
    extends $AsyncNotifierProvider<RegionNotifier, MarketRegion> {
  /// Region notifier provider for managing region selection.
  RegionNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'regionProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$regionNotifierHash();

  @$internal
  @override
  RegionNotifier create() => RegionNotifier();
}

String _$regionNotifierHash() => r'a230fadde6c76b972a48b7a1d937f47b6c1af072';

/// Region notifier provider for managing region selection.

abstract class _$RegionNotifier extends $AsyncNotifier<MarketRegion> {
  FutureOr<MarketRegion> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<MarketRegion>, MarketRegion>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<MarketRegion>, MarketRegion>,
        AsyncValue<MarketRegion>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
