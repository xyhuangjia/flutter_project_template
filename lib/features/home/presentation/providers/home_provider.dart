/// Home provider using Riverpod code generation.
///
/// This file demonstrates the pattern for creating Riverpod
/// providers with the @riverpod annotation.
library;

import 'package:flutter_project_template/core/constants/app_strings.dart';
import 'package:flutter_project_template/features/home/domain/entities/home_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_provider.g.dart';

/// Home state notifier provider.
///
/// Manages the state for the home screen.
@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  Future<HomeEntity> build() async {
    // Simulate loading data
    await Future<void>.delayed(const Duration(milliseconds: 500));

    // Return initial home data
    return const HomeEntity(
      title: AppStrings.appName,
      welcomeMessage: 'Welcome to the Flutter Project Template!',
      userName: 'Guest',
      avatarUrl: null,
    );
  }

  /// Updates the user name.
  Future<void> updateUserName(String name) async {
    final current = state.valueOrNull;
    if (current == null) return;

    state = const AsyncValue.loading();

    // Simulate API call
    await Future<void>.delayed(const Duration(milliseconds: 300));

    state = AsyncValue.data(
      current.copyWith(userName: name),
    );
  }

  /// Refreshes the home data.
  Future<void> refresh() async {
    state = const AsyncValue.loading();

    // Simulate API call
    await Future<void>.delayed(const Duration(milliseconds: 500));

    state = const AsyncValue.data(
      HomeEntity(
        title: AppStrings.appName,
        welcomeMessage: 'Welcome to the Flutter Project Template!',
        userName: 'Guest',
        avatarUrl: null,
      ),
    );
  }
}

/// Provider for greeting message based on time of day.
@riverpod
String greetingMessage(Ref ref) {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return 'Good Morning';
  } else if (hour < 17) {
    return 'Good Afternoon';
  } else {
    return 'Good Evening';
  }
}
