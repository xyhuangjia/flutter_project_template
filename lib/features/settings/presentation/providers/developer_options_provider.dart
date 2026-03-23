/// Developer options provider using Riverpod code generation.
library;

import 'package:flutter_project_template/core/di/injection.dart';
import 'package:flutter_project_template/core/providers/locale_provider.dart';
import 'package:flutter_project_template/features/settings/data/datasources/developer_options_local_data_source.dart';
import 'package:flutter_project_template/features/settings/domain/entities/developer_options.dart';
import 'package:flutter_project_template/features/settings/domain/repositories/developer_options_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'developer_options_provider.g.dart';

/// Provider for DeveloperOptionsLocalDataSource.
/// Uses GetIt for dependency injection.
@riverpod
DeveloperOptionsLocalDataSource developerOptionsLocalDataSource(
  Ref ref,
) => getIt<DeveloperOptionsLocalDataSource>();

/// Provider for DeveloperOptionsRepository.
/// Uses GetIt for dependency injection.
@riverpod
DeveloperOptionsRepository developerOptionsRepository(
  Ref ref,
) => getIt<DeveloperOptionsRepository>();

/// Developer options notifier provider.
///
/// Manages the developer options state.
@riverpod
class DeveloperOptionsNotifier extends _$DeveloperOptionsNotifier {
  @override
  Future<DeveloperOptions> build() async {
    await ref.watch(sharedPrefsProvider.future);
    final repository = ref.read(developerOptionsRepositoryProvider);
    final result = await repository.getDeveloperOptions();

    return result.when(
      failure: (_) => DeveloperOptions.defaults,
      success: (options) => options,
    );
  }

  /// Updates the custom API base URL.
  Future<bool> updateCustomApiBaseUrl(String? url) async {
    final current = state.value ?? DeveloperOptions.defaults;
    final updated = current.copyWith(
      customApiBaseUrl: url,
      clearCustomApiBaseUrl: url == null,
    );
    return _saveOptions(updated);
  }

  /// Updates the log level.
  Future<bool> updateLogLevel(LogLevel level) async {
    final current = state.value ?? DeveloperOptions.defaults;
    final updated = current.copyWith(logLevel: level);
    return _saveOptions(updated);
  }

  /// Updates the logging enabled flag.
  Future<bool> updateLoggingEnabled(bool enabled) async {
    final current = state.value ?? DeveloperOptions.defaults;
    final updated = current.copyWith(loggingEnabled: enabled);
    return _saveOptions(updated);
  }

  /// Updates the network log enabled flag.
  Future<bool> updateNetworkLogEnabled(bool enabled) async {
    final current = state.value ?? DeveloperOptions.defaults;
    final updated = current.copyWith(networkLogEnabled: enabled);
    return _saveOptions(updated);
  }

  /// Updates the performance monitor enabled flag.
  Future<bool> updatePerformanceMonitorEnabled(bool enabled) async {
    final current = state.value ?? DeveloperOptions.defaults;
    final updated = current.copyWith(performanceMonitorEnabled: enabled);
    return _saveOptions(updated);
  }

  /// Updates the show debug info flag.
  Future<bool> updateShowDebugInfo(bool show) async {
    final current = state.value ?? DeveloperOptions.defaults;
    final updated = current.copyWith(showDebugInfo: show);
    return _saveOptions(updated);
  }

  /// Updates an experimental feature flag.
  Future<bool> updateExperimentalFeature(String key, bool enabled) async {
    final current = state.value ?? DeveloperOptions.defaults;
    final features = Map<String, bool>.from(current.experimentalFeatures);
    features[key] = enabled;
    final updated = current.copyWith(experimentalFeatures: features);
    return _saveOptions(updated);
  }

  /// Resets all developer options to defaults.
  Future<bool> resetToDefaults() async => _saveOptions(DeveloperOptions.defaults);

  /// Clears app cache.
  Future<bool> clearCache() async {
    final repository = ref.read(developerOptionsRepositoryProvider);
    final result = await repository.clearCache();
    return !result.isFailure;
  }

  /// Clears database data.
  Future<bool> clearDatabase() async {
    final repository = ref.read(developerOptionsRepositoryProvider);
    final result = await repository.clearDatabase();
    return !result.isFailure;
  }

  Future<bool> _saveOptions(DeveloperOptions options) async {
    final repository = ref.read(developerOptionsRepositoryProvider);
    final result = await repository.updateDeveloperOptions(options);

    result.when(
      failure: (_) => null,
      success: (updated) => state = AsyncValue.data(updated),
    );

    return !result.isFailure;
  }
}
