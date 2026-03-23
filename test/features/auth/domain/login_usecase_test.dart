/// Unit tests for LoginUseCase.
library;

import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/auth/domain/entities/user.dart';
import 'package:flutter_project_template/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_project_template/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  const tUser = User(
    id: 'user-123',
    email: 'test@example.com',
    username: 'testuser',
    displayName: 'Test User',
  );

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(repository: mockRepository);
  });

  group('executeWithEmail', () {
    test('should return User on successful login', () async {
      // Arrange
      when(() => mockRepository.loginWithEmail(
            email: 'test@example.com',
            password: 'password123',
          ),).thenAnswer((_) async => Success(tUser));

      // Act
      final result = await useCase.executeWithEmail(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.data, equals(tUser));
      verify(() => mockRepository.loginWithEmail(
            email: 'test@example.com',
            password: 'password123',
          ),).called(1);
    });

    test('should return AuthFailure on invalid credentials', () async {
      // Arrange
      when(() => mockRepository.loginWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),).thenAnswer((_) async => FailureResult(const AuthFailure(
        message: 'Invalid credentials',
      ),));

      // Act
      final result = await useCase.executeWithEmail(
        email: 'wrong@example.com',
        password: 'wrongpassword',
      );

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<AuthFailure>());
    });

    test('should return NetworkFailure on network error', () async {
      // Arrange
      when(() => mockRepository.loginWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),).thenAnswer((_) async => FailureResult(const NetworkFailure(
        message: 'Network error',
      ),));

      // Act
      final result = await useCase.executeWithEmail(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<NetworkFailure>());
    });
  });

  group('executeWithUsername', () {
    test('should return User on successful login', () async {
      // Arrange
      when(() => mockRepository.loginWithUsername(
            username: 'testuser',
            password: 'password123',
          ),).thenAnswer((_) async => Success(tUser));

      // Act
      final result = await useCase.executeWithUsername(
        username: 'testuser',
        password: 'password123',
      );

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.data, equals(tUser));
      verify(() => mockRepository.loginWithUsername(
            username: 'testuser',
            password: 'password123',
          ),).called(1);
    });

    test('should return AuthFailure on invalid credentials', () async {
      // Arrange
      when(() => mockRepository.loginWithUsername(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),).thenAnswer((_) async => FailureResult(const AuthFailure(
        message: 'Invalid credentials',
      ),));

      // Act
      final result = await useCase.executeWithUsername(
        username: 'wronguser',
        password: 'wrongpassword',
      );

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<AuthFailure>());
    });

    test('should forward correct parameters to repository', () async {
      // Arrange
      when(() => mockRepository.loginWithUsername(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),).thenAnswer((_) async => Success(tUser));

      // Act
      await useCase.executeWithUsername(
        username: 'testuser',
        password: 'password123',
      );

      // Assert
      verify(() => mockRepository.loginWithUsername(
            username: 'testuser',
            password: 'password123',
          ),).called(1);
    });
  });

  group('edge cases', () {
    test('should handle empty email', () async {
      // Arrange
      when(() => mockRepository.loginWithEmail(
            email: '',
            password: 'password123',
          ),).thenAnswer((_) async => FailureResult(const AuthFailure(
        message: 'Email cannot be empty',
      ),));

      // Act
      final result = await useCase.executeWithEmail(
        email: '',
        password: 'password123',
      );

      // Assert
      expect(result.isFailure, isTrue);
    });

    test('should handle empty username', () async {
      // Arrange
      when(() => mockRepository.loginWithUsername(
            username: '',
            password: 'password123',
          ),).thenAnswer((_) async => FailureResult(const AuthFailure(
        message: 'Username cannot be empty',
      ),));

      // Act
      final result = await useCase.executeWithUsername(
        username: '',
        password: 'password123',
      );

      // Assert
      expect(result.isFailure, isTrue);
    });

    test('should handle empty password for email login', () async {
      // Arrange
      when(() => mockRepository.loginWithEmail(
            email: 'test@example.com',
            password: '',
          ),).thenAnswer((_) async => FailureResult(const AuthFailure(
        message: 'Password cannot be empty',
      ),));

      // Act
      final result = await useCase.executeWithEmail(
        email: 'test@example.com',
        password: '',
      );

      // Assert
      expect(result.isFailure, isTrue);
    });
  });
}