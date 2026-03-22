// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'environment_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// SharedPreferences provider.

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// SharedPreferences provider.

final class SharedPreferencesProvider extends $FunctionalProvider<
    SharedPreferences,
    SharedPreferences,
    SharedPreferences> with $Provider<SharedPreferences> {
  /// SharedPreferences provider.
  SharedPreferencesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'sharedPreferencesProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'1c2dd1a84771b17e16cc7c9461dd6736a2a28921';

/// Environment local data source provider.

@ProviderFor(environmentLocalDataSource)
final environmentLocalDataSourceProvider =
    EnvironmentLocalDataSourceProvider._();

/// Environment local data source provider.

final class EnvironmentLocalDataSourceProvider extends $FunctionalProvider<
    EnvironmentLocalDataSource,
    EnvironmentLocalDataSource,
    EnvironmentLocalDataSource> with $Provider<EnvironmentLocalDataSource> {
  /// Environment local data source provider.
  EnvironmentLocalDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'environmentLocalDataSourceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$environmentLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<EnvironmentLocalDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EnvironmentLocalDataSource create(Ref ref) {
    return environmentLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EnvironmentLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EnvironmentLocalDataSource>(value),
    );
  }
}

String _$environmentLocalDataSourceHash() =>
    r'0b4d9246c8b280f0e69faa390fd6432e7f8423ab';

/// Environment configuration provider.
///
/// This provider manages the current environment configuration.
/// It loads the saved environment on startup and provides
/// methods to switch environments.

@ProviderFor(Environment)
final environmentProvider = EnvironmentProvider._();

/// Environment configuration provider.
///
/// This provider manages the current environment configuration.
/// It loads the saved environment on startup and provides
/// methods to switch environments.
final class EnvironmentProvider
    extends $NotifierProvider<Environment, EnvironmentConfig> {
  /// Environment configuration provider.
  ///
  /// This provider manages the current environment configuration.
  /// It loads the saved environment on startup and provides
  /// methods to switch environments.
  EnvironmentProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'environmentProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$environmentHash();

  @$internal
  @override
  Environment create() => Environment();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EnvironmentConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EnvironmentConfig>(value),
    );
  }
}

String _$environmentHash() => r'fee275407a1b2571074c099ef100e63f765ebfad';

/// Environment configuration provider.
///
/// This provider manages the current environment configuration.
/// It loads the saved environment on startup and provides
/// methods to switch environments.

abstract class _$Environment extends $Notifier<EnvironmentConfig> {
  EnvironmentConfig build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<EnvironmentConfig, EnvironmentConfig>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<EnvironmentConfig, EnvironmentConfig>,
        EnvironmentConfig,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// Provider for checking if developer options should be visible.
///
/// Developer options are only shown in debug mode.

@ProviderFor(showDeveloperOptions)
final showDeveloperOptionsProvider = ShowDeveloperOptionsProvider._();

/// Provider for checking if developer options should be visible.
///
/// Developer options are only shown in debug mode.

final class ShowDeveloperOptionsProvider
    extends $FunctionalProvider<bool, bool, bool> with $Provider<bool> {
  /// Provider for checking if developer options should be visible.
  ///
  /// Developer options are only shown in debug mode.
  ShowDeveloperOptionsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'showDeveloperOptionsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$showDeveloperOptionsHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return showDeveloperOptions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showDeveloperOptionsHash() =>
    r'a17d853c27d1794713564cb936c339730a76dc86';
