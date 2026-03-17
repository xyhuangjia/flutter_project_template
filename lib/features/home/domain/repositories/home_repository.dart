/// Home repository interface.
///
/// This file defines the repository contract for home feature.
library;

import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/home/domain/entities/home_entity.dart';

/// Home repository interface.
///
/// Defines the contract for home data operations.
/// This is part of the domain layer and has no external dependencies.
abstract class HomeRepository {
  /// Gets home data.
  ///
  /// Returns either a [HomeEntity] on success or a [Failure] on error.
  Future<Result<HomeEntity>> getHomeData();

  /// Refreshes home data.
  ///
  /// Returns either a [HomeEntity] on success or a [Failure] on error.
  Future<Result<HomeEntity>> refreshHomeData();
}
