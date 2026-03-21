/// Application router configuration.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/router/router_guard.dart';
import 'package:flutter_project_template/core/router/routes.dart';
import 'package:flutter_project_template/core/splash/splash_screen.dart';
import 'package:flutter_project_template/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:flutter_project_template/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_project_template/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter_project_template/features/chat/presentation/screens/ai_config_screen.dart';
import 'package:flutter_project_template/features/chat/presentation/screens/chat_detail_screen.dart';
import 'package:flutter_project_template/features/chat/presentation/screens/conversation_list_screen.dart';
import 'package:flutter_project_template/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_project_template/features/privacy/presentation/screens/account_deletion_screen.dart';
import 'package:flutter_project_template/features/privacy/presentation/screens/permission_rationale_screen.dart';
import 'package:flutter_project_template/features/privacy/presentation/screens/privacy_settings_screen.dart';
import 'package:flutter_project_template/features/privacy/presentation/widgets/permission_card.dart';
import 'package:flutter_project_template/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_project_template/features/settings/presentation/screens/about_screen.dart';
import 'package:flutter_project_template/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_project_template/features/webview/presentation/screens/webview_screen.dart';
import 'package:go_router/go_router.dart';

/// Creates a page with iOS-style slide transition.
CustomTransitionPage<T> _iosSlidePage<T>({
  required Widget child,
  required GoRouterState state,
  String? name,
}) =>
    CustomTransitionPage<T>(
      key: state.pageKey,
      name: name,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // iOS push animation: slide from right
        final slideAnimation = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
          reverseCurve: Curves.easeInOut,
        ));

        return SlideTransition(
          position: slideAnimation,
          child: child,
        );
      },
    );

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
    // Login - use iOS transition
    GoRoute(
      path: Routes.login,
      name: RouteNames.login,
      pageBuilder: (context, state) => _iosSlidePage(
        child: const LoginScreen(),
        state: state,
        name: RouteNames.login,
      ),
    ),
    // Register - use iOS transition
    GoRoute(
      path: Routes.register,
      name: RouteNames.register,
      pageBuilder: (context, state) => _iosSlidePage(
        child: const RegisterScreen(),
        state: state,
        name: RouteNames.register,
      ),
    ),
    // Settings - use iOS transition
    GoRoute(
      path: Routes.settings,
      name: RouteNames.settings,
      pageBuilder: (context, state) => _iosSlidePage(
        child: const SettingsScreen(),
        state: state,
        name: RouteNames.settings,
      ),
    ),
    // About - use iOS transition
    GoRoute(
      path: Routes.about,
      name: RouteNames.about,
      pageBuilder: (context, state) => _iosSlidePage(
        child: const AboutScreen(),
        state: state,
        name: RouteNames.about,
      ),
    ),
    // Profile - use iOS transition
    GoRoute(
      path: Routes.profile,
      name: RouteNames.profile,
      pageBuilder: (context, state) => _iosSlidePage(
        child: const ProfileScreen(),
        state: state,
        name: RouteNames.profile,
      ),
    ),
    // WebView - use iOS transition
    GoRoute(
      path: Routes.webView,
      name: RouteNames.webView,
      pageBuilder: (context, state) {
        final title = state.uri.queryParameters['title'] ?? '';
        final url = state.uri.queryParameters['url'] ?? '';
        return _iosSlidePage(
          child: WebViewScreen.url(
            url: url,
            title: title,
          ),
          state: state,
          name: RouteNames.webView,
        );
      },
    ),
    // Chat routes
    GoRoute(
      path: Routes.chat,
      name: RouteNames.chat,
      builder: (context, state) => const ConversationListScreen(),
    ),
    // Chat detail - use iOS transition
    GoRoute(
      path: Routes.chatDetail,
      name: RouteNames.chatDetail,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return _iosSlidePage(
          child: ChatDetailScreen(conversationId: id),
          state: state,
          name: RouteNames.chatDetail,
        );
      },
    ),
    // Privacy routes - use iOS transition
    GoRoute(
      path: Routes.privacySettings,
      name: RouteNames.privacySettings,
      pageBuilder: (context, state) => _iosSlidePage(
        child: const PrivacySettingsScreen(),
        state: state,
        name: RouteNames.privacySettings,
      ),
    ),
    GoRoute(
      path: Routes.permissionRationale,
      name: RouteNames.permissionRationale,
      pageBuilder: (context, state) {
        final typeStr = state.uri.queryParameters['type'] ?? 'camera';
        final permissionType = PermissionType.values.firstWhere(
          (e) => e.name == typeStr,
          orElse: () => PermissionType.camera,
        );
        return _iosSlidePage(
          child: PermissionRationaleScreen(permissionType: permissionType),
          state: state,
          name: RouteNames.permissionRationale,
        );
      },
    ),
    GoRoute(
      path: Routes.accountDeletion,
      name: RouteNames.accountDeletion,
      pageBuilder: (context, state) => _iosSlidePage(
        child: const AccountDeletionScreen(),
        state: state,
        name: RouteNames.accountDeletion,
      ),
    ),
    // Forgot password - use iOS transition
    GoRoute(
      path: Routes.forgotPassword,
      name: RouteNames.forgotPassword,
      pageBuilder: (context, state) => _iosSlidePage(
        child: const ForgotPasswordScreen(),
        state: state,
        name: RouteNames.forgotPassword,
      ),
    ),
    // AI configuration - use iOS transition
    GoRoute(
      path: Routes.aiConfig,
      name: RouteNames.aiConfig,
      pageBuilder: (context, state) => _iosSlidePage(
        child: const AIConfigScreen(),
        state: state,
        name: RouteNames.aiConfig,
      ),
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
