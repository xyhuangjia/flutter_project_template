import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/webview/data/datasources/webview_cookie_data_source.dart';
import 'package:flutter_project_template/features/webview/data/datasources/webview_file_data_source.dart';
import 'package:flutter_project_template/features/webview/data/datasources/webview_local_storage_data_source.dart';
import 'package:flutter_project_template/features/webview/data/repositories/webview_repository_impl.dart';
import 'package:flutter_project_template/features/webview/domain/entities/js_bridge_message.dart';

void main() {
  group('WebViewRepositoryImpl', () {
    late WebViewRepositoryImpl repository;
    late FakeCookieDataSource fakeCookieDataSource;
    late FakeFileDataSource fakeFileDataSource;
    late FakeLocalStorageDataSource fakeLocalStorageDataSource;

    setUp(() {
      fakeCookieDataSource = FakeCookieDataSource();
      fakeFileDataSource = FakeFileDataSource();
      fakeLocalStorageDataSource = FakeLocalStorageDataSource();
      repository = WebViewRepositoryImpl(
        cookieDataSource: fakeCookieDataSource,
        fileDataSource: fakeFileDataSource,
        localStorageDataSource: fakeLocalStorageDataSource,
      );
    });

    group('getCookies', () {
      test('returns cookies from data source', () async {
        fakeCookieDataSource.cookies['https://example.com'] = {
          'session': 'abc123',
        };

        final result = await repository.getCookies('https://example.com');

        expect(result, isA<Success<Map<String, String>>>());
        final success = result as Success<Map<String, String>>;
        expect(success.data, containsPair('session', 'abc123'));
      });

      test('returns empty map for unknown URL', () async {
        final result = await repository.getCookies('https://unknown.com');

        expect(result, isA<Success<Map<String, String>>>());
        final success = result as Success<Map<String, String>>;
        expect(success.data, isEmpty);
      });
    });

    group('setCookies', () {
      test('sets cookies via data source', () async {
        const cookies = {'session': 'xyz789'};

        final result = await repository.setCookies(
          'https://example.com',
          cookies,
        );

        expect(result, isA<Success<void>>());
        expect(
          fakeCookieDataSource.cookies['https://example.com'],
          containsPair('session', 'xyz789'),
        );
      });
    });

    group('clearCookies', () {
      test('clears all cookies', () async {
        fakeCookieDataSource.cookies['https://example.com'] = {'session': 'a'};
        fakeCookieDataSource.cookies['https://other.com'] = {'session': 'b'};

        final result = await repository.clearCookies();

        expect(result, isA<Success<void>>());
        expect(fakeCookieDataSource.cookies, isEmpty);
      });
    });

    group('clearCookiesForUrl', () {
      test('clears cookies for specific URL only', () async {
        fakeCookieDataSource.cookies['https://example.com'] = {'session': 'a'};
        fakeCookieDataSource.cookies['https://other.com'] = {'session': 'b'};

        final result = await repository.clearCookiesForUrl('https://example.com');

        expect(result, isA<Success<void>>());
        expect(
          fakeCookieDataSource.cookies['https://example.com'],
          isNull,
        );
        expect(
          fakeCookieDataSource.cookies['https://other.com'],
          isNotNull,
        );
      });
    });

    group('sendJsMessage', () {
      test('returns failure when controller is null', () async {
        repository.controller = null;
        const message = JsBridgeMessage(type: 'test', data: {});

        final result = await repository.sendJsMessage('handler', message);

        expect(result, isA<FailureResult>());
        final failure = result as FailureResult;
        expect(failure.failure, isA<CacheFailure>());
      });
    });

    group('downloadFile', () {
      test('returns file path on success', () async {
        fakeFileDataSource.downloadedFiles['https://example.com/file.pdf'] =
            '/path/to/file.pdf';

        final result = await repository.downloadFile('https://example.com/file.pdf');

        expect(result, isA<Success<String>>());
        final success = result as Success<String>;
        expect(success.data, equals('/path/to/file.pdf'));
      });

      test('returns failure on download error', () async {
        fakeFileDataSource.shouldThrow = true;

        final result = await repository.downloadFile('https://example.com/file.pdf');

        expect(result, isA<FailureResult>());
        final failure = result as FailureResult;
        expect(failure.failure, isA<NetworkFailure>());
      });
    });

    group('fileExists', () {
      test('returns true when file exists', () async {
        fakeFileDataSource.existingFiles.add('/path/to/file.pdf');

        final result = await repository.fileExists('/path/to/file.pdf');

        expect(result, isA<Success<bool>>());
        final success = result as Success<bool>;
        expect(success.data, isTrue);
      });

      test('returns false when file does not exist', () async {
        final result = await repository.fileExists('/path/to/missing.pdf');

        expect(result, isA<Success<bool>>());
        final success = result as Success<bool>;
        expect(success.data, isFalse);
      });
    });

    group('deleteFile', () {
      test('deletes file successfully', () async {
        fakeFileDataSource.existingFiles.add('/path/to/file.pdf');

        final result = await repository.deleteFile('/path/to/file.pdf');

        expect(result, isA<Success<void>>());
        expect(fakeFileDataSource.existingFiles, isNot(contains('/path/to/file.pdf')));
      });
    });

    group('getLocalStorage', () {
      test('returns value from data source', () async {
        fakeLocalStorageDataSource.storage['example.com_token'] = 'stored-value';

        final result = await repository.getLocalStorage(
          'https://example.com',
          'token',
        );

        expect(result, isA<Success<String?>>());
        final success = result as Success<String?>;
        expect(success.data, equals('stored-value'));
      });

      test('returns null when key does not exist', () async {
        final result = await repository.getLocalStorage(
          'https://example.com',
          'nonexistent',
        );

        expect(result, isA<Success<String?>>());
        final success = result as Success<String?>;
        expect(success.data, isNull);
      });
    });

    group('setLocalStorage', () {
      test('sets value via data source', () async {
        final result = await repository.setLocalStorage(
          'https://example.com',
          'token',
          'new-value',
        );

        expect(result, isA<Success<void>>());
        expect(
          fakeLocalStorageDataSource.storage['example.com_token'],
          equals('new-value'),
        );
      });
    });

    group('clearLocalStorage', () {
      test('clears local storage for URL', () async {
        fakeLocalStorageDataSource.storage['example.com_token'] = 'value';
        fakeLocalStorageDataSource.storage['other.com_token'] = 'other-value';

        final result = await repository.clearLocalStorage('https://example.com');

        expect(result, isA<Success<void>>());
        expect(
          fakeLocalStorageDataSource.storage['example.com_token'],
          isNull,
        );
        expect(
          fakeLocalStorageDataSource.storage['other.com_token'],
          isNotNull,
        );
      });
    });
  });
}

// Fake implementations for testing

class FakeCookieDataSource implements WebViewCookieDataSource {
  final Map<String, Map<String, String>> cookies = {};

  @override
  Future<Map<String, String>> getCookies(String url) async {
    return cookies[url] ?? {};
  }

  @override
  Future<void> setCookies(String url, Map<String, String> cookies) async {
    this.cookies[url] = {...?this.cookies[url], ...cookies};
  }

  @override
  Future<void> clearAllCookies() async {
    cookies.clear();
  }

  @override
  Future<void> clearCookiesForUrl(String url) async {
    cookies.remove(url);
  }

  @override
  Future<void> syncCookiesToController(
    dynamic controller,
    String url,
  ) async {
    // No-op in fake
  }

  @override
  Future<Map<String, String>> extractCookiesFromController(
    dynamic controller,
  ) async {
    return {};
  }
}

class FakeFileDataSource implements WebViewFileDataSource {
  final Map<String, String> downloadedFiles = {};
  final Set<String> existingFiles = {};
  bool shouldThrow = false;

  @override
  Future<String> downloadFile(String url) async {
    if (shouldThrow) {
      throw Exception('Download failed');
    }
    return downloadedFiles[url] ?? '/default/path';
  }

  @override
  Future<bool> fileExists(String filePath) async {
    return existingFiles.contains(filePath);
  }

  @override
  Future<void> deleteFile(String filePath) async {
    existingFiles.remove(filePath);
  }

  @override
  Future<Directory> getDownloadDirectory() async {
    return Directory.systemTemp;
  }

  @override
  Future<int> getFileSize(String filePath) async {
    return 1024;
  }

  @override
  Future<List<FileSystemEntity>> listDownloadedFiles() async {
    return [];
  }

  @override
  Future<void> clearDownloadedFiles() async {
    existingFiles.clear();
  }
}

class FakeLocalStorageDataSource implements WebViewLocalStorageDataSource {
  final Map<String, String> storage = {};

  @override
  Future<String?> getValue(String url, String key) async {
    final uri = Uri.parse(url);
    final storageKey = '${uri.host}_$key';
    return storage[storageKey];
  }

  @override
  Future<void> setValue(String url, String key, String value) async {
    final uri = Uri.parse(url);
    final storageKey = '${uri.host}_$key';
    storage[storageKey] = value;
  }

  @override
  Future<void> removeValue(String url, String key) async {
    final uri = Uri.parse(url);
    final storageKey = '${uri.host}_$key';
    storage.remove(storageKey);
  }

  @override
  Future<void> clearForUrl(String url) async {
    final uri = Uri.parse(url);
    final prefix = '${uri.host}_';
    storage.removeWhere((key, _) => key.startsWith(prefix));
  }

  @override
  Future<void> clearAll() async {
    storage.clear();
  }

  @override
  Future<Map<String, String>> getAllForUrl(String url) async {
    final uri = Uri.parse(url);
    final prefix = '${uri.host}_';
    return Map.fromEntries(
      storage.entries
          .where((e) => e.key.startsWith(prefix))
          .map((e) => MapEntry(e.key.substring(prefix.length), e.value)),
    );
  }

  @override
  Future<void> setMultiple(String url, Map<String, String> values) async {
    for (final entry in values.entries) {
      await setValue(url, entry.key, entry.value);
    }
  }

  @override
  Future<Map<String, dynamic>?> getJson(String url, String key) async {
    // Not used in repository tests
    return null;
  }

  @override
  Future<void> setJson(
    String url,
    String key,
    Map<String, dynamic> value,
  ) async {
    // Not used in repository tests
  }
}