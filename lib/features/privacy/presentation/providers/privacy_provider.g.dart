// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$privacyLocalDataSourceHash() =>
    r'a1232ea09c31aca2f5f50b757929ac7e2a0c75bf';

/// Privacy local data source provider.
///
/// Copied from [privacyLocalDataSource].
@ProviderFor(privacyLocalDataSource)
final privacyLocalDataSourceProvider =
    AutoDisposeProvider<PrivacyLocalDataSource>.internal(
  privacyLocalDataSource,
  name: r'privacyLocalDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$privacyLocalDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PrivacyLocalDataSourceRef
    = AutoDisposeProviderRef<PrivacyLocalDataSource>;
String _$accountServiceMockHash() =>
    r'489dfb7a1a5849d9f9490316a8d997eec9d16a08';

/// Mock account service provider.
///
/// Copied from [accountServiceMock].
@ProviderFor(accountServiceMock)
final accountServiceMockProvider =
    AutoDisposeProvider<AccountServiceMock>.internal(
  accountServiceMock,
  name: r'accountServiceMockProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountServiceMockHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AccountServiceMockRef = AutoDisposeProviderRef<AccountServiceMock>;
String _$privacyRepositoryHash() => r'4954c7f75d5693c21da72135ba9b1c5febd82271';

/// Privacy repository provider.
///
/// Copied from [privacyRepository].
@ProviderFor(privacyRepository)
final privacyRepositoryProvider =
    AutoDisposeProvider<PrivacyRepository>.internal(
  privacyRepository,
  name: r'privacyRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$privacyRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PrivacyRepositoryRef = AutoDisposeProviderRef<PrivacyRepository>;
String _$privacyNotifierHash() => r'748f726546da5c36acecad0508f65d774c57271d';

/// Privacy state notifier provider.
///
/// Manages the privacy state.
/// Uses keepAlive to prevent auto-dispose during navigation.
///
/// Copied from [PrivacyNotifier].
@ProviderFor(PrivacyNotifier)
final privacyNotifierProvider =
    AsyncNotifierProvider<PrivacyNotifier, PrivacyState>.internal(
  PrivacyNotifier.new,
  name: r'privacyNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$privacyNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PrivacyNotifier = AsyncNotifier<PrivacyState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
