/// Get home data use case.
///
/// This file defines the use case for fetching home data.
library;

import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/home/domain/entities/home_entity.dart';
import 'package:flutter_project_template/features/home/domain/repositories/home_repository.dart';

/// Get home data use case.
///
/// Encapsulates the business logic for fetching home data.
class GetHomeData {
  /// Creates a get home data use case.
  GetHomeData(this._repository);

  final HomeRepository _repository;

  /// Executes the use case.
  ///
  /// Returns either a [HomeEntity] on success or a [Failure] on error.
  Future<Result<HomeEntity>> call() async => _repository.getHomeData();
}
