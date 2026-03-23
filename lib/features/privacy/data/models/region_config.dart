/// Region configuration for market-specific settings.
library;

import 'package:flutter_project_template/features/privacy/domain/entities/privacy_state.dart';

/// Region configuration containing market-specific compliance settings.
class RegionConfig {
  /// Creates a region config.
  const RegionConfig({
    required this.region,
    required this.privacyPolicyUrl,
    required this.termsOfServiceUrl,
    required this.requiresExplicitConsent,
    required this.allowsDataCollectionToggle,
    required this.complianceStandard,
  });

  /// China region configuration.
  static const china = RegionConfig(
    region: MarketRegion.china,
    privacyPolicyUrl: 'https://flutter.cn',
    termsOfServiceUrl: 'https://flutter.cn',
    requiresExplicitConsent: true,
    allowsDataCollectionToggle: true,
    complianceStandard: 'PIPL',
  );

  /// International region configuration.
  static const international = RegionConfig(
    region: MarketRegion.international,
    privacyPolicyUrl: 'https://flutter.cn',
    termsOfServiceUrl: 'https://flutter.cn',
    requiresExplicitConsent: true,
    allowsDataCollectionToggle: true,
    complianceStandard: 'GDPR',
  );

  /// The market region.
  final MarketRegion region;

  /// URL to privacy policy.
  final String privacyPolicyUrl;

  /// URL to terms of service.
  final String termsOfServiceUrl;

  /// Whether explicit consent is required before using the app.
  final bool requiresExplicitConsent;

  /// Whether users can toggle data collection.
  final bool allowsDataCollectionToggle;

  /// The compliance standard (e.g., PIPL, GDPR).
  final String complianceStandard;

  /// Gets config for a region.
  static RegionConfig forRegion(MarketRegion region) {
    switch (region) {
      case MarketRegion.china:
        return china;
      case MarketRegion.international:
        return international;
    }
  }

  /// Detects region from locale.
  static MarketRegion detectRegionFromLocale(String languageCode) {
    // Simplified detection: Chinese locale -> China market
    if (languageCode == 'zh') {
      return MarketRegion.china;
    }
    return MarketRegion.international;
  }
}
