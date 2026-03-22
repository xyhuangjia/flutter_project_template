// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingsLocalDataSourceHash() =>
    r'abf924cb6a7a32642c6a8a472d5b81819bb61302';

/// Provider for SettingsLocalDataSource.
///
/// Copied from [settingsLocalDataSource].
@ProviderFor(settingsLocalDataSource)
final settingsLocalDataSourceProvider =
    AutoDisposeProvider<SettingsLocalDataSource>.internal(
  settingsLocalDataSource,
  name: r'settingsLocalDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingsLocalDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SettingsLocalDataSourceRef
    = AutoDisposeProviderRef<SettingsLocalDataSource>;
String _$settingsRepositoryHash() =>
    r'280c7e776908b4283fc2a10c42fe3dd224199de5';

/// Provider for SettingsRepository.
///
/// Copied from [settingsRepository].
@ProviderFor(settingsRepository)
final settingsRepositoryProvider =
    AutoDisposeProvider<SettingsRepository>.internal(
  settingsRepository,
  name: r'settingsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SettingsRepositoryRef = AutoDisposeProviderRef<SettingsRepository>;
String _$settingsNotifierHash() => r'a265bb2ac5166dcab8792cdf86ca7072b4f16f13';

/// Settings state notifier provider.
///
/// Manages the application settings.
///
/// Copied from [SettingsNotifier].
@ProviderFor(SettingsNotifier)
final settingsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<SettingsNotifier, SettingsEntity>.internal(
  SettingsNotifier.new,
  name: r'settingsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SettingsNotifier = AutoDisposeAsyncNotifier<SettingsEntity>;
String _$userPreferencesNotifierHash() =>
    r'c101ec0ced05b1278709f26a3bc974cd0a68120b';

/// User preferences notifier provider.
///
/// Manages the user preferences.
///
/// Copied from [UserPreferencesNotifier].
@ProviderFor(UserPreferencesNotifier)
final userPreferencesNotifierProvider = AutoDisposeAsyncNotifierProvider<
    UserPreferencesNotifier, UserPreferences>.internal(
  UserPreferencesNotifier.new,
  name: r'userPreferencesNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userPreferencesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserPreferencesNotifier = AutoDisposeAsyncNotifier<UserPreferences>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
