// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'privacy_consent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PrivacyConsent {
  /// Whether consent has been given.
  bool get hasConsented;

  /// Consent timestamp.
  DateTime? get consentedAt;

  /// Agreement version.
  String? get version;

  /// User region.
  String get region;

  /// Create a copy of PrivacyConsent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PrivacyConsentCopyWith<PrivacyConsent> get copyWith =>
      _$PrivacyConsentCopyWithImpl<PrivacyConsent>(
          this as PrivacyConsent, _$identity);

  /// Serializes this PrivacyConsent to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PrivacyConsent &&
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

  @override
  String toString() {
    return 'PrivacyConsent(hasConsented: $hasConsented, consentedAt: $consentedAt, version: $version, region: $region)';
  }
}

/// @nodoc
abstract mixin class $PrivacyConsentCopyWith<$Res> {
  factory $PrivacyConsentCopyWith(
          PrivacyConsent value, $Res Function(PrivacyConsent) _then) =
      _$PrivacyConsentCopyWithImpl;
  @useResult
  $Res call(
      {bool hasConsented,
      DateTime? consentedAt,
      String? version,
      String region});
}

/// @nodoc
class _$PrivacyConsentCopyWithImpl<$Res>
    implements $PrivacyConsentCopyWith<$Res> {
  _$PrivacyConsentCopyWithImpl(this._self, this._then);

  final PrivacyConsent _self;
  final $Res Function(PrivacyConsent) _then;

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
    return _then(_self.copyWith(
      hasConsented: null == hasConsented
          ? _self.hasConsented
          : hasConsented // ignore: cast_nullable_to_non_nullable
              as bool,
      consentedAt: freezed == consentedAt
          ? _self.consentedAt
          : consentedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      version: freezed == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      region: null == region
          ? _self.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [PrivacyConsent].
extension PrivacyConsentPatterns on PrivacyConsent {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PrivacyConsent value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PrivacyConsent() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PrivacyConsent value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PrivacyConsent():
        return $default(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PrivacyConsent value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PrivacyConsent() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(bool hasConsented, DateTime? consentedAt, String? version,
            String region)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PrivacyConsent() when $default != null:
        return $default(
            _that.hasConsented, _that.consentedAt, _that.version, _that.region);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(bool hasConsented, DateTime? consentedAt, String? version,
            String region)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PrivacyConsent():
        return $default(
            _that.hasConsented, _that.consentedAt, _that.version, _that.region);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(bool hasConsented, DateTime? consentedAt, String? version,
            String region)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PrivacyConsent() when $default != null:
        return $default(
            _that.hasConsented, _that.consentedAt, _that.version, _that.region);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PrivacyConsent implements PrivacyConsent {
  const _PrivacyConsent(
      {required this.hasConsented,
      this.consentedAt,
      this.version,
      this.region = 'CN'});
  factory _PrivacyConsent.fromJson(Map<String, dynamic> json) =>
      _$PrivacyConsentFromJson(json);

  /// Whether consent has been given.
  @override
  final bool hasConsented;

  /// Consent timestamp.
  @override
  final DateTime? consentedAt;

  /// Agreement version.
  @override
  final String? version;

  /// User region.
  @override
  @JsonKey()
  final String region;

  /// Create a copy of PrivacyConsent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PrivacyConsentCopyWith<_PrivacyConsent> get copyWith =>
      __$PrivacyConsentCopyWithImpl<_PrivacyConsent>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PrivacyConsentToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PrivacyConsent &&
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

  @override
  String toString() {
    return 'PrivacyConsent(hasConsented: $hasConsented, consentedAt: $consentedAt, version: $version, region: $region)';
  }
}

/// @nodoc
abstract mixin class _$PrivacyConsentCopyWith<$Res>
    implements $PrivacyConsentCopyWith<$Res> {
  factory _$PrivacyConsentCopyWith(
          _PrivacyConsent value, $Res Function(_PrivacyConsent) _then) =
      __$PrivacyConsentCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool hasConsented,
      DateTime? consentedAt,
      String? version,
      String region});
}

/// @nodoc
class __$PrivacyConsentCopyWithImpl<$Res>
    implements _$PrivacyConsentCopyWith<$Res> {
  __$PrivacyConsentCopyWithImpl(this._self, this._then);

  final _PrivacyConsent _self;
  final $Res Function(_PrivacyConsent) _then;

  /// Create a copy of PrivacyConsent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? hasConsented = null,
    Object? consentedAt = freezed,
    Object? version = freezed,
    Object? region = null,
  }) {
    return _then(_PrivacyConsent(
      hasConsented: null == hasConsented
          ? _self.hasConsented
          : hasConsented // ignore: cast_nullable_to_non_nullable
              as bool,
      consentedAt: freezed == consentedAt
          ? _self.consentedAt
          : consentedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      version: freezed == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      region: null == region
          ? _self.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
