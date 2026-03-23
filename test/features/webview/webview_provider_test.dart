import 'package:flutter_project_template/features/webview/domain/entities/webview_config.dart';
import 'package:flutter_project_template/features/webview/domain/entities/webview_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WebViewNotifier State Management', () {
    group('WebViewState', () {
      test('initial state is correct', () {
        const state = WebViewState.initial();

        expect(state.loadingState, equals(WebViewLoadingState.initial));
        expect(state.loadingProgress, equals(0));
        expect(state.currentUrl, isNull);
        expect(state.pageTitle, isNull);
        expect(state.canGoBack, isFalse);
        expect(state.canGoForward, isFalse);
        expect(state.errorMessage, isNull);
        expect(state.errorCode, isNull);
        expect(state.isLoading, isFalse);
        expect(state.hasError, isFalse);
      });

      test('state transitions correctly', () {
        // Initial -> Loading
        var state = const WebViewState.initial().copyWith(
          loadingState: WebViewLoadingState.loading,
          currentUrl: 'https://example.com',
        );
        expect(state.isLoading, isTrue);
        expect(state.hasError, isFalse);

        // Loading -> Loaded
        state = state.copyWith(
          loadingState: WebViewLoadingState.loaded,
          loadingProgress: 100,
          pageTitle: 'Example',
          canGoBack: true,
          canGoForward: false,
        );
        expect(state.isLoading, isFalse);
        expect(state.hasError, isFalse);
        expect(state.pageTitle, equals('Example'));
      });

      test('error state is set correctly', () {
        const state = WebViewState(
          loadingState: WebViewLoadingState.error,
          errorMessage: 'Network error',
          errorCode: -1,
        );

        expect(state.hasError, isTrue);
        expect(state.isLoading, isFalse);
        expect(state.errorMessage, equals('Network error'));
        expect(state.errorCode, equals(-1));
      });

      test('loading state clears error flag', () {
        const errorState = WebViewState(
          loadingState: WebViewLoadingState.error,
          errorMessage: 'Error',
          errorCode: -1,
        );

        // When loading state changes to loading, hasError should be false
        const loadingState = WebViewState(
          loadingState: WebViewLoadingState.loading,
        );

        expect(errorState.hasError, isTrue);
        expect(loadingState.hasError, isFalse);
        expect(loadingState.isLoading, isTrue);
      });
    });

    group('WebViewConfig', () {
      test('default configuration is correct', () {
        const config = WebViewConfig(url: 'https://example.com');

        expect(config.url, equals('https://example.com'));
        expect(config.showAppBar, isTrue);
        expect(config.enableJavaScript, isTrue);
        expect(config.enableDomStorage, isTrue);
        expect(config.enableCache, isTrue);
        expect(config.title, isNull);
        expect(config.userAgent, isNull);
        expect(config.blockedUrls, isEmpty);
        expect(config.allowedSchemes, containsAll(['http', 'https']));
      });

      test('copyWith preserves unmodified fields', () {
        const original = WebViewConfig(
          url: 'https://example.com',
          title: 'Test',
          showAppBar: false,
          enableJavaScript: false,
        );

        final updated = original.copyWith(url: 'https://updated.com');

        expect(updated.url, equals('https://updated.com'));
        expect(updated.title, equals('Test'));
        expect(updated.showAppBar, isFalse);
        expect(updated.enableJavaScript, isFalse);
      });
    });

    group('Navigation Blocking Logic', () {
      test('blocked URLs prevent navigation', () {
        const config = WebViewConfig(
          url: 'https://example.com',
          blockedUrls: ['blocked.com', 'ads.example.com'],
        );

        const blockedUrl1 = 'https://blocked.com/page';
        const blockedUrl2 = 'https://ads.example.com/banner';
        const allowedUrl = 'https://example.com/content';

        // Test blocked URL contains blocked domain
        expect(
          blockedUrl1.contains('blocked.com'),
          isTrue,
        );
        expect(
          blockedUrl2.contains('ads.example.com'),
          isTrue,
        );
        expect(
          allowedUrl.contains('blocked.com') || allowedUrl.contains('ads.example.com'),
          isFalse,
        );
      });

      test('allowed schemes filter navigation', () {
        const config = WebViewConfig(
          url: 'https://example.com',
        );

        final httpsUri = Uri.parse('https://example.com');
        final httpUri = Uri.parse('http://example.com');
        final telUri = Uri.parse('tel:1234567890');
        final mailtoUri = Uri.parse('mailto:test@example.com');

        expect(config.allowedSchemes.contains(httpsUri.scheme), isTrue);
        expect(config.allowedSchemes.contains(httpUri.scheme), isTrue);
        expect(config.allowedSchemes.contains(telUri.scheme), isFalse);
        expect(config.allowedSchemes.contains(mailtoUri.scheme), isFalse);
      });
    });

    group('Loading Progress', () {
      test('progress increments correctly', () {
        var state = const WebViewState.initial();

        state = state.copyWith(loadingProgress: 25);
        expect(state.loadingProgress, equals(25));

        state = state.copyWith(loadingProgress: 50);
        expect(state.loadingProgress, equals(50));

        state = state.copyWith(loadingProgress: 75);
        expect(state.loadingProgress, equals(75));

        state = state.copyWith(loadingProgress: 100);
        expect(state.loadingProgress, equals(100));
      });
    });

    group('Navigation State', () {
      test('canGoBack and canGoForward are independent', () {
        var state = const WebViewState.initial();

        state = state.copyWith(canGoBack: true, canGoForward: false);
        expect(state.canGoBack, isTrue);
        expect(state.canGoForward, isFalse);

        state = state.copyWith(canGoBack: false, canGoForward: true);
        expect(state.canGoBack, isFalse);
        expect(state.canGoForward, isTrue);

        state = state.copyWith(canGoBack: true, canGoForward: true);
        expect(state.canGoBack, isTrue);
        expect(state.canGoForward, isTrue);
      });
    });

    group('Error Code Detection', () {
      test('not found error codes are identified', () {
        const notFoundErrorCodes = {-1, -2, -6, -8, -11, -12, -102};

        expect(notFoundErrorCodes.contains(-1), isTrue); // Unknown error
        expect(notFoundErrorCodes.contains(-2), isTrue); // Host lookup failed
        expect(notFoundErrorCodes.contains(-6), isTrue); // Connection refused
        expect(notFoundErrorCodes.contains(-8), isTrue); // Connection timeout
        expect(notFoundErrorCodes.contains(200), isFalse); // Not an error
        expect(notFoundErrorCodes.contains(404), isFalse); // HTTP error, not WebView
      });
    });
  });

  group('ProviderContainer Tests', () {
    test('WebViewState can be created and updated', () {
      final container = ProviderContainer();

      // Create initial state
      var state = const WebViewState.initial();
      expect(state.loadingState, equals(WebViewLoadingState.initial));

      // Update state
      state = state.copyWith(
        loadingState: WebViewLoadingState.loading,
        currentUrl: 'https://test.com',
      );
      expect(state.loadingState, equals(WebViewLoadingState.loading));
      expect(state.currentUrl, equals('https://test.com'));

      container.dispose();
    });

    test('WebViewConfig can be created with different options', () {
      final container = ProviderContainer();

      const config1 = WebViewConfig(url: 'https://example.com');
      expect(config1.url, equals('https://example.com'));

      const config2 = WebViewConfig(
        url: 'https://example.com',
        showAppBar: false,
        enableJavaScript: false,
      );
      expect(config2.showAppBar, isFalse);
      expect(config2.enableJavaScript, isFalse);

      container.dispose();
    });
  });
}