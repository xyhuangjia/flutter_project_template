/// Application router configuration.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/router/router_guard.dart';
import 'package:flutter_project_template/core/router/routes.dart';
import 'package:flutter_project_template/core/splash/splash_screen.dart';
import 'package:flutter_project_template/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:flutter_project_template/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_project_template/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter_project_template/features/chat/presentation/screens/chat_detail_screen.dart';
import 'package:flutter_project_template/features/chat/presentation/screens/conversation_list_screen.dart';
import 'package:flutter_project_template/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_project_template/features/privacy/presentation/screens/account_deletion_screen.dart';
import 'package:flutter_project_template/features/privacy/presentation/screens/permission_rationale_screen.dart';
import 'package:flutter_project_template/features/privacy/presentation/screens/privacy_consent_screen.dart';
import 'package:flutter_project_template/features/privacy/presentation/screens/privacy_settings_screen.dart';
import 'package:flutter_project_template/features/privacy/presentation/widgets/permission_card.dart';
import 'package:flutter_project_template/features/settings/presentation/screens/about_screen.dart';
import 'package:flutter_project_template/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_project_template/features/webview/presentation/screens/webview_screen.dart';
import 'package:go_router/go_router.dart';

/// Application router configuration.
///
/// Provides the go_router configuration with all routes,
/// redirect logic, and error handling.
final GoRouter appRouter = GoRouter(
  initialLocation: Routes.splash,
  debugLogDiagnostics: true,
  redirect: RouterGuard.redirect,
  routes: [
    // Splash screen - entry point for app initialization
    GoRoute(
      path: Routes.splash,
      name: RouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: Routes.root,
      redirect: (context, state) => Routes.splash,
    ),
    GoRoute(
      path: Routes.home,
      name: RouteNames.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: Routes.login,
      name: RouteNames.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: Routes.register,
      name: RouteNames.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: Routes.settings,
      name: RouteNames.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: Routes.about,
      name: RouteNames.about,
      builder: (context, state) => const AboutScreen(),
    ),
    GoRoute(
      path: Routes.webView,
      name: RouteNames.webView,
      builder: (context, state) {
        final title = state.uri.queryParameters['title'] ?? '';
        final url = state.uri.queryParameters['url'] ?? '';
        return WebViewScreen.url(
          url: url,
          title: title,
        );
      },
    ),
    // Chat routes
    GoRoute(
      path: Routes.chat,
      name: RouteNames.chat,
      builder: (context, state) => const ConversationListScreen(),
    ),
    GoRoute(
      path: Routes.chatDetail,
      name: RouteNames.chatDetail,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return ChatDetailScreen(conversationId: id);
      },
    ),
    // Privacy routes
    GoRoute(
      path: Routes.privacyConsent,
      name: RouteNames.privacyConsent,
      builder: (context, state) => const PrivacyConsentScreen(),
    ),
    GoRoute(
      path: Routes.privacySettings,
      name: RouteNames.privacySettings,
      builder: (context, state) => const PrivacySettingsScreen(),
    ),
    GoRoute(
      path: Routes.permissionRationale,
      name: RouteNames.permissionRationale,
      builder: (context, state) {
        final typeStr = state.uri.queryParameters['type'] ?? 'camera';
        final permissionType = PermissionType.values.firstWhere(
          (e) => e.name == typeStr,
          orElse: () => PermissionType.camera,
        );
        return PermissionRationaleScreen(permissionType: permissionType);
      },
    ),
    GoRoute(
      path: Routes.accountDeletion,
      name: RouteNames.accountDeletion,
      builder: (context, state) => const AccountDeletionScreen(),
    ),
    // Forgot password route
    GoRoute(
      path: Routes.forgotPassword,
      name: RouteNames.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(
      title: const Text('Error'),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Page not found: ${state.error?.toString() ?? 'Unknown error'}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go(Routes.chat),
            child: const Text('Go to Chat'),
          ),
        ],
      ),
    ),
  ),
);
