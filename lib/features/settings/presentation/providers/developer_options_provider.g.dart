// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'developer_options_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$developerOptionsLocalDataSourceHash() =>
    r'8a0ca18f8a7ff11e60a1d06bbb3fc3e69f145b15';

/// Provider for DeveloperOptionsLocalDataSource.
///
/// Copied from [developerOptionsLocalDataSource].
@ProviderFor(developerOptionsLocalDataSource)
final developerOptionsLocalDataSourceProvider =
    AutoDisposeProvider<DeveloperOptionsLocalDataSource>.internal(
  developerOptionsLocalDataSource,
  name: r'developerOptionsLocalDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$developerOptionsLocalDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeveloperOptionsLocalDataSourceRef
    = AutoDisposeProviderRef<DeveloperOptionsLocalDataSource>;
String _$developerOptionsRepositoryHash() =>
    r'abf2f8293d3e118b5c1133e166532bbbc764d409';

/// Provider for DeveloperOptionsRepository.
///
/// Copied from [developerOptionsRepository].
@ProviderFor(developerOptionsRepository)
final developerOptionsRepositoryProvider =
    AutoDisposeProvider<DeveloperOptionsRepository>.internal(
  developerOptionsRepository,
  name: r'developerOptionsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$developerOptionsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeveloperOptionsRepositoryRef
    = AutoDisposeProviderRef<DeveloperOptionsRepository>;
String _$developerOptionsNotifierHash() =>
    r'26aa880042af2f4df8d4e46475f31d559429cc8b';

/// Developer options notifier provider.
///
/// Manages the developer options state.
///
/// Copied from [DeveloperOptionsNotifier].
@ProviderFor(DeveloperOptionsNotifier)
final developerOptionsNotifierProvider = AutoDisposeAsyncNotifierProvider<
    DeveloperOptionsNotifier, DeveloperOptions>.internal(
  DeveloperOptionsNotifier.new,
  name: r'developerOptionsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$developerOptionsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DeveloperOptionsNotifier = AutoDisposeAsyncNotifier<DeveloperOptions>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
