/// Home screen with Chinese app style design.
///
/// Features:
/// - Immersive header with gradient background
/// - Grid-style module navigation
/// - Card sections with rounded corners
/// - Compact information density
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/router/routes.dart';
import 'package:flutter_project_template/features/home/domain/entities/home_entity.dart';
import 'package:flutter_project_template/features/home/presentation/providers/home_provider.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Home screen widget.
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
      backgroundColor: colorScheme.surfaceContainerLow,
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
        error: (error, stack) => _ErrorState(
          error: error,
          localizations: localizations,
          colorScheme: colorScheme,
          textTheme: textTheme,
          onRetry: () => ref.read(homeNotifierProvider.notifier).refresh(),
        ),
      ),
    );
  }
}

/// Error state widget.
class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.error,
    required this.localizations,
    required this.colorScheme,
    required this.textTheme,
    required this.onRetry,
  });

  final Object error;
  final AppLocalizations localizations;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
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
                onPressed: onRetry,
                child: Text(localizations.retry),
              ),
            ],
          ),
        ),
      );
}

/// Home content widget.
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
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _ImmersiveHeader(
              greeting: greeting,
              userName: home.userName,
              colorScheme: colorScheme,
              textTheme: textTheme,
              localizations: localizations,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _ProjectCard(
                    title: home.title,
                    message: home.welcomeMessage,
                    theme: theme,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    localizations: localizations,
                  ),
                  const SizedBox(height: 16),
                  _SectionTitle(
                    title: localizations.modulesIntro,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                  const SizedBox(height: 12),
                  _ModuleGrid(
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    localizations: localizations,
                  ),
                  const SizedBox(height: 16),
                  _SectionTitle(
                    title: localizations.templateIncludes,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                  const SizedBox(height: 12),
                  _TechTags(
                    theme: theme,
                    localizations: localizations,
                  ),
                ]),
              ),
            ),
          ],
        ),
      );
}

/// Immersive header with gradient background.
class _ImmersiveHeader extends StatelessWidget {
  const _ImmersiveHeader({
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
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primary,
                colorScheme.primaryContainer,
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localizations.appTitle,
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search,
                              size: 18,
                              color: colorScheme.onPrimary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              localizations.searchHint,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onPrimary
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.push(Routes.profile),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: colorScheme.onPrimary.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: colorScheme.onPrimary,
                            child: Icon(
                              Icons.person,
                              size: 28,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$greeting，',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onPrimary
                                    .withValues(alpha: 0.8),
                              ),
                            ),
                            Text(
                              userName ?? localizations.guest,
                              style: textTheme.titleLarge?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

/// Section title widget.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.colorScheme,
    required this.textTheme,
  });

  final String title;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
}

/// Project introduction card.
class _ProjectCard extends StatelessWidget {
  const _ProjectCard({
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
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.rocket_launch_rounded,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      );
}

/// Module item data.
class _ModuleItem {
  const _ModuleItem({
    required this.icon,
    required this.title,
    required this.color,
    required this.bgColor,
  });

  final IconData icon;
  final String title;
  final Color color;
  final Color bgColor;
}

/// Module grid with Chinese app style.
class _ModuleGrid extends StatelessWidget {
  const _ModuleGrid({
    required this.colorScheme,
    required this.textTheme,
    required this.localizations,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final modules = [
      _ModuleItem(
        icon: Icons.login_rounded,
        title: localizations.moduleAuthTitle,
        color: const Color(0xFF4F46E5),
        bgColor: const Color(0xFFEEF2FF),
      ),
      _ModuleItem(
        icon: Icons.chat_bubble_rounded,
        title: localizations.moduleChatTitle,
        color: const Color(0xFF059669),
        bgColor: const Color(0xFFECFDF5),
      ),
      _ModuleItem(
        icon: Icons.settings_rounded,
        title: localizations.moduleSettingsTitle,
        color: const Color(0xFFD97706),
        bgColor: const Color(0xFFFFF7ED),
      ),
      _ModuleItem(
        icon: Icons.privacy_tip_rounded,
        title: localizations.modulePrivacyTitle,
        color: const Color(0xFFDC2626),
        bgColor: const Color(0xFFFEF2F2),
      ),
      _ModuleItem(
        icon: Icons.web_rounded,
        title: localizations.moduleWebViewTitle,
        color: const Color(0xFF0284C7),
        bgColor: const Color(0xFFF0F9FF),
      ),
      _ModuleItem(
        icon: Icons.extension_rounded,
        title: localizations.moduleMore,
        color: const Color(0xFF7C3AED),
        bgColor: const Color(0xFFF5F3FF),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: modules.length,
        itemBuilder: (context, index) => _ModuleGridItem(
          item: modules[index],
          textTheme: textTheme,
        ),
      ),
    );
  }
}

/// Module grid item widget.
class _ModuleGridItem extends StatelessWidget {
  const _ModuleGridItem({
    required this.item,
    required this.textTheme,
  });

  final _ModuleItem item;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: item.bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              item.icon,
              color: item.color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
}

/// Tech tags widget.
class _TechTags extends StatelessWidget {
  const _TechTags({
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: features
            .map(
              (feature) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 14,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      feature,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
