import 'package:flutter_project_template/features/webview/data/datasources/webview_cookie_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WebViewCookieDataSource', () {
    late WebViewCookieDataSource dataSource;

    setUp(() {
      dataSource = WebViewCookieDataSource();
    });

    test('gets empty cookies for unknown URL', () async {
      final cookies = await dataSource.getCookies('https://unknown.com');
      expect(cookies, isEmpty);
    });

    test('sets and gets cookies for URL', () async {
      const url = 'https://example.com';
      final cookies = {'session': 'abc123', 'user': 'test'};

      await dataSource.setCookies(url, cookies);

      final result = await dataSource.getCookies(url);
      expect(result, containsPair('session', 'abc123'));
      expect(result, containsPair('user', 'test'));
    });

    test('cookies are isolated by domain', () async {
      await dataSource.setCookies('https://example.com', {'session': 'abc'});
      await dataSource.setCookies('https://other.com', {'session': 'xyz'});

      final exampleCookies = await dataSource.getCookies('https://example.com');
      final otherCookies = await dataSource.getCookies('https://other.com');

      expect(exampleCookies, containsPair('session', 'abc'));
      expect(otherCookies, containsPair('session', 'xyz'));
    });

    test('clears all cookies', () async {
      await dataSource.setCookies('https://example.com', {'session': 'abc'});
      await dataSource.setCookies('https://other.com', {'session': 'xyz'});

      await dataSource.clearAllCookies();

      final exampleCookies = await dataSource.getCookies('https://example.com');
      final otherCookies = await dataSource.getCookies('https://other.com');

      expect(exampleCookies, isEmpty);
      expect(otherCookies, isEmpty);
    });

    test('clears cookies for specific URL', () async {
      await dataSource.setCookies('https://example.com', {'session': 'abc'});
      await dataSource.setCookies('https://other.com', {'session': 'xyz'});

      await dataSource.clearCookiesForUrl('https://example.com');

      final exampleCookies = await dataSource.getCookies('https://example.com');
      final otherCookies = await dataSource.getCookies('https://other.com');

      expect(exampleCookies, isEmpty);
      expect(otherCookies, containsPair('session', 'xyz'));
    });

    test('updates existing cookies', () async {
      const url = 'https://example.com';

      await dataSource.setCookies(url, {'session': 'abc'});
      await dataSource.setCookies(url, {'user': 'test'});

      final result = await dataSource.getCookies(url);
      expect(result, containsPair('session', 'abc'));
      expect(result, containsPair('user', 'test'));
    });
  });
}
