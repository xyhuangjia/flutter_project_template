/// Widget tests for LoginForm.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/features/auth/presentation/widgets/login_form.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginForm', () {
    late bool emailLoginCalled;
    late bool usernameLoginCalled;
    late String? capturedEmail;
    late String? capturedUsername;
    late String? capturedPassword;
    late bool loginResult;

    Future<bool> mockEmailLogin(String email, String password) async {
      emailLoginCalled = true;
      capturedEmail = email;
      capturedPassword = password;
      return loginResult;
    }

    Future<bool> mockUsernameLogin(String username, String password) async {
      usernameLoginCalled = true;
      capturedUsername = username;
      capturedPassword = password;
      return loginResult;
    }

    setUp(() {
      emailLoginCalled = false;
      usernameLoginCalled = false;
      capturedEmail = null;
      capturedUsername = null;
      capturedPassword = null;
      loginResult = true;
    });

    Widget createTestWidget({bool isLoading = false}) => MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(
            body: LoginForm(
              onEmailLogin: mockEmailLogin,
              onUsernameLogin: mockUsernameLogin,
              isLoading: isLoading,
            ),
          ),
        );

    group('rendering', () {
      testWidgets('should render form with email mode by default', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(Form), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(2));
        expect(find.byType(FilledButton), findsOneWidget);
        expect(find.byType(ChoiceChip), findsNWidgets(2));
      });

      testWidgets('should show email field label by default', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Assert - 'Email' appears in both ChoiceChip and TextFormField label
        expect(find.text('Email'), findsWidgets);
      });

      testWidgets('should show password field', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.text('Password'), findsOneWidget);
      });

      testWidgets('should show login button', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.text('Login'), findsOneWidget);
      });

      testWidgets('should show loading indicator when isLoading is true', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(isLoading: true));

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Login'), findsNothing);
      });
    });

    group('mode switching', () {
      testWidgets('should switch to username mode when username chip tapped', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Find and tap username chip
        final usernameChips = find.widgetWithText(ChoiceChip, 'Username');
        expect(usernameChips, findsOneWidget);

        await tester.tap(usernameChips);
        await tester.pumpAndSettle();

        // Assert - Should now show username field
        expect(find.byKey(const ValueKey('login_username_field')), findsOneWidget);
      });

      testWidgets('should switch back to email mode when email chip tapped', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Switch to username mode
        await tester.tap(find.widgetWithText(ChoiceChip, 'Username'));
        await tester.pumpAndSettle();

        // Switch back to email mode
        await tester.tap(find.widgetWithText(ChoiceChip, 'Email'));
        await tester.pumpAndSettle();

        // Assert - Should show email field
        expect(find.byKey(const ValueKey('login_email_field')), findsOneWidget);
      });
    });

    group('password visibility', () {
      testWidgets('should show visibility icon for password field', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Assert - Should have visibility toggle icon
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      });

      testWidgets('should toggle password visibility when icon tapped', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Find visibility toggle button
        final visibilityToggle = find.byIcon(Icons.visibility_outlined);
        expect(visibilityToggle, findsOneWidget);

        // Tap to show password
        await tester.tap(visibilityToggle);
        await tester.pump();

        // Assert - Should show visibility off icon (password now visible)
        expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

        // Tap again to hide password
        await tester.tap(find.byIcon(Icons.visibility_off_outlined));
        await tester.pump();

        // Assert - Should show visibility icon again (password hidden)
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      });
    });

    group('form validation', () {
      testWidgets('should show error for empty email', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Tap login button without entering data
        await tester.tap(find.text('Login'));
        await tester.pump();

        // Assert
        expect(find.text('Please enter email or username'), findsOneWidget);
      });

      testWidgets('should show error for invalid email format', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Enter invalid email
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'),
          'invalid-email',
        );

        // Tap login button
        await tester.tap(find.text('Login'));
        await tester.pump();

        // Assert
        expect(find.text('Please enter a valid email'), findsOneWidget);
      });

      testWidgets('should show error for empty password', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Enter email but not password
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'),
          'test@example.com',
        );

        // Tap login button
        await tester.tap(find.text('Login'));
        await tester.pump();

        // Assert
        expect(find.text('Please enter password'), findsOneWidget);
      });

      testWidgets('should show error for short password', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Enter valid email and short password
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'),
          'test@example.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'),
          '12345',
        );

        // Tap login button
        await tester.tap(find.text('Login'));
        await tester.pump();

        // Assert
        expect(find.text('Password must be at least 6 characters'), findsOneWidget);
      });

      testWidgets('should show error for short username', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Switch to username mode
        await tester.tap(find.widgetWithText(ChoiceChip, 'Username'));
        await tester.pumpAndSettle();

        // Enter short username
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Username'),
          'ab',
        );

        // Tap login button
        await tester.tap(find.text('Login'));
        await tester.pump();

        // Assert
        expect(find.text('Username must be at least 3 characters'), findsOneWidget);
      });
    });

    group('form submission', () {
      testWidgets('should call onEmailLogin with correct parameters', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Enter valid credentials
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'),
          'test@example.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'),
          'password123',
        );

        // Submit form
        await tester.tap(find.text('Login'));
        await tester.pumpAndSettle();

        // Assert
        expect(emailLoginCalled, isTrue);
        expect(capturedEmail, 'test@example.com');
        expect(capturedPassword, 'password123');
      });

      testWidgets('should call onUsernameLogin with correct parameters', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Switch to username mode
        await tester.tap(find.widgetWithText(ChoiceChip, 'Username'));
        await tester.pumpAndSettle();

        // Enter valid credentials
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Username'),
          'testuser',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'),
          'password123',
        );

        // Submit form
        await tester.tap(find.text('Login'));
        await tester.pumpAndSettle();

        // Assert
        expect(usernameLoginCalled, isTrue);
        expect(capturedUsername, 'testuser');
        expect(capturedPassword, 'password123');
      });

      testWidgets('should trim email/username input', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Enter email with spaces
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'),
          '  test@example.com  ',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'),
          'password123',
        );

        // Submit form
        await tester.tap(find.text('Login'));
        await tester.pumpAndSettle();

        // Assert
        expect(capturedEmail, 'test@example.com');
      });

      testWidgets('should not submit if validation fails', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Enter invalid data
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'),
          'invalid-email',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'),
          '123',
        );

        // Try to submit form
        await tester.tap(find.text('Login'));
        await tester.pump();

        // Assert
        expect(emailLoginCalled, isFalse);
      });
    });

    group('loading state', () {
      testWidgets('should disable form fields when loading', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(isLoading: true));

        // Find form fields
        final emailField = tester.widget<TextFormField>(
          find.widgetWithText(TextFormField, 'Email'),
        );
        final passwordField = tester.widget<TextFormField>(
          find.widgetWithText(TextFormField, 'Password'),
        );

        // Assert
        expect(emailField.enabled, isFalse);
        expect(passwordField.enabled, isFalse);
      });

      testWidgets('should disable button when loading', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(isLoading: true));

        // Find login button
        final button = tester.widget<FilledButton>(find.byType(FilledButton));

        // Assert
        expect(button.onPressed, isNull);
      });
    });

    group('keyboard actions', () {
      testWidgets('should submit form when done is pressed on password field', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Enter valid credentials
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'),
          'test@example.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'),
          'password123',
        );

        // Simulate done action on password field
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        // Assert
        expect(emailLoginCalled, isTrue);
      });
    });

    group('accessibility', () {
      testWidgets('should have accessible form fields', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Assert - Form fields should have labels
        // Use firstMatch for 'Email' since it appears in both tab and label
        expect(find.text('Email').first, findsOneWidget);
        expect(find.text('Password'), findsOneWidget);
      });

      testWidgets('should have accessible button', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Assert
        final button = find.byType(FilledButton);
        expect(button, findsOneWidget);
      });
    });
  });
}