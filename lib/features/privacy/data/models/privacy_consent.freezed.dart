// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'privacy_consent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PrivacyConsent _$PrivacyConsentFromJson(Map<String, dynamic> json) {
  return _PrivacyConsent.fromJson(json);
}

/// @nodoc
mixin _$PrivacyConsent {
  /// 是否已同意
  bool get hasConsented => throw _privateConstructorUsedError;

  /// 同意时间
  DateTime? get consentedAt => throw _privateConstructorUsedError;

  /// 协议版本
  String? get version => throw _privateConstructorUsedError;

  /// 用户地区
  String get region => throw _privateConstructorUsedError;

  /// Serializes this PrivacyConsent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrivacyConsent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrivacyConsentCopyWith<PrivacyConsent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrivacyConsentCopyWith<$Res> {
  factory $PrivacyConsentCopyWith(
          PrivacyConsent value, $Res Function(PrivacyConsent) then) =
      _$PrivacyConsentCopyWithImpl<$Res, PrivacyConsent>;
  @useResult
  $Res call(
      {bool hasConsented,
      DateTime? consentedAt,
      String? version,
      String region});
}

/// @nodoc
class _$PrivacyConsentCopyWithImpl<$Res, $Val extends PrivacyConsent>
    implements $PrivacyConsentCopyWith<$Res> {
  _$PrivacyConsentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrivacyConsent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasConsented = null,
    Object? consentedAt = freezed,
    Object? version = freezed,
    Object? region = null,
  }) {
    return _then(_value.copyWith(
      hasConsented: null == hasConsented
          ? _value.hasConsented
          : hasConsented // ignore: cast_nullable_to_non_nullable
              as bool,
      consentedAt: freezed == consentedAt
          ? _value.consentedAt
          : consentedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      region: null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrivacyConsentImplCopyWith<$Res>
    implements $PrivacyConsentCopyWith<$Res> {
  factory _$$PrivacyConsentImplCopyWith(_$PrivacyConsentImpl value,
          $Res Function(_$PrivacyConsentImpl) then) =
      __$$PrivacyConsentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool hasConsented,
      DateTime? consentedAt,
      String? version,
      String region});
}

/// @nodoc
class __$$PrivacyConsentImplCopyWithImpl<$Res>
    extends _$PrivacyConsentCopyWithImpl<$Res, _$PrivacyConsentImpl>
    implements _$$PrivacyConsentImplCopyWith<$Res> {
  __$$PrivacyConsentImplCopyWithImpl(
      _$PrivacyConsentImpl _value, $Res Function(_$PrivacyConsentImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrivacyConsent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasConsented = null,
    Object? consentedAt = freezed,
    Object? version = freezed,
    Object? region = null,
  }) {
    return _then(_$PrivacyConsentImpl(
      hasConsented: null == hasConsented
          ? _value.hasConsented
          : hasConsented // ignore: cast_nullable_to_non_nullable
              as bool,
      consentedAt: freezed == consentedAt
          ? _value.consentedAt
          : consentedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      region: null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrivacyConsentImpl implements _PrivacyConsent {
  const _$PrivacyConsentImpl(
      {required this.hasConsented,
      this.consentedAt,
      this.version,
      this.region = 'CN'});

  factory _$PrivacyConsentImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrivacyConsentImplFromJson(json);

  /// 是否已同意
  @override
  final bool hasConsented;

  /// 同意时间
  @override
  final DateTime? consentedAt;

  /// 协议版本
  @override
  final String? version;

  /// 用户地区
  @override
  @JsonKey()
  final String region;

  @override
  String toString() {
    return 'PrivacyConsent(hasConsented: $hasConsented, consentedAt: $consentedAt, version: $version, region: $region)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrivacyConsentImpl &&
            (identical(other.hasConsented, hasConsented) ||
                other.hasConsented == hasConsented) &&
            (identical(other.consentedAt, consentedAt) ||
                other.consentedAt == consentedAt) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.region, region) || other.region == region));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, hasConsented, consentedAt, version, region);

  /// Create a copy of PrivacyConsent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrivacyConsentImplCopyWith<_$PrivacyConsentImpl> get copyWith =>
      __$$PrivacyConsentImplCopyWithImpl<_$PrivacyConsentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrivacyConsentImplToJson(
      this,
    );
  }
}

abstract class _PrivacyConsent implements PrivacyConsent {
  const factory _PrivacyConsent(
      {required final bool hasConsented,
      final DateTime? consentedAt,
      final String? version,
      final String region}) = _$PrivacyConsentImpl;

  factory _PrivacyConsent.fromJson(Map<String, dynamic> json) =
      _$PrivacyConsentImpl.fromJson;

  /// 是否已同意
  @override
  bool get hasConsented;

  /// 同意时间
  @override
  DateTime? get consentedAt;

  /// 协议版本
  @override
  String? get version;

  /// 用户地区
  @override
  String get region;

  /// Create a copy of PrivacyConsent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrivacyConsentImplCopyWith<_$PrivacyConsentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
