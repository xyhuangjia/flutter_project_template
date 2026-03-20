// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_consent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrivacyConsentImpl _$$PrivacyConsentImplFromJson(Map<String, dynamic> json) =>
    _$PrivacyConsentImpl(
      hasConsented: json['hasConsented'] as bool,
      consentedAt: json['consentedAt'] == null
          ? null
          : DateTime.parse(json['consentedAt'] as String),
      version: json['version'] as String?,
      region: json['region'] as String? ?? 'CN',
    );

Map<String, dynamic> _$$PrivacyConsentImplToJson(
        _$PrivacyConsentImpl instance) =>
    <String, dynamic>{
      'hasConsented': instance.hasConsented,
      'consentedAt': instance.consentedAt?.toIso8601String(),
      'version': instance.version,
      'region': instance.region,
    };
