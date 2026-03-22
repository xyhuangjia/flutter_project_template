/// Privacy state entity for managing privacy consent and preferences.
library;

import 'package:flutter/foundation.dart';

/// Market region enum for different compliance requirements.
enum MarketRegion {
  /// China market (PIPL compliance).
  china,

  /// International market (GDPR compliance).
  international,
}

/// Privacy consent state entity.
@immutable
class PrivacyState {
  /// Creates a privacy state entity.
  const PrivacyState({
    required this.hasConsented,
    required this.consentedAt,
    required this.privacyPolicyVersion,
    required this.termsOfServiceVersion,
    required this.region,
    this.dataCollectionEnabled = true,
    this.analyticsEnabled = true,
  });

  /// Default privacy state (not consented).
  static const defaultState = PrivacyState(
    hasConsented: false,
    consentedAt: null,
    privacyPolicyVersion: '1.0.0',
    termsOfServiceVersion: '1.0.0',
    region: MarketRegion.international,
  );

  /// Whether user has consented to privacy policy.
  final bool hasConsented;

  /// When the user consented (null if not consented).
  final DateTime? consentedAt;

  /// Version of privacy policy consented to.
  final String privacyPolicyVersion;

  /// Version of terms of service consented to.
  final String termsOfServiceVersion;

  /// Current market region.
  final MarketRegion region;

  /// Whether data collection is enabled.
  final bool dataCollectionEnabled;

  /// Whether analytics is enabled.
  final bool analyticsEnabled;

  /// Creates a copy with updated fields.
  PrivacyState copyWith({
    bool? hasConsented,
    DateTime? consentedAt,
    String? privacyPolicyVersion,
    String? termsOfServiceVersion,
    MarketRegion? region,
    bool? dataCollectionEnabled,
    bool? analyticsEnabled,
  }) =>
      PrivacyState(
        hasConsented: hasConsented ?? this.hasConsented,
        consentedAt: consentedAt ?? this.consentedAt,
        privacyPolicyVersion: privacyPolicyVersion ?? this.privacyPolicyVersion,
        termsOfServiceVersion:
            termsOfServiceVersion ?? this.termsOfServiceVersion,
        region: region ?? this.region,
        dataCollectionEnabled:
            dataCollectionEnabled ?? this.dataCollectionEnabled,
        analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PrivacyState &&
        other.hasConsented == hasConsented &&
        other.consentedAt == consentedAt &&
        other.privacyPolicyVersion == privacyPolicyVersion &&
        other.termsOfServiceVersion == termsOfServiceVersion &&
        other.region == region &&
        other.dataCollectionEnabled == dataCollectionEnabled &&
        other.analyticsEnabled == analyticsEnabled;
  }

  @override
  int get hashCode => Object.hash(
        hasConsented,
        consentedAt,
        privacyPolicyVersion,
        termsOfServiceVersion,
        region,
        dataCollectionEnabled,
        analyticsEnabled,
      );

  @override
  String toString() =>
      'PrivacyState(hasConsented: $hasConsented, consentedAt: $consentedAt, '
      'privacyPolicyVersion: $privacyPolicyVersion, '
      'termsOfServiceVersion: $termsOfServiceVersion, region: $region, '
      'dataCollectionEnabled: $dataCollectionEnabled, '
      'analyticsEnabled: $analyticsEnabled)';
}
