/// WebView cookie data source.
///
/// Handles cookie management operations.
library;

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// WebView cookie data source.
///
/// Provides cookie management functionality for WebView.
/// Registered as a lazy singleton in GetIt.
@lazySingleton
class WebViewCookieDataSource {
  /// Creates a cookie data source.
  WebViewCookieDataSource();

  final Map<String, Map<String, String>> _cookies = {};

  /// Gets all cookies for a URL.
  Future<Map<String, String>> getCookies(String url) async {
    final uri = Uri.parse(url);
    final domain = uri.host;
    return Map.from(_cookies[domain] ?? {});
  }

  /// Sets cookies for a URL.
  Future<void> setCookies(
    String url,
    Map<String, String> cookies,
  ) async {
    final uri = Uri.parse(url);
    final domain = uri.host;
    _cookies[domain] = {...?_cookies[domain], ...cookies};
  }

  /// Clears all cookies.
  Future<void> clearAllCookies() async {
    _cookies.clear();
  }

  /// Clears cookies for a specific URL.
  Future<void> clearCookiesForUrl(String url) async {
    final uri = Uri.parse(url);
    final domain = uri.host;
    _cookies.remove(domain);
  }

  /// Syncs cookies to a WebView controller.
  Future<void> syncCookiesToController(
    WebViewController controller,
    String url,
  ) async {
    final uri = Uri.parse(url);
    final domain = uri.host;
    final cookies = _cookies[domain];

    if (cookies != null) {
      for (final entry in cookies.entries) {
        await controller.runJavaScript(
          'document.cookie = "${entry.key}=${entry.value}; path=/"',
        );
      }
    }
  }

  /// Extracts cookies from a WebView controller.
  Future<Map<String, String>> extractCookiesFromController(
    WebViewController controller,
  ) async {
    try {
      final cookieString = await controller.runJavaScriptReturningResult(
        'document.cookie',
      ) as String;

      final cookies = <String, String>{};
      if (cookieString.isNotEmpty) {
        final pairs = cookieString.split(';');
        for (final pair in pairs) {
          final trimmed = pair.trim();
          if (trimmed.isEmpty) continue;

          final equalIndex = trimmed.indexOf('=');
          if (equalIndex > 0) {
            final name = trimmed.substring(0, equalIndex);
            final value = trimmed.substring(equalIndex + 1);
            cookies[name] = value;
          }
        }
      }
      return cookies;
    } on Exception catch (e) {
      debugPrint('Error extracting cookies: $e');
      return {};
    }
  }
}
