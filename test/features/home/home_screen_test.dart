/// Unit tests for Home entity.
library;

import 'package:flutter_project_template/features/home/domain/entities/home_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeEntity', () {
    test('should create a HomeEntity with all required fields', () {
      // Arrange & Act
      const entity = HomeEntity(
        title: 'Test Title',
        welcomeMessage: 'Welcome!',
        userName: 'John Doe',
        avatarUrl: 'https://example.com/avatar.png',
      );

      // Assert
      expect(entity.title, 'Test Title');
      expect(entity.welcomeMessage, 'Welcome!');
      expect(entity.userName, 'John Doe');
      expect(entity.avatarUrl, 'https://example.com/avatar.png');
    });

    test('should support nullable fields', () {
      // Arrange & Act
      const entity = HomeEntity(
        title: 'Test Title',
        welcomeMessage: 'Welcome!',
      );

      // Assert
      expect(entity.userName, isNull);
      expect(entity.avatarUrl, isNull);
    });

    test('should support equality', () {
      // Arrange
      const entity1 = HomeEntity(
        title: 'Test',
        welcomeMessage: 'Welcome',
        userName: 'User',
      );
      const entity2 = HomeEntity(
        title: 'Test',
        welcomeMessage: 'Welcome',
        userName: 'User',
      );

      // Assert
      expect(entity1, equals(entity2));
    });

    test('should support copyWith', () {
      // Arrange
      const original = HomeEntity(
        title: 'Original Title',
        welcomeMessage: 'Original Message',
        userName: 'Original User',
      );

      // Act
      final copied = original.copyWith(
        title: 'New Title',
      );

      // Assert
      expect(copied.title, 'New Title');
      expect(copied.welcomeMessage, 'Original Message');
      expect(copied.userName, 'Original User');
    });

    test('should have proper toString', () {
      // Arrange
      const entity = HomeEntity(
        title: 'Test',
        welcomeMessage: 'Welcome',
        userName: 'User',
      );

      // Act
      final string = entity.toString();

      // Assert
      expect(string, contains('HomeEntity'));
      expect(string, contains('Test'));
      expect(string, contains('Welcome'));
    });
  });
}
