/// Privacy repository interface.
library;

import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/features/privacy/domain/entities/privacy_state.dart';

/// Privacy repository interface for managing privacy settings.
abstract class PrivacyRepository {
  /// Gets the current privacy state.
  Future<Result<PrivacyState>> getPrivacyState();

  /// Saves privacy consent.
  Future<Result<PrivacyState>> saveConsent({
    required bool hasConsented,
    String? privacyPolicyVersion,
    String? termsOfServiceVersion,
  });

  /// Updates data collection preference.
  Future<Result<PrivacyState>> updateDataCollection(bool enabled);

  /// Updates analytics preference.
  Future<Result<PrivacyState>> updateAnalytics(bool enabled);

  /// Updates market region.
  Future<Result<PrivacyState>> updateRegion(MarketRegion region);

  /// Deletes account (mock implementation).
  Future<Result<void>> deleteAccount(String password);

  /// Clears all privacy data.
  Future<Result<void>> clearPrivacyData();
}
