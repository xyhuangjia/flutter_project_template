/// Router guard for authentication and authorization.
///
/// This file provides guards for route protection and
/// redirect logic based on authentication state.
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_project_template/core/router/routes.dart';
import 'package:flutter_project_template/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Global provider container for router guard.
///
/// This is set in main.dart before the app starts.
ProviderContainer? _globalContainer;

/// Sets the global provider container for router guard.
void setRouterGuardContainer(ProviderContainer container) {
  _globalContainer = container;
}

/// Router guard for route protection.
///
/// Provides static methods for authentication checks
/// and route redirects.
abstract final class RouterGuard {
  /// Public routes that don't require authentication.
  static const List<String> publicRoutes = [
    Routes.root,
    Routes.home,
    Routes.login,
    Routes.register,
    Routes.splash,
    Routes.error,
    Routes.about,
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
  static bool _checkAuthentication() {
    if (_globalContainer == null) {
      return false;
    }
    try {
      return _globalContainer!
          .read(authNotifierProvider.notifier)
          .isAuthenticated;
    } on Exception {
      return false;
    }
  }

  /// Checks if a route requires authentication.
  static bool requiresAuthentication(String path) =>
      !publicRoutes.contains(path);
}
