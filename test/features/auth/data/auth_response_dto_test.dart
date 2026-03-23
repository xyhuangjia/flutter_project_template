/// Unit tests for AuthResponseDto.
library;

import 'package:flutter_project_template/features/auth/data/models/auth_response_dto.dart';
import 'package:flutter_project_template/features/auth/data/models/user_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthResponseDto', () {
    const tUserDto = UserDto(
      id: 'user-123',
      email: 'test@example.com',
      username: 'testuser',
      displayName: 'Test User',
    );

    group('constructor', () {
      test('should create with required fields', () {
        // Arrange & Act
        const dto = AuthResponseDto(
          success: true,
          user: tUserDto,
          token: 'test-token',
        );

        // Assert
        expect(dto.success, isTrue);
        expect(dto.user, equals(tUserDto));
        expect(dto.token, 'test-token');
        expect(dto.message, isNull);
        expect(dto.refreshToken, isNull);
        expect(dto.expiresIn, isNull);
      });

      test('should create with all fields', () {
        // Arrange & Act
        const dto = AuthResponseDto(
          success: true,
          user: tUserDto,
          token: 'test-token',
          message: 'Login successful',
          refreshToken: 'refresh-token',
          expiresIn: 3600,
        );

        // Assert
        expect(dto.success, isTrue);
        expect(dto.user, equals(tUserDto));
        expect(dto.token, 'test-token');
        expect(dto.message, 'Login successful');
        expect(dto.refreshToken, 'refresh-token');
        expect(dto.expiresIn, 3600);
      });

      test('should create failure response', () {
        // Arrange & Act
        const dto = AuthResponseDto(
          success: false,
          user: tUserDto,
          token: '',
          message: 'Invalid credentials',
        );

        // Assert
        expect(dto.success, isFalse);
        expect(dto.message, 'Invalid credentials');
      });
    });

    group('toJson', () {
      test('should serialize to JSON with required fields', () {
        // Arrange
        const dto = AuthResponseDto(
          success: true,
          user: tUserDto,
          token: 'test-token',
        );

        // Act
        final json = dto.toJson();

        // Assert
        expect(json['success'], isTrue);
        expect(json['token'], 'test-token');
        expect(json['message'], isNull);
        expect(json['refreshToken'], isNull);
        expect(json['expiresIn'], isNull);
      });

      test('should serialize to JSON with all fields', () {
        // Arrange
        const dto = AuthResponseDto(
          success: true,
          user: tUserDto,
          token: 'test-token',
          message: 'Login successful',
          refreshToken: 'refresh-token',
          expiresIn: 3600,
        );

        // Act
        final json = dto.toJson();

        // Assert
        expect(json['success'], isTrue);
        expect(json['token'], 'test-token');
        expect(json['message'], 'Login successful');
        expect(json['refreshToken'], 'refresh-token');
        expect(json['expiresIn'], 3600);
      });
    });

    group('fromJson', () {
      test('should deserialize from JSON with required fields', () {
        // Arrange
        final json = {
          'success': true,
          'user': {
            'id': 'user-123',
            'email': 'test@example.com',
            'username': 'testuser',
          },
          'token': 'test-token',
        };

        // Act
        final dto = AuthResponseDto.fromJson(json);

        // Assert
        expect(dto.success, isTrue);
        expect(dto.user.id, 'user-123');
        expect(dto.user.email, 'test@example.com');
        expect(dto.token, 'test-token');
      });

      test('should deserialize from JSON with all fields', () {
        // Arrange
        final json = {
          'success': true,
          'user': {
            'id': 'user-123',
            'email': 'test@example.com',
            'username': 'testuser',
          },
          'token': 'test-token',
          'message': 'Login successful',
          'refreshToken': 'refresh-token',
          'expiresIn': 3600,
        };

        // Act
        final dto = AuthResponseDto.fromJson(json);

        // Assert
        expect(dto.success, isTrue);
        expect(dto.message, 'Login successful');
        expect(dto.refreshToken, 'refresh-token');
        expect(dto.expiresIn, 3600);
      });
    });

    group('round-trip serialization', () {
      test('should maintain data through JSON round-trip', () {
        // Arrange
        const original = AuthResponseDto(
          success: true,
          user: tUserDto,
          token: 'test-token',
          message: 'Login successful',
          refreshToken: 'refresh-token',
          expiresIn: 3600,
        );

        // Act
        final json = original.toJson();
        final restored = AuthResponseDto.fromJson(json);

        // Assert
        expect(restored.success, original.success);
        expect(restored.token, original.token);
        expect(restored.message, original.message);
        expect(restored.refreshToken, original.refreshToken);
        expect(restored.expiresIn, original.expiresIn);
        expect(restored.user.id, original.user.id);
      });
    });
  });

  group('TokenRefreshResponseDto', () {
    group('constructor', () {
      test('should create with required fields', () {
        // Arrange & Act
        const dto = TokenRefreshResponseDto(
          success: true,
          token: 'new-token',
        );

        // Assert
        expect(dto.success, isTrue);
        expect(dto.token, 'new-token');
        expect(dto.refreshToken, isNull);
        expect(dto.expiresIn, isNull);
      });

      test('should create with all fields', () {
        // Arrange & Act
        const dto = TokenRefreshResponseDto(
          success: true,
          token: 'new-token',
          refreshToken: 'new-refresh-token',
          expiresIn: 7200,
        );

        // Assert
        expect(dto.success, isTrue);
        expect(dto.token, 'new-token');
        expect(dto.refreshToken, 'new-refresh-token');
        expect(dto.expiresIn, 7200);
      });

      test('should create failure response', () {
        // Arrange & Act
        const dto = TokenRefreshResponseDto(
          success: false,
          token: '',
        );

        // Assert
        expect(dto.success, isFalse);
      });
    });

    group('toJson', () {
      test('should serialize to JSON', () {
        // Arrange
        const dto = TokenRefreshResponseDto(
          success: true,
          token: 'new-token',
          refreshToken: 'new-refresh-token',
          expiresIn: 7200,
        );

        // Act
        final json = dto.toJson();

        // Assert
        expect(json['success'], isTrue);
        expect(json['token'], 'new-token');
        expect(json['refreshToken'], 'new-refresh-token');
        expect(json['expiresIn'], 7200);
      });
    });

    group('fromJson', () {
      test('should deserialize from JSON', () {
        // Arrange
        final json = {
          'success': true,
          'token': 'new-token',
          'refreshToken': 'new-refresh-token',
          'expiresIn': 7200,
        };

        // Act
        final dto = TokenRefreshResponseDto.fromJson(json);

        // Assert
        expect(dto.success, isTrue);
        expect(dto.token, 'new-token');
        expect(dto.refreshToken, 'new-refresh-token');
        expect(dto.expiresIn, 7200);
      });
    });

    group('round-trip serialization', () {
      test('should maintain data through JSON round-trip', () {
        // Arrange
        const original = TokenRefreshResponseDto(
          success: true,
          token: 'new-token',
          refreshToken: 'new-refresh-token',
          expiresIn: 7200,
        );

        // Act
        final json = original.toJson();
        final restored = TokenRefreshResponseDto.fromJson(json);

        // Assert
        expect(restored.success, original.success);
        expect(restored.token, original.token);
        expect(restored.refreshToken, original.refreshToken);
        expect(restored.expiresIn, original.expiresIn);
      });
    });
  });
}