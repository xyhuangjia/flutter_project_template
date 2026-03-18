/// Auth state entity representing authentication status.
///
/// This is a domain entity with no external dependencies.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_project_template/features/auth/domain/entities/user.dart';

/// Auth state representing the current authentication status.
@immutable
class AuthState {
  /// Creates an auth state.
  const AuthState({required this.isAuthenticated, this.user, this.token});

  /// Creates an unauthenticated state.
  const AuthState.unauthenticated()
    : isAuthenticated = false,
      user = null,
      token = null;

  /// Creates an authenticated state.
  const AuthState.authenticated({required User user, required String token})
    : isAuthenticated = true,
      this.user = user,
      this.token = token;

  /// Whether the user is authenticated.
  final bool isAuthenticated;

  /// The authenticated user (null if not authenticated).
  final User? user;

  /// The authentication token (null if not authenticated).
  final String? token;

  /// Creates a copy of this state with optionally overridden fields.
  AuthState copyWith({bool? isAuthenticated, User? user, String? token}) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthState &&
        other.isAuthenticated == isAuthenticated &&
        other.user == user &&
        other.token == token;
  }

  @override
  int get hashCode => Object.hash(isAuthenticated, user, token);

  @override
  String toString() {
    return 'AuthState(isAuthenticated: $isAuthenticated, user: $user, '
        'token: ${token != null ? "***" : null})';
  }
}
