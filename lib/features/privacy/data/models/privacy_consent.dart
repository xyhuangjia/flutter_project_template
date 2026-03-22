import 'package:freezed_annotation/freezed_annotation.dart';

part 'privacy_consent.freezed.dart';
part 'privacy_consent.g.dart';

/// Privacy consent record.
@freezed
class PrivacyConsent with _$PrivacyConsent {
  const factory PrivacyConsent({
    /// Whether consent has been given.
    required bool hasConsented,

    /// Consent timestamp.
    DateTime? consentedAt,

    /// Agreement version.
    String? version,

    /// User region.
    @Default('CN') String region,
  }) = _PrivacyConsent;

  factory PrivacyConsent.fromJson(Map<String, dynamic> json) =>
      _$PrivacyConsentFromJson(json);
}
