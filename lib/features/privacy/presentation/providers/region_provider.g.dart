// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$regionConfigHash() => r'11e8f81585042a4899767638dbb80d34fe1aa502';

/// Region config provider.
///
/// Copied from [regionConfig].
@ProviderFor(regionConfig)
final regionConfigProvider = AutoDisposeProvider<RegionConfig>.internal(
  regionConfig,
  name: r'regionConfigProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$regionConfigHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RegionConfigRef = AutoDisposeProviderRef<RegionConfig>;
String _$regionNotifierHash() => r'aa09785b06fa588f7a68b72fbca14a96ad0968c6';

/// Region notifier provider for managing region selection.
///
/// Copied from [RegionNotifier].
@ProviderFor(RegionNotifier)
final regionNotifierProvider =
    AutoDisposeAsyncNotifierProvider<RegionNotifier, MarketRegion>.internal(
  RegionNotifier.new,
  name: r'regionNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$regionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RegionNotifier = AutoDisposeAsyncNotifier<MarketRegion>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
