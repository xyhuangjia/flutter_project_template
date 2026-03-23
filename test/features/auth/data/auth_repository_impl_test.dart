/// Unit tests for AuthRepositoryImpl.
library;

import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_project_template/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_project_template/features/auth/data/models/user_dto.dart';
import 'package:flutter_project_template/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_project_template/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const tUserDto = UserDto(
    id: 'user-123',
    email: 'test@example.com',
    username: 'testuser',
    displayName: 'Test User',
    avatarUrl: 'https://example.com/avatar.png',
    token: 'test-token',
  );

  const tUser = User(
    id: 'user-123',
    email: 'test@example.com',
    username: 'testuser',
    displayName: 'Test User',
    avatarUrl: 'https://example.com/avatar.png',
  );

  group('loginWithEmail', () {
    test('should return User on successful login', () async {
      // Arrange
      when(() => mockRemoteDataSource.loginWithEmail(
            email: 'test@example.com',
            password: 'password123',
          ),).thenAnswer((_) async => tUserDto);
      when(() => mockLocalDataSource.saveToken(any()))
          .thenAnswer((_) async => {});
      when(() => mockLocalDataSource.saveUserData(
            userId: any(named: 'userId'),
            email: any(named: 'email'),
            username: any(named: 'username'),
            displayName: any(named: 'displayName'),
            avatarUrl: any(named: 'avatarUrl'),
          ),).thenAnswer((_) async => []);

      // Act
      final result = await repository.loginWithEmail(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.data, equals(tUser));

      verify(() => mockRemoteDataSource.loginWithEmail(
            email: 'test@example.com',
            password: 'password123',
          ),).called(1);
      verify(() => mockLocalDataSource.saveToken('test-token')).called(1);
    });

    test('should return AuthFailure when AuthException is thrown', () async {
      // Arrange
      when(() => mockRemoteDataSource.loginWithEmail(
            email: 'test@example.com',
            password: 'wrong',
          ),).thenThrow(AuthException('Invalid credentials'));

      // Act
      final result = await repository.loginWithEmail(
        email: 'test@example.com',
        password: 'wrong',
      );

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<AuthFailure>());
      expect(result.failureOrNull?.message, 'Invalid credentials');
    });

    test('should return Failure when generic exception is thrown', () async {
      // Arrange
      when(() => mockRemoteDataSource.loginWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),).thenThrow(Exception('Network error'));

      // Act
      final result = await repository.loginWithEmail(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result.isFailure, isTrue);
    });
  });

  group('loginWithUsername', () {
    test('should return User on successful login', () async {
      // Arrange
      when(() => mockRemoteDataSource.loginWithUsername(
            username: 'testuser',
            password: 'password123',
          ),).thenAnswer((_) async => tUserDto);
      when(() => mockLocalDataSource.saveToken(any()))
          .thenAnswer((_) async => {});
      when(() => mockLocalDataSource.saveUserData(
            userId: any(named: 'userId'),
            email: any(named: 'email'),
            username: any(named: 'username'),
            displayName: any(named: 'displayName'),
            avatarUrl: any(named: 'avatarUrl'),
          ),).thenAnswer((_) async => []);

      // Act
      final result = await repository.loginWithUsername(
        username: 'testuser',
        password: 'password123',
      );

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.data, equals(tUser));
    });
  });

  group('logout', () {
    test('should clear auth data and return success', () async {
      // Arrange
      when(() => mockLocalDataSource.clearAuthData())
          .thenAnswer((_) async => []);

      // Act
      final result = await repository.logout();

      // Assert
      expect(result.isSuccess, isTrue);
      verify(() => mockLocalDataSource.clearAuthData()).called(1);
    });
  });

  group('getCurrentUser', () {
    test('should return null when no user is stored', () async {
      // Arrange
      when(() => mockLocalDataSource.getUserId()).thenReturn(null);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.data, isNull);
    });

    test('should return User when user data is stored', () async {
      // Arrange
      when(() => mockLocalDataSource.getUserId()).thenReturn('user-123');
      when(() => mockLocalDataSource.getUserEmail())
          .thenReturn('test@example.com');
      when(() => mockLocalDataSource.getUsername()).thenReturn('testuser');
      when(() => mockLocalDataSource.getDisplayName()).thenReturn('Test User');
      when(() => mockLocalDataSource.getAvatarUrl())
          .thenReturn('https://example.com/avatar.png');

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.data, isNotNull);
      expect(result.data?.id, 'user-123');
      expect(result.data?.email, 'test@example.com');
      expect(result.data?.username, 'testuser');
    });
  });

  group('isAuthenticated', () {
    test('should return true when token exists', () async {
      // Arrange
      when(() => mockLocalDataSource.isAuthenticated()).thenReturn(true);

      // Act
      final result = await repository.isAuthenticated();

      // Assert
      expect(result, isTrue);
    });

    test('should return false when no token', () async {
      // Arrange
      when(() => mockLocalDataSource.isAuthenticated()).thenReturn(false);

      // Act
      final result = await repository.isAuthenticated();

      // Assert
      expect(result, isFalse);
    });
  });

  group('register', () {
    test('should return User on successful registration', () async {
      // Arrange
      when(() => mockRemoteDataSource.register(
            email: 'test@example.com',
            username: 'testuser',
            password: 'password123',
          ),).thenAnswer((_) async => tUserDto);
      when(() => mockLocalDataSource.saveToken(any()))
          .thenAnswer((_) async => {});
      when(() => mockLocalDataSource.saveUserData(
            userId: any(named: 'userId'),
            email: any(named: 'email'),
            username: any(named: 'username'),
            displayName: any(named: 'displayName'),
            avatarUrl: any(named: 'avatarUrl'),
          ),).thenAnswer((_) async => []);

      // Act
      final result = await repository.register(
        email: 'test@example.com',
        username: 'testuser',
        password: 'password123',
      );

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.data, equals(tUser));
    });
  });

  group('social login', () {
    test('should return User on successful WeChat login', () async {
      // Arrange
      when(() => mockRemoteDataSource.loginWithWeChat())
          .thenAnswer((_) async => tUserDto);
      when(() => mockLocalDataSource.saveToken(any()))
          .thenAnswer((_) async => {});
      when(() => mockLocalDataSource.saveUserData(
            userId: any(named: 'userId'),
            email: any(named: 'email'),
            username: any(named: 'username'),
            displayName: any(named: 'displayName'),
            avatarUrl: any(named: 'avatarUrl'),
          ),).thenAnswer((_) async => []);

      // Act
      final result = await repository.loginWithWeChat();

      // Assert
      expect(result.isSuccess, isTrue);
    });

    test('should return User on successful Apple login', () async {
      // Arrange
      when(() => mockRemoteDataSource.loginWithApple())
          .thenAnswer((_) async => tUserDto);
      when(() => mockLocalDataSource.saveToken(any()))
          .thenAnswer((_) async => {});
      when(() => mockLocalDataSource.saveUserData(
            userId: any(named: 'userId'),
            email: any(named: 'email'),
            username: any(named: 'username'),
            displayName: any(named: 'displayName'),
            avatarUrl: any(named: 'avatarUrl'),
          ),).thenAnswer((_) async => []);

      // Act
      final result = await repository.loginWithApple();

      // Assert
      expect(result.isSuccess, isTrue);
    });

    test('should return User on successful Google login', () async {
      // Arrange
      when(() => mockRemoteDataSource.loginWithGoogle())
          .thenAnswer((_) async => tUserDto);
      when(() => mockLocalDataSource.saveToken(any()))
          .thenAnswer((_) async => {});
      when(() => mockLocalDataSource.saveUserData(
            userId: any(named: 'userId'),
            email: any(named: 'email'),
            username: any(named: 'username'),
            displayName: any(named: 'displayName'),
            avatarUrl: any(named: 'avatarUrl'),
          ),).thenAnswer((_) async => []);

      // Act
      final result = await repository.loginWithGoogle();

      // Assert
      expect(result.isSuccess, isTrue);
    });
  });
}
