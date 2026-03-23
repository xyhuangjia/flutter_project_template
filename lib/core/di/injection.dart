/// Dependency injection configuration using get_it and injectable.
///
/// This file provides the service locator setup for the application.
/// GetIt manages singleton services while Riverpod handles UI state.
///
/// ## Architecture
///
/// - **GetIt**: Manages service layer singletons (DioClient, Database, Repositories)
/// - **Riverpod**: Manages UI state and presentation logic
/// - **Bridge**: Riverpod providers can access GetIt services
///
/// ## Usage
///
/// ```dart
/// // In main.dart
/// final sharedPreferences = await SharedPreferences.getInstance();
/// await configureDependencies(sharedPreferences: sharedPreferences);
///
/// // In providers
/// final dioClient = getIt<DioClient>();
/// ```
library;

import 'package:flutter_project_template/core/di/injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global service locator instance.
final getIt = GetIt.instance;

/// Initializes all registered dependencies.
///
/// This should be called in main.dart before runApp().
/// The [environment] parameter allows for environment-specific
/// registrations (dev, staging, prod).
///
/// [sharedPreferences] is required for data sources that depend on it.
///
/// Example:
/// ```dart
/// final sharedPreferences = await SharedPreferences.getInstance();
/// await configureDependencies(
///   sharedPreferences: sharedPreferences,
///   environment: Environment.prod,
/// );
/// ```
@InjectableInit(
  preferRelativeImports: true,
)
Future<void> configureDependencies({
  required SharedPreferences sharedPreferences,
  String environment = Environment.dev,
}) async {
  // Allow reassignment for testing purposes
  getIt.allowReassignment = true;

  // Register SharedPreferences first (external dependency)
  if (!getIt.isRegistered<SharedPreferences>()) {
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  }

  // Register all dependencies via generated code
  getIt.init(environment: environment);
}

/// Resets all registered dependencies.
///
/// Useful for testing or when needing to reinitialize the DI container.
Future<void> resetDependencies() async {
  await getIt.reset();
}
