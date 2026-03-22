// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'developer_options_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for DeveloperOptionsLocalDataSource.
/// Uses GetIt for dependency injection.

@ProviderFor(developerOptionsLocalDataSource)
final developerOptionsLocalDataSourceProvider =
    DeveloperOptionsLocalDataSourceProvider._();

/// Provider for DeveloperOptionsLocalDataSource.
/// Uses GetIt for dependency injection.

final class DeveloperOptionsLocalDataSourceProvider extends $FunctionalProvider<
        DeveloperOptionsLocalDataSource,
        DeveloperOptionsLocalDataSource,
        DeveloperOptionsLocalDataSource>
    with $Provider<DeveloperOptionsLocalDataSource> {
  /// Provider for DeveloperOptionsLocalDataSource.
  /// Uses GetIt for dependency injection.
  DeveloperOptionsLocalDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'developerOptionsLocalDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$developerOptionsLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<DeveloperOptionsLocalDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeveloperOptionsLocalDataSource create(Ref ref) {
    return developerOptionsLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeveloperOptionsLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<DeveloperOptionsLocalDataSource>(value),
    );
  }
}

String _$developerOptionsLocalDataSourceHash() =>
    r'2bb327914100f8a4290e56ca0801e140963751ba';

/// Provider for DeveloperOptionsRepository.
/// Uses GetIt for dependency injection.

@ProviderFor(developerOptionsRepository)
final developerOptionsRepositoryProvider =
    DeveloperOptionsRepositoryProvider._();

/// Provider for DeveloperOptionsRepository.
/// Uses GetIt for dependency injection.

final class DeveloperOptionsRepositoryProvider extends $FunctionalProvider<
    DeveloperOptionsRepository,
    DeveloperOptionsRepository,
    DeveloperOptionsRepository> with $Provider<DeveloperOptionsRepository> {
  /// Provider for DeveloperOptionsRepository.
  /// Uses GetIt for dependency injection.
  DeveloperOptionsRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'developerOptionsRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$developerOptionsRepositoryHash();

  @$internal
  @override
  $ProviderElement<DeveloperOptionsRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeveloperOptionsRepository create(Ref ref) {
    return developerOptionsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeveloperOptionsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeveloperOptionsRepository>(value),
    );
  }
}

String _$developerOptionsRepositoryHash() =>
    r'd849a76628b402c9c57aae9b67608ed23dbd79c8';

/// Developer options notifier provider.
///
/// Manages the developer options state.

@ProviderFor(DeveloperOptionsNotifier)
final developerOptionsProvider = DeveloperOptionsNotifierProvider._();

/// Developer options notifier provider.
///
/// Manages the developer options state.
final class DeveloperOptionsNotifierProvider
    extends $AsyncNotifierProvider<DeveloperOptionsNotifier, DeveloperOptions> {
  /// Developer options notifier provider.
  ///
  /// Manages the developer options state.
  DeveloperOptionsNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'developerOptionsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$developerOptionsNotifierHash();

  @$internal
  @override
  DeveloperOptionsNotifier create() => DeveloperOptionsNotifier();
}

String _$developerOptionsNotifierHash() =>
    r'4b509acf3904bb3f65f11cb6d08b72723644e615';

/// Developer options notifier provider.
///
/// Manages the developer options state.

abstract class _$DeveloperOptionsNotifier
    extends $AsyncNotifier<DeveloperOptions> {
  FutureOr<DeveloperOptions> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<DeveloperOptions>, DeveloperOptions>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<DeveloperOptions>, DeveloperOptions>,
        AsyncValue<DeveloperOptions>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
