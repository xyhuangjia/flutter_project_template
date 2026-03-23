/// Home remote data source for API operations.
///
/// This file provides remote API operations for home feature.
library;

import 'package:flutter_project_template/features/home/data/models/dummy_model.dart';
import 'package:injectable/injectable.dart';

/// Abstract home remote data source.
///
/// Defines the contract for remote API operations.
abstract class HomeRemoteDataSource {
  /// Fetches home data from the API.
  Future<DummyModel> fetchHomeData();
}

/// Home remote data source implementation.
///
/// Implements API calls using Dio client.
/// Registered as a lazy singleton in GetIt.
@LazySingleton(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  /// Creates a home remote data source.
  HomeRemoteDataSourceImpl();

  @override
  Future<DummyModel> fetchHomeData() async {
    // Simulate API call
    // In a real app, this would be:
    // final response = await _dioClient.get('/home');
    // return DummyModel.fromJson(response.data);

    await Future<void>.delayed(const Duration(milliseconds: 500));

    return DummyModel(
      id: 'home-1',
      title: 'Flutter Project Template',
      welcomeMessage: 'Welcome to the Flutter Project Template!',
      userName: 'Guest',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
