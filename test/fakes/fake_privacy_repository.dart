/// Fake implementation of PrivacyRepository for testing.
library;

import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/privacy/domain/entities/privacy_state.dart';
import 'package:flutter_project_template/features/privacy/domain/repositories/privacy_repository.dart';

/// Fake implementation of PrivacyRepository for testing purposes.
///
/// Allows controlling the behavior of privacy operations in tests.
class FakePrivacyRepository implements PrivacyRepository {
  /// Creates a fake privacy repository.
  FakePrivacyRepository();

  /// The current privacy state.
  PrivacyState currentPrivacyState = PrivacyState.defaultState;

  /// Whether to simulate failure on next operation.
  bool shouldFail = false;

  /// The failure to return when shouldFail is true.
  Failure failureToReturn = const CacheFailure(message: 'Test failure');

  /// Delay before operations complete (simulates network/storage).
  Duration operationDelay = Duration.zero;

  /// Tracks method calls for verification.
  final List<String> methodCalls = [];

  /// Has consented value used in last saveConsent call.
  bool? lastSavedConsent;

  /// Data collection enabled value used in last updateDataCollection call.
  bool? lastDataCollectionEnabled;

  /// Analytics enabled value used in last updateAnalytics call.
  bool? lastAnalyticsEnabled;

  /// Region used in last updateRegion call.
  MarketRegion? lastRegion;

  /// Resets the repository to initial state.
  void reset() {
    currentPrivacyState = PrivacyState.defaultState;
    shouldFail = false;
    failureToReturn = const CacheFailure(message: 'Test failure');
    operationDelay = Duration.zero;
    methodCalls.clear();
    lastSavedConsent = null;
    lastDataCollectionEnabled = null;
    lastAnalyticsEnabled = null;
    lastRegion = null;
  }

  /// Sets up a successful state.
  void setupSuccessfulState(PrivacyState state) {
    currentPrivacyState = state;
    shouldFail = false;
  }

  /// Sets up a failed operation.
  void setupFailedOperation(Failure failure) {
    shouldFail = true;
    failureToReturn = failure;
  }

  Future<void> _simulateDelay() async {
    if (operationDelay > Duration.zero) {
      await Future<void>.delayed(operationDelay);
    }
  }

  Result<T> _handleResult<T>(T successValue) {
    if (shouldFail) {
      return FailureResult(failureToReturn);
    }
    return Success(successValue);
  }

  @override
  Future<Result<PrivacyState>> getPrivacyState() async {
    methodCalls.add('getPrivacyState');
    await _simulateDelay();

    if (shouldFail) {
      return FailureResult(failureToReturn);
    }

    return Success(currentPrivacyState);
  }

  @override
  Future<Result<PrivacyState>> saveConsent({
    required bool hasConsented,
    String? privacyPolicyVersion,
    String? termsOfServiceVersion,
  }) async {
    methodCalls.add('saveConsent');
    lastSavedConsent = hasConsented;
    await _simulateDelay();

    if (shouldFail) {
      return FailureResult(failureToReturn);
    }

    final newState = currentPrivacyState.copyWith(
      hasConsented: hasConsented,
      consentedAt: hasConsented ? DateTime.now() : null,
      privacyPolicyVersion:
          privacyPolicyVersion ?? currentPrivacyState.privacyPolicyVersion,
      termsOfServiceVersion:
          termsOfServiceVersion ?? currentPrivacyState.termsOfServiceVersion,
    );

    currentPrivacyState = newState;
    return Success(newState);
  }

  @override
  Future<Result<PrivacyState>> updateDataCollection(bool enabled) async {
    methodCalls.add('updateDataCollection');
    lastDataCollectionEnabled = enabled;
    await _simulateDelay();

    if (shouldFail) {
      return FailureResult(failureToReturn);
    }

    currentPrivacyState = currentPrivacyState.copyWith(
      dataCollectionEnabled: enabled,
    );

    return Success(currentPrivacyState);
  }

  @override
  Future<Result<PrivacyState>> updateAnalytics(bool enabled) async {
    methodCalls.add('updateAnalytics');
    lastAnalyticsEnabled = enabled;
    await _simulateDelay();

    if (shouldFail) {
      return FailureResult(failureToReturn);
    }

    currentPrivacyState = currentPrivacyState.copyWith(
      analyticsEnabled: enabled,
    );

    return Success(currentPrivacyState);
  }

  @override
  Future<Result<PrivacyState>> updateRegion(MarketRegion region) async {
    methodCalls.add('updateRegion');
    lastRegion = region;
    await _simulateDelay();

    if (shouldFail) {
      return FailureResult(failureToReturn);
    }

    currentPrivacyState = currentPrivacyState.copyWith(
      region: region,
    );

    return Success(currentPrivacyState);
  }

  @override
  Future<Result<void>> deleteAccount(String password) async {
    methodCalls.add('deleteAccount');
    await _simulateDelay();

    if (shouldFail) {
      return FailureResult(failureToReturn);
    }

    return const Success(null);
  }

  @override
  Future<Result<void>> clearPrivacyData() async {
    methodCalls.add('clearPrivacyData');
    await _simulateDelay();

    if (shouldFail) {
      return FailureResult(failureToReturn);
    }

    currentPrivacyState = PrivacyState.defaultState;
    return const Success(null);
  }
}
