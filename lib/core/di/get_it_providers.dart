/// Riverpod providers that bridge to GetIt services.
///
/// This file provides Riverpod providers that access services
/// registered in GetIt. This allows seamless integration between
/// Riverpod (UI state) and GetIt (service layer).
library;

import 'package:flutter_project_template/core/di/injection.dart';
import 'package:flutter_project_template/core/network/dio_client.dart';
import 'package:flutter_project_template/core/storage/database.dart';
import 'package:flutter_project_template/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_project_template/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_project_template/features/privacy/domain/repositories/privacy_repository.dart';
import 'package:flutter_project_template/features/settings/domain/repositories/developer_options_repository.dart';
import 'package:flutter_project_template/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter_project_template/features/webview/domain/repositories/webview_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_it_providers.g.dart';

/// Provides the DioClient singleton from GetIt.
@Riverpod(keepAlive: true)
DioClient dioClient(DioClientRef ref) => getIt<DioClient>();

/// Provides the AppDatabase singleton from GetIt.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) => getIt<AppDatabase>();

/// Provides the AuthRepository from GetIt.
@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) => getIt<AuthRepository>();

/// Provides the HomeRepository from GetIt.
@Riverpod(keepAlive: true)
HomeRepository homeRepository(HomeRepositoryRef ref) => getIt<HomeRepository>();

/// Provides the SettingsRepository from GetIt.
@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(SettingsRepositoryRef ref) =>
    getIt<SettingsRepository>();

/// Provides the DeveloperOptionsRepository from GetIt.
@Riverpod(keepAlive: true)
DeveloperOptionsRepository developerOptionsRepository(
  DeveloperOptionsRepositoryRef ref,
) =>
    getIt<DeveloperOptionsRepository>();

/// Provides the PrivacyRepository from GetIt.
@Riverpod(keepAlive: true)
PrivacyRepository privacyRepository(PrivacyRepositoryRef ref) =>
    getIt<PrivacyRepository>();

/// Provides the WebViewRepository from GetIt.
@Riverpod(keepAlive: true)
WebViewRepository webviewRepository(WebviewRepositoryRef ref) =>
    getIt<WebViewRepository>();
