// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_consent_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivacyConsentDto _$PrivacyConsentDtoFromJson(Map<String, dynamic> json) =>
    PrivacyConsentDto(
      hasConsented: json['hasConsented'] as bool,
      consentedAt: json['consentedAt'] == null
          ? null
          : DateTime.parse(json['consentedAt'] as String),
      privacyPolicyVersion: json['privacyPolicyVersion'] as String,
      termsOfServiceVersion: json['termsOfServiceVersion'] as String,
      region: json['region'] as String,
      dataCollectionEnabled: json['dataCollectionEnabled'] as bool,
      analyticsEnabled: json['analyticsEnabled'] as bool,
    );

Map<String, dynamic> _$PrivacyConsentDtoToJson(PrivacyConsentDto instance) =>
    <String, dynamic>{
      'hasConsented': instance.hasConsented,
      'consentedAt': instance.consentedAt?.toIso8601String(),
      'privacyPolicyVersion': instance.privacyPolicyVersion,
      'termsOfServiceVersion': instance.termsOfServiceVersion,
      'region': instance.region,
      'dataCollectionEnabled': instance.dataCollectionEnabled,
      'analyticsEnabled': instance.analyticsEnabled,
    };
