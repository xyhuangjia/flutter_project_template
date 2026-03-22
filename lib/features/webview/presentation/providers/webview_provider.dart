/// WebView providers using Riverpod code generation.
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_template/core/providers/locale_provider.dart';
import 'package:flutter_project_template/features/webview/data/datasources/webview_cookie_data_source.dart';
import 'package:flutter_project_template/features/webview/data/datasources/webview_file_data_source.dart';
import 'package:flutter_project_template/features/webview/data/datasources/webview_local_storage_data_source.dart';
import 'package:flutter_project_template/features/webview/data/repositories/webview_repository_impl.dart';
import 'package:flutter_project_template/features/webview/domain/entities/js_bridge_message.dart';
import 'package:flutter_project_template/features/webview/domain/entities/webview_config.dart';
import 'package:flutter_project_template/features/webview/domain/entities/webview_state.dart';
import 'package:flutter_project_template/features/webview/domain/repositories/webview_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

part 'webview_provider.g.dart';

/// Provider for WebViewCookieDataSource.
@riverpod
WebViewCookieDataSource webviewCookieDataSource(Ref ref) =>
    WebViewCookieDataSource();

/// Provider for WebViewFileDataSource.
@riverpod
WebViewFileDataSource webviewFileDataSource(Ref ref) => WebViewFileDataSource();

/// Provider for WebViewLocalStorageDataSource.
@riverpod
WebViewLocalStorageDataSource webviewLocalStorageDataSource(Ref ref) {
  final prefs = ref.watch(sharedPrefsProvider).value;
  if (prefs == null) {
    throw StateError('SharedPreferences not initialized');
  }
  return WebViewLocalStorageDataSource(sharedPreferences: prefs);
}

/// Provider for WebViewRepository.
@riverpod
WebViewRepository webviewRepository(Ref ref) => WebViewRepositoryImpl(
      cookieDataSource: ref.watch(webviewCookieDataSourceProvider),
      fileDataSource: ref.watch(webviewFileDataSourceProvider),
      localStorageDataSource: ref.watch(webviewLocalStorageDataSourceProvider),
    );

/// WebView state notifier provider.
///
/// Manages the WebView state and controller.
@riverpod
class WebViewNotifier extends _$WebViewNotifier {
  WebViewController? _controller;
  WebViewConfig? _config;

  @override
  WebViewState build() => const WebViewState.initial();

  /// Initializes the WebView with a configuration.
  Future<void> initialize(WebViewConfig config) async {
    _config = config;
    _controller = WebViewController()
      // ignore: unawaited_futures
      ..setJavaScriptMode(
        config.enableJavaScript
            ? JavaScriptMode.unrestricted
            : JavaScriptMode.disabled,
      )
      // ignore: unawaited_futures
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: _onPageStarted,
          onPageFinished: _onPageFinished,
          onProgress: _onProgress,
          onWebResourceError: _onWebResourceError,
          onHttpError: _onHttpError,
          onNavigationRequest: (request) =>
              _onNavigationRequest(request, config),
        ),
      )
      // ignore: unawaited_futures
      ..setUserAgent(config.userAgent);

    // DOM storage is enabled by default in webview_flutter

    // Configure cache
    if (!config.enableCache) {
      unawaited(_controller?.clearCache());
    }

    // Set up JS bridge handlers
    _setupJsBridgeHandlers();

    // Load the URL
    if (config.url.isNotEmpty) {
      await loadUrl(config.url);
    }

    // Sync cookies
    final repository = ref.read(webviewRepositoryProvider);
    if (repository is WebViewRepositoryImpl && _controller != null) {
      repository.controller = _controller;
      unawaited(repository.syncCookies(config.url));
    }
  }

  void _setupJsBridgeHandlers() {
    _controller?.addJavaScriptChannel(
      'FlutterBridge',
      onMessageReceived: (message) {
        _handleJsMessage(message.message);
      },
    );
  }

  void _handleJsMessage(String message) {
    try {
      debugPrint('Received JS message: $message');

      final data = jsonDecode(message) as Map<String, dynamic>;
      final type = data['type'] as String?;

      switch (type) {
        case 'retry':
          // 从 404 页面重试时，重新加载原始 URL
          final originalUrl = _config?.url;
          if (originalUrl != null && originalUrl.isNotEmpty) {
            loadUrl(originalUrl);
          }
          break;
        default:
          debugPrint('Unknown JS message type: $type');
      }
    } on Exception catch (e) {
      debugPrint('Error handling JS message: $e');
    }
  }

  void _onPageStarted(String url) {
    state = state.copyWith(
      loadingState: WebViewLoadingState.loading,
      currentUrl: url,
      // ignore: avoid_redundant_argument_values
      errorMessage: null, // Clear previous error
      // ignore: avoid_redundant_argument_values
      errorCode: null,
    );
  }

  Future<void> _onPageFinished(String url) async {
    state = state.copyWith(
      loadingState: WebViewLoadingState.loaded,
      currentUrl: url,
      loadingProgress: 100,
    );

    // Update navigation state
    final canGoBack = await _controller?.canGoBack() ?? false;
    final canGoForward = await _controller?.canGoForward() ?? false;
    state = state.copyWith(
      canGoBack: canGoBack,
      canGoForward: canGoForward,
    );

    // Get page title
    final title = await _controller?.getTitle();
    if (title != null && title.isNotEmpty) {
      state = state.copyWith(pageTitle: title);
    }

    // Extract and save cookies
    final repository = ref.read(webviewRepositoryProvider);
    if (repository is WebViewRepositoryImpl) {
      final cookies = await repository.extractCookies();
      if (cookies.isNotEmpty) {
        await repository.setCookies(url, cookies);
      }
    }
  }

  void _onProgress(int progress) {
    state = state.copyWith(loadingProgress: progress);
  }

  void _onWebResourceError(WebResourceError error) {
    // 检查是否是需要显示404页面的错误
    final shouldShowNotFound = _shouldShowNotFoundPage(error.errorCode);
    if (shouldShowNotFound) {
      _loadNotFoundPage();
      return;
    }

    state = state.copyWith(
      loadingState: WebViewLoadingState.error,
      errorMessage: error.description,
      errorCode: error.errorCode,
    );
  }

  /// 处理 HTTP 错误（如 404, 500 等）
  void _onHttpError(HttpResponseError error) {
    debugPrint('HTTP Error: ${error.response?.statusCode}');

    final statusCode = error.response?.statusCode;
    // 对于 4xx 和 5xx 错误，显示 404 页面
    if (statusCode != null && statusCode >= 400) {
      _loadNotFoundPage();
    }
  }

  /// 判断是否需要显示 404 页面
  bool _shouldShowNotFoundPage(int errorCode) {
    // WebView 错误码参考：
    // -1: 未知错误 (ERR_UNKNOWN)
    // -2: 主机名查找失败 (ERR_NAME_NOT_RESOLVED)
    // -6: 连接被拒绝 (ERR_CONNECTION_REFUSED)
    // -8: 连接超时 (ERR_CONNECTION_TIMED_OUT)
    // -11: 资源加载失败 (ERR_ACCESS_DENIED)
    // -12: 页面无法加载 (ERR_FILE_NOT_FOUND)
    // -102: 帧框加载已中断 (ERR_FAILED)
    const notFoundErrorCodes = {-1, -2, -6, -8, -11, -12, -102};
    return notFoundErrorCodes.contains(errorCode);
  }

  /// 加载本地 404 页面
  Future<void> _loadNotFoundPage() async {
    state = state.copyWith(
      loadingState: WebViewLoadingState.loading,
      // ignore: avoid_redundant_argument_values
      errorMessage: null, // Clear previous error
      // ignore: avoid_redundant_argument_values
      errorCode: null,
    );

    await _controller?.loadFlutterAsset('assets/html/404.html');

    state = state.copyWith(
      loadingState: WebViewLoadingState.loaded,
      loadingProgress: 100,
    );
  }

  NavigationDecision _onNavigationRequest(
    NavigationRequest request,
    WebViewConfig config,
  ) {
    final url = request.url;

    // Check blocked URLs
    for (final blocked in config.blockedUrls) {
      if (url.contains(blocked)) {
        return NavigationDecision.prevent;
      }
    }

    // Check allowed schemes
    final uri = Uri.tryParse(url);
    if (uri != null && !config.allowedSchemes.contains(uri.scheme)) {
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  /// Loads a URL.
  Future<void> loadUrl(String url) async {
    state = state.copyWith(
      loadingState: WebViewLoadingState.loading,
      currentUrl: url,
    );

    final config = _config;
    if (config == null) return;

    final allHeaders = config.headers ?? <String, String>{};
    await _controller?.loadRequest(
      Uri.parse(url),
      headers: allHeaders,
    );
  }

  /// Reloads the current page.
  Future<void> reload() async {
    state = state.copyWith(loadingState: WebViewLoadingState.loading);
    await _controller?.reload();
  }

  /// Goes back in history.
  Future<void> goBack() async {
    if (state.canGoBack) {
      await _controller?.goBack();
    }
  }

  /// Goes forward in history.
  Future<void> goForward() async {
    if (state.canGoForward) {
      await _controller?.goForward();
    }
  }

  /// Clears the cache.
  Future<void> clearCache() async {
    await _controller?.clearCache();
    await _controller?.reload();
  }

  /// Sends a message to JavaScript.
  Future<void> sendJsMessage(
    String handlerName,
    JsBridgeMessage message,
  ) async {
    final repository = ref.read(webviewRepositoryProvider);
    await repository.sendJsMessage(handlerName, message);
  }

  /// Evaluates JavaScript.
  Future<String?> evaluateJavascript(String script) async {
    try {
      final result = await _controller?.runJavaScriptReturningResult(script);
      return result?.toString();
    } on Exception catch (e) {
      debugPrint('Error evaluating JavaScript: $e');
      return null;
    }
  }

  /// Gets the current URL.
  String? get currentUrl => state.currentUrl;

  /// Gets the page title.
  String? get pageTitle => state.pageTitle;

  /// Gets the WebView controller.
  WebViewController? get controller => _controller;

  /// Checks if can go back.
  bool get canGoBack => state.canGoBack;

  /// Checks if can go forward.
  bool get canGoForward => state.canGoForward;

  /// Checks if is loading.
  bool get isLoading => state.isLoading;

  /// Checks if has error.
  bool get hasError => state.hasError;

  /// Gets the current config.
  WebViewConfig? get config => _config;

  /// Opens the current URL in an external browser.
  Future<void> openInBrowser() async {
    final url = state.currentUrl;
    if (url == null || url.isEmpty) return;

    final uri = Uri.tryParse(url);
    if (uri == null) return;

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Copies the current URL to clipboard.
  Future<void> copyCurrentUrl() async {
    final url = state.currentUrl;
    if (url == null || url.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: url));
  }
}

/// Provider for WebView configuration.
@riverpod
class WebViewConfigNotifier extends _$WebViewConfigNotifier {
  @override
  WebViewConfig? build() => null;

  /// Gets the current configuration.
  WebViewConfig? get config => state;

  /// Sets the configuration.
  set config(WebViewConfig? value) {
    state = value;
  }

  /// Updates the URL.
  void updateUrl(String url) {
    if (state != null) {
      state = state!.copyWith(url: url);
    }
  }
}
