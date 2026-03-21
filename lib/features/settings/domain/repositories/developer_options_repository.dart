/// Developer options repository interface.
library;

import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/settings/domain/entities/developer_options.dart';

/// Developer options repository interface.
abstract class DeveloperOptionsRepository {
  /// Gets the developer options.
  Future<Result<DeveloperOptions>> getDeveloperOptions();

  /// Updates the developer options.
  Future<Result<DeveloperOptions>> updateDeveloperOptions(
    DeveloperOptions options,
  );

  /// Clears all developer options (resets to defaults).
  Future<Result<void>> clearDeveloperOptions();

  /// Clears app cache.
  Future<Result<void>> clearCache();

  /// Clears database data.
  Future<Result<void>> clearDatabase();
}