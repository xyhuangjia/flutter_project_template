// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'environment_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'a81206f7f5ee549db42bac71be6e8e9f1104b0ce';

/// SharedPreferences provider.
///
/// Copied from [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = Provider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPreferencesRef = ProviderRef<SharedPreferences>;
String _$environmentLocalDataSourceHash() =>
    r'c084e67ea08b2bec6a5f29a965b72b39be605741';

/// Environment local data source provider.
///
/// Copied from [environmentLocalDataSource].
@ProviderFor(environmentLocalDataSource)
final environmentLocalDataSourceProvider =
    Provider<EnvironmentLocalDataSource>.internal(
  environmentLocalDataSource,
  name: r'environmentLocalDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$environmentLocalDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EnvironmentLocalDataSourceRef = ProviderRef<EnvironmentLocalDataSource>;
String _$showDeveloperOptionsHash() =>
    r'cbce339000fbc25e308bd3d1914a47be0e8e1594';

/// Provider for checking if developer options should be visible.
///
/// Developer options are only shown in debug mode.
///
/// Copied from [showDeveloperOptions].
@ProviderFor(showDeveloperOptions)
final showDeveloperOptionsProvider = AutoDisposeProvider<bool>.internal(
  showDeveloperOptions,
  name: r'showDeveloperOptionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$showDeveloperOptionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShowDeveloperOptionsRef = AutoDisposeProviderRef<bool>;
String _$environmentHash() => r'fee275407a1b2571074c099ef100e63f765ebfad';

/// Environment configuration provider.
///
/// This provider manages the current environment configuration.
/// It loads the saved environment on startup and provides
/// methods to switch environments.
///
/// Copied from [Environment].
@ProviderFor(Environment)
final environmentProvider =
    NotifierProvider<Environment, EnvironmentConfig>.internal(
  Environment.new,
  name: r'environmentProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$environmentHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Environment = Notifier<EnvironmentConfig>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
