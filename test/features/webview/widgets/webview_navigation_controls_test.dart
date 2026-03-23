import 'package:flutter/material.dart';
import 'package:flutter_project_template/features/webview/presentation/widgets/webview_navigation_controls.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget createTestWidget({
    required Widget child,
  }) => ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: child,
        ),
      ),
    );

  group('WebViewNavigationControls', () {
    testWidgets('renders all buttons', (tester) async {
      var backPressed = false;
      var forwardPressed = false;
      var refreshPressed = false;

      await tester.pumpWidget(createTestWidget(
        child: WebViewNavigationControls(
          canGoBack: true,
          canGoForward: true,
          onBack: () => backPressed = true,
          onForward: () => forwardPressed = true,
          onRefresh: () => refreshPressed = true,
        ),
      ),);

      // Find all IconButtons
      expect(find.byType(IconButton), findsNWidgets(3));

      // Find specific icons
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('back button is disabled when canGoBack is false', (tester) async {
      await tester.pumpWidget(createTestWidget(
        child: WebViewNavigationControls(
          canGoBack: false,
          canGoForward: true,
          onBack: () {},
          onForward: () {},
          onRefresh: () {},
        ),
      ),);

      final backButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.arrow_back),
      );
      expect(backButton.onPressed, isNull);
    });

    testWidgets('forward button is disabled when canGoForward is false', (tester) async {
      await tester.pumpWidget(createTestWidget(
        child: WebViewNavigationControls(
          canGoBack: true,
          canGoForward: false,
          onBack: () {},
          onForward: () {},
          onRefresh: () {},
        ),
      ),);

      final forwardButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.arrow_forward),
      );
      expect(forwardButton.onPressed, isNull);
    });

    testWidgets('refresh button is always enabled', (tester) async {
      await tester.pumpWidget(createTestWidget(
        child: WebViewNavigationControls(
          canGoBack: false,
          canGoForward: false,
          onBack: () {},
          onForward: () {},
          onRefresh: () {},
        ),
      ),);

      final refreshButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.refresh),
      );
      expect(refreshButton.onPressed, isNotNull);
    });

    testWidgets('hides refresh button when showRefresh is false', (tester) async {
      await tester.pumpWidget(createTestWidget(
        child: WebViewNavigationControls(
          canGoBack: true,
          canGoForward: true,
          onBack: () {},
          onForward: () {},
          onRefresh: () {},
          showRefresh: false,
        ),
      ),);

      expect(find.byIcon(Icons.refresh), findsNothing);
      expect(find.byType(IconButton), findsNWidgets(2)); // Back and forward only
    });

    testWidgets('calls onBack when back button is tapped', (tester) async {
      var backPressed = false;

      await tester.pumpWidget(createTestWidget(
        child: WebViewNavigationControls(
          canGoBack: true,
          canGoForward: true,
          onBack: () => backPressed = true,
          onForward: () {},
          onRefresh: () {},
        ),
      ),);

      await tester.tap(find.byIcon(Icons.arrow_back));
      expect(backPressed, isTrue);
    });

    testWidgets('calls onForward when forward button is tapped', (tester) async {
      var forwardPressed = false;

      await tester.pumpWidget(createTestWidget(
        child: WebViewNavigationControls(
          canGoBack: true,
          canGoForward: true,
          onBack: () {},
          onForward: () => forwardPressed = true,
          onRefresh: () {},
        ),
      ),);

      await tester.tap(find.byIcon(Icons.arrow_forward));
      expect(forwardPressed, isTrue);
    });

    testWidgets('calls onRefresh when refresh button is tapped', (tester) async {
      var refreshPressed = false;

      await tester.pumpWidget(createTestWidget(
        child: WebViewNavigationControls(
          canGoBack: true,
          canGoForward: true,
          onBack: () {},
          onForward: () {},
          onRefresh: () => refreshPressed = true,
        ),
      ),);

      await tester.tap(find.byIcon(Icons.refresh));
      expect(refreshPressed, isTrue);
    });
  });
}