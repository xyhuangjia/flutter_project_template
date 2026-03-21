/// Router guard for authentication and authorization.
///
/// This file provides guards for route protection and
/// redirect logic based on authentication state.
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_project_template/core/router/routes.dart';
import 'package:flutter_project_template/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_project_template/features/privacy/presentation/providers/privacy_provider.dart';
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
    Routes.privacyConsent,
  ];

  /// Routes that don't require privacy consent (initialization screens).
  static const List<String> noConsentRequiredRoutes = [
    Routes.splash,
    Routes.privacyConsent,
    Routes.error,
  ];

  /// Redirects based on authentication and privacy consent state.
  ///
  /// Returns a redirect path if needed, null otherwise.
  static String? redirect(BuildContext context, GoRouterState state) {
    final currentPath = state.matchedLocation;

    // Skip redirect logic for splash and error screens
    // These screens handle their own navigation logic
    if (currentPath == Routes.splash || currentPath == Routes.error) {
      return null;
    }

    final isAuthenticated = _checkAuthentication();
    final hasConsent = _checkPrivacyConsent();
    final isPublicRoute = publicRoutes.contains(currentPath);
    final requiresConsent = !noConsentRequiredRoutes.contains(currentPath);

    // First check: Privacy consent (must be accepted before any other screen)
    if (!hasConsent && requiresConsent) {
      return Routes.privacyConsent;
    }

    // Second check: Authentication
    if (!isAuthenticated && !isPublicRoute) {
      return Routes.login;
    }

    // If authenticated user tries to access login/register:
    // - Redirect away from login page
    // - Allow access to register page (user might want to register new account)
    if (isAuthenticated && currentPath == Routes.login) {
      return Routes.chat;
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

  /// Checks if the user has accepted privacy consent.
  ///
  /// Returns true only if:
  /// - Privacy state is loaded and user has consented
  ///
  /// Returns false if:
  /// - Privacy state is still loading
  /// - User has not consented
  static bool _checkPrivacyConsent() {
    if (_globalContainer == null) {
      return false;
    }
    try {
      final privacyState = _globalContainer!.read(privacyNotifierProvider);
      // If still loading, return false to prevent premature navigation
      if (privacyState.isLoading) {
        return false;
      }
      return privacyState.valueOrNull?.hasConsented ?? false;
    } on Exception {
      return false;
    }
  }

  /// Checks if a route requires authentication.
  static bool requiresAuthentication(String path) =>
      !publicRoutes.contains(path);

  /// Checks if a route requires privacy consent.
  static bool requiresConsent(String path) =>
      !noConsentRequiredRoutes.contains(path);
}
