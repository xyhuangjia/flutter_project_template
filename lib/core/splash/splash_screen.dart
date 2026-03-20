/// Splash screen for app initialization.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/router/routes.dart';
import 'package:flutter_project_template/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_project_template/features/privacy/presentation/providers/privacy_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Splash screen that handles app initialization and routing.
class SplashScreen extends ConsumerStatefulWidget {
  /// Creates a splash screen.
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _initializeApp();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    // Wait for privacy state to load
    await ref.read(privacyNotifierProvider.future);

    // Small delay for smooth transition
    await Future<void>.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    final privacyState = ref.read(privacyNotifierProvider).valueOrNull;
    final isAuthenticated =
        ref.read(authNotifierProvider.notifier).isAuthenticated;

    // Step 1: Check privacy consent
    if (privacyState?.hasConsented != true) {
      context.go(Routes.privacyConsent);
      return;
    }

    // Step 2: Check authentication
    if (!isAuthenticated) {
      context.go(Routes.login);
      return;
    }

    // Step 3: Go to main screen
    context.go(Routes.chat);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App logo with container
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.flutter_dash,
                      size: 80,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // App name
                  Text(
                    'Flutter App',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Tagline
                  Text(
                    'Your Privacy, Our Priority',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 64),
                  // Loading indicator
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
