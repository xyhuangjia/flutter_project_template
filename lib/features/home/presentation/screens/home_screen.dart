/// Home screen displaying welcome message and user info.
///
/// This screen demonstrates the pattern for building screens
/// using ConsumerWidget and Riverpod providers.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/router/routes.dart';
import 'package:flutter_project_template/features/home/domain/entities/home_entity.dart';
import 'package:flutter_project_template/features/home/presentation/providers/home_provider.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.home),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push(Routes.profile),
            tooltip: localizations.profile,
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
          localizations: localizations,
          onRefresh: () => ref.read(homeNotifierProvider.notifier).refresh(),
        ),
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(localizations.loading),
            ],
          ),
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
                  localizations.error,
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
                  child: Text(localizations.retry),
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
    required this.localizations,
    required this.onRefresh,
  });

  final String greeting;
  final HomeEntity home;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final AppLocalizations localizations;
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
                localizations: localizations,
              ),
              const SizedBox(height: 24),
              _WelcomeCard(
                title: home.title,
                message: home.welcomeMessage,
                theme: theme,
                colorScheme: colorScheme,
                textTheme: textTheme,
                localizations: localizations,
              ),
              const SizedBox(height: 24),
              _QuickAccessGrid(),
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
    required this.localizations,
  });

  final String greeting;
  final String? userName;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final AppLocalizations localizations;

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
                  userName ?? localizations.guest,
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
    required this.localizations,
  });

  final String title;
  final String message;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final AppLocalizations localizations;

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
              Text(
                localizations.templateIncludes,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              _FeatureList(theme: theme, localizations: localizations),
            ],
          ),
        ),
      );
}

/// Feature list showing included features.
class _FeatureList extends StatelessWidget {
  const _FeatureList({
    required this.theme,
    required this.localizations,
  });

  final ThemeData theme;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final features = [
      localizations.featureCleanArchitecture,
      localizations.featureRiverpod,
      localizations.featureGoRouter,
      localizations.featureDio,
      localizations.featureDrift,
      localizations.featureJsonSerializable,
      localizations.featureLintRules,
      localizations.featureI18n,
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

/// Quick access grid for main features.
class _QuickAccessGrid extends StatelessWidget {
  const _QuickAccessGrid({super.key});

  static const _FeatureItem _auth = _FeatureItem(
    icon: Icons.login,
    title: 'Authentication',
    description: 'Login, register, and manage your account',
    route: '/login',
  );

  static const _FeatureItem _profile = _FeatureItem(
    icon: Icons.person,
    title: 'Profile',
    description: 'View and manage your profile',
    route: '/profile',
  );

  static const _FeatureItem _chat = _FeatureItem(
    icon: Icons.chat_bubble,
    title: 'AI Chat',
    description: 'Chat with AI assistant',
    route: '/chat',
  );

  static const _FeatureItem _settings = _FeatureItem(
    icon: Icons.settings,
    title: 'Settings',
    description: 'Configure app preferences',
    route: '/settings',
  );

  static const _FeatureItem _privacy = _FeatureItem(
    icon: Icons.privacy_tip,
    title: 'Privacy',
    description: 'Manage privacy settings',
    route: '/privacy/settings',
  );

  static const _FeatureItem _webview = _FeatureItem(
    icon: Icons.web,
    title: 'WebView',
    description: 'Browse web content',
    route: '/webview',
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _QuickAccessCard(item: _auth),
        const SizedBox(height: 12),
        const _QuickAccessCard(item: _profile),
        const SizedBox(height: 12),
        const _QuickAccessCard(item: _chat),
        const SizedBox(height: 12),
        const _QuickAccessCard(item: _settings),
        const SizedBox(height: 12),
        const _QuickAccessCard(item: _privacy),
        const SizedBox(height: 12),
        const _QuickAccessCard(item: _webview),
      ],
    );
  }
}

/// Feature item data class.
class _FeatureItem {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.route,
  });

  final IconData icon;
  final String title;
  final String description;
  final String route;
}

/// Quick access card for a feature.
class _QuickAccessCard extends StatelessWidget {
  const _QuickAccessCard({
    required this.item,
    super.key,
  });

  final _FeatureItem item;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return Card(
          child: InkWell(
            onTap: () => context.push(item.route),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      item.icon,
                      color: colorScheme.onPrimaryContainer,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.description,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
