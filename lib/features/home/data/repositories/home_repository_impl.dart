/// Home repository implementation.
///
/// This file implements the home repository interface.
library;

import 'package:flutter_project_template/core/errors/error_handler.dart';
import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/home/data/datasources/home_local_data_source.dart';
import 'package:flutter_project_template/features/home/data/datasources/home_remote_data_source.dart';
import 'package:flutter_project_template/features/home/domain/entities/home_entity.dart';
import 'package:flutter_project_template/features/home/domain/repositories/home_repository.dart';
import 'package:injectable/injectable.dart';

/// Home repository implementation.
///
/// Coordinates between local and remote data sources.
/// Registered as a lazy singleton in GetIt.
@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  /// Creates a home repository.
  HomeRepositoryImpl({
    required HomeRemoteDataSource remoteDataSource,
    required HomeLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final HomeRemoteDataSource _remoteDataSource;
  final HomeLocalDataSource _localDataSource;

  @override
  Future<Result<HomeEntity>> getHomeData() async {
    try {
      // Try to get cached data first
      final cachedData = await _localDataSource.getCachedHomeData();
      if (cachedData != null) {
        return Success(cachedData.toEntity());
      }

      // Fetch from remote
      return await _fetchFromRemote();
    } on Exception catch (e) {
      return FailureResult(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<HomeEntity>> refreshHomeData() async {
    try {
      // Always fetch from remote on refresh
      return await _fetchFromRemote();
    } on Exception catch (e) {
      return FailureResult(ErrorHandler.handleException(e));
    }
  }

  /// Fetches data from remote and caches it.
  Future<Result<HomeEntity>> _fetchFromRemote() async {
    final remoteData = await _remoteDataSource.fetchHomeData();
    await _localDataSource.cacheHomeData(remoteData);
    return Success(remoteData.toEntity());
  }
}
