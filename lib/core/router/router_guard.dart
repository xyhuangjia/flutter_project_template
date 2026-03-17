/// Router guard for authentication and authorization.
///
/// This file provides guards for route protection and
/// redirect logic based on authentication state.
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_project_template/core/router/routes.dart';
import 'package:go_router/go_router.dart';

/// Router guard for route protection.
///
/// Provides static methods for authentication checks
/// and route redirects.
abstract final class RouterGuard {
  /// Public routes that don't require authentication.
  static const List<String> publicRoutes = [
    Routes.root,
    Routes.login,
    Routes.register,
    Routes.splash,
    Routes.error,
  ];

  /// Redirects based on authentication state.
  ///
  /// Returns a redirect path if needed, null otherwise.
  static String? redirect(BuildContext context, GoRouterState state) {
    final isAuthenticated = _checkAuthentication();
    final isPublicRoute = publicRoutes.contains(state.matchedLocation);

    // If not authenticated and trying to access protected route
    if (!isAuthenticated && !isPublicRoute) {
      return Routes.login;
    }

    // If authenticated and trying to access login/register
    if (isAuthenticated &&
        (state.matchedLocation == Routes.login ||
            state.matchedLocation == Routes.register)) {
      return Routes.home;
    }

    return null;
  }

  /// Checks if the user is authenticated.
  ///
  /// This would typically check a token in secure storage
  /// or a provider state.
  static bool _checkAuthentication() {
    // FIXME: Implement actual authentication check
    // Example: return ref.read(authProvider).isAuthenticated;
    return true; // Always authenticated for skeleton
  }

  /// Checks if a route requires authentication.
  static bool requiresAuthentication(String path) =>
      !publicRoutes.contains(path);
}
