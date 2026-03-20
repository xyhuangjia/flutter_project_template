import 'package:freezed_annotation/freezed_annotation.dart';

part 'privacy_consent.freezed.dart';
part 'privacy_consent.g.dart';

/// 隐私同意记录
@freezed
class PrivacyConsent with _$PrivacyConsent {
  const factory PrivacyConsent({
    /// 是否已同意
    required bool hasConsented,

    /// 同意时间
    DateTime? consentedAt,

    /// 协议版本
    String? version,

    /// 用户地区
    @Default('CN') String region,
  }) = _PrivacyConsent;

  factory PrivacyConsent.fromJson(Map<String, dynamic> json) =>
      _$PrivacyConsentFromJson(json);
}
