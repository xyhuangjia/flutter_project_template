// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Privacy local data source provider.

@ProviderFor(privacyLocalDataSource)
final privacyLocalDataSourceProvider = PrivacyLocalDataSourceProvider._();

/// Privacy local data source provider.

final class PrivacyLocalDataSourceProvider extends $FunctionalProvider<
    PrivacyLocalDataSource,
    PrivacyLocalDataSource,
    PrivacyLocalDataSource> with $Provider<PrivacyLocalDataSource> {
  /// Privacy local data source provider.
  PrivacyLocalDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'privacyLocalDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$privacyLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<PrivacyLocalDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PrivacyLocalDataSource create(Ref ref) {
    return privacyLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrivacyLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrivacyLocalDataSource>(value),
    );
  }
}

String _$privacyLocalDataSourceHash() =>
    r'f0719fbc5172777b7010598b6be7d74dc7b222ab';

/// Mock account service provider.

@ProviderFor(accountServiceMock)
final accountServiceMockProvider = AccountServiceMockProvider._();

/// Mock account service provider.

final class AccountServiceMockProvider extends $FunctionalProvider<
    AccountServiceMock,
    AccountServiceMock,
    AccountServiceMock> with $Provider<AccountServiceMock> {
  /// Mock account service provider.
  AccountServiceMockProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'accountServiceMockProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$accountServiceMockHash();

  @$internal
  @override
  $ProviderElement<AccountServiceMock> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AccountServiceMock create(Ref ref) {
    return accountServiceMock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountServiceMock value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountServiceMock>(value),
    );
  }
}

String _$accountServiceMockHash() =>
    r'880a092c0349dd973a23794da794aff63011af1d';

/// Privacy repository provider.

@ProviderFor(privacyRepository)
final privacyRepositoryProvider = PrivacyRepositoryProvider._();

/// Privacy repository provider.

final class PrivacyRepositoryProvider extends $FunctionalProvider<
    PrivacyRepository,
    PrivacyRepository,
    PrivacyRepository> with $Provider<PrivacyRepository> {
  /// Privacy repository provider.
  PrivacyRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'privacyRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$privacyRepositoryHash();

  @$internal
  @override
  $ProviderElement<PrivacyRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PrivacyRepository create(Ref ref) {
    return privacyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrivacyRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrivacyRepository>(value),
    );
  }
}

String _$privacyRepositoryHash() => r'796667fc102f3004e3cb06ed61694e1425ac789e';

/// Privacy state notifier provider.
///
/// Manages the privacy state.
/// Uses keepAlive to prevent auto-dispose during navigation.

@ProviderFor(PrivacyNotifier)
final privacyProvider = PrivacyNotifierProvider._();

/// Privacy state notifier provider.
///
/// Manages the privacy state.
/// Uses keepAlive to prevent auto-dispose during navigation.
final class PrivacyNotifierProvider
    extends $AsyncNotifierProvider<PrivacyNotifier, PrivacyState> {
  /// Privacy state notifier provider.
  ///
  /// Manages the privacy state.
  /// Uses keepAlive to prevent auto-dispose during navigation.
  PrivacyNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'privacyProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$privacyNotifierHash();

  @$internal
  @override
  PrivacyNotifier create() => PrivacyNotifier();
}

String _$privacyNotifierHash() => r'a59f326487545124788f5c645f236d2999e42b34';

/// Privacy state notifier provider.
///
/// Manages the privacy state.
/// Uses keepAlive to prevent auto-dispose during navigation.

abstract class _$PrivacyNotifier extends $AsyncNotifier<PrivacyState> {
  FutureOr<PrivacyState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PrivacyState>, PrivacyState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<PrivacyState>, PrivacyState>,
        AsyncValue<PrivacyState>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
