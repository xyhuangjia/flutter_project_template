/// Application router configuration.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/router/router_guard.dart';
import 'package:flutter_project_template/core/router/routes.dart';
import 'package:flutter_project_template/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_project_template/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter_project_template/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_project_template/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_project_template/features/settings/presentation/screens/about_screen.dart';
import 'package:flutter_project_template/features/chat/presentation/screens/conversation_list_screen.dart';
import 'package:flutter_project_template/features/chat/presentation/screens/chat_detail_screen.dart';
import 'package:flutter_project_template/features/webview/presentation/screens/webview_screen.dart';
import 'package:go_router/go_router.dart';

/// Application router configuration.
///
/// Provides the go_router configuration with all routes,
/// redirect logic, and error handling.
final GoRouter appRouter = GoRouter(
  initialLocation: Routes.chat,
  debugLogDiagnostics: true,
  redirect: RouterGuard.redirect,
  routes: [
    GoRoute(
      path: Routes.root,
      redirect: (context, state) => Routes.chat,
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
        final title = state.uri.queryParameters['title'];
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
