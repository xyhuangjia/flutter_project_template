// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webview_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for WebViewCookieDataSource.

@ProviderFor(webviewCookieDataSource)
final webviewCookieDataSourceProvider = WebviewCookieDataSourceProvider._();

/// Provider for WebViewCookieDataSource.

final class WebviewCookieDataSourceProvider extends $FunctionalProvider<
    WebViewCookieDataSource,
    WebViewCookieDataSource,
    WebViewCookieDataSource> with $Provider<WebViewCookieDataSource> {
  /// Provider for WebViewCookieDataSource.
  WebviewCookieDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'webviewCookieDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$webviewCookieDataSourceHash();

  @$internal
  @override
  $ProviderElement<WebViewCookieDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WebViewCookieDataSource create(Ref ref) {
    return webviewCookieDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WebViewCookieDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WebViewCookieDataSource>(value),
    );
  }
}

String _$webviewCookieDataSourceHash() =>
    r'29f613f4ec140097fcbbe74af70bb065121218aa';

/// Provider for WebViewFileDataSource.

@ProviderFor(webviewFileDataSource)
final webviewFileDataSourceProvider = WebviewFileDataSourceProvider._();

/// Provider for WebViewFileDataSource.

final class WebviewFileDataSourceProvider extends $FunctionalProvider<
    WebViewFileDataSource,
    WebViewFileDataSource,
    WebViewFileDataSource> with $Provider<WebViewFileDataSource> {
  /// Provider for WebViewFileDataSource.
  WebviewFileDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'webviewFileDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$webviewFileDataSourceHash();

  @$internal
  @override
  $ProviderElement<WebViewFileDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WebViewFileDataSource create(Ref ref) {
    return webviewFileDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WebViewFileDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WebViewFileDataSource>(value),
    );
  }
}

String _$webviewFileDataSourceHash() =>
    r'31f653e0d4c66d8022b4faec95dbaf5ef1f6f77f';

/// Provider for WebViewLocalStorageDataSource.

@ProviderFor(webviewLocalStorageDataSource)
final webviewLocalStorageDataSourceProvider =
    WebviewLocalStorageDataSourceProvider._();

/// Provider for WebViewLocalStorageDataSource.

final class WebviewLocalStorageDataSourceProvider extends $FunctionalProvider<
        WebViewLocalStorageDataSource,
        WebViewLocalStorageDataSource,
        WebViewLocalStorageDataSource>
    with $Provider<WebViewLocalStorageDataSource> {
  /// Provider for WebViewLocalStorageDataSource.
  WebviewLocalStorageDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'webviewLocalStorageDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$webviewLocalStorageDataSourceHash();

  @$internal
  @override
  $ProviderElement<WebViewLocalStorageDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WebViewLocalStorageDataSource create(Ref ref) {
    return webviewLocalStorageDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WebViewLocalStorageDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<WebViewLocalStorageDataSource>(value),
    );
  }
}

String _$webviewLocalStorageDataSourceHash() =>
    r'46929f7298919397e7dcf5894dccdbb9cd6c2fb1';

/// Provider for WebViewRepository.

@ProviderFor(webviewRepository)
final webviewRepositoryProvider = WebviewRepositoryProvider._();

/// Provider for WebViewRepository.

final class WebviewRepositoryProvider extends $FunctionalProvider<
    WebViewRepository,
    WebViewRepository,
    WebViewRepository> with $Provider<WebViewRepository> {
  /// Provider for WebViewRepository.
  WebviewRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'webviewRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$webviewRepositoryHash();

  @$internal
  @override
  $ProviderElement<WebViewRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WebViewRepository create(Ref ref) {
    return webviewRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WebViewRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WebViewRepository>(value),
    );
  }
}

String _$webviewRepositoryHash() => r'b36393a8642ff803d13f281caa0a531da33f2204';

/// WebView state notifier provider.
///
/// Manages the WebView state and controller.

@ProviderFor(WebViewNotifier)
final webViewProvider = WebViewNotifierProvider._();

/// WebView state notifier provider.
///
/// Manages the WebView state and controller.
final class WebViewNotifierProvider
    extends $NotifierProvider<WebViewNotifier, WebViewState> {
  /// WebView state notifier provider.
  ///
  /// Manages the WebView state and controller.
  WebViewNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'webViewProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$webViewNotifierHash();

  @$internal
  @override
  WebViewNotifier create() => WebViewNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WebViewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WebViewState>(value),
    );
  }
}

String _$webViewNotifierHash() => r'9068c35ea3dd46f68c47c9211cfe05ae80edca9e';

/// WebView state notifier provider.
///
/// Manages the WebView state and controller.

abstract class _$WebViewNotifier extends $Notifier<WebViewState> {
  WebViewState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<WebViewState, WebViewState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<WebViewState, WebViewState>,
        WebViewState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// Provider for WebView configuration.

@ProviderFor(WebViewConfigNotifier)
final webViewConfigProvider = WebViewConfigNotifierProvider._();

/// Provider for WebView configuration.
final class WebViewConfigNotifierProvider
    extends $NotifierProvider<WebViewConfigNotifier, WebViewConfig?> {
  /// Provider for WebView configuration.
  WebViewConfigNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'webViewConfigProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$webViewConfigNotifierHash();

  @$internal
  @override
  WebViewConfigNotifier create() => WebViewConfigNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WebViewConfig? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WebViewConfig?>(value),
    );
  }
}

String _$webViewConfigNotifierHash() =>
    r'25fc40890e83bb28c3766d4d6f6102353a9172c0';

/// Provider for WebView configuration.

abstract class _$WebViewConfigNotifier extends $Notifier<WebViewConfig?> {
  WebViewConfig? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<WebViewConfig?, WebViewConfig?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<WebViewConfig?, WebViewConfig?>,
        WebViewConfig?,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
