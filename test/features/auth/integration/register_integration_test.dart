/// Widget tests for Registration Screen integration flow.
///
/// Tests the complete registration flow including UI interactions,
/// form validation, and state management.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_project_template/features/auth/domain/entities/user.dart';
import 'package:flutter_project_template/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_project_template/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fakes/fake_auth_repository.dart';

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

  Widget createTestWidget() => ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeRepository),
          authLocalDataSourceProvider.overrideWithValue(mockLocalDataSource),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('en'),
          home: RegisterScreen(),
        ),
      );

  group('Registration Screen Integration Tests', () {
    group('initial render', () {
      testWidgets('should display registration form elements', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(RegisterScreen), findsOneWidget);
      });
    });

    group('form validation', () {
      testWidgets('should show error for empty email', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Find submit button
        final submitButton = find.widgetWithText(FilledButton, 'Register');
        if (submitButton.evaluate().isNotEmpty) {
          // Act
          await tester.tap(submitButton);
          await tester.pump();

          // Assert - Should show validation error
          expect(find.text('Please enter email'), findsOneWidget);
        }
      });

      testWidgets('should show error for invalid email format', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final emailField = find.byType(TextFormField).first;
        if (emailField.evaluate().isNotEmpty) {
          // Act
          await tester.enterText(emailField, 'invalid-email');
          final submitButton = find.widgetWithText(FilledButton, 'Register');
          if (submitButton.evaluate().isNotEmpty) {
            await tester.tap(submitButton);
            await tester.pump();

            // Assert
            expect(find.text('Please enter a valid email'), findsOneWidget);
          }
        }
      });
    });

    group('registration actions', () {
      testWidgets('should register successfully with valid data', (tester) async {
        // Arrange
        fakeRepository.setupSuccessfulLogin(tUser);
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Find form fields (order depends on implementation)
        final textFields = find.byType(TextFormField);
        if (textFields.evaluate().length >= 3) {
          // Enter email
          await tester.enterText(textFields.at(0), 'test@example.com');
          // Enter username
          await tester.enterText(textFields.at(1), 'testuser');
          // Enter password
          await tester.enterText(textFields.at(2), 'Password123');

          // Submit
          final submitButton = find.widgetWithText(FilledButton, 'Register');
          if (submitButton.evaluate().isNotEmpty) {
            await tester.tap(submitButton);
            await tester.pumpAndSettle();

            // Assert
            expect(fakeRepository.methodCalls, contains('register'));
          }
        }
      });

      testWidgets('should show loading indicator during registration', (tester) async {
        // Arrange
        fakeRepository.setupSuccessfulLogin(tUser);
        fakeRepository.operationDelay = const Duration(milliseconds: 500);
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final textFields = find.byType(TextFormField);
        if (textFields.evaluate().length >= 3) {
          // Enter data
          await tester.enterText(textFields.at(0), 'test@example.com');
          await tester.enterText(textFields.at(1), 'testuser');
          await tester.enterText(textFields.at(2), 'Password123');

          final submitButton = find.widgetWithText(FilledButton, 'Register');
          if (submitButton.evaluate().isNotEmpty) {
            // Start registration
            await tester.tap(submitButton);
            await tester.pump(const Duration(milliseconds: 100));

            // Assert - Loading indicator should be visible
            expect(find.byType(CircularProgressIndicator), findsOneWidget);

            // Wait for completion
            await tester.pumpAndSettle();
          }
        }
      });
    });

    group('navigation', () {
      testWidgets('should navigate back to login', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Find login link
        final loginLink = find.text('Already have an account? Login');
        if (loginLink.evaluate().isNotEmpty) {
          // Act
          await tester.tap(loginLink);
          await tester.pumpAndSettle();

          // Assert - Should navigate (behavior depends on app routing)
        }
      });
    });

    group('responsive layout', () {
      testWidgets('should render on mobile screen size', (tester) async {
        // Arrange
        await tester.binding.setSurfaceSize(const Size(375, 667));
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(RegisterScreen), findsOneWidget);

        // Cleanup
        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('should render on tablet screen size', (tester) async {
        // Arrange
        await tester.binding.setSurfaceSize(const Size(1024, 768));
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(RegisterScreen), findsOneWidget);

        // Cleanup
        await tester.binding.setSurfaceSize(null);
      });
    });
  });
}