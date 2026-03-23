/// Unit tests for AuthNotifier.
library;

import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_project_template/features/auth/domain/entities/user.dart';
import 'package:flutter_project_template/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fakes/fake_auth_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeAuthRepository fakeRepository;
  late ProviderContainer container;
  late AuthNotifier authNotifier;
  late SharedPreferences mockPrefs;
  late AuthLocalDataSource mockLocalDataSource;

  const tUser = User(
    id: 'user-123',
    email: 'test@example.com',
    username: 'testuser',
    displayName: 'Test User',
  );

  setUp(() async {
    // Initialize mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    mockPrefs = await SharedPreferences.getInstance();

    fakeRepository = FakeAuthRepository();
    mockLocalDataSource = AuthLocalDataSource(sharedPreferences: mockPrefs);

    // Create container with all necessary overrides
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(fakeRepository),
        authLocalDataSourceProvider.overrideWithValue(mockLocalDataSource),
      ],
    );

    // Wait for initial build
    await container.read(authProvider.future);
    authNotifier = container.read(authProvider.notifier);
  });

  tearDown(() {
    container.dispose();
    fakeRepository.reset();
  });

  group('initial state', () {
    test('should start with unauthenticated state', () async {
      // Assert
      final state = container.read(authProvider);
      expect(state.value?.isAuthenticated, isFalse);
    });
  });

  group('loginWithEmail', () {
    test('should return true and set authenticated state on success', () async {
      // Arrange
      fakeRepository.setupSuccessfulLogin(tUser);

      // Act
      final success = await authNotifier.loginWithEmail(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(success, isTrue);
      final state = container.read(authProvider);
      expect(state.value?.isAuthenticated, isTrue);
      expect(state.value?.user, equals(tUser));
    });

    test('should return false and set error state on failure', () async {
      // Arrange
      fakeRepository.setupFailedLogin(
        const AuthFailure(message: 'Invalid credentials'),
      );

      // Act
      final success = await authNotifier.loginWithEmail(
        email: 'test@example.com',
        password: 'wrong',
      );

      // Assert
      expect(success, isFalse);
      final state = container.read(authProvider);
      expect(state.hasError, isTrue);
    });

    test('should call repository with correct parameters', () async {
      // Arrange
      fakeRepository.setupSuccessfulLogin(tUser);

      // Act
      await authNotifier.loginWithEmail(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(fakeRepository.lastLoginEmail, 'test@example.com');
      expect(fakeRepository.lastLoginPassword, 'password123');
      expect(fakeRepository.methodCalls, contains('loginWithEmail'));
    });
  });

  group('loginWithUsername', () {
    test('should return true and set authenticated state on success', () async {
      // Arrange
      fakeRepository.setupSuccessfulLogin(tUser);

      // Act
      final success = await authNotifier.loginWithUsername(
        username: 'testuser',
        password: 'password123',
      );

      // Assert
      expect(success, isTrue);
      final state = container.read(authProvider);
      expect(state.value?.isAuthenticated, isTrue);
    });

    test('should call repository with correct parameters', () async {
      // Arrange
      fakeRepository.setupSuccessfulLogin(tUser);

      // Act
      await authNotifier.loginWithUsername(
        username: 'testuser',
        password: 'password123',
      );

      // Assert
      expect(fakeRepository.lastLoginUsername, 'testuser');
      expect(fakeRepository.lastLoginPassword, 'password123');
    });
  });

  group('social login', () {
    test('loginWithWeChat should authenticate user', () async {
      // Arrange
      fakeRepository.setupSuccessfulLogin(tUser);

      // Act
      final success = await authNotifier.loginWithWeChat();

      // Assert
      expect(success, isTrue);
      expect(fakeRepository.methodCalls, contains('loginWithWeChat'));
    });

    test('loginWithApple should authenticate user', () async {
      // Arrange
      fakeRepository.setupSuccessfulLogin(tUser);

      // Act
      final success = await authNotifier.loginWithApple();

      // Assert
      expect(success, isTrue);
      expect(fakeRepository.methodCalls, contains('loginWithApple'));
    });

    test('loginWithGoogle should authenticate user', () async {
      // Arrange
      fakeRepository.setupSuccessfulLogin(tUser);

      // Act
      final success = await authNotifier.loginWithGoogle();

      // Assert
      expect(success, isTrue);
      expect(fakeRepository.methodCalls, contains('loginWithGoogle'));
    });
  });

  group('register', () {
    test('should return true and set authenticated state on success', () async {
      // Arrange
      fakeRepository.setupSuccessfulLogin(tUser);

      // Act
      final success = await authNotifier.register(
        email: 'test@example.com',
        username: 'testuser',
        password: 'password123',
      );

      // Assert
      expect(success, isTrue);
      final state = container.read(authProvider);
      expect(state.value?.isAuthenticated, isTrue);
    });

    test('should return false on failure', () async {
      // Arrange
      fakeRepository.setupFailedLogin(
        const AuthFailure(message: 'Email already exists'),
      );

      // Act
      final success = await authNotifier.register(
        email: 'test@example.com',
        username: 'testuser',
        password: 'password123',
      );

      // Assert
      expect(success, isFalse);
    });
  });

  group('logout', () {
    test('should return true and set unauthenticated state', () async {
      // Arrange
      fakeRepository.setupSuccessfulLogin(tUser);
      await authNotifier.loginWithEmail(
        email: 'test@example.com',
        password: 'password123',
      );

      // Act
      final success = await authNotifier.logout();

      // Assert
      expect(success, isTrue);
      final state = container.read(authProvider);
      expect(state.value?.isAuthenticated, isFalse);
    });

    test('should call repository logout', () async {
      // Act
      await authNotifier.logout();

      // Assert
      expect(fakeRepository.methodCalls, contains('logout'));
    });
  });

  group('currentUser getter', () {
    test('should return null when not authenticated', () async {
      // Assert
      expect(authNotifier.currentUser, isNull);
    });

    test('should return user when authenticated', () async {
      // Arrange
      fakeRepository.setupSuccessfulLogin(tUser);
      await authNotifier.loginWithEmail(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(authNotifier.currentUser, equals(tUser));
    });
  });

  group('isAuthenticated getter', () {
    test('should return false when not authenticated', () {
      // Assert
      expect(authNotifier.isAuthenticated, isFalse);
    });

    test('should return true when authenticated', () async {
      // Arrange
      fakeRepository.setupSuccessfulLogin(tUser);
      await authNotifier.loginWithEmail(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(authNotifier.isAuthenticated, isTrue);
    });
  });

  group('verification', () {
    test('sendVerificationCodeToEmail should return true on success', () async {
      // Act
      final success = await authNotifier.sendVerificationCodeToEmail(
        'test@example.com',
      );

      // Assert
      expect(success, isTrue);
      expect(
        fakeRepository.methodCalls,
        contains('sendVerificationCodeToEmail'),
      );
    });

    test('verifyEmailCode should return true on success', () async {
      // Act
      final success = await authNotifier.verifyEmailCode(
        email: 'test@example.com',
        code: '123456',
      );

      // Assert
      expect(success, isTrue);
      expect(fakeRepository.methodCalls, contains('verifyEmailCode'));
    });

    test('verifyEmailCode should return false on failure', () async {
      // Arrange
      fakeRepository
          .setupFailedLogin(const AuthFailure(message: 'Invalid code'));

      // Act
      final success = await authNotifier.verifyEmailCode(
        email: 'test@example.com',
        code: 'wrong',
      );

      // Assert
      expect(success, isFalse);
    });
  });

  group('loading state', () {
    test('should complete login and update state', () async {
      // Arrange
      fakeRepository.setupSuccessfulLogin(tUser);

      // Act
      await authNotifier.loginWithEmail(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert - state should not be loading after completion
      final state = container.read(authProvider);
      expect(state.isLoading, isFalse);
      expect(state.hasValue, isTrue);
      expect(state.value?.isAuthenticated, isTrue);
    });
  });
}
