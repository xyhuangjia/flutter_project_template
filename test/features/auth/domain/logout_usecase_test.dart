/// Unit tests for LogoutUseCase.
library;

import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_project_template/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LogoutUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LogoutUseCase(repository: mockRepository);
  });

  group('execute', () {
    test('should return success on successful logout', () async {
      // Arrange
      when(() => mockRepository.logout())
          .thenAnswer((_) async => const Success(null));

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result.isSuccess, isTrue);
      verify(() => mockRepository.logout()).called(1);
    });

    test('should return failure on logout error', () async {
      // Arrange
      when(() => mockRepository.logout()).thenAnswer(
        (_) async => FailureResult(const AuthFailure(message: 'Logout failed')),
      );

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<AuthFailure>());
    });

    test('should call repository logout method', () async {
      // Arrange
      when(() => mockRepository.logout())
          .thenAnswer((_) async => const Success(null));

      // Act
      await useCase.execute();

      // Assert
      verify(() => mockRepository.logout()).called(1);
    });

    test('should handle network error during logout', () async {
      // Arrange
      when(() => mockRepository.logout()).thenAnswer(
        (_) async =>
            FailureResult(const NetworkFailure(message: 'Network error')),
      );

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<NetworkFailure>());
    });

    test('should handle server error during logout', () async {
      // Arrange
      when(() => mockRepository.logout()).thenAnswer(
        (_) async => FailureResult(const ServerFailure(message: 'Server error')),
      );

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ServerFailure>());
    });
  });
}