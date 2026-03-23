// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'log_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LogUploadConfig {
  /// 服务器 URL。
  /// 示例: 'https://api.example.com/logs/upload'
  String get uploadUrl;

  /// 自定义 HTTP 请求头。
  /// 示例: {'Authorization': 'Bearer token', 'X-API-Key': 'key'}
  Map<String, String> get headers;

  /// 是否启用自动上传。
  bool get autoUpload;

  /// 上传批量大小（每次请求的日志数量）。
  int get batchSize;

  /// 自动上传间隔（分钟）。
  int get uploadIntervalMinutes;

  /// 是否仅在 WiFi 下上传。
  bool get wifiOnly;

  /// Create a copy of LogUploadConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LogUploadConfigCopyWith<LogUploadConfig> get copyWith =>
      _$LogUploadConfigCopyWithImpl<LogUploadConfig>(
          this as LogUploadConfig, _$identity);

  /// Serializes this LogUploadConfig to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LogUploadConfig &&
            (identical(other.uploadUrl, uploadUrl) ||
                other.uploadUrl == uploadUrl) &&
            const DeepCollectionEquality().equals(other.headers, headers) &&
            (identical(other.autoUpload, autoUpload) ||
                other.autoUpload == autoUpload) &&
            (identical(other.batchSize, batchSize) ||
                other.batchSize == batchSize) &&
            (identical(other.uploadIntervalMinutes, uploadIntervalMinutes) ||
                other.uploadIntervalMinutes == uploadIntervalMinutes) &&
            (identical(other.wifiOnly, wifiOnly) ||
                other.wifiOnly == wifiOnly));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uploadUrl,
      const DeepCollectionEquality().hash(headers),
      autoUpload,
      batchSize,
      uploadIntervalMinutes,
      wifiOnly);

  @override
  String toString() {
    return 'LogUploadConfig(uploadUrl: $uploadUrl, headers: $headers, autoUpload: $autoUpload, batchSize: $batchSize, uploadIntervalMinutes: $uploadIntervalMinutes, wifiOnly: $wifiOnly)';
  }
}

/// @nodoc
abstract mixin class $LogUploadConfigCopyWith<$Res> {
  factory $LogUploadConfigCopyWith(
          LogUploadConfig value, $Res Function(LogUploadConfig) _then) =
      _$LogUploadConfigCopyWithImpl;
  @useResult
  $Res call(
      {String uploadUrl,
      Map<String, String> headers,
      bool autoUpload,
      int batchSize,
      int uploadIntervalMinutes,
      bool wifiOnly});
}

/// @nodoc
class _$LogUploadConfigCopyWithImpl<$Res>
    implements $LogUploadConfigCopyWith<$Res> {
  _$LogUploadConfigCopyWithImpl(this._self, this._then);

  final LogUploadConfig _self;
  final $Res Function(LogUploadConfig) _then;

  /// Create a copy of LogUploadConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uploadUrl = null,
    Object? headers = null,
    Object? autoUpload = null,
    Object? batchSize = null,
    Object? uploadIntervalMinutes = null,
    Object? wifiOnly = null,
  }) {
    return _then(_self.copyWith(
      uploadUrl: null == uploadUrl
          ? _self.uploadUrl
          : uploadUrl // ignore: cast_nullable_to_non_nullable
              as String,
      headers: null == headers
          ? _self.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      autoUpload: null == autoUpload
          ? _self.autoUpload
          : autoUpload // ignore: cast_nullable_to_non_nullable
              as bool,
      batchSize: null == batchSize
          ? _self.batchSize
          : batchSize // ignore: cast_nullable_to_non_nullable
              as int,
      uploadIntervalMinutes: null == uploadIntervalMinutes
          ? _self.uploadIntervalMinutes
          : uploadIntervalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      wifiOnly: null == wifiOnly
          ? _self.wifiOnly
          : wifiOnly // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [LogUploadConfig].
extension LogUploadConfigPatterns on LogUploadConfig {
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
    TResult Function(_LogUploadConfig value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LogUploadConfig() when $default != null:
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
    TResult Function(_LogUploadConfig value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LogUploadConfig():
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
    TResult? Function(_LogUploadConfig value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LogUploadConfig() when $default != null:
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
    TResult Function(
            String uploadUrl,
            Map<String, String> headers,
            bool autoUpload,
            int batchSize,
            int uploadIntervalMinutes,
            bool wifiOnly)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LogUploadConfig() when $default != null:
        return $default(_that.uploadUrl, _that.headers, _that.autoUpload,
            _that.batchSize, _that.uploadIntervalMinutes, _that.wifiOnly);
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
    TResult Function(
            String uploadUrl,
            Map<String, String> headers,
            bool autoUpload,
            int batchSize,
            int uploadIntervalMinutes,
            bool wifiOnly)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LogUploadConfig():
        return $default(_that.uploadUrl, _that.headers, _that.autoUpload,
            _that.batchSize, _that.uploadIntervalMinutes, _that.wifiOnly);
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
    TResult? Function(
            String uploadUrl,
            Map<String, String> headers,
            bool autoUpload,
            int batchSize,
            int uploadIntervalMinutes,
            bool wifiOnly)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LogUploadConfig() when $default != null:
        return $default(_that.uploadUrl, _that.headers, _that.autoUpload,
            _that.batchSize, _that.uploadIntervalMinutes, _that.wifiOnly);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _LogUploadConfig implements LogUploadConfig {
  const _LogUploadConfig(
      {required this.uploadUrl,
      final Map<String, String> headers = const {},
      this.autoUpload = false,
      this.batchSize = 100,
      this.uploadIntervalMinutes = 30,
      this.wifiOnly = true})
      : _headers = headers;
  factory _LogUploadConfig.fromJson(Map<String, dynamic> json) =>
      _$LogUploadConfigFromJson(json);

  /// 服务器 URL。
  /// 示例: 'https://api.example.com/logs/upload'
  @override
  final String uploadUrl;

  /// 自定义 HTTP 请求头。
  /// 示例: {'Authorization': 'Bearer token', 'X-API-Key': 'key'}
  final Map<String, String> _headers;

  /// 自定义 HTTP 请求头。
  /// 示例: {'Authorization': 'Bearer token', 'X-API-Key': 'key'}
  @override
  @JsonKey()
  Map<String, String> get headers {
    if (_headers is EqualUnmodifiableMapView) return _headers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_headers);
  }

  /// 是否启用自动上传。
  @override
  @JsonKey()
  final bool autoUpload;

  /// 上传批量大小（每次请求的日志数量）。
  @override
  @JsonKey()
  final int batchSize;

  /// 自动上传间隔（分钟）。
  @override
  @JsonKey()
  final int uploadIntervalMinutes;

  /// 是否仅在 WiFi 下上传。
  @override
  @JsonKey()
  final bool wifiOnly;

  /// Create a copy of LogUploadConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LogUploadConfigCopyWith<_LogUploadConfig> get copyWith =>
      __$LogUploadConfigCopyWithImpl<_LogUploadConfig>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LogUploadConfigToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LogUploadConfig &&
            (identical(other.uploadUrl, uploadUrl) ||
                other.uploadUrl == uploadUrl) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            (identical(other.autoUpload, autoUpload) ||
                other.autoUpload == autoUpload) &&
            (identical(other.batchSize, batchSize) ||
                other.batchSize == batchSize) &&
            (identical(other.uploadIntervalMinutes, uploadIntervalMinutes) ||
                other.uploadIntervalMinutes == uploadIntervalMinutes) &&
            (identical(other.wifiOnly, wifiOnly) ||
                other.wifiOnly == wifiOnly));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uploadUrl,
      const DeepCollectionEquality().hash(_headers),
      autoUpload,
      batchSize,
      uploadIntervalMinutes,
      wifiOnly);

  @override
  String toString() {
    return 'LogUploadConfig(uploadUrl: $uploadUrl, headers: $headers, autoUpload: $autoUpload, batchSize: $batchSize, uploadIntervalMinutes: $uploadIntervalMinutes, wifiOnly: $wifiOnly)';
  }
}

/// @nodoc
abstract mixin class _$LogUploadConfigCopyWith<$Res>
    implements $LogUploadConfigCopyWith<$Res> {
  factory _$LogUploadConfigCopyWith(
          _LogUploadConfig value, $Res Function(_LogUploadConfig) _then) =
      __$LogUploadConfigCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String uploadUrl,
      Map<String, String> headers,
      bool autoUpload,
      int batchSize,
      int uploadIntervalMinutes,
      bool wifiOnly});
}

/// @nodoc
class __$LogUploadConfigCopyWithImpl<$Res>
    implements _$LogUploadConfigCopyWith<$Res> {
  __$LogUploadConfigCopyWithImpl(this._self, this._then);

  final _LogUploadConfig _self;
  final $Res Function(_LogUploadConfig) _then;

  /// Create a copy of LogUploadConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? uploadUrl = null,
    Object? headers = null,
    Object? autoUpload = null,
    Object? batchSize = null,
    Object? uploadIntervalMinutes = null,
    Object? wifiOnly = null,
  }) {
    return _then(_LogUploadConfig(
      uploadUrl: null == uploadUrl
          ? _self.uploadUrl
          : uploadUrl // ignore: cast_nullable_to_non_nullable
              as String,
      headers: null == headers
          ? _self._headers
          : headers // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      autoUpload: null == autoUpload
          ? _self.autoUpload
          : autoUpload // ignore: cast_nullable_to_non_nullable
              as bool,
      batchSize: null == batchSize
          ? _self.batchSize
          : batchSize // ignore: cast_nullable_to_non_nullable
              as int,
      uploadIntervalMinutes: null == uploadIntervalMinutes
          ? _self.uploadIntervalMinutes
          : uploadIntervalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      wifiOnly: null == wifiOnly
          ? _self.wifiOnly
          : wifiOnly // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$LogStorageConfig {
  /// 内存中保留的最大日志数量。
  int get maxCapacity;

  /// 最大文件大小（字节），默认 5MB。
  int get maxFileSize;

  /// 日志保留周期。
  LogRetentionPeriod get retentionPeriod;

  /// 是否启用文件日志。
  bool get enableFileLogging;

  /// 是否启用 Hive 数据库日志。
  bool get enableHiveLogging;

  /// 批量写入缓冲区大小（0 表示立即写入）。
  int get bufferSize;

  /// 发生错误时是否立即刷新缓冲区。
  bool get flushOnError;

  /// Create a copy of LogStorageConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LogStorageConfigCopyWith<LogStorageConfig> get copyWith =>
      _$LogStorageConfigCopyWithImpl<LogStorageConfig>(
          this as LogStorageConfig, _$identity);

  /// Serializes this LogStorageConfig to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LogStorageConfig &&
            (identical(other.maxCapacity, maxCapacity) ||
                other.maxCapacity == maxCapacity) &&
            (identical(other.maxFileSize, maxFileSize) ||
                other.maxFileSize == maxFileSize) &&
            (identical(other.retentionPeriod, retentionPeriod) ||
                other.retentionPeriod == retentionPeriod) &&
            (identical(other.enableFileLogging, enableFileLogging) ||
                other.enableFileLogging == enableFileLogging) &&
            (identical(other.enableHiveLogging, enableHiveLogging) ||
                other.enableHiveLogging == enableHiveLogging) &&
            (identical(other.bufferSize, bufferSize) ||
                other.bufferSize == bufferSize) &&
            (identical(other.flushOnError, flushOnError) ||
                other.flushOnError == flushOnError));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      maxCapacity,
      maxFileSize,
      retentionPeriod,
      enableFileLogging,
      enableHiveLogging,
      bufferSize,
      flushOnError);

  @override
  String toString() {
    return 'LogStorageConfig(maxCapacity: $maxCapacity, maxFileSize: $maxFileSize, retentionPeriod: $retentionPeriod, enableFileLogging: $enableFileLogging, enableHiveLogging: $enableHiveLogging, bufferSize: $bufferSize, flushOnError: $flushOnError)';
  }
}

/// @nodoc
abstract mixin class $LogStorageConfigCopyWith<$Res> {
  factory $LogStorageConfigCopyWith(
          LogStorageConfig value, $Res Function(LogStorageConfig) _then) =
      _$LogStorageConfigCopyWithImpl;
  @useResult
  $Res call(
      {int maxCapacity,
      int maxFileSize,
      LogRetentionPeriod retentionPeriod,
      bool enableFileLogging,
      bool enableHiveLogging,
      int bufferSize,
      bool flushOnError});
}

/// @nodoc
class _$LogStorageConfigCopyWithImpl<$Res>
    implements $LogStorageConfigCopyWith<$Res> {
  _$LogStorageConfigCopyWithImpl(this._self, this._then);

  final LogStorageConfig _self;
  final $Res Function(LogStorageConfig) _then;

  /// Create a copy of LogStorageConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxCapacity = null,
    Object? maxFileSize = null,
    Object? retentionPeriod = null,
    Object? enableFileLogging = null,
    Object? enableHiveLogging = null,
    Object? bufferSize = null,
    Object? flushOnError = null,
  }) {
    return _then(_self.copyWith(
      maxCapacity: null == maxCapacity
          ? _self.maxCapacity
          : maxCapacity // ignore: cast_nullable_to_non_nullable
              as int,
      maxFileSize: null == maxFileSize
          ? _self.maxFileSize
          : maxFileSize // ignore: cast_nullable_to_non_nullable
              as int,
      retentionPeriod: null == retentionPeriod
          ? _self.retentionPeriod
          : retentionPeriod // ignore: cast_nullable_to_non_nullable
              as LogRetentionPeriod,
      enableFileLogging: null == enableFileLogging
          ? _self.enableFileLogging
          : enableFileLogging // ignore: cast_nullable_to_non_nullable
              as bool,
      enableHiveLogging: null == enableHiveLogging
          ? _self.enableHiveLogging
          : enableHiveLogging // ignore: cast_nullable_to_non_nullable
              as bool,
      bufferSize: null == bufferSize
          ? _self.bufferSize
          : bufferSize // ignore: cast_nullable_to_non_nullable
              as int,
      flushOnError: null == flushOnError
          ? _self.flushOnError
          : flushOnError // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [LogStorageConfig].
extension LogStorageConfigPatterns on LogStorageConfig {
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
    TResult Function(_LogStorageConfig value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LogStorageConfig() when $default != null:
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
    TResult Function(_LogStorageConfig value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LogStorageConfig():
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
    TResult? Function(_LogStorageConfig value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LogStorageConfig() when $default != null:
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
    TResult Function(
            int maxCapacity,
            int maxFileSize,
            LogRetentionPeriod retentionPeriod,
            bool enableFileLogging,
            bool enableHiveLogging,
            int bufferSize,
            bool flushOnError)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LogStorageConfig() when $default != null:
        return $default(
            _that.maxCapacity,
            _that.maxFileSize,
            _that.retentionPeriod,
            _that.enableFileLogging,
            _that.enableHiveLogging,
            _that.bufferSize,
            _that.flushOnError);
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
    TResult Function(
            int maxCapacity,
            int maxFileSize,
            LogRetentionPeriod retentionPeriod,
            bool enableFileLogging,
            bool enableHiveLogging,
            int bufferSize,
            bool flushOnError)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LogStorageConfig():
        return $default(
            _that.maxCapacity,
            _that.maxFileSize,
            _that.retentionPeriod,
            _that.enableFileLogging,
            _that.enableHiveLogging,
            _that.bufferSize,
            _that.flushOnError);
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
    TResult? Function(
            int maxCapacity,
            int maxFileSize,
            LogRetentionPeriod retentionPeriod,
            bool enableFileLogging,
            bool enableHiveLogging,
            int bufferSize,
            bool flushOnError)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LogStorageConfig() when $default != null:
        return $default(
            _that.maxCapacity,
            _that.maxFileSize,
            _that.retentionPeriod,
            _that.enableFileLogging,
            _that.enableHiveLogging,
            _that.bufferSize,
            _that.flushOnError);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _LogStorageConfig implements LogStorageConfig {
  const _LogStorageConfig(
      {this.maxCapacity = 1000,
      this.maxFileSize = 5242880,
      this.retentionPeriod = LogRetentionPeriod.thirtyDays,
      this.enableFileLogging = true,
      this.enableHiveLogging = true,
      this.bufferSize = 0,
      this.flushOnError = true});
  factory _LogStorageConfig.fromJson(Map<String, dynamic> json) =>
      _$LogStorageConfigFromJson(json);

  /// 内存中保留的最大日志数量。
  @override
  @JsonKey()
  final int maxCapacity;

  /// 最大文件大小（字节），默认 5MB。
  @override
  @JsonKey()
  final int maxFileSize;

  /// 日志保留周期。
  @override
  @JsonKey()
  final LogRetentionPeriod retentionPeriod;

  /// 是否启用文件日志。
  @override
  @JsonKey()
  final bool enableFileLogging;

  /// 是否启用 Hive 数据库日志。
  @override
  @JsonKey()
  final bool enableHiveLogging;

  /// 批量写入缓冲区大小（0 表示立即写入）。
  @override
  @JsonKey()
  final int bufferSize;

  /// 发生错误时是否立即刷新缓冲区。
  @override
  @JsonKey()
  final bool flushOnError;

  /// Create a copy of LogStorageConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LogStorageConfigCopyWith<_LogStorageConfig> get copyWith =>
      __$LogStorageConfigCopyWithImpl<_LogStorageConfig>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LogStorageConfigToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LogStorageConfig &&
            (identical(other.maxCapacity, maxCapacity) ||
                other.maxCapacity == maxCapacity) &&
            (identical(other.maxFileSize, maxFileSize) ||
                other.maxFileSize == maxFileSize) &&
            (identical(other.retentionPeriod, retentionPeriod) ||
                other.retentionPeriod == retentionPeriod) &&
            (identical(other.enableFileLogging, enableFileLogging) ||
                other.enableFileLogging == enableFileLogging) &&
            (identical(other.enableHiveLogging, enableHiveLogging) ||
                other.enableHiveLogging == enableHiveLogging) &&
            (identical(other.bufferSize, bufferSize) ||
                other.bufferSize == bufferSize) &&
            (identical(other.flushOnError, flushOnError) ||
                other.flushOnError == flushOnError));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      maxCapacity,
      maxFileSize,
      retentionPeriod,
      enableFileLogging,
      enableHiveLogging,
      bufferSize,
      flushOnError);

  @override
  String toString() {
    return 'LogStorageConfig(maxCapacity: $maxCapacity, maxFileSize: $maxFileSize, retentionPeriod: $retentionPeriod, enableFileLogging: $enableFileLogging, enableHiveLogging: $enableHiveLogging, bufferSize: $bufferSize, flushOnError: $flushOnError)';
  }
}

/// @nodoc
abstract mixin class _$LogStorageConfigCopyWith<$Res>
    implements $LogStorageConfigCopyWith<$Res> {
  factory _$LogStorageConfigCopyWith(
          _LogStorageConfig value, $Res Function(_LogStorageConfig) _then) =
      __$LogStorageConfigCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int maxCapacity,
      int maxFileSize,
      LogRetentionPeriod retentionPeriod,
      bool enableFileLogging,
      bool enableHiveLogging,
      int bufferSize,
      bool flushOnError});
}

/// @nodoc
class __$LogStorageConfigCopyWithImpl<$Res>
    implements _$LogStorageConfigCopyWith<$Res> {
  __$LogStorageConfigCopyWithImpl(this._self, this._then);

  final _LogStorageConfig _self;
  final $Res Function(_LogStorageConfig) _then;

  /// Create a copy of LogStorageConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? maxCapacity = null,
    Object? maxFileSize = null,
    Object? retentionPeriod = null,
    Object? enableFileLogging = null,
    Object? enableHiveLogging = null,
    Object? bufferSize = null,
    Object? flushOnError = null,
  }) {
    return _then(_LogStorageConfig(
      maxCapacity: null == maxCapacity
          ? _self.maxCapacity
          : maxCapacity // ignore: cast_nullable_to_non_nullable
              as int,
      maxFileSize: null == maxFileSize
          ? _self.maxFileSize
          : maxFileSize // ignore: cast_nullable_to_non_nullable
              as int,
      retentionPeriod: null == retentionPeriod
          ? _self.retentionPeriod
          : retentionPeriod // ignore: cast_nullable_to_non_nullable
              as LogRetentionPeriod,
      enableFileLogging: null == enableFileLogging
          ? _self.enableFileLogging
          : enableFileLogging // ignore: cast_nullable_to_non_nullable
              as bool,
      enableHiveLogging: null == enableHiveLogging
          ? _self.enableHiveLogging
          : enableHiveLogging // ignore: cast_nullable_to_non_nullable
              as bool,
      bufferSize: null == bufferSize
          ? _self.bufferSize
          : bufferSize // ignore: cast_nullable_to_non_nullable
              as int,
      flushOnError: null == flushOnError
          ? _self.flushOnError
          : flushOnError // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$LogConfig {
  /// 存储配置。
  LogStorageConfig get storage;

  /// 上传配置（null 表示禁用上传）。
  LogUploadConfig? get upload;

  /// 是否启用日志。
  bool get enabled;

  /// 最低日志级别。
  AppLogLevel get logLevel;

  /// 持久化存储的日志名称。
  String get logName;

  /// Create a copy of LogConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LogConfigCopyWith<LogConfig> get copyWith =>
      _$LogConfigCopyWithImpl<LogConfig>(this as LogConfig, _$identity);

  /// Serializes this LogConfig to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LogConfig &&
            (identical(other.storage, storage) || other.storage == storage) &&
            (identical(other.upload, upload) || other.upload == upload) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.logLevel, logLevel) ||
                other.logLevel == logLevel) &&
            (identical(other.logName, logName) || other.logName == logName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, storage, upload, enabled, logLevel, logName);

  @override
  String toString() {
    return 'LogConfig(storage: $storage, upload: $upload, enabled: $enabled, logLevel: $logLevel, logName: $logName)';
  }
}

/// @nodoc
abstract mixin class $LogConfigCopyWith<$Res> {
  factory $LogConfigCopyWith(LogConfig value, $Res Function(LogConfig) _then) =
      _$LogConfigCopyWithImpl;
  @useResult
  $Res call(
      {LogStorageConfig storage,
      LogUploadConfig? upload,
      bool enabled,
      AppLogLevel logLevel,
      String logName});

  $LogStorageConfigCopyWith<$Res> get storage;
  $LogUploadConfigCopyWith<$Res>? get upload;
}

/// @nodoc
class _$LogConfigCopyWithImpl<$Res> implements $LogConfigCopyWith<$Res> {
  _$LogConfigCopyWithImpl(this._self, this._then);

  final LogConfig _self;
  final $Res Function(LogConfig) _then;

  /// Create a copy of LogConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storage = null,
    Object? upload = freezed,
    Object? enabled = null,
    Object? logLevel = null,
    Object? logName = null,
  }) {
    return _then(_self.copyWith(
      storage: null == storage
          ? _self.storage
          : storage // ignore: cast_nullable_to_non_nullable
              as LogStorageConfig,
      upload: freezed == upload
          ? _self.upload
          : upload // ignore: cast_nullable_to_non_nullable
              as LogUploadConfig?,
      enabled: null == enabled
          ? _self.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      logLevel: null == logLevel
          ? _self.logLevel
          : logLevel // ignore: cast_nullable_to_non_nullable
              as AppLogLevel,
      logName: null == logName
          ? _self.logName
          : logName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of LogConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LogStorageConfigCopyWith<$Res> get storage {
    return $LogStorageConfigCopyWith<$Res>(_self.storage, (value) {
      return _then(_self.copyWith(storage: value));
    });
  }

  /// Create a copy of LogConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LogUploadConfigCopyWith<$Res>? get upload {
    if (_self.upload == null) {
      return null;
    }

    return $LogUploadConfigCopyWith<$Res>(_self.upload!, (value) {
      return _then(_self.copyWith(upload: value));
    });
  }
}

/// Adds pattern-matching-related methods to [LogConfig].
extension LogConfigPatterns on LogConfig {
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
    TResult Function(_LogConfig value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LogConfig() when $default != null:
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
    TResult Function(_LogConfig value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LogConfig():
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
    TResult? Function(_LogConfig value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LogConfig() when $default != null:
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
    TResult Function(LogStorageConfig storage, LogUploadConfig? upload,
            bool enabled, AppLogLevel logLevel, String logName)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LogConfig() when $default != null:
        return $default(_that.storage, _that.upload, _that.enabled,
            _that.logLevel, _that.logName);
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
    TResult Function(LogStorageConfig storage, LogUploadConfig? upload,
            bool enabled, AppLogLevel logLevel, String logName)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LogConfig():
        return $default(_that.storage, _that.upload, _that.enabled,
            _that.logLevel, _that.logName);
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
    TResult? Function(LogStorageConfig storage, LogUploadConfig? upload,
            bool enabled, AppLogLevel logLevel, String logName)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LogConfig() when $default != null:
        return $default(_that.storage, _that.upload, _that.enabled,
            _that.logLevel, _that.logName);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _LogConfig implements LogConfig {
  const _LogConfig(
      {this.storage = const LogStorageConfig(),
      this.upload,
      this.enabled = true,
      this.logLevel = AppLogLevel.info,
      this.logName = 'app_logs'});
  factory _LogConfig.fromJson(Map<String, dynamic> json) =>
      _$LogConfigFromJson(json);

  /// 存储配置。
  @override
  @JsonKey()
  final LogStorageConfig storage;

  /// 上传配置（null 表示禁用上传）。
  @override
  final LogUploadConfig? upload;

  /// 是否启用日志。
  @override
  @JsonKey()
  final bool enabled;

  /// 最低日志级别。
  @override
  @JsonKey()
  final AppLogLevel logLevel;

  /// 持久化存储的日志名称。
  @override
  @JsonKey()
  final String logName;

  /// Create a copy of LogConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LogConfigCopyWith<_LogConfig> get copyWith =>
      __$LogConfigCopyWithImpl<_LogConfig>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LogConfigToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LogConfig &&
            (identical(other.storage, storage) || other.storage == storage) &&
            (identical(other.upload, upload) || other.upload == upload) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.logLevel, logLevel) ||
                other.logLevel == logLevel) &&
            (identical(other.logName, logName) || other.logName == logName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, storage, upload, enabled, logLevel, logName);

  @override
  String toString() {
    return 'LogConfig(storage: $storage, upload: $upload, enabled: $enabled, logLevel: $logLevel, logName: $logName)';
  }
}

/// @nodoc
abstract mixin class _$LogConfigCopyWith<$Res>
    implements $LogConfigCopyWith<$Res> {
  factory _$LogConfigCopyWith(
          _LogConfig value, $Res Function(_LogConfig) _then) =
      __$LogConfigCopyWithImpl;
  @override
  @useResult
  $Res call(
      {LogStorageConfig storage,
      LogUploadConfig? upload,
      bool enabled,
      AppLogLevel logLevel,
      String logName});

  @override
  $LogStorageConfigCopyWith<$Res> get storage;
  @override
  $LogUploadConfigCopyWith<$Res>? get upload;
}

/// @nodoc
class __$LogConfigCopyWithImpl<$Res> implements _$LogConfigCopyWith<$Res> {
  __$LogConfigCopyWithImpl(this._self, this._then);

  final _LogConfig _self;
  final $Res Function(_LogConfig) _then;

  /// Create a copy of LogConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? storage = null,
    Object? upload = freezed,
    Object? enabled = null,
    Object? logLevel = null,
    Object? logName = null,
  }) {
    return _then(_LogConfig(
      storage: null == storage
          ? _self.storage
          : storage // ignore: cast_nullable_to_non_nullable
              as LogStorageConfig,
      upload: freezed == upload
          ? _self.upload
          : upload // ignore: cast_nullable_to_non_nullable
              as LogUploadConfig?,
      enabled: null == enabled
          ? _self.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      logLevel: null == logLevel
          ? _self.logLevel
          : logLevel // ignore: cast_nullable_to_non_nullable
              as AppLogLevel,
      logName: null == logName
          ? _self.logName
          : logName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of LogConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LogStorageConfigCopyWith<$Res> get storage {
    return $LogStorageConfigCopyWith<$Res>(_self.storage, (value) {
      return _then(_self.copyWith(storage: value));
    });
  }

  /// Create a copy of LogConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LogUploadConfigCopyWith<$Res>? get upload {
    if (_self.upload == null) {
      return null;
    }

    return $LogUploadConfigCopyWith<$Res>(_self.upload!, (value) {
      return _then(_self.copyWith(upload: value));
    });
  }
}

// dart format on
