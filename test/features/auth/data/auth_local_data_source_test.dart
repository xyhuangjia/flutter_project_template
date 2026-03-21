/// Unit tests for AuthLocalDataSource.
library;

import 'package:flutter_project_template/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AuthLocalDataSource dataSource;
  late SharedPreferences mockPrefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    mockPrefs = await SharedPreferences.getInstance();
    dataSource = AuthLocalDataSource(sharedPreferences: mockPrefs);
  });

  group('saveToken', () {
    test('should save token to SharedPreferences', () async {
      // Act
      await dataSource.saveToken('test-token');

      // Assert
      expect(mockPrefs.getString('auth_token'), 'test-token');
    });

    test('should overwrite existing token', () async {
      // Arrange
      await dataSource.saveToken('old-token');

      // Act
      await dataSource.saveToken('new-token');

      // Assert
      expect(mockPrefs.getString('auth_token'), 'new-token');
    });
  });

  group('getToken', () {
    test('should return null when no token is stored', () {
      // Act
      final token = dataSource.getToken();

      // Assert
      expect(token, isNull);
    });

    test('should return stored token', () async {
      // Arrange
      await dataSource.saveToken('test-token');

      // Act
      final token = dataSource.getToken();

      // Assert
      expect(token, 'test-token');
    });
  });

  group('saveUserData', () {
    test('should save all user data', () async {
      // Act
      await dataSource.saveUserData(
        userId: 'user-123',
        email: 'test@example.com',
        username: 'testuser',
        displayName: 'Test User',
        avatarUrl: 'https://example.com/avatar.png',
      );

      // Assert
      expect(mockPrefs.getString('user_id'), 'user-123');
      expect(mockPrefs.getString('user_email'), 'test@example.com');
      expect(mockPrefs.getString('username'), 'testuser');
      expect(mockPrefs.getString('display_name'), 'Test User');
      expect(
          mockPrefs.getString('avatar_url'), 'https://example.com/avatar.png');
    });

    test('should save user data without optional fields', () async {
      // Act
      await dataSource.saveUserData(
        userId: 'user-123',
        email: 'test@example.com',
        username: 'testuser',
      );

      // Assert
      expect(mockPrefs.getString('user_id'), 'user-123');
      expect(mockPrefs.getString('user_email'), 'test@example.com');
      expect(mockPrefs.getString('username'), 'testuser');
      expect(mockPrefs.getString('display_name'), isNull);
      expect(mockPrefs.getString('avatar_url'), isNull);
    });

    test('should overwrite existing user data', () async {
      // Arrange
      await dataSource.saveUserData(
        userId: 'user-123',
        email: 'test@example.com',
        username: 'testuser',
        displayName: 'Old Name',
      );

      // Act
      await dataSource.saveUserData(
        userId: 'user-456',
        email: 'new@example.com',
        username: 'newuser',
        displayName: 'New Name',
      );

      // Assert
      expect(mockPrefs.getString('user_id'), 'user-456');
      expect(mockPrefs.getString('user_email'), 'new@example.com');
      expect(mockPrefs.getString('username'), 'newuser');
      expect(mockPrefs.getString('display_name'), 'New Name');
    });
  });

  group('getUser data getters', () {
    setUp(() async {
      await dataSource.saveUserData(
        userId: 'user-123',
        email: 'test@example.com',
        username: 'testuser',
        displayName: 'Test User',
        avatarUrl: 'https://example.com/avatar.png',
      );
    });

    test('getUserId should return stored user ID', () {
      // Act
      final userId = dataSource.getUserId();

      // Assert
      expect(userId, 'user-123');
    });

    test('getUserEmail should return stored email', () {
      // Act
      final email = dataSource.getUserEmail();

      // Assert
      expect(email, 'test@example.com');
    });

    test('getUsername should return stored username', () {
      // Act
      final username = dataSource.getUsername();

      // Assert
      expect(username, 'testuser');
    });

    test('getDisplayName should return stored display name', () {
      // Act
      final displayName = dataSource.getDisplayName();

      // Assert
      expect(displayName, 'Test User');
    });

    test('getAvatarUrl should return stored avatar URL', () {
      // Act
      final avatarUrl = dataSource.getAvatarUrl();

      // Assert
      expect(avatarUrl, 'https://example.com/avatar.png');
    });

    test('should return null when data is not stored', () async {
      // Arrange - clear data
      await dataSource.clearAuthData();

      // Act & Assert
      expect(dataSource.getUserId(), isNull);
      expect(dataSource.getUserEmail(), isNull);
      expect(dataSource.getUsername(), isNull);
      expect(dataSource.getDisplayName(), isNull);
      expect(dataSource.getAvatarUrl(), isNull);
    });
  });

  group('clearAuthData', () {
    test('should clear all auth data', () async {
      // Arrange
      await dataSource.saveToken('test-token');
      await dataSource.saveUserData(
        userId: 'user-123',
        email: 'test@example.com',
        username: 'testuser',
      );

      // Act
      await dataSource.clearAuthData();

      // Assert
      expect(mockPrefs.getString('auth_token'), isNull);
      expect(mockPrefs.getString('user_id'), isNull);
      expect(mockPrefs.getString('user_email'), isNull);
      expect(mockPrefs.getString('username'), isNull);
      expect(mockPrefs.getString('display_name'), isNull);
      expect(mockPrefs.getString('avatar_url'), isNull);
    });

    test('should work when no data is stored', () async {
      // Act & Assert - should not throw
      await dataSource.clearAuthData();
    });
  });

  group('isAuthenticated', () {
    test('should return false when no token is stored', () {
      // Act
      final authenticated = dataSource.isAuthenticated();

      // Assert
      expect(authenticated, isFalse);
    });

    test('should return true when token is stored', () async {
      // Arrange
      await dataSource.saveToken('test-token');

      // Act
      final authenticated = dataSource.isAuthenticated();

      // Assert
      expect(authenticated, isTrue);
    });
  });

  group('integration tests', () {
    test('should handle complete auth flow', () async {
      // Arrange & Act - Login
      await dataSource.saveToken('test-token');
      await dataSource.saveUserData(
        userId: 'user-123',
        email: 'test@example.com',
        username: 'testuser',
        displayName: 'Test User',
      );

      // Assert - Check authenticated
      expect(dataSource.isAuthenticated(), isTrue);
      expect(dataSource.getToken(), 'test-token');
      expect(dataSource.getUserId(), 'user-123');

      // Act - Logout
      await dataSource.clearAuthData();

      // Assert - Check unauthenticated
      expect(dataSource.isAuthenticated(), isFalse);
      expect(dataSource.getToken(), isNull);
      expect(dataSource.getUserId(), isNull);
    });
  });
}
