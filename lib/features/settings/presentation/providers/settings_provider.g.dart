// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingsLocalDataSourceHash() =>
    r'72e94c583c8a0294742254300e1196d2ce4b8f3b';

/// Provider for SettingsLocalDataSource.
///
/// Copied from [settingsLocalDataSource].
@ProviderFor(settingsLocalDataSource)
final settingsLocalDataSourceProvider =
    Provider<SettingsLocalDataSource>.internal(
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
typedef SettingsLocalDataSourceRef = ProviderRef<SettingsLocalDataSource>;
String _$sharedPreferencesHash() => r'ab2adf09d4c5f157be5f0d18d20ea4581bcf2690';

/// Provider for SharedPreferences.
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
String _$settingsRepositoryHash() =>
    r'be7681d7effc1d1821479d693653a5c28451a814';

/// Provider for SettingsRepository.
///
/// Copied from [settingsRepository].
@ProviderFor(settingsRepository)
final settingsRepositoryProvider = Provider<SettingsRepository>.internal(
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
typedef SettingsRepositoryRef = ProviderRef<SettingsRepository>;
String _$settingsNotifierHash() => r'd477816741d2d54db97666f346af17c1ffb5e286';

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
    r'bf8706e9b37db8fab4a6c468e18612f3aed7ce03';

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
