/// Privacy repository implementation.
library;

import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/privacy/data/datasources/privacy_local_data_source.dart';
import 'package:flutter_project_template/features/privacy/data/models/privacy_consent_dto.dart';
import 'package:flutter_project_template/features/privacy/data/services/account_service_mock.dart';
import 'package:flutter_project_template/features/privacy/domain/entities/privacy_state.dart';
import 'package:flutter_project_template/features/privacy/domain/repositories/privacy_repository.dart';

/// Privacy repository implementation.
class PrivacyRepositoryImpl implements PrivacyRepository {
  /// Creates a privacy repository.
  PrivacyRepositoryImpl({
    required PrivacyLocalDataSource localDataSource,
    required AccountServiceMock accountService,
  })  : _localDataSource = localDataSource,
        _accountService = accountService;

  final PrivacyLocalDataSource _localDataSource;
  final AccountServiceMock _accountService;

  /// Gets the current privacy state, returns default state on failure.
  Future<PrivacyState> _getCurrentState() async {
    final result = await getPrivacyState();
    return result.when(
      failure: (_) => PrivacyState.defaultState,
      success: (s) => s,
    );
  }

  @override
  Future<Result<PrivacyState>> getPrivacyState() async {
    try {
      final dto = _localDataSource.getPrivacyConsent();

      if (dto == null) {
        // No consent stored, return default state
        return Success(PrivacyState.defaultState);
      }

      return Success(dto.toEntity());
    } catch (e) {
      return FailureResult(
        CacheFailure(message: 'Failed to get privacy state: $e'),
      );
    }
  }

  @override
  Future<Result<PrivacyState>> saveConsent({
    required bool hasConsented,
    String? privacyPolicyVersion,
    String? termsOfServiceVersion,
  }) async {
    try {
      final currentEntity = await _getCurrentState();

      final newState = currentEntity.copyWith(
        hasConsented: hasConsented,
        consentedAt: hasConsented ? DateTime.now() : null,
        privacyPolicyVersion:
            privacyPolicyVersion ?? currentEntity.privacyPolicyVersion,
        termsOfServiceVersion:
            termsOfServiceVersion ?? currentEntity.termsOfServiceVersion,
      );

      final dto = PrivacyConsentDto.fromEntity(newState);
      await _localDataSource.savePrivacyConsent(dto);

      return Success(newState);
    } catch (e) {
      return FailureResult(
        CacheFailure(message: 'Failed to save consent: $e'),
      );
    }
  }

  @override
  Future<Result<PrivacyState>> updateDataCollection(bool enabled) async {
    try {
      final currentEntity = await _getCurrentState();

      final newState = currentEntity.copyWith(
        dataCollectionEnabled: enabled,
      );

      final dto = PrivacyConsentDto.fromEntity(newState);
      await _localDataSource.savePrivacyConsent(dto);

      return Success(newState);
    } catch (e) {
      return FailureResult(
        CacheFailure(message: 'Failed to update data collection: $e'),
      );
    }
  }

  @override
  Future<Result<PrivacyState>> updateAnalytics(bool enabled) async {
    try {
      final currentEntity = await _getCurrentState();

      final newState = currentEntity.copyWith(
        analyticsEnabled: enabled,
      );

      final dto = PrivacyConsentDto.fromEntity(newState);
      await _localDataSource.savePrivacyConsent(dto);

      return Success(newState);
    } catch (e) {
      return FailureResult(
        CacheFailure(message: 'Failed to update analytics: $e'),
      );
    }
  }

  @override
  Future<Result<PrivacyState>> updateRegion(MarketRegion region) async {
    try {
      final currentEntity = await _getCurrentState();

      final newState = currentEntity.copyWith(
        region: region,
      );

      final dto = PrivacyConsentDto.fromEntity(newState);
      await _localDataSource.savePrivacyConsent(dto);

      return Success(newState);
    } catch (e) {
      return FailureResult(
        CacheFailure(message: 'Failed to update region: $e'),
      );
    }
  }

  @override
  Future<Result<void>> deleteAccount(String password) async {
    return _accountService.deleteAccount(password);
  }

  @override
  Future<Result<void>> clearPrivacyData() async {
    try {
      await _localDataSource.clearPrivacyConsent();
      return Success(null);
    } catch (e) {
      return FailureResult(
        CacheFailure(message: 'Failed to clear privacy data: $e'),
      );
    }
  }
}
