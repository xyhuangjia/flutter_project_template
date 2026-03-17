/// Home local data source for caching home data.
///
/// This file provides local storage operations for home feature.
library;

import 'package:flutter_project_template/features/home/data/models/dummy_model.dart';

/// Abstract home local data source.
///
/// Defines the contract for local data operations.
abstract class HomeLocalDataSource {
  /// Caches home data locally.
  Future<void> cacheHomeData(DummyModel home);

  /// Gets cached home data.
  Future<DummyModel?> getCachedHomeData();

  /// Clears cached home data.
  Future<void> clearCachedHomeData();
}

/// Home local data source implementation.
///
/// Implements local storage using in-memory cache.
/// In a real app, this would use SharedPreferences or Drift.
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  /// Creates a home local data source.
  HomeLocalDataSourceImpl();

  DummyModel? _cachedHome;

  @override
  Future<void> cacheHomeData(DummyModel home) async {
    _cachedHome = home;
  }

  @override
  Future<DummyModel?> getCachedHomeData() async {
    return _cachedHome;
  }

  @override
  Future<void> clearCachedHomeData() async {
    _cachedHome = null;
  }
}
