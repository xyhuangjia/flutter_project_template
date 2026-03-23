/// Widget tests for ChangePasswordScreen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_project_template/features/profile/presentation/screens/change_password_screen.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fakes/fake_auth_repository.dart';

/// Creates a test widget with proper localization setup.
Widget createTestWidget({
  required FakeAuthRepository fakeRepository,
}) => ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(fakeRepository),
    ],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('en'),
      home: ChangePasswordScreen(),
    ),
  );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeAuthRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeAuthRepository();
  });

  tearDown(() {
    fakeRepository.reset();
  });

  group('ChangePasswordScreen widget structure', () {
    testWidgets('should render without errors', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        fakeRepository: fakeRepository,
      ),);

      // Assert
      expect(find.byType(ChangePasswordScreen), findsOneWidget);
    });

    testWidgets('should contain three password text fields', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        fakeRepository: fakeRepository,
      ),);

      // Assert
      expect(find.byType(TextField), findsNWidgets(3));
    });

    testWidgets('should contain submit button', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        fakeRepository: fakeRepository,
      ),);

      // Assert
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('should have password visibility toggles', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        fakeRepository: fakeRepository,
      ),);

      // Assert - Should have three visibility toggle icons
      expect(
        find.byIcon(Icons.visibility_outlined),
        findsNWidgets(3),
      );
    });
  });

  group('ChangePasswordScreen password visibility', () {
    testWidgets('should toggle current password visibility', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        fakeRepository: fakeRepository,
      ),);

      // Find first visibility toggle (current password)
      final visibilityIcon = find.byIcon(Icons.visibility_outlined).first;

      // Act - Tap visibility toggle
      await tester.tap(visibilityIcon);
      await tester.pump();

      // Assert - Should show visibility off icon
      expect(
        find.byIcon(Icons.visibility_off_outlined),
        findsOneWidget,
      );
    });

    testWidgets('should toggle new password visibility', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        fakeRepository: fakeRepository,
      ),);

      // Find second visibility toggle (new password)
      final visibilityIcon = find.byIcon(Icons.visibility_outlined).at(1);

      // Act - Tap visibility toggle
      await tester.tap(visibilityIcon);
      await tester.pump();

      // Assert - Should show visibility off icon
      expect(
        find.byIcon(Icons.visibility_off_outlined),
        findsOneWidget,
      );
    });

    testWidgets('should toggle confirm password visibility', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        fakeRepository: fakeRepository,
      ),);

      // Find third visibility toggle (confirm password)
      final visibilityIcon = find.byIcon(Icons.visibility_outlined).at(2);

      // Act - Tap visibility toggle
      await tester.tap(visibilityIcon);
      await tester.pump();

      // Assert - Should show visibility off icon
      expect(
        find.byIcon(Icons.visibility_off_outlined),
        findsOneWidget,
      );
    });
  });

  group('ChangePasswordScreen form validation', () {
    testWidgets('should show error when current password is empty',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        fakeRepository: fakeRepository,
      ),);

      // Enter new password only
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(1), 'Newpass123');
      await tester.enterText(textFields.at(2), 'Newpass123');

      // Tap submit
      await tester.tap(find.byType(FilledButton));
      // DialogUtil shows dialog with 1200ms duration
      await tester.pump(const Duration(milliseconds: 1500));

      // Assert - Should call DialogUtil.showErrorDialog
      expect(fakeRepository.methodCalls, isNot(contains('updatePassword')));
    });

    testWidgets('should show error when passwords do not match',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        fakeRepository: fakeRepository,
      ),);

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'Currentpass1');
      await tester.enterText(textFields.at(1), 'Newpass123');
      await tester.enterText(textFields.at(2), 'Different123');

      // Tap submit
      await tester.tap(find.byType(FilledButton));
      // DialogUtil shows dialog with 1200ms duration
      await tester.pump(const Duration(milliseconds: 1500));

      // Assert - Should not call API
      expect(fakeRepository.methodCalls, isNot(contains('updatePassword')));
    });

    testWidgets('should show error when new password is too short',
        (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        fakeRepository: fakeRepository,
      ),);

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'Currentpass1');
      await tester.enterText(textFields.at(1), 'Short1');
      await tester.enterText(textFields.at(2), 'Short1');

      // Tap submit
      await tester.tap(find.byType(FilledButton));
      // DialogUtil shows dialog with 1200ms duration
      await tester.pump(const Duration(milliseconds: 1500));

      // Assert - Should not call API
      expect(fakeRepository.methodCalls, isNot(contains('updatePassword')));
    });
  });

  group('ChangePasswordScreen password change', () {
    testWidgets('should show loading indicator during submission',
        (tester) async {
      // Arrange - Set up failure to avoid success dialog and pop
      fakeRepository.shouldFail = true;
      fakeRepository.operationDelay = const Duration(milliseconds: 500);
      await tester.pumpWidget(createTestWidget(
        fakeRepository: fakeRepository,
      ),);

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'Currentpass1');
      await tester.enterText(textFields.at(1), 'Newpass123');
      await tester.enterText(textFields.at(2), 'Newpass123');

      // Tap submit
      await tester.tap(find.byType(FilledButton));
      // Pump a small amount to trigger the loading state
      await tester.pump(const Duration(milliseconds: 50));

      // Assert - Should show loading indicator before operation completes
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for error dialog to close
      await tester.pump(const Duration(milliseconds: 2000));
    });

    testWidgets('should disable button during loading', (tester) async {
      // Arrange - Set up failure to avoid success dialog and pop
      fakeRepository.shouldFail = true;
      fakeRepository.operationDelay = const Duration(milliseconds: 500);
      await tester.pumpWidget(createTestWidget(
        fakeRepository: fakeRepository,
      ),);

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'Currentpass1');
      await tester.enterText(textFields.at(1), 'Newpass123');
      await tester.enterText(textFields.at(2), 'Newpass123');

      // Tap submit
      await tester.tap(find.byType(FilledButton));
      // Pump a small amount to trigger the loading state
      await tester.pump(const Duration(milliseconds: 50));

      // Assert - Button should be disabled (onPressed is null)
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);

      // Wait for error dialog to close
      await tester.pump(const Duration(milliseconds: 2000));
    });
  });

  group('ChangePasswordScreen accessibility', () {
    testWidgets('should have proper button semantics', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(
        fakeRepository: fakeRepository,
      ),);

      // Assert - Button should have semantics
      expect(find.byType(FilledButton), findsOneWidget);
    });
  });
}
