/// Unit tests for LoginRequestDto.
library;

import 'package:flutter_project_template/features/auth/data/models/login_request_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginRequestDto', () {
    group('constructor', () {
      test('should create with required fields', () {
        // Arrange & Act
        const dto = LoginRequestDto(
          email: 'test@example.com',
          password: 'password123',
        );

        // Assert
        expect(dto.email, 'test@example.com');
        expect(dto.password, 'password123');
        expect(dto.username, isNull);
      });

      test('should create with username', () {
        // Arrange & Act
        const dto = LoginRequestDto(
          email: '',
          password: 'password123',
          username: 'testuser',
        );

        // Assert
        expect(dto.email, '');
        expect(dto.password, 'password123');
        expect(dto.username, 'testuser');
      });
    });

    group('toJson', () {
      test('should serialize to JSON with required fields', () {
        // Arrange
        const dto = LoginRequestDto(
          email: 'test@example.com',
          password: 'password123',
        );

        // Act
        final json = dto.toJson();

        // Assert
        expect(json['email'], 'test@example.com');
        expect(json['password'], 'password123');
        expect(json['username'], isNull);
      });

      test('should serialize to JSON with username', () {
        // Arrange
        const dto = LoginRequestDto(
          email: '',
          password: 'password123',
          username: 'testuser',
        );

        // Act
        final json = dto.toJson();

        // Assert
        expect(json['email'], '');
        expect(json['password'], 'password123');
        expect(json['username'], 'testuser');
      });
    });

    group('fromJson', () {
      test('should deserialize from JSON with required fields', () {
        // Arrange
        final json = {
          'email': 'test@example.com',
          'password': 'password123',
        };

        // Act
        final dto = LoginRequestDto.fromJson(json);

        // Assert
        expect(dto.email, 'test@example.com');
        expect(dto.password, 'password123');
        expect(dto.username, isNull);
      });

      test('should deserialize from JSON with username', () {
        // Arrange
        final json = {
          'email': '',
          'password': 'password123',
          'username': 'testuser',
        };

        // Act
        final dto = LoginRequestDto.fromJson(json);

        // Assert
        expect(dto.email, '');
        expect(dto.password, 'password123');
        expect(dto.username, 'testuser');
      });
    });

    group('round-trip serialization', () {
      test('should maintain data through JSON round-trip', () {
        // Arrange
        const original = LoginRequestDto(
          email: 'test@example.com',
          password: 'password123',
          username: 'testuser',
        );

        // Act
        final json = original.toJson();
        final restored = LoginRequestDto.fromJson(json);

        // Assert
        expect(restored.email, original.email);
        expect(restored.password, original.password);
        expect(restored.username, original.username);
      });
    });
  });

  group('UsernameLoginRequestDto', () {
    group('constructor', () {
      test('should create with required fields', () {
        // Arrange & Act
        const dto = UsernameLoginRequestDto(
          username: 'testuser',
          password: 'password123',
        );

        // Assert
        expect(dto.username, 'testuser');
        expect(dto.password, 'password123');
      });
    });

    group('toJson', () {
      test('should serialize to JSON', () {
        // Arrange
        const dto = UsernameLoginRequestDto(
          username: 'testuser',
          password: 'password123',
        );

        // Act
        final json = dto.toJson();

        // Assert
        expect(json['username'], 'testuser');
        expect(json['password'], 'password123');
      });
    });

    group('fromJson', () {
      test('should deserialize from JSON', () {
        // Arrange
        final json = {
          'username': 'testuser',
          'password': 'password123',
        };

        // Act
        final dto = UsernameLoginRequestDto.fromJson(json);

        // Assert
        expect(dto.username, 'testuser');
        expect(dto.password, 'password123');
      });
    });

    group('round-trip serialization', () {
      test('should maintain data through JSON round-trip', () {
        // Arrange
        const original = UsernameLoginRequestDto(
          username: 'testuser',
          password: 'password123',
        );

        // Act
        final json = original.toJson();
        final restored = UsernameLoginRequestDto.fromJson(json);

        // Assert
        expect(restored.username, original.username);
        expect(restored.password, original.password);
      });
    });
  });
}