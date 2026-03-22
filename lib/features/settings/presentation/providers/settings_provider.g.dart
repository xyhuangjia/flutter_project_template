// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for SettingsLocalDataSource.

@ProviderFor(settingsLocalDataSource)
final settingsLocalDataSourceProvider = SettingsLocalDataSourceProvider._();

/// Provider for SettingsLocalDataSource.

final class SettingsLocalDataSourceProvider extends $FunctionalProvider<
    SettingsLocalDataSource,
    SettingsLocalDataSource,
    SettingsLocalDataSource> with $Provider<SettingsLocalDataSource> {
  /// Provider for SettingsLocalDataSource.
  SettingsLocalDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'settingsLocalDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$settingsLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<SettingsLocalDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SettingsLocalDataSource create(Ref ref) {
    return settingsLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsLocalDataSource>(value),
    );
  }
}

String _$settingsLocalDataSourceHash() =>
    r'c2e9693729b162c5ab9a74399e948628e2be324c';

/// Provider for SettingsRepository.

@ProviderFor(settingsRepository)
final settingsRepositoryProvider = SettingsRepositoryProvider._();

/// Provider for SettingsRepository.

final class SettingsRepositoryProvider extends $FunctionalProvider<
    SettingsRepository,
    SettingsRepository,
    SettingsRepository> with $Provider<SettingsRepository> {
  /// Provider for SettingsRepository.
  SettingsRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'settingsRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$settingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SettingsRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SettingsRepository create(Ref ref) {
    return settingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsRepository>(value),
    );
  }
}

String _$settingsRepositoryHash() =>
    r'8b8a5cd52917d536c77b5c7ee9fbdcc809daa6e1';

/// Settings state notifier provider.
///
/// Manages the application settings.

@ProviderFor(SettingsNotifier)
final settingsProvider = SettingsNotifierProvider._();

/// Settings state notifier provider.
///
/// Manages the application settings.
final class SettingsNotifierProvider
    extends $AsyncNotifierProvider<SettingsNotifier, SettingsEntity> {
  /// Settings state notifier provider.
  ///
  /// Manages the application settings.
  SettingsNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'settingsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$settingsNotifierHash();

  @$internal
  @override
  SettingsNotifier create() => SettingsNotifier();
}

String _$settingsNotifierHash() => r'a662a1daad73d5a1036138c3528de5f826eda632';

/// Settings state notifier provider.
///
/// Manages the application settings.

abstract class _$SettingsNotifier extends $AsyncNotifier<SettingsEntity> {
  FutureOr<SettingsEntity> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SettingsEntity>, SettingsEntity>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<SettingsEntity>, SettingsEntity>,
        AsyncValue<SettingsEntity>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// User preferences notifier provider.
///
/// Manages the user preferences.

@ProviderFor(UserPreferencesNotifier)
final userPreferencesProvider = UserPreferencesNotifierProvider._();

/// User preferences notifier provider.
///
/// Manages the user preferences.
final class UserPreferencesNotifierProvider
    extends $AsyncNotifierProvider<UserPreferencesNotifier, UserPreferences> {
  /// User preferences notifier provider.
  ///
  /// Manages the user preferences.
  UserPreferencesNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'userPreferencesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userPreferencesNotifierHash();

  @$internal
  @override
  UserPreferencesNotifier create() => UserPreferencesNotifier();
}

String _$userPreferencesNotifierHash() =>
    r'c101ec0ced05b1278709f26a3bc974cd0a68120b';

/// User preferences notifier provider.
///
/// Manages the user preferences.

abstract class _$UserPreferencesNotifier
    extends $AsyncNotifier<UserPreferences> {
  FutureOr<UserPreferences> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserPreferences>, UserPreferences>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<UserPreferences>, UserPreferences>,
        AsyncValue<UserPreferences>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
