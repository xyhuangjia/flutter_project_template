import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project_template/features/webview/data/datasources/webview_local_storage_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('WebViewLocalStorageDataSource', () {
    late WebViewLocalStorageDataSource dataSource;
    late SharedPreferences prefs;

    setUp(() async {
      // Set initial values for SharedPreferences mock
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      dataSource = WebViewLocalStorageDataSource(
        sharedPreferences: prefs,
      );
    });

    group('getValue and setValue', () {
      test('sets and gets a value', () async {
        const url = 'https://example.com';
        const key = 'token';
        const value = 'abc123';

        await dataSource.setValue(url, key, value);
        final result = await dataSource.getValue(url, key);

        expect(result, equals(value));
      });

      test('returns null for non-existent key', () async {
        final result = await dataSource.getValue(
          'https://example.com',
          'nonexistent',
        );
        expect(result, isNull);
      });

      test('isolates values by domain', () async {
        await dataSource.setValue(
          'https://example.com',
          'token',
          'example-token',
        );
        await dataSource.setValue('https://other.com', 'token', 'other-token');

        final exampleToken = await dataSource.getValue(
          'https://example.com',
          'token',
        );
        final otherToken = await dataSource.getValue(
          'https://other.com',
          'token',
        );

        expect(exampleToken, equals('example-token'));
        expect(otherToken, equals('other-token'));
      });
    });

    group('removeValue', () {
      test('removes a value', () async {
        const url = 'https://example.com';
        await dataSource.setValue(url, 'token', 'abc123');

        await dataSource.removeValue(url, 'token');
        final result = await dataSource.getValue(url, 'token');

        expect(result, isNull);
      });

      test('does not affect other keys', () async {
        const url = 'https://example.com';
        await dataSource.setValue(url, 'token', 'abc123');
        await dataSource.setValue(url, 'user', 'john');

        await dataSource.removeValue(url, 'token');

        expect(await dataSource.getValue(url, 'token'), isNull);
        expect(await dataSource.getValue(url, 'user'), equals('john'));
      });
    });

    group('clearForUrl', () {
      test('clears all values for a URL', () async {
        const url = 'https://example.com';
        await dataSource.setValue(url, 'token', 'abc');
        await dataSource.setValue(url, 'user', 'john');

        await dataSource.clearForUrl(url);

        expect(await dataSource.getValue(url, 'token'), isNull);
        expect(await dataSource.getValue(url, 'user'), isNull);
      });

      test('does not affect other domains', () async {
        await dataSource.setValue('https://example.com', 'token', 'abc');
        await dataSource.setValue('https://other.com', 'token', 'xyz');

        await dataSource.clearForUrl('https://example.com');

        expect(
          await dataSource.getValue('https://example.com', 'token'),
          isNull,
        );
        expect(
          await dataSource.getValue('https://other.com', 'token'),
          equals('xyz'),
        );
      });
    });

    group('clearAll', () {
      test('clears all WebView local storage', () async {
        await dataSource.setValue('https://example.com', 'token', 'abc');
        await dataSource.setValue('https://other.com', 'token', 'xyz');

        await dataSource.clearAll();

        expect(
          await dataSource.getValue('https://example.com', 'token'),
          isNull,
        );
        expect(await dataSource.getValue('https://other.com', 'token'), isNull);
      });
    });

    group('getAllForUrl', () {
      test('returns all key-value pairs for a URL', () async {
        const url = 'https://example.com';
        await dataSource.setValue(url, 'token', 'abc');
        await dataSource.setValue(url, 'user', 'john');
        await dataSource.setValue('https://other.com', 'token', 'xyz');

        final result = await dataSource.getAllForUrl(url);

        expect(result, containsPair('token', 'abc'));
        expect(result, containsPair('user', 'john'));
        expect(result, isNot(contains('xyz')));
      });

      test('returns empty map when no values exist', () async {
        final result = await dataSource.getAllForUrl('https://empty.com');
        expect(result, isEmpty);
      });
    });

    group('setMultiple', () {
      test('sets multiple values at once', () async {
        const url = 'https://example.com';
        final values = {'token': 'abc', 'user': 'john', 'theme': 'dark'};

        await dataSource.setMultiple(url, values);

        expect(await dataSource.getValue(url, 'token'), equals('abc'));
        expect(await dataSource.getValue(url, 'user'), equals('john'));
        expect(await dataSource.getValue(url, 'theme'), equals('dark'));
      });
    });

    group('getJson and setJson', () {
      test('sets and gets JSON values', () async {
        const url = 'https://example.com';
        const key = 'settings';
        final value = {'darkMode': true, 'fontSize': 14};

        await dataSource.setJson(url, key, value);
        final result = await dataSource.getJson(url, key);

        expect(result, isNotNull);
        expect(result!['darkMode'], isTrue);
        expect(result['fontSize'], equals(14));
      });

      test('returns null for non-existent JSON key', () async {
        final result = await dataSource.getJson(
          'https://example.com',
          'nonexistent',
        );
        expect(result, isNull);
      });

      test('returns null for invalid JSON', () async {
        const url = 'https://example.com';
        // Set a non-JSON string
        await dataSource.setValue(url, 'invalid', 'not json');

        final result = await dataSource.getJson(url, 'invalid');
        expect(result, isNull);
      });
    });

    group('_getStorageKey', () {
      test('generates correct key format', () async {
        const url = 'https://example.com/path';
        const key = 'token';

        await dataSource.setValue(url, key, 'value');
        final prefs = await SharedPreferences.getInstance();
        final keys = prefs.getKeys();

        // Should contain domain-based prefix
        expect(
          keys.any((k) => k.contains('webview_local_storage_example.com_token')),
          isTrue,
        );
      });

      test('handles subdomains correctly', () async {
        const url1 = 'https://api.example.com';
        const url2 = 'https://www.example.com';

        await dataSource.setValue(url1, 'token', 'api-token');
        await dataSource.setValue(url2, 'token', 'www-token');

        expect(await dataSource.getValue(url1, 'token'), equals('api-token'));
        expect(await dataSource.getValue(url2, 'token'), equals('www-token'));
      });
    });
  });
}