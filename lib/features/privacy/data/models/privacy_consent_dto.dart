/// Privacy consent data transfer object.
library;

import 'package:flutter_project_template/features/privacy/domain/entities/privacy_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'privacy_consent_dto.g.dart';

/// Privacy consent DTO for serialization.
@JsonSerializable()
class PrivacyConsentDto {
  /// Creates a privacy consent DTO.
  const PrivacyConsentDto({
    required this.hasConsented,
    required this.privacyPolicyVersion, required this.termsOfServiceVersion, required this.region, required this.dataCollectionEnabled, required this.analyticsEnabled, this.consentedAt,
  });

  /// Creates from JSON.
  factory PrivacyConsentDto.fromJson(Map<String, dynamic> json) =>
      _$PrivacyConsentDtoFromJson(json);

  /// Whether user has consented.
  final bool hasConsented;

  /// When the user consented.
  final DateTime? consentedAt;

  /// Privacy policy version.
  final String privacyPolicyVersion;

  /// Terms of service version.
  final String termsOfServiceVersion;

  /// Market region.
  final String region;

  /// Data collection enabled.
  final bool dataCollectionEnabled;

  /// Analytics enabled.
  final bool analyticsEnabled;

  /// Converts to JSON.
  Map<String, dynamic> toJson() => _$PrivacyConsentDtoToJson(this);

  /// Converts to domain entity.
  PrivacyState toEntity() => PrivacyState(
      hasConsented: hasConsented,
      consentedAt: consentedAt,
      privacyPolicyVersion: privacyPolicyVersion,
      termsOfServiceVersion: termsOfServiceVersion,
      region: _parseRegion(region),
      dataCollectionEnabled: dataCollectionEnabled,
      analyticsEnabled: analyticsEnabled,
    );

  /// Creates from domain entity.
  static PrivacyConsentDto fromEntity(PrivacyState entity) => PrivacyConsentDto(
      hasConsented: entity.hasConsented,
      consentedAt: entity.consentedAt,
      privacyPolicyVersion: entity.privacyPolicyVersion,
      termsOfServiceVersion: entity.termsOfServiceVersion,
      region: entity.region.name,
      dataCollectionEnabled: entity.dataCollectionEnabled,
      analyticsEnabled: entity.analyticsEnabled,
    );

  static MarketRegion _parseRegion(String value) => MarketRegion.values.firstWhere(
      (r) => r.name == value,
      orElse: () => MarketRegion.international,
    );
}
