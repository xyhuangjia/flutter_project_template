import 'package:flutter_project_template/features/webview/domain/entities/webview_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WebViewState', () {
    test('creates initial state', () {
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

    test('creates state with custom values', () {
      const state = WebViewState(
        loadingState: WebViewLoadingState.loading,
        loadingProgress: 50,
        currentUrl: 'https://example.com',
        pageTitle: 'Example',
        canGoBack: true,
      );

      expect(state.loadingState, equals(WebViewLoadingState.loading));
      expect(state.loadingProgress, equals(50));
      expect(state.currentUrl, equals('https://example.com'));
      expect(state.pageTitle, equals('Example'));
      expect(state.canGoBack, isTrue);
      expect(state.canGoForward, isFalse);
      expect(state.isLoading, isTrue);
      expect(state.hasError, isFalse);
    });

    test('creates error state', () {
      const state = WebViewState(
        loadingState: WebViewLoadingState.error,
        errorMessage: 'Failed to load',
        errorCode: -1,
      );

      expect(state.loadingState, equals(WebViewLoadingState.error));
      expect(state.errorMessage, equals('Failed to load'));
      expect(state.errorCode, equals(-1));
      expect(state.hasError, isTrue);
      expect(state.isLoading, isFalse);
    });

    test('copyWith creates new state with updated values', () {
      const original = WebViewState.initial();
      final updated = original.copyWith(
        loadingState: WebViewLoadingState.loading,
        loadingProgress: 30,
        currentUrl: 'https://example.com',
      );

      expect(original.loadingState, equals(WebViewLoadingState.initial));
      expect(updated.loadingState, equals(WebViewLoadingState.loading));
      expect(updated.loadingProgress, equals(30));
      expect(updated.currentUrl, equals('https://example.com'));
    });

    test('equality compares all fields', () {
      const state1 = WebViewState(
        loadingState: WebViewLoadingState.loaded,
        currentUrl: 'https://example.com',
      );
      const state2 = WebViewState(
        loadingState: WebViewLoadingState.loaded,
        currentUrl: 'https://example.com',
      );
      const state3 = WebViewState(
        loadingState: WebViewLoadingState.loaded,
        currentUrl: 'https://different.com',
      );

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });
  });

  group('WebViewLoadingState', () {
    test('has correct values', () {
      expect(WebViewLoadingState.initial.name, equals('initial'));
      expect(WebViewLoadingState.loading.name, equals('loading'));
      expect(WebViewLoadingState.loaded.name, equals('loaded'));
      expect(WebViewLoadingState.error.name, equals('error'));
    });
  });
}
