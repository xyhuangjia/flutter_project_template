/// Unit tests for User entity.
library;

import 'package:flutter_project_template/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User', () {
    group('constructor', () {
      test('should create a User with all required fields', () {
        // Arrange & Act
        const user = User(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
          displayName: 'Test User',
          avatarUrl: 'https://example.com/avatar.png',
          phoneNumber: '13800138000',
          bio: 'Test bio',
        );

        // Assert
        expect(user.id, 'user-123');
        expect(user.email, 'test@example.com');
        expect(user.username, 'testuser');
        expect(user.displayName, 'Test User');
        expect(user.avatarUrl, 'https://example.com/avatar.png');
        expect(user.phoneNumber, '13800138000');
        expect(user.bio, 'Test bio');
      });

      test('should create a User with only required fields', () {
        // Arrange & Act
        const user = User(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
        );

        // Assert
        expect(user.id, 'user-123');
        expect(user.email, 'test@example.com');
        expect(user.username, 'testuser');
        expect(user.displayName, isNull);
        expect(user.avatarUrl, isNull);
        expect(user.phoneNumber, isNull);
        expect(user.bio, isNull);
      });
    });

    group('equality', () {
      test('should be equal when all fields are the same', () {
        // Arrange
        const user1 = User(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
          displayName: 'Test User',
        );
        const user2 = User(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
          displayName: 'Test User',
        );

        // Assert
        expect(user1, equals(user2));
        expect(user1.hashCode, equals(user2.hashCode));
      });

      test('should not be equal when id differs', () {
        // Arrange
        const user1 = User(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
        );
        const user2 = User(
          id: 'user-456',
          email: 'test@example.com',
          username: 'testuser',
        );

        // Assert
        expect(user1, isNot(equals(user2)));
      });

      test('should not be equal when email differs', () {
        // Arrange
        const user1 = User(
          id: 'user-123',
          email: 'test1@example.com',
          username: 'testuser',
        );
        const user2 = User(
          id: 'user-123',
          email: 'test2@example.com',
          username: 'testuser',
        );

        // Assert
        expect(user1, isNot(equals(user2)));
      });
    });

    group('copyWith', () {
      test('should copy with new values', () {
        // Arrange
        const original = User(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
          displayName: 'Original Name',
        );

        // Act
        final copied = original.copyWith(
          displayName: 'New Name',
          avatarUrl: 'https://example.com/new-avatar.png',
        );

        // Assert
        expect(copied.id, 'user-123');
        expect(copied.email, 'test@example.com');
        expect(copied.username, 'testuser');
        expect(copied.displayName, 'New Name');
        expect(copied.avatarUrl, 'https://example.com/new-avatar.png');
      });

      test('should keep original values when not specified', () {
        // Arrange
        const original = User(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
          displayName: 'Test User',
          avatarUrl: 'https://example.com/avatar.png',
        );

        // Act
        final copied = original.copyWith(displayName: 'New Name');

        // Assert
        expect(copied.id, 'user-123');
        expect(copied.email, 'test@example.com');
        expect(copied.username, 'testuser');
        expect(copied.displayName, 'New Name');
        expect(copied.avatarUrl, 'https://example.com/avatar.png');
      });
    });

    group('toString', () {
      test('should contain all field names', () {
        // Arrange
        const user = User(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
          displayName: 'Test User',
        );

        // Act
        final string = user.toString();

        // Assert
        expect(string, contains('User'));
        expect(string, contains('user-123'));
        expect(string, contains('test@example.com'));
        expect(string, contains('testuser'));
        expect(string, contains('Test User'));
      });
    });
  });
}
