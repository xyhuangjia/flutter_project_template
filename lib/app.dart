/// Application configuration and root widget.
///
/// This file defines the MaterialApp configuration including
/// theme, routing, localization, and other app-level settings.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/providers/locale_provider.dart';
import 'package:flutter_project_template/core/router/app_router.dart';
import 'package:flutter_project_template/core/theme/app_theme.dart';
import 'package:flutter_project_template/core/widgets/keyboard_dismiss_wrapper.dart';
import 'package:flutter_project_template/features/settings/domain/entities/settings_entity.dart';
import 'package:flutter_project_template/features/settings/presentation/providers/settings_provider.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Root application widget.
///
/// Configures the MaterialApp with theme, routing, and localization.
class MyApp extends ConsumerWidget {
  /// Creates the root application widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeAsync = ref.watch(localeNotifierProvider);
    final settingsAsync = ref.watch(settingsNotifierProvider);

    return KeyboardDismissWrapper(
      child: localeAsync.when(
        data: (locale) => _buildMaterialApp(
          themeMode: _getThemeMode(settingsAsync),
          locale: locale,
        ),
        loading: _buildMaterialApp,
        error: (_, __) => _buildMaterialApp(),
      ),
    );
  }

  /// Builds the MaterialApp.router with common configuration.
  Widget _buildMaterialApp({
    ThemeMode themeMode = ThemeMode.system,
    Locale? locale,
  }) =>
      MaterialApp.router(
        title: 'Flutter Project Template',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: themeMode,
        routerConfig: appRouter,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
      );

  /// Gets the ThemeMode from settings.
  ThemeMode _getThemeMode(AsyncValue<SettingsEntity> settingsAsync) =>
      settingsAsync.when(
        data: (settings) => AppTheme.toThemeMode(settings.themeMode),
        loading: () => ThemeMode.system,
        error: (_, __) => ThemeMode.system,
      );
}
