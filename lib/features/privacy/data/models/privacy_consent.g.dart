// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_consent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PrivacyConsent _$PrivacyConsentFromJson(Map<String, dynamic> json) =>
    _PrivacyConsent(
      hasConsented: json['hasConsented'] as bool,
      consentedAt: json['consentedAt'] == null
          ? null
          : DateTime.parse(json['consentedAt'] as String),
      version: json['version'] as String?,
      region: json['region'] as String? ?? 'CN',
    );

Map<String, dynamic> _$PrivacyConsentToJson(_PrivacyConsent instance) =>
    <String, dynamic>{
      'hasConsented': instance.hasConsented,
      'consentedAt': instance.consentedAt?.toIso8601String(),
      'version': instance.version,
      'region': instance.region,
    };
