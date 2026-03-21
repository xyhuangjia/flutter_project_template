/// Unit tests for AuthState entity.
library;

import 'package:flutter_project_template/features/auth/domain/entities/auth_state.dart';
import 'package:flutter_project_template/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthState', () {
    group('unauthenticated', () {
      test('should create an unauthenticated state', () {
        // Act
        const state = AuthState.unauthenticated();

        // Assert
        expect(state.isAuthenticated, isFalse);
        expect(state.user, isNull);
        expect(state.token, isNull);
      });
    });

    group('authenticated', () {
      test('should create an authenticated state with user and token', () {
        // Arrange
        const user = User(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
        );

        // Act
        const state = AuthState.authenticated(user: user, token: 'test-token');

        // Assert
        expect(state.isAuthenticated, isTrue);
        expect(state.user, equals(user));
        expect(state.token, 'test-token');
      });
    });

    group('default constructor', () {
      test('should create state with custom values', () {
        // Arrange
        const user = User(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
        );

        // Act
        const state = AuthState(
          isAuthenticated: true,
          user: user,
          token: 'custom-token',
        );

        // Assert
        expect(state.isAuthenticated, isTrue);
        expect(state.user, equals(user));
        expect(state.token, 'custom-token');
      });
    });

    group('equality', () {
      test('should be equal when all fields are the same', () {
        // Arrange
        const user = User(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
        );
        const state1 = AuthState.authenticated(user: user, token: 'token');
        const state2 = AuthState.authenticated(user: user, token: 'token');

        // Assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('unauthenticated states should be equal', () {
        // Arrange
        const state1 = AuthState.unauthenticated();
        const state2 = AuthState.unauthenticated();

        // Assert
        expect(state1, equals(state2));
      });

      test('should not be equal when isAuthenticated differs', () {
        // Arrange
        const user = User(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
        );
        const state1 = AuthState.authenticated(user: user, token: 'token');
        const state2 = AuthState.unauthenticated();

        // Assert
        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when token differs', () {
        // Arrange
        const user = User(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
        );
        const state1 = AuthState.authenticated(user: user, token: 'token1');
        const state2 = AuthState.authenticated(user: user, token: 'token2');

        // Assert
        expect(state1, isNot(equals(state2)));
      });
    });

    group('copyWith', () {
      test('should copy with new values', () {
        // Arrange
        const original = AuthState.unauthenticated();
        const user = User(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
        );

        // Act
        final copied = original.copyWith(
          isAuthenticated: true,
          user: user,
          token: 'new-token',
        );

        // Assert
        expect(copied.isAuthenticated, isTrue);
        expect(copied.user, equals(user));
        expect(copied.token, 'new-token');
      });

      test('should keep original values when not specified', () {
        // Arrange
        const user = User(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
        );
        const original = AuthState.authenticated(
          user: user,
          token: 'original-token',
        );

        // Act
        final copied = original.copyWith(token: 'new-token');

        // Assert
        expect(copied.isAuthenticated, isTrue);
        expect(copied.user, equals(user));
        expect(copied.token, 'new-token');
      });
    });

    group('toString', () {
      test('should contain authentication status', () {
        // Arrange
        const state = AuthState.unauthenticated();

        // Act
        final string = state.toString();

        // Assert
        expect(string, contains('AuthState'));
        expect(string, contains('isAuthenticated'));
      });

      test('should mask token for security', () {
        // Arrange
        const user = User(
          id: 'user-123',
          email: 'test@example.com',
          username: 'testuser',
        );
        const state =
            AuthState.authenticated(user: user, token: 'secret-token');

        // Act
        final string = state.toString();

        // Assert
        expect(string, contains('AuthState'));
        expect(string, isNot(contains('secret-token')));
        expect(string, contains('***'));
      });
    });
  });
}
