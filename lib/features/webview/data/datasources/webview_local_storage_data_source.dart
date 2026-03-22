/// WebView local storage data source.
///
/// Handles local storage operations for WebView.
library;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// WebView local storage data source.
///
/// Provides local storage functionality for WebView using SharedPreferences.
/// Registered as a lazy singleton in GetIt.
@lazySingleton
class WebViewLocalStorageDataSource {
  /// Creates a local storage data source.
  WebViewLocalStorageDataSource({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  static const String _keyPrefix = 'webview_local_storage_';

  /// Gets the storage key for a URL and key combination.
  String _getStorageKey(String url, String key) {
    final uri = Uri.parse(url);
    final domain = uri.host;
    return '$_keyPrefix${domain}_$key';
  }

  /// Gets a value from local storage.
  Future<String?> getValue(String url, String key) async {
    final storageKey = _getStorageKey(url, key);
    return _sharedPreferences.getString(storageKey);
  }

  /// Sets a value in local storage.
  Future<void> setValue(String url, String key, String value) async {
    final storageKey = _getStorageKey(url, key);
    await _sharedPreferences.setString(storageKey, value);
  }

  /// Removes a value from local storage.
  Future<void> removeValue(String url, String key) async {
    final storageKey = _getStorageKey(url, key);
    await _sharedPreferences.remove(storageKey);
  }

  /// Clears all local storage for a URL.
  Future<void> clearForUrl(String url) async {
    final uri = Uri.parse(url);
    final domain = uri.host;
    final prefix = '$_keyPrefix${domain}_';

    final keys = _sharedPreferences.getKeys();
    for (final key in keys) {
      if (key.startsWith(prefix)) {
        await _sharedPreferences.remove(key);
      }
    }
  }

  /// Clears all local storage.
  Future<void> clearAll() async {
    final keys = _sharedPreferences.getKeys();
    for (final key in keys) {
      if (key.startsWith(_keyPrefix)) {
        await _sharedPreferences.remove(key);
      }
    }
  }

  /// Gets all key-value pairs for a URL.
  Future<Map<String, String>> getAllForUrl(String url) async {
    final uri = Uri.parse(url);
    final domain = uri.host;
    final prefix = '$_keyPrefix${domain}_';

    final result = <String, String>{};
    final keys = _sharedPreferences.getKeys();

    for (final key in keys) {
      if (key.startsWith(prefix)) {
        final originalKey = key.substring(prefix.length);
        final value = _sharedPreferences.getString(key);
        if (value != null) {
          result[originalKey] = value;
        }
      }
    }

    return result;
  }

  /// Sets multiple key-value pairs for a URL.
  Future<void> setMultiple(String url, Map<String, String> values) async {
    for (final entry in values.entries) {
      await setValue(url, entry.key, entry.value);
    }
  }

  /// Gets a JSON value from local storage.
  Future<Map<String, dynamic>?> getJson(String url, String key) async {
    final value = await getValue(url, key);
    if (value == null) return null;

    try {
      return jsonDecode(value) as Map<String, dynamic>;
    } on Exception catch (e) {
      debugPrint('Error parsing JSON from local storage: $e');
      return null;
    }
  }

  /// Sets a JSON value in local storage.
  Future<void> setJson(
    String url,
    String key,
    Map<String, dynamic> value,
  ) async {
    final jsonString = jsonEncode(value);
    await setValue(url, key, jsonString);
  }
}
