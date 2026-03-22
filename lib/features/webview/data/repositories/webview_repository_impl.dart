/// WebView repository implementation.
///
/// Implements the WebView repository interface.
library;

import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/webview/data/datasources/webview_cookie_data_source.dart';
import 'package:flutter_project_template/features/webview/data/datasources/webview_file_data_source.dart';
import 'package:flutter_project_template/features/webview/data/datasources/webview_local_storage_data_source.dart';
import 'package:flutter_project_template/features/webview/domain/entities/js_bridge_message.dart';
import 'package:flutter_project_template/features/webview/domain/repositories/webview_repository.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// WebView repository implementation.
///
/// Coordinates between data sources to provide WebView functionality.
class WebViewRepositoryImpl implements WebViewRepository {
  /// Creates a webview repository implementation.
  WebViewRepositoryImpl({
    required WebViewCookieDataSource cookieDataSource,
    required WebViewFileDataSource fileDataSource,
    required WebViewLocalStorageDataSource localStorageDataSource,
  })  : _cookieDataSource = cookieDataSource,
        _fileDataSource = fileDataSource,
        _localStorageDataSource = localStorageDataSource;

  final WebViewCookieDataSource _cookieDataSource;
  final WebViewFileDataSource _fileDataSource;
  final WebViewLocalStorageDataSource _localStorageDataSource;

  /// The WebView controller used for operations.
  WebViewController? controller;

  @override
  Future<Result<Map<String, String>>> getCookies(String url) async {
    try {
      final cookies = await _cookieDataSource.getCookies(url);
      return Success(cookies);
    } on Exception catch (e) {
      return FailureResult(
        CacheFailure(message: 'Failed to get cookies: $e'),
      );
    }
  }

  @override
  Future<Result<void>> setCookies(
    String url,
    Map<String, String> cookies,
  ) async {
    try {
      await _cookieDataSource.setCookies(url, cookies);
      return const Success(null);
    } on Exception catch (e) {
      return FailureResult(
        CacheFailure(message: 'Failed to set cookies: $e'),
      );
    }
  }

  @override
  Future<Result<void>> clearCookies() async {
    try {
      await _cookieDataSource.clearAllCookies();
      return const Success(null);
    } on Exception catch (e) {
      return FailureResult(
        CacheFailure(message: 'Failed to clear cookies: $e'),
      );
    }
  }

  @override
  Future<Result<void>> clearCookiesForUrl(String url) async {
    try {
      await _cookieDataSource.clearCookiesForUrl(url);
      return const Success(null);
    } on Exception catch (e) {
      return FailureResult(
        CacheFailure(message: 'Failed to clear cookies for URL: $e'),
      );
    }
  }

  @override
  Future<Result<void>> sendJsMessage(
    String handlerName,
    JsBridgeMessage message,
  ) async {
    try {
      final ctrl = controller;
      if (ctrl == null) {
        return const FailureResult(
          CacheFailure(message: 'WebView controller not initialized'),
        );
      }

      final jsonMessage = message.toJson();
      final jsonString = jsonMessage.toString().replaceAll("'", r"\'");
      await ctrl.runJavaScript(
        'if (window.$handlerName) { window.$handlerName("$jsonString"); }',
      );

      return const Success(null);
    } on Exception catch (e) {
      return FailureResult(
        UnknownFailure(message: 'Failed to send JS message: $e'),
      );
    }
  }

  @override
  Future<Result<String>> downloadFile(String url) async {
    try {
      final filePath = await _fileDataSource.downloadFile(url);
      return Success(filePath);
    } on Exception catch (e) {
      return FailureResult(
        NetworkFailure(message: 'Failed to download file: $e'),
      );
    }
  }

  @override
  Future<Result<bool>> fileExists(String filePath) async {
    try {
      final exists = await _fileDataSource.fileExists(filePath);
      return Success(exists);
    } on Exception catch (e) {
      return FailureResult(
        CacheFailure(message: 'Failed to check file existence: $e'),
      );
    }
  }

  @override
  Future<Result<void>> deleteFile(String filePath) async {
    try {
      await _fileDataSource.deleteFile(filePath);
      return const Success(null);
    } on Exception catch (e) {
      return FailureResult(
        CacheFailure(message: 'Failed to delete file: $e'),
      );
    }
  }

  @override
  Future<Result<String?>> getLocalStorage(String url, String key) async {
    try {
      final value = await _localStorageDataSource.getValue(url, key);
      return Success(value);
    } on Exception catch (e) {
      return FailureResult(
        CacheFailure(message: 'Failed to get local storage: $e'),
      );
    }
  }

  @override
  Future<Result<void>> setLocalStorage(
    String url,
    String key,
    String value,
  ) async {
    try {
      await _localStorageDataSource.setValue(url, key, value);
      return const Success(null);
    } on Exception catch (e) {
      return FailureResult(
        CacheFailure(message: 'Failed to set local storage: $e'),
      );
    }
  }

  @override
  Future<Result<void>> clearLocalStorage(String url) async {
    try {
      await _localStorageDataSource.clearForUrl(url);
      return const Success(null);
    } on Exception catch (e) {
      return FailureResult(
        CacheFailure(message: 'Failed to clear local storage: $e'),
      );
    }
  }

  /// Syncs cookies to the WebView controller.
  Future<void> syncCookies(String url) async {
    final ctrl = controller;
    if (ctrl != null) {
      await _cookieDataSource.syncCookiesToController(ctrl, url);
    }
  }

  /// Extracts cookies from the WebView controller.
  Future<Map<String, String>> extractCookies() async {
    final ctrl = controller;
    if (ctrl != null) {
      return _cookieDataSource.extractCookiesFromController(ctrl);
    }
    return {};
  }
}
