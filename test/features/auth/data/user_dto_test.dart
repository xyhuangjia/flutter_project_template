/// Unit tests for UserDto.
library;

import 'package:flutter_project_template/features/auth/data/models/user_dto.dart';
import 'package:flutter_project_template/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserDto', () {
    group('constructor', () {
      test('should create UserDto with all required fields', () {
        // Arrange & Act
        const dto = UserDto(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
          displayName: 'Test User',
          avatarUrl: 'https://example.com/avatar.png',
          phoneNumber: '13800138000',
          gender: 'male',
          bio: 'Test bio',
          token: 'test-token',
        );

        // Assert
        expect(dto.id, 'user-123');
        expect(dto.email, 'test@example.com');
        expect(dto.username, 'testuser');
        expect(dto.displayName, 'Test User');
        expect(dto.avatarUrl, 'https://example.com/avatar.png');
        expect(dto.phoneNumber, '13800138000');
        expect(dto.gender, 'male');
        expect(dto.bio, 'Test bio');
        expect(dto.token, 'test-token');
      });

      test('should create UserDto with only required fields', () {
        // Arrange & Act
        const dto = UserDto(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
        );

        // Assert
        expect(dto.id, 'user-123');
        expect(dto.email, 'test@example.com');
        expect(dto.username, 'testuser');
        expect(dto.displayName, isNull);
        expect(dto.avatarUrl, isNull);
        expect(dto.phoneNumber, isNull);
        expect(dto.gender, isNull);
        expect(dto.bio, isNull);
        expect(dto.token, isNull);
      });
    });

    group('toEntity', () {
      test('should convert to User entity with all fields', () {
        // Arrange
        const dto = UserDto(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
          displayName: 'Test User',
          avatarUrl: 'https://example.com/avatar.png',
          phoneNumber: '13800138000',
          gender: 'male',
          bio: 'Test bio',
        );

        // Act
        final entity = dto.toEntity();

        // Assert
        expect(entity.id, 'user-123');
        expect(entity.email, 'test@example.com');
        expect(entity.username, 'testuser');
        expect(entity.displayName, 'Test User');
        expect(entity.avatarUrl, 'https://example.com/avatar.png');
        expect(entity.phoneNumber, '13800138000');
        expect(entity.gender, UserGender.male);
        expect(entity.bio, 'Test bio');
      });

      test('should convert to User entity with minimal fields', () {
        // Arrange
        const dto = UserDto(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
        );

        // Act
        final entity = dto.toEntity();

        // Assert
        expect(entity.id, 'user-123');
        expect(entity.email, 'test@example.com');
        expect(entity.username, 'testuser');
        expect(entity.displayName, isNull);
        expect(entity.avatarUrl, isNull);
        expect(entity.phoneNumber, isNull);
        expect(entity.gender, UserGender.unspecified);
        expect(entity.bio, isNull);
      });

      test('should parse female gender correctly', () {
        // Arrange
        const dto = UserDto(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
          gender: 'female',
        );

        // Act
        final entity = dto.toEntity();

        // Assert
        expect(entity.gender, UserGender.female);
      });

      test('should parse unspecified gender correctly', () {
        // Arrange
        const dto = UserDto(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
          gender: 'other',
        );

        // Act
        final entity = dto.toEntity();

        // Assert
        expect(entity.gender, UserGender.unspecified);
      });

      test('should handle null gender as unspecified', () {
        // Arrange
        const dto = UserDto(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
          gender: null,
        );

        // Act
        final entity = dto.toEntity();

        // Assert
        expect(entity.gender, UserGender.unspecified);
      });

      test('should handle case-insensitive gender parsing', () {
        // Arrange
        const maleDto = UserDto(
          id: 'user-1',
          email: 'test@example.com',
          username: 'test',
          gender: 'MALE',
        );
        const femaleDto = UserDto(
          id: 'user-2',
          email: 'test@example.com',
          username: 'test',
          gender: 'Female',
        );

        // Act
        final maleEntity = maleDto.toEntity();
        final femaleEntity = femaleDto.toEntity();

        // Assert
        expect(maleEntity.gender, UserGender.male);
        expect(femaleEntity.gender, UserGender.female);
      });
    });

    group('fromJson', () {
      test('should deserialize from JSON with all fields', () {
        // Arrange
        final json = {
          'id': 'user-123',
          'email': 'test@example.com',
          'username': 'testuser',
          'displayName': 'Test User',
          'avatarUrl': 'https://example.com/avatar.png',
          'phoneNumber': '13800138000',
          'gender': 'male',
          'bio': 'Test bio',
          'token': 'test-token',
        };

        // Act
        final dto = UserDto.fromJson(json);

        // Assert
        expect(dto.id, 'user-123');
        expect(dto.email, 'test@example.com');
        expect(dto.username, 'testuser');
        expect(dto.displayName, 'Test User');
        expect(dto.avatarUrl, 'https://example.com/avatar.png');
        expect(dto.phoneNumber, '13800138000');
        expect(dto.gender, 'male');
        expect(dto.bio, 'Test bio');
        expect(dto.token, 'test-token');
      });

      test('should deserialize from JSON with missing optional fields', () {
        // Arrange
        final json = {
          'id': 'user-123',
          'email': 'test@example.com',
          'username': 'testuser',
        };

        // Act
        final dto = UserDto.fromJson(json);

        // Assert
        expect(dto.id, 'user-123');
        expect(dto.email, 'test@example.com');
        expect(dto.username, 'testuser');
        expect(dto.displayName, isNull);
        expect(dto.avatarUrl, isNull);
        expect(dto.token, isNull);
      });
    });

    group('toJson', () {
      test('should serialize to JSON with all fields', () {
        // Arrange
        const dto = UserDto(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
          displayName: 'Test User',
          avatarUrl: 'https://example.com/avatar.png',
          phoneNumber: '13800138000',
          gender: 'male',
          bio: 'Test bio',
          token: 'test-token',
        );

        // Act
        final json = dto.toJson();

        // Assert
        expect(json['id'], 'user-123');
        expect(json['email'], 'test@example.com');
        expect(json['username'], 'testuser');
        expect(json['displayName'], 'Test User');
        expect(json['avatarUrl'], 'https://example.com/avatar.png');
        expect(json['phoneNumber'], '13800138000');
        expect(json['gender'], 'male');
        expect(json['bio'], 'Test bio');
        expect(json['token'], 'test-token');
      });

      test('should serialize to JSON with null optional fields', () {
        // Arrange
        const dto = UserDto(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
        );

        // Act
        final json = dto.toJson();

        // Assert
        expect(json['id'], 'user-123');
        expect(json['email'], 'test@example.com');
        expect(json['username'], 'testuser');
        expect(json['displayName'], isNull);
        expect(json['avatarUrl'], isNull);
        expect(json['token'], isNull);
      });
    });

    group('serialization round-trip', () {
      test('should maintain data through JSON round-trip', () {
        // Arrange
        const original = UserDto(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
          displayName: 'Test User',
          avatarUrl: 'https://example.com/avatar.png',
          phoneNumber: '13800138000',
          gender: 'female',
          bio: 'Test bio',
          token: 'test-token',
        );

        // Act
        final json = original.toJson();
        final restored = UserDto.fromJson(json);

        // Assert
        expect(restored.id, original.id);
        expect(restored.email, original.email);
        expect(restored.username, original.username);
        expect(restored.displayName, original.displayName);
        expect(restored.avatarUrl, original.avatarUrl);
        expect(restored.phoneNumber, original.phoneNumber);
        expect(restored.gender, original.gender);
        expect(restored.bio, original.bio);
        expect(restored.token, original.token);
      });
    });

    group('toString', () {
      test('should contain main field values', () {
        // Arrange
        const dto = UserDto(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
          displayName: 'Test User',
        );

        // Act
        final string = dto.toString();

        // Assert
        expect(string, contains('UserDto'));
        expect(string, contains('user-123'));
        expect(string, contains('test@example.com'));
        expect(string, contains('testuser'));
        expect(string, contains('Test User'));
      });
    });
  });
}