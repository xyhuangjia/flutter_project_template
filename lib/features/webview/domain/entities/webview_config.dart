/// WebView configuration entity.
///
/// This is a domain entity with no external dependencies.
/// It defines the configuration for a WebView instance.
library;

import 'package:flutter/foundation.dart';

/// WebView configuration entity.
///
/// Contains all the configuration options for loading and
/// controlling a WebView instance.
@immutable
class WebViewConfig {
  /// Creates a webview configuration.
  const WebViewConfig({
    required this.url,
    this.title,
    this.showAppBar = true,
    this.enableJavaScript = true,
    this.enableDomStorage = true,
    this.enableCache = true,
    this.userAgent,
    this.headers,
    this.blockedUrls = const [],
    this.allowedSchemes = const ['http', 'https'],
    this.enableFileDownload = true,
    this.enableFileUpload = true,
    this.enableNavigationControls = true,
    this.enablePullToRefresh = true,
  });

  /// The URL to load in the WebView.
  final String url;

  /// The title to display in the AppBar.
  /// If null, the page title will be used.
  final String? title;

  /// Whether to show the AppBar.
  final bool showAppBar;

  /// Whether to enable JavaScript.
  final bool enableJavaScript;

  /// Whether to enable DOM storage.
  final bool enableDomStorage;

  /// Whether to enable caching.
  final bool enableCache;

  /// Custom user agent string.
  final String? userAgent;

  /// Additional HTTP headers to send with the request.
  final Map<String, String>? headers;

  /// List of URL patterns to block.
  final List<String> blockedUrls;

  /// List of allowed URL schemes.
  final List<String> allowedSchemes;

  /// Whether to enable file download.
  final bool enableFileDownload;

  /// Whether to enable file upload.
  final bool enableFileUpload;

  /// Whether to show navigation controls (back/forward/refresh).
  final bool enableNavigationControls;

  /// Whether to enable pull-to-refresh.
  final bool enablePullToRefresh;

  /// Creates a copy of this configuration with optionally overridden fields.
  WebViewConfig copyWith({
    String? url,
    String? title,
    bool? showAppBar,
    bool? enableJavaScript,
    bool? enableDomStorage,
    bool? enableCache,
    String? userAgent,
    Map<String, String>? headers,
    List<String>? blockedUrls,
    List<String>? allowedSchemes,
    bool? enableFileDownload,
    bool? enableFileUpload,
    bool? enableNavigationControls,
    bool? enablePullToRefresh,
  }) =>
      WebViewConfig(
        url: url ?? this.url,
        title: title ?? this.title,
        showAppBar: showAppBar ?? this.showAppBar,
        enableJavaScript: enableJavaScript ?? this.enableJavaScript,
        enableDomStorage: enableDomStorage ?? this.enableDomStorage,
        enableCache: enableCache ?? this.enableCache,
        userAgent: userAgent ?? this.userAgent,
        headers: headers ?? this.headers,
        blockedUrls: blockedUrls ?? this.blockedUrls,
        allowedSchemes: allowedSchemes ?? this.allowedSchemes,
        enableFileDownload: enableFileDownload ?? this.enableFileDownload,
        enableFileUpload: enableFileUpload ?? this.enableFileUpload,
        enableNavigationControls:
            enableNavigationControls ?? this.enableNavigationControls,
        enablePullToRefresh: enablePullToRefresh ?? this.enablePullToRefresh,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WebViewConfig &&
        other.url == url &&
        other.title == title &&
        other.showAppBar == showAppBar &&
        other.enableJavaScript == enableJavaScript &&
        other.enableDomStorage == enableDomStorage &&
        other.enableCache == enableCache &&
        other.userAgent == userAgent &&
        _mapEquals(other.headers, headers) &&
        _listEquals(other.blockedUrls, blockedUrls) &&
        _listEquals(other.allowedSchemes, allowedSchemes) &&
        other.enableFileDownload == enableFileDownload &&
        other.enableFileUpload == enableFileUpload &&
        other.enableNavigationControls == enableNavigationControls &&
        other.enablePullToRefresh == enablePullToRefresh;
  }

  @override
  int get hashCode => Object.hash(
        url,
        title,
        showAppBar,
        enableJavaScript,
        enableDomStorage,
        enableCache,
        userAgent,
        Object.hashAll(headers?.entries ?? []),
        Object.hashAll(blockedUrls),
        Object.hashAll(allowedSchemes),
        enableFileDownload,
        enableFileUpload,
        enableNavigationControls,
        enablePullToRefresh,
      );

  @override
  String toString() => 'WebViewConfig(url: $url, title: $title, '
      'showAppBar: $showAppBar, enableJavaScript: $enableJavaScript, '
      'enableDomStorage: $enableDomStorage, enableCache: $enableCache, '
      'userAgent: $userAgent, headers: $headers, blockedUrls: $blockedUrls, '
      'allowedSchemes: $allowedSchemes, '
      'enableFileDownload: $enableFileDownload, '
      'enableFileUpload: $enableFileUpload, '
      'enableNavigationControls: $enableNavigationControls, '
      'enablePullToRefresh: $enablePullToRefresh)';

  static bool _mapEquals<T>(Map<T, T>? a, Map<T, T>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
