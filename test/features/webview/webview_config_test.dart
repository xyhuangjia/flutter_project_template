import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project_template/features/webview/domain/entities/webview_config.dart';

void main() {
  group('WebViewConfig', () {
    test('creates config with required url', () {
      const config = WebViewConfig(url: 'https://example.com');

      expect(config.url, equals('https://example.com'));
      expect(config.showAppBar, isTrue);
      expect(config.enableJavaScript, isTrue);
      expect(config.enableDomStorage, isTrue);
      expect(config.enableCache, isTrue);
    });

    test('creates config with custom options', () {
      const config = WebViewConfig(
        url: 'https://example.com',
        title: 'Test Page',
        showAppBar: false,
        enableJavaScript: false,
        enableDomStorage: false,
        enableCache: false,
        userAgent: 'CustomAgent',
        blockedUrls: ['https://blocked.com'],
        allowedSchemes: ['http', 'https', 'custom'],
      );

      expect(config.url, equals('https://example.com'));
      expect(config.title, equals('Test Page'));
      expect(config.showAppBar, isFalse);
      expect(config.enableJavaScript, isFalse);
      expect(config.enableDomStorage, isFalse);
      expect(config.enableCache, isFalse);
      expect(config.userAgent, equals('CustomAgent'));
      expect(config.blockedUrls, contains('https://blocked.com'));
      expect(config.allowedSchemes, contains('custom'));
    });

    test('copyWith creates new config with updated values', () {
      const original = WebViewConfig(url: 'https://example.com');
      final updated = original.copyWith(
        url: 'https://updated.com',
        title: 'Updated Title',
        showAppBar: false,
      );

      expect(original.url, equals('https://example.com'));
      expect(updated.url, equals('https://updated.com'));
      expect(updated.title, equals('Updated Title'));
      expect(updated.showAppBar, isFalse);
      expect(updated.enableJavaScript, isTrue);
    });

    test('equality compares all fields', () {
      const config1 = WebViewConfig(url: 'https://example.com');
      const config2 = WebViewConfig(url: 'https://example.com');
      const config3 = WebViewConfig(url: 'https://different.com');

      expect(config1, equals(config2));
      expect(config1, isNot(equals(config3)));
    });
  });
}
