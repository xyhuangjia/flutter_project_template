/// Widget tests for Home screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/providers/locale_provider.dart';
import 'package:flutter_project_template/features/home/domain/entities/home_entity.dart';
import 'package:flutter_project_template/features/home/presentation/providers/home_provider.dart';
import 'package:flutter_project_template/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('HomeScreen', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            homeProvider.overrideWith(() => MockHomeNotifier()),
            sharedPrefsProvider.overrideWith(() => MockSharedPrefs()),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPrefsProvider.overrideWith(() => MockSharedPrefs()),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 600));
    });

    testWidgets('shows content after loading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            homeProvider.overrideWith(() => MockHomeNotifier()),
            sharedPrefsProvider.overrideWith(() => MockSharedPrefs()),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
    });
  });
}

class MockHomeNotifier extends HomeNotifier {
  @override
  Future<HomeEntity> build() async => const HomeEntity(
        title: 'Test App',
        welcomeMessage: 'Welcome!',
        userName: 'Test User',
      );

  @override
  Future<void> updateUserName(String name) async {}

  @override
  Future<void> refresh() async {}
}

class MockSharedPrefs extends SharedPrefs {
  @override
  Future<SharedPreferences> build() async => SharedPreferences.getInstance();
}
