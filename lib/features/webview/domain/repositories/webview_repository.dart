/// WebView repository interface.
///
/// This file defines the repository contract for WebView feature.
library;

import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/webview/domain/entities/js_bridge_message.dart';

/// WebView repository interface.
///
/// Defines the contract for WebView operations including
/// cookie management, JavaScript bridge, and file operations.
abstract class WebViewRepository {
  /// Gets cookies for a given URL.
  ///
  /// Returns a map of cookie names to values.
  Future<Result<Map<String, String>>> getCookies(String url);

  /// Sets cookies for a given URL.
  ///
  /// [url] The URL to set cookies for.
  /// [cookies] Map of cookie names to values.
  Future<Result<void>> setCookies(
    String url,
    Map<String, String> cookies,
  );

  /// Clears all cookies.
  Future<Result<void>> clearCookies();

  /// Clears cookies for a specific URL.
  Future<Result<void>> clearCookiesForUrl(String url);

  /// Sends a message to JavaScript in the WebView.
  ///
  /// [handlerName] The name of the JavaScript handler to call.
  /// [message] The message to send.
  Future<Result<void>> sendJsMessage(
    String handlerName,
    JsBridgeMessage message,
  );

  /// Downloads a file from a URL.
  ///
  /// [url] The URL of the file to download.
  /// Returns the local file path on success.
  Future<Result<String>> downloadFile(String url);

  /// Checks if a file exists at the given URL.
  Future<Result<bool>> fileExists(String url);

  /// Deletes a downloaded file.
  ///
  /// [filePath] The local file path to delete.
  Future<Result<void>> deleteFile(String filePath);

  /// Gets the local storage value for a key.
  ///
  /// [url] The URL associated with the storage.
  /// [key] The storage key.
  Future<Result<String?>> getLocalStorage(String url, String key);

  /// Sets a local storage value.
  ///
  /// [url] The URL associated with the storage.
  /// [key] The storage key.
  /// [value] The value to store.
  Future<Result<void>> setLocalStorage(
    String url,
    String key,
    String value,
  );

  /// Clears all local storage for a URL.
  Future<Result<void>> clearLocalStorage(String url);
}
