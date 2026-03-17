/// Widget tests for Home screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/features/home/domain/entities/home_entity.dart';
import 'package:flutter_project_template/features/home/presentation/providers/home_provider.dart';
import 'package:flutter_project_template/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            homeNotifierProvider.overrideWith(() => MockHomeNotifier()),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
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
            homeNotifierProvider.overrideWith(() => MockHomeNotifier()),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
    });
  });
}

class MockHomeNotifier extends AutoDisposeAsyncNotifier<HomeEntity>
    implements HomeNotifier {
  @override
  Future<HomeEntity> build() async {
    return const HomeEntity(
      title: 'Test App',
      welcomeMessage: 'Welcome!',
      userName: 'Test User',
    );
  }

  @override
  Future<void> updateUserName(String name) async {}

  @override
  Future<void> refresh() async {}
}
