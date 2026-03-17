/// Application router configuration.
///
/// This file configures go_router with all application routes,
/// guards, and navigation logic.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/router/router_guard.dart';
import 'package:flutter_project_template/core/router/routes.dart';
import 'package:flutter_project_template/features/home/presentation/screens/home_screen.dart';
import 'package:go_router/go_router.dart';

/// Application router configuration.
///
/// Provides the go_router configuration with all routes,
/// redirect logic, and error handling.
final GoRouter appRouter = GoRouter(
  initialLocation: Routes.home,
  debugLogDiagnostics: true,
  redirect: RouterGuard.redirect,
  routes: [
    GoRoute(
      path: Routes.root,
      redirect: (context, state) => Routes.home,
    ),
    GoRoute(
      path: Routes.home,
      name: RouteNames.home,
      builder: (context, state) => const HomeScreen(),
    ),
    // Add more routes here as the app grows
    // GoRoute(
    //   path: Routes.settings,
    //   name: RouteNames.settings,
    //   builder: (context, state) => const SettingsScreen(),
    // ),
    // GoRoute(
    //   path: Routes.profile,
    //   name: RouteNames.profile,
    //   builder: (context, state) => const ProfileScreen(),
    // ),
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
            onPressed: () => context.go(Routes.home),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
);
