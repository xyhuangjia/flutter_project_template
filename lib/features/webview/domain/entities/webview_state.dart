/// WebView state entity.
///
/// This is a domain entity with no external dependencies.
/// It represents the current state of a WebView instance.
library;

import 'package:flutter/foundation.dart';

/// WebView loading state enum.
enum WebViewLoadingState {
  /// Initial state, no page loaded.
  initial,

  /// Page is loading.
  loading,

  /// Page finished loading successfully.
  loaded,

  /// Page failed to load.
  error,
}

/// WebView state entity.
///
/// Represents the current state of a WebView instance including
/// loading state, navigation state, and error information.
@immutable
class WebViewState {
  /// Creates a webview state.
  const WebViewState({
    this.loadingState = WebViewLoadingState.initial,
    this.loadingProgress = 0,
    this.currentUrl,
    this.pageTitle,
    this.canGoBack = false,
    this.canGoForward = false,
    this.errorMessage,
    this.errorCode,
  });

  /// Creates an initial state.
  const WebViewState.initial()
      : loadingState = WebViewLoadingState.initial,
        loadingProgress = 0,
        currentUrl = null,
        pageTitle = null,
        canGoBack = false,
        canGoForward = false,
        errorMessage = null,
        errorCode = null;

  /// The current loading state.
  final WebViewLoadingState loadingState;

  /// The loading progress (0-100).
  final int loadingProgress;

  /// The current URL being displayed.
  final String? currentUrl;

  /// The title of the current page.
  final String? pageTitle;

  /// Whether the WebView can navigate back.
  final bool canGoBack;

  /// Whether the WebView can navigate forward.
  final bool canGoForward;

  /// Error message if loading failed.
  final String? errorMessage;

  /// Error code if loading failed.
  final int? errorCode;

  /// Whether the WebView is currently loading.
  bool get isLoading => loadingState == WebViewLoadingState.loading;

  /// Whether the WebView has an error.
  bool get hasError => loadingState == WebViewLoadingState.error;

  /// Creates a copy of this state with optionally overridden fields.
  WebViewState copyWith({
    WebViewLoadingState? loadingState,
    int? loadingProgress,
    String? currentUrl,
    String? pageTitle,
    bool? canGoBack,
    bool? canGoForward,
    String? errorMessage,
    int? errorCode,
  }) {
    return WebViewState(
      loadingState: loadingState ?? this.loadingState,
      loadingProgress: loadingProgress ?? this.loadingProgress,
      currentUrl: currentUrl ?? this.currentUrl,
      pageTitle: pageTitle ?? this.pageTitle,
      canGoBack: canGoBack ?? this.canGoBack,
      canGoForward: canGoForward ?? this.canGoForward,
      errorMessage: errorMessage ?? this.errorMessage,
      errorCode: errorCode ?? this.errorCode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WebViewState &&
        other.loadingState == loadingState &&
        other.loadingProgress == loadingProgress &&
        other.currentUrl == currentUrl &&
        other.pageTitle == pageTitle &&
        other.canGoBack == canGoBack &&
        other.canGoForward == canGoForward &&
        other.errorMessage == errorMessage &&
        other.errorCode == errorCode;
  }

  @override
  int get hashCode {
    return Object.hash(
      loadingState,
      loadingProgress,
      currentUrl,
      pageTitle,
      canGoBack,
      canGoForward,
      errorMessage,
      errorCode,
    );
  }

  @override
  String toString() {
    return 'WebViewState(loadingState: $loadingState, '
        'loadingProgress: $loadingProgress, currentUrl: $currentUrl, '
        'pageTitle: $pageTitle, canGoBack: $canGoBack, '
        'canGoForward: $canGoForward, errorMessage: $errorMessage, '
        'errorCode: $errorCode)';
  }
}
