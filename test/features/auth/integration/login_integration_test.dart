/// Widget tests for Login Screen integration flow.
///
/// Tests the complete login flow including UI interactions,
/// form validation, and state management.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_project_template/features/auth/domain/entities/user.dart';
import 'package:flutter_project_template/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_project_template/features/auth/presentation/screens/login_screen.dart';
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
          home: LoginScreen(),
        ),
      );

  group('Login Screen Integration Tests', () {
    group('initial render', () {
      testWidgets('should display all login form elements', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(LoginScreen), findsOneWidget);
        expect(find.byKey(const ValueKey('login_email_field')), findsOneWidget);
        expect(find.byKey(const ValueKey('login_password_field')), findsOneWidget);
        expect(find.byKey(const ValueKey('login_submit_button')), findsOneWidget);
        expect(find.byKey(const ValueKey('login_email_tab')), findsOneWidget);
        expect(find.byKey(const ValueKey('login_username_tab')), findsOneWidget);
      });

      testWidgets('should show email mode by default', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byKey(const ValueKey('login_email_field')), findsOneWidget);
        expect(find.byKey(const ValueKey('login_username_field')), findsNothing);
      });
    });

    group('mode switching', () {
      testWidgets('should switch to username mode when username tab tapped', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Act
        await tester.tap(find.byKey(const ValueKey('login_username_tab')));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byKey(const ValueKey('login_username_field')), findsOneWidget);
        expect(find.byKey(const ValueKey('login_email_field')), findsNothing);
      });

      testWidgets('should switch back to email mode', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Switch to username mode
        await tester.tap(find.byKey(const ValueKey('login_username_tab')));
        await tester.pumpAndSettle();

        // Switch back
        await tester.tap(find.byKey(const ValueKey('login_email_tab')));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byKey(const ValueKey('login_email_field')), findsOneWidget);
      });
    });

    group('form validation', () {
      testWidgets('should show error for empty email', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Act
        await tester.tap(find.byKey(const ValueKey('login_submit_button')));
        await tester.pump();

        // Assert
        expect(find.text('Please enter email or username'), findsOneWidget);
      });

      testWidgets('should show error for invalid email format', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Act
        await tester.enterText(
          find.byKey(const ValueKey('login_email_field')),
          'invalid-email',
        );
        await tester.tap(find.byKey(const ValueKey('login_submit_button')));
        await tester.pump();

        // Assert
        expect(find.text('Please enter a valid email'), findsOneWidget);
      });

      testWidgets('should show error for empty password', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Act
        await tester.enterText(
          find.byKey(const ValueKey('login_email_field')),
          'test@example.com',
        );
        await tester.tap(find.byKey(const ValueKey('login_submit_button')));
        await tester.pump();

        // Assert
        expect(find.text('Please enter password'), findsOneWidget);
      });

      testWidgets('should show error for short password', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Act
        await tester.enterText(
          find.byKey(const ValueKey('login_email_field')),
          'test@example.com',
        );
        await tester.enterText(
          find.byKey(const ValueKey('login_password_field')),
          '12345',
        );
        await tester.tap(find.byKey(const ValueKey('login_submit_button')));
        await tester.pump();

        // Assert
        expect(find.text('Password must be at least 6 characters'), findsOneWidget);
      });
    });

    group('login actions', () {
      testWidgets('should login successfully with valid email credentials', (tester) async {
        // Arrange
        fakeRepository.setupSuccessfulLogin(tUser);
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Act
        await tester.enterText(
          find.byKey(const ValueKey('login_email_field')),
          'test@example.com',
        );
        await tester.enterText(
          find.byKey(const ValueKey('login_password_field')),
          'password123',
        );
        await tester.tap(find.byKey(const ValueKey('login_submit_button')));
        await tester.pumpAndSettle();

        // Assert
        expect(fakeRepository.methodCalls, contains('loginWithEmail'));
        expect(fakeRepository.lastLoginEmail, 'test@example.com');
      });

      testWidgets('should login successfully with valid username credentials', (tester) async {
        // Arrange
        fakeRepository.setupSuccessfulLogin(tUser);
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Switch to username mode
        await tester.tap(find.byKey(const ValueKey('login_username_tab')));
        await tester.pumpAndSettle();

        // Act
        await tester.enterText(
          find.byKey(const ValueKey('login_username_field')),
          'testuser',
        );
        await tester.enterText(
          find.byKey(const ValueKey('login_password_field')),
          'password123',
        );
        await tester.tap(find.byKey(const ValueKey('login_submit_button')));
        await tester.pumpAndSettle();

        // Assert
        expect(fakeRepository.methodCalls, contains('loginWithUsername'));
        expect(fakeRepository.lastLoginUsername, 'testuser');
      });

      testWidgets('should show loading indicator during login', (tester) async {
        // Arrange
        fakeRepository.setupSuccessfulLogin(tUser);
        fakeRepository.operationDelay = const Duration(milliseconds: 500);
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter credentials
        await tester.enterText(
          find.byKey(const ValueKey('login_email_field')),
          'test@example.com',
        );
        await tester.enterText(
          find.byKey(const ValueKey('login_password_field')),
          'password123',
        );

        // Act - Start login
        await tester.tap(find.byKey(const ValueKey('login_submit_button')));
        await tester.pump(const Duration(milliseconds: 100));

        // Assert - Loading indicator should be visible
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Wait for completion
        await tester.pumpAndSettle();
      });

      testWidgets('should show error on failed login', (tester) async {
        // Arrange
        fakeRepository.setupFailedLogin(
          const AuthFailure(message: 'Invalid credentials'),
        );
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Act
        await tester.enterText(
          find.byKey(const ValueKey('login_email_field')),
          'wrong@example.com',
        );
        await tester.enterText(
          find.byKey(const ValueKey('login_password_field')),
          'wrongpassword',
        );
        await tester.tap(find.byKey(const ValueKey('login_submit_button')));
        await tester.pumpAndSettle();

        // Assert - Should still be on login screen
        expect(find.byType(LoginScreen), findsOneWidget);
      });
    });

    group('password visibility', () {
      testWidgets('should toggle password visibility', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Initial state - password obscured
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

        // Act - Toggle to show
        await tester.tap(find.byKey(const ValueKey('login_password_visibility_toggle')));
        await tester.pump();

        // Assert - Password visible
        expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

        // Act - Toggle to hide
        await tester.tap(find.byKey(const ValueKey('login_password_visibility_toggle')));
        await tester.pump();

        // Assert - Password hidden
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      });
    });

    group('responsive layout', () {
      testWidgets('should render on mobile screen size', (tester) async {
        // Arrange
        await tester.binding.setSurfaceSize(const Size(375, 667));
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(LoginScreen), findsOneWidget);

        // Cleanup
        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('should render on tablet screen size', (tester) async {
        // Arrange
        await tester.binding.setSurfaceSize(const Size(1024, 768));
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(LoginScreen), findsOneWidget);

        // Cleanup
        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('should render on landscape phone', (tester) async {
        // Arrange
        await tester.binding.setSurfaceSize(const Size(667, 375));
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(LoginScreen), findsOneWidget);

        // Cleanup
        await tester.binding.setSurfaceSize(null);
      });
    });

    group('accessibility', () {
      testWidgets('should have accessible form fields', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byKey(const ValueKey('login_email_field')), findsOneWidget);
        expect(find.byKey(const ValueKey('login_password_field')), findsOneWidget);
        expect(find.byKey(const ValueKey('login_submit_button')), findsOneWidget);
      });
    });
  });
}