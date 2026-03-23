/// Developer options repository implementation.
library;

import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/core/storage/database.dart';
import 'package:flutter_project_template/features/settings/data/datasources/developer_options_local_data_source.dart';
import 'package:flutter_project_template/features/settings/data/models/developer_options_dto.dart';
import 'package:flutter_project_template/features/settings/domain/entities/developer_options.dart';
import 'package:flutter_project_template/features/settings/domain/repositories/developer_options_repository.dart';
import 'package:injectable/injectable.dart';

/// Developer options repository implementation.
/// Registered as a lazy singleton in GetIt.
@LazySingleton(as: DeveloperOptionsRepository)
class DeveloperOptionsRepositoryImpl implements DeveloperOptionsRepository {
  /// Creates developer options repository.
  DeveloperOptionsRepositoryImpl({
    required DeveloperOptionsLocalDataSource localDataSource,
    required AppDatabase database,
  })  : _localDataSource = localDataSource,
        _database = database;

  final DeveloperOptionsLocalDataSource _localDataSource;
  final AppDatabase _database;

  @override
  Future<Result<DeveloperOptions>> getDeveloperOptions() async {
    try {
      final dto = _localDataSource.getDeveloperOptions();
      if (dto == null) {
        return const Success(DeveloperOptions.defaults);
      }
      return Success(dto.toEntity());
    } catch (e) {
      return FailureResult(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<DeveloperOptions>> updateDeveloperOptions(
    DeveloperOptions options,
  ) async {
    try {
      final dto = DeveloperOptionsDto.fromEntity(options);
      await _localDataSource.saveDeveloperOptions(dto);
      return Success(options);
    } catch (e) {
      return FailureResult(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> clearDeveloperOptions() async {
    try {
      await _localDataSource.clearDeveloperOptions();
      return const Success(null);
    } catch (e) {
      return FailureResult(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> clearCache() async {
    try {
      await _localDataSource.clearCache();
      return const Success(null);
    } catch (e) {
      return FailureResult(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> clearDatabase() async {
    try {
      await _database.clearAllUsers();
      // Add other table clearing as needed
      return const Success(null);
    } catch (e) {
      return FailureResult(UnknownFailure(message: e.toString()));
    }
  }
}
