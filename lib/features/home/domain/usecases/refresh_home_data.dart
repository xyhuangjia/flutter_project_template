/// Refresh home data use case.
///
/// This file defines the use case for refreshing home data.
library;

import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/home/domain/entities/home_entity.dart';
import 'package:flutter_project_template/features/home/domain/repositories/home_repository.dart';

/// Refresh home data use case.
///
/// Encapsulates the business logic for refreshing home data.
class RefreshHomeData {
  /// Creates a refresh home data use case.
  RefreshHomeData(this._repository);

  final HomeRepository _repository;

  /// Executes the use case.
  ///
  /// Returns either a [HomeEntity] on success or a [Failure] on error.
  Future<Result<HomeEntity>> call() async {
    return _repository.refreshHomeData();
  }
}
