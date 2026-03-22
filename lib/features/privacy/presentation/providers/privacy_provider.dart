/// Privacy provider using Riverpod code generation.
library;

import 'package:flutter_project_template/core/config/environment_provider.dart';
import 'package:flutter_project_template/core/logging/talker_config.dart';
import 'package:flutter_project_template/features/privacy/data/datasources/privacy_local_data_source.dart';
import 'package:flutter_project_template/features/privacy/data/repositories/privacy_repository_impl.dart';
import 'package:flutter_project_template/features/privacy/data/services/account_service_mock.dart';
import 'package:flutter_project_template/features/privacy/domain/entities/privacy_state.dart';
import 'package:flutter_project_template/features/privacy/domain/repositories/privacy_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'privacy_provider.g.dart';

/// Privacy local data source provider.
@riverpod
PrivacyLocalDataSource privacyLocalDataSource(PrivacyLocalDataSourceRef ref) {
  // Use the same sharedPreferencesProvider that is overridden in main.dart
  final prefs = ref.watch(sharedPreferencesProvider);
  return PrivacyLocalDataSource(sharedPreferences: prefs);
}

/// Mock account service provider.
@riverpod
AccountServiceMock accountServiceMock(AccountServiceMockRef ref) =>
    AccountServiceMock();

/// Privacy repository provider.
@riverpod
PrivacyRepository privacyRepository(PrivacyRepositoryRef ref) =>
    PrivacyRepositoryImpl(
      localDataSource: ref.watch(privacyLocalDataSourceProvider),
      accountService: ref.watch(accountServiceMockProvider),
    );

/// Privacy state notifier provider.
///
/// Manages the privacy state.
/// Uses keepAlive to prevent auto-dispose during navigation.
@Riverpod(keepAlive: true)
class PrivacyNotifier extends _$PrivacyNotifier {
  @override
  Future<PrivacyState> build() async {
    final repository = ref.read(privacyRepositoryProvider);
    final result = await repository.getPrivacyState();

    talker.log('[隐私状态] build() 已调用');
    return result.when(
      failure: (_) {
        talker.log('[隐私状态] build() 失败，返回默认状态');
        return PrivacyState.defaultState;
      },
      success: (state) {
        talker.log(
          '[隐私状态] build() 成功，已同意隐私政策: ${state.hasConsented}',
        );
        return state;
      },
    );
  }

  /// Saves privacy consent.
  Future<bool> saveConsent({
    required bool hasConsented,
    String? privacyPolicyVersion,
    String? termsOfServiceVersion,
  }) async {
    talker.log(
      '[隐私状态] saveConsent() 已调用，已同意: $hasConsented',
    );
    final repository = ref.read(privacyRepositoryProvider);
    final result = await repository.saveConsent(
      hasConsented: hasConsented,
      privacyPolicyVersion: privacyPolicyVersion,
      termsOfServiceVersion: termsOfServiceVersion,
    );

    result.when(
      failure: (f) {
        talker.error('[隐私状态] saveConsent() 失败: ${f.message}');
      },
      success: (newState) {
        talker.log(
          '[隐私状态] saveConsent() 成功，新的已同意状态: ${newState.hasConsented}',
        );
        state = AsyncValue.data(newState);
      },
    );

    return !result.isFailure;
  }

  /// Updates data collection preference.
  Future<bool> updateDataCollection(bool enabled) async {
    final repository = ref.read(privacyRepositoryProvider);
    final result = await repository.updateDataCollection(enabled);

    result.when(
      failure: (_) => null,
      success: (newState) => state = AsyncValue.data(newState),
    );

    return !result.isFailure;
  }

  /// Updates analytics preference.
  Future<bool> updateAnalytics(bool enabled) async {
    final repository = ref.read(privacyRepositoryProvider);
    final result = await repository.updateAnalytics(enabled);

    result.when(
      failure: (_) => null,
      success: (newState) => state = AsyncValue.data(newState),
    );

    return !result.isFailure;
  }

  /// Updates market region.
  Future<bool> updateRegion(MarketRegion region) async {
    final repository = ref.read(privacyRepositoryProvider);
    final result = await repository.updateRegion(region);

    result.when(
      failure: (_) => null,
      success: (newState) => state = AsyncValue.data(newState),
    );

    return !result.isFailure;
  }

  /// Deletes account.
  Future<bool> deleteAccount(String password) async {
    final repository = ref.read(privacyRepositoryProvider);
    final result = await repository.deleteAccount(password);

    return !result.isFailure;
  }

  /// Clears all privacy data.
  Future<bool> clearPrivacyData() async {
    final repository = ref.read(privacyRepositoryProvider);
    final result = await repository.clearPrivacyData();

    if (!result.isFailure) {
      state = const AsyncValue.data(PrivacyState.defaultState);
    }

    return !result.isFailure;
  }
}
