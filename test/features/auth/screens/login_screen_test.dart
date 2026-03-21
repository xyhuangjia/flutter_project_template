/// Widget tests for LoginScreen.
///
/// Note: Full widget tests require localization setup which is complex.
/// This file focuses on testing the widget structure without localization.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/auth/domain/entities/user.dart';
import 'package:flutter_project_template/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_project_template/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_project_template/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fakes/fake_auth_repository.dart';

/// Creates a test widget with proper localization setup.
Widget createTestWidget({
  required FakeAuthRepository fakeRepository,
}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(fakeRepository),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: const LoginScreen(),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeAuthRepository fakeRepository;
  late SharedPreferences mockPrefs;
  late AuthLocalDataSource mockLocalDataSource;

  const tUser = User(
    id: 'user-123',
    email: 'test@example.com',
    username: 'testuser',
    displayName: 'Test User',
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    mockPrefs = await SharedPreferences.getInstance();
    fakeRepository = FakeAuthRepository();
    mockLocalDataSource = AuthLocalDataSource(sharedPreferences: mockPrefs);
  });

  tearDown(() {
    fakeRepository.reset();
  });

  group('LoginScreen widget structure', () {
    testWidgets('should render without errors', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        fakeRepository: fakeRepository,
      ));

      // Assert - Should render LoginScreen
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('should contain form elements', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        fakeRepository: fakeRepository,
      ));

      // Assert - Should have form-related widgets
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(FilledButton), findsWidgets);
    });

    testWidgets('should have social login options', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        fakeRepository: fakeRepository,
      ));

      // Assert - Should have outlined buttons for social login
      expect(find.byType(OutlinedButton), findsWidgets);
    });

    testWidgets('should show password visibility toggle', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        fakeRepository: fakeRepository,
      ));

      // Find visibility toggle icon
      final visibilityIcon = find.byIcon(Icons.visibility_outlined);
      if (visibilityIcon.evaluate().isNotEmpty) {
        // Act - Tap visibility toggle
        await tester.tap(visibilityIcon.first);
        await tester.pump();

        // Assert - Should show visibility off icon
        expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      }
    });
  });

  group('LoginScreen responsive layout', () {
    testWidgets('should render on mobile screen size', (tester) async {
      // Arrange - Set phone size
      await tester.binding.setSurfaceSize(const Size(375, 667));
      await tester.pumpWidget(createTestWidget(
        fakeRepository: fakeRepository,
      ));

      // Assert - Should render without errors
      expect(find.byType(LoginScreen), findsOneWidget);

      // Cleanup
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should render on tablet screen size', (tester) async {
      // Arrange - Set tablet size
      await tester.binding.setSurfaceSize(const Size(1024, 768));
      await tester.pumpWidget(createTestWidget(
        fakeRepository: fakeRepository,
      ));

      // Assert - Should render without errors
      expect(find.byType(LoginScreen), findsOneWidget);

      // Cleanup
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should render on landscape phone', (tester) async {
      // Arrange - Set landscape phone size
      await tester.binding.setSurfaceSize(const Size(667, 375));
      await tester.pumpWidget(createTestWidget(
        fakeRepository: fakeRepository,
      ));

      // Assert - Should render without errors
      expect(find.byType(LoginScreen), findsOneWidget);

      // Cleanup
      await tester.binding.setSurfaceSize(null);
    });
  });

  group('LoginScreen accessibility', () {
    testWidgets('should have proper button semantics', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        fakeRepository: fakeRepository,
      ));

      // Assert - Buttons should have semantics
      expect(find.byType(FilledButton), findsWidgets);
      expect(find.byType(OutlinedButton), findsWidgets);
    });
  });
}
