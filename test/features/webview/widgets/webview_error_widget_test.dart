import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project_template/features/webview/presentation/widgets/webview_error_widget.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget createTestWidget({
    required Widget child,
  }) {
    return ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: child,
        ),
      ),
    );
  }

  group('WebViewErrorWidget', () {
    testWidgets('renders error message', (tester) async {
      const errorMessage = 'Failed to load page';

      await tester.pumpWidget(createTestWidget(
        child: WebViewErrorWidget(
          errorMessage: errorMessage,
          onRetry: () {},
        ),
      ));

      // The widget should render the error message
      expect(find.textContaining(errorMessage), findsOneWidget);
    });

    testWidgets('renders error icon', (tester) async {
      await tester.pumpWidget(createTestWidget(
        child: WebViewErrorWidget(
          errorMessage: 'Error',
          onRetry: () {},
        ),
      ));

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('renders retry icon', (tester) async {
      await tester.pumpWidget(createTestWidget(
        child: WebViewErrorWidget(
          errorMessage: 'Error',
          onRetry: () {},
        ),
      ));

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('shows error code when provided', (tester) async {
      await tester.pumpWidget(createTestWidget(
        child: WebViewErrorWidget(
          errorMessage: 'Error',
          errorCode: 404,
          onRetry: () {},
        ),
      ));

      expect(find.textContaining('404'), findsOneWidget);
    });

    testWidgets('applies error color to icon', (tester) async {
      await tester.pumpWidget(createTestWidget(
        child: WebViewErrorWidget(
          errorMessage: 'Error',
          onRetry: () {},
        ),
      ));

      final icon = tester.widget<Icon>(find.byIcon(Icons.error_outline));
      final theme = Theme.of(tester.element(find.byIcon(Icons.error_outline)));

      expect(icon.color, equals(theme.colorScheme.error));
    });

    testWidgets('has padding around content', (tester) async {
      await tester.pumpWidget(createTestWidget(
        child: WebViewErrorWidget(
          errorMessage: 'Error',
          onRetry: () {},
        ),
      ));

      // Verify padding widget exists
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('uses column layout for vertical arrangement', (tester) async {
      await tester.pumpWidget(createTestWidget(
        child: WebViewErrorWidget(
          errorMessage: 'Error',
          errorCode: 404,
          onRetry: () {},
        ),
      ));

      final column = tester.widget<Column>(find.byType(Column));
      expect(column.mainAxisAlignment, equals(MainAxisAlignment.center));
    });
  });
}