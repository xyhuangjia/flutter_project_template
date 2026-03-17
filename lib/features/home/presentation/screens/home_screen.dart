/// Home screen displaying welcome message and user info.
///
/// This screen demonstrates the pattern for building screens
/// using ConsumerWidget and Riverpod providers.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/constants/app_strings.dart';
import 'package:flutter_project_template/features/home/domain/entities/home_entity.dart';
import 'package:flutter_project_template/features/home/presentation/providers/home_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Home screen widget.
///
/// Displays a welcome message and basic user information.
class HomeScreen extends ConsumerWidget {
  /// Creates the home screen.
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeNotifierProvider);
    final greeting = ref.watch(greetingMessageProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.home),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: homeState.when(
        data: (home) => _HomeContent(
          greeting: greeting,
          home: home,
          theme: theme,
          colorScheme: colorScheme,
          textTheme: textTheme,
          onRefresh: () => ref.read(homeNotifierProvider.notifier).refresh(),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.error,
                  style: textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () =>
                      ref.read(homeNotifierProvider.notifier).refresh(),
                  child: const Text(AppStrings.retry),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Home content widget displaying the main content.
class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.greeting,
    required this.home,
    required this.theme,
    required this.colorScheme,
    required this.textTheme,
    required this.onRefresh,
  });

  final String greeting;
  final HomeEntity home;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        onRefresh: () async => onRefresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderSection(
                greeting: greeting,
                userName: home.userName,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              const SizedBox(height: 24),
              _WelcomeCard(
                title: home.title,
                message: home.welcomeMessage,
                theme: theme,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              const SizedBox(height: 24),
              _QuickActionsSection(
                theme: theme,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ],
          ),
        ),
      );
}

/// Header section with greeting and avatar.
class _HeaderSection extends StatelessWidget {
  const _HeaderSection({
    required this.greeting,
    required this.userName,
    required this.colorScheme,
    required this.textTheme,
  });

  final String greeting;
  final String? userName;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: colorScheme.primaryContainer,
            child: Icon(
              Icons.person,
              size: 32,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  userName ?? 'Guest',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

/// Welcome card displaying the main message.
class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({
    required this.title,
    required this.message,
    required this.theme,
    required this.colorScheme,
    required this.textTheme,
  });

  final String title;
  final String message;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.rocket_launch,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'This template includes:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              _FeatureList(theme: theme),
            ],
          ),
        ),
      );
}

/// Feature list showing included features.
class _FeatureList extends StatelessWidget {
  const _FeatureList({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    const features = [
      'Clean Architecture structure',
      'Riverpod state management',
      'go_router navigation',
      'Dio HTTP client',
      'Drift database',
      'json_serializable',
      'Comprehensive lint rules',
    ];

    return Column(
      children: features
          .map(
            (feature) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feature,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

/// Quick actions section with action buttons.
class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection({
    required this.theme,
    required this.colorScheme,
    required this.textTheme,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionCard(
                  icon: Icons.person_outline,
                  label: 'Profile',
                  theme: theme,
                  onTap: () {
                    // Navigate to profile
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionCard(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  theme: theme,
                  onTap: () {
                    // Navigate to settings
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionCard(
                  icon: Icons.info_outline,
                  label: 'About',
                  theme: theme,
                  onTap: () {
                    // Navigate to about
                  },
                ),
              ),
            ],
          ),
        ],
      );
}

/// Action card widget.
class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.label,
    required this.theme,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final ThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
}
