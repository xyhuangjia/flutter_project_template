import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project_template/features/webview/presentation/widgets/webview_loading_indicator.dart';

void main() {
  group('WebViewLoadingIndicator', () {
    testWidgets('renders LinearProgressIndicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WebViewLoadingIndicator(progress: 50),
          ),
        ),
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('displays correct progress value', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WebViewLoadingIndicator(progress: 75),
          ),
        ),
      );

      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, equals(0.75));
    });

    testWidgets('handles 0 progress', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WebViewLoadingIndicator(progress: 0),
          ),
        ),
      );

      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, equals(0.0));
    });

    testWidgets('handles 100 progress', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WebViewLoadingIndicator(progress: 100),
          ),
        ),
      );

      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, equals(1.0));
    });

    testWidgets('uses default height when not specified', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WebViewLoadingIndicator(progress: 50),
          ),
        ),
      );

      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.minHeight, equals(3.0));
    });

    testWidgets('uses custom height when specified', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WebViewLoadingIndicator(
              progress: 50,
              height: 5.0,
            ),
          ),
        ),
      );

      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.minHeight, equals(5.0));
    });

    testWidgets('applies theme colors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              surfaceContainerHighest: Colors.grey,
            ),
          ),
          home: const Scaffold(
            body: WebViewLoadingIndicator(progress: 50),
          ),
        ),
      );

      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );

      expect(indicator.backgroundColor, equals(Colors.grey));
      // valueColor is AlwaysStoppedAnimation, just verify it's not null
      expect(indicator.valueColor, isNotNull);
    });

    testWidgets('progress calculations are correct', (tester) async {
      final testCases = [
        {'progress': 0, 'expected': 0.0},
        {'progress': 25, 'expected': 0.25},
        {'progress': 50, 'expected': 0.5},
        {'progress': 75, 'expected': 0.75},
        {'progress': 100, 'expected': 1.0},
      ];

      for (final testCase in testCases) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WebViewLoadingIndicator(
                progress: testCase['progress'] as int,
              ),
            ),
          ),
        );

        final indicator = tester.widget<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator),
        );
        expect(
          indicator.value,
          equals(testCase['expected']),
          reason: 'Progress ${testCase['progress']} should equal ${testCase['expected']}',
        );
      }
    });
  });
}