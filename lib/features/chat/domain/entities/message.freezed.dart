// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TextMessage implements DiagnosticableTreeMixin {
  /// 消息唯一标识符。
  String get id;

  /// 所属会话 ID。
  String get conversationId;

  /// 消息发送者。
  MessageSender get sender;

  /// 消息发送时间。
  DateTime get timestamp;

  /// 消息状态。
  MessageStatus get status;

  /// 文本内容。
  String get content;

  /// Create a copy of TextMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TextMessageCopyWith<TextMessage> get copyWith =>
      _$TextMessageCopyWithImpl<TextMessage>(this as TextMessage, _$identity);

  /// Serializes this TextMessage to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'TextMessage'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('conversationId', conversationId))
      ..add(DiagnosticsProperty('sender', sender))
      ..add(DiagnosticsProperty('timestamp', timestamp))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('content', content));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TextMessage &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, conversationId, sender, timestamp, status, content);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'TextMessage(id: $id, conversationId: $conversationId, sender: $sender, timestamp: $timestamp, status: $status, content: $content)';
  }
}

/// @nodoc
abstract mixin class $TextMessageCopyWith<$Res> {
  factory $TextMessageCopyWith(
          TextMessage value, $Res Function(TextMessage) _then) =
      _$TextMessageCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String conversationId,
      MessageSender sender,
      DateTime timestamp,
      MessageStatus status,
      String content});
}

/// @nodoc
class _$TextMessageCopyWithImpl<$Res> implements $TextMessageCopyWith<$Res> {
  _$TextMessageCopyWithImpl(this._self, this._then);

  final TextMessage _self;
  final $Res Function(TextMessage) _then;

  /// Create a copy of TextMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? sender = null,
    Object? timestamp = null,
    Object? status = null,
    Object? content = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _self.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      sender: null == sender
          ? _self.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as MessageSender,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatus,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [TextMessage].
extension TextMessagePatterns on TextMessage {
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
    TResult Function(_TextMessage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TextMessage() when $default != null:
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
    TResult Function(_TextMessage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TextMessage():
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
    TResult? Function(_TextMessage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TextMessage() when $default != null:
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
    TResult Function(String id, String conversationId, MessageSender sender,
            DateTime timestamp, MessageStatus status, String content)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TextMessage() when $default != null:
        return $default(_that.id, _that.conversationId, _that.sender,
            _that.timestamp, _that.status, _that.content);
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
    TResult Function(String id, String conversationId, MessageSender sender,
            DateTime timestamp, MessageStatus status, String content)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TextMessage():
        return $default(_that.id, _that.conversationId, _that.sender,
            _that.timestamp, _that.status, _that.content);
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
    TResult? Function(String id, String conversationId, MessageSender sender,
            DateTime timestamp, MessageStatus status, String content)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TextMessage() when $default != null:
        return $default(_that.id, _that.conversationId, _that.sender,
            _that.timestamp, _that.status, _that.content);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TextMessage extends TextMessage with DiagnosticableTreeMixin {
  const _TextMessage(
      {required this.id,
      required this.conversationId,
      required this.sender,
      required this.timestamp,
      this.status = MessageStatus.sent,
      required this.content})
      : super._();
  factory _TextMessage.fromJson(Map<String, dynamic> json) =>
      _$TextMessageFromJson(json);

  /// 消息唯一标识符。
  @override
  final String id;

  /// 所属会话 ID。
  @override
  final String conversationId;

  /// 消息发送者。
  @override
  final MessageSender sender;

  /// 消息发送时间。
  @override
  final DateTime timestamp;

  /// 消息状态。
  @override
  @JsonKey()
  final MessageStatus status;

  /// 文本内容。
  @override
  final String content;

  /// Create a copy of TextMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TextMessageCopyWith<_TextMessage> get copyWith =>
      __$TextMessageCopyWithImpl<_TextMessage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TextMessageToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'TextMessage'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('conversationId', conversationId))
      ..add(DiagnosticsProperty('sender', sender))
      ..add(DiagnosticsProperty('timestamp', timestamp))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('content', content));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TextMessage &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, conversationId, sender, timestamp, status, content);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'TextMessage(id: $id, conversationId: $conversationId, sender: $sender, timestamp: $timestamp, status: $status, content: $content)';
  }
}

/// @nodoc
abstract mixin class _$TextMessageCopyWith<$Res>
    implements $TextMessageCopyWith<$Res> {
  factory _$TextMessageCopyWith(
          _TextMessage value, $Res Function(_TextMessage) _then) =
      __$TextMessageCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String conversationId,
      MessageSender sender,
      DateTime timestamp,
      MessageStatus status,
      String content});
}

/// @nodoc
class __$TextMessageCopyWithImpl<$Res> implements _$TextMessageCopyWith<$Res> {
  __$TextMessageCopyWithImpl(this._self, this._then);

  final _TextMessage _self;
  final $Res Function(_TextMessage) _then;

  /// Create a copy of TextMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? sender = null,
    Object? timestamp = null,
    Object? status = null,
    Object? content = null,
  }) {
    return _then(_TextMessage(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _self.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      sender: null == sender
          ? _self.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as MessageSender,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatus,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$ImageMessage implements DiagnosticableTreeMixin {
  /// 消息唯一标识符。
  String get id;

  /// 所属会话 ID。
  String get conversationId;

  /// 消息发送者。
  MessageSender get sender;

  /// 消息发送时间。
  DateTime get timestamp;

  /// 消息状态。
  MessageStatus get status;

  /// 图片 URL 列表（支持多图）。
  List<String> get imageUrls;

  /// 缩略图 URL 列表（与图片一一对应）。
  List<String> get thumbnailUrls;

  /// 图片说明/描述。
  String? get caption;

  /// 图片宽度列表（像素）。
  List<int> get widths;

  /// 图片高度列表（像素）。
  List<int> get heights;

  /// Create a copy of ImageMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ImageMessageCopyWith<ImageMessage> get copyWith =>
      _$ImageMessageCopyWithImpl<ImageMessage>(
          this as ImageMessage, _$identity);

  /// Serializes this ImageMessage to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'ImageMessage'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('conversationId', conversationId))
      ..add(DiagnosticsProperty('sender', sender))
      ..add(DiagnosticsProperty('timestamp', timestamp))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('imageUrls', imageUrls))
      ..add(DiagnosticsProperty('thumbnailUrls', thumbnailUrls))
      ..add(DiagnosticsProperty('caption', caption))
      ..add(DiagnosticsProperty('widths', widths))
      ..add(DiagnosticsProperty('heights', heights));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ImageMessage &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other.imageUrls, imageUrls) &&
            const DeepCollectionEquality()
                .equals(other.thumbnailUrls, thumbnailUrls) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            const DeepCollectionEquality().equals(other.widths, widths) &&
            const DeepCollectionEquality().equals(other.heights, heights));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      conversationId,
      sender,
      timestamp,
      status,
      const DeepCollectionEquality().hash(imageUrls),
      const DeepCollectionEquality().hash(thumbnailUrls),
      caption,
      const DeepCollectionEquality().hash(widths),
      const DeepCollectionEquality().hash(heights));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ImageMessage(id: $id, conversationId: $conversationId, sender: $sender, timestamp: $timestamp, status: $status, imageUrls: $imageUrls, thumbnailUrls: $thumbnailUrls, caption: $caption, widths: $widths, heights: $heights)';
  }
}

/// @nodoc
abstract mixin class $ImageMessageCopyWith<$Res> {
  factory $ImageMessageCopyWith(
          ImageMessage value, $Res Function(ImageMessage) _then) =
      _$ImageMessageCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String conversationId,
      MessageSender sender,
      DateTime timestamp,
      MessageStatus status,
      List<String> imageUrls,
      List<String> thumbnailUrls,
      String? caption,
      List<int> widths,
      List<int> heights});
}

/// @nodoc
class _$ImageMessageCopyWithImpl<$Res> implements $ImageMessageCopyWith<$Res> {
  _$ImageMessageCopyWithImpl(this._self, this._then);

  final ImageMessage _self;
  final $Res Function(ImageMessage) _then;

  /// Create a copy of ImageMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? sender = null,
    Object? timestamp = null,
    Object? status = null,
    Object? imageUrls = null,
    Object? thumbnailUrls = null,
    Object? caption = freezed,
    Object? widths = null,
    Object? heights = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _self.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      sender: null == sender
          ? _self.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as MessageSender,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatus,
      imageUrls: null == imageUrls
          ? _self.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      thumbnailUrls: null == thumbnailUrls
          ? _self.thumbnailUrls
          : thumbnailUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      caption: freezed == caption
          ? _self.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      widths: null == widths
          ? _self.widths
          : widths // ignore: cast_nullable_to_non_nullable
              as List<int>,
      heights: null == heights
          ? _self.heights
          : heights // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// Adds pattern-matching-related methods to [ImageMessage].
extension ImageMessagePatterns on ImageMessage {
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
    TResult Function(_ImageMessage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ImageMessage() when $default != null:
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
    TResult Function(_ImageMessage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ImageMessage():
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
    TResult? Function(_ImageMessage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ImageMessage() when $default != null:
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
            String id,
            String conversationId,
            MessageSender sender,
            DateTime timestamp,
            MessageStatus status,
            List<String> imageUrls,
            List<String> thumbnailUrls,
            String? caption,
            List<int> widths,
            List<int> heights)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ImageMessage() when $default != null:
        return $default(
            _that.id,
            _that.conversationId,
            _that.sender,
            _that.timestamp,
            _that.status,
            _that.imageUrls,
            _that.thumbnailUrls,
            _that.caption,
            _that.widths,
            _that.heights);
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
            String id,
            String conversationId,
            MessageSender sender,
            DateTime timestamp,
            MessageStatus status,
            List<String> imageUrls,
            List<String> thumbnailUrls,
            String? caption,
            List<int> widths,
            List<int> heights)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ImageMessage():
        return $default(
            _that.id,
            _that.conversationId,
            _that.sender,
            _that.timestamp,
            _that.status,
            _that.imageUrls,
            _that.thumbnailUrls,
            _that.caption,
            _that.widths,
            _that.heights);
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
            String id,
            String conversationId,
            MessageSender sender,
            DateTime timestamp,
            MessageStatus status,
            List<String> imageUrls,
            List<String> thumbnailUrls,
            String? caption,
            List<int> widths,
            List<int> heights)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ImageMessage() when $default != null:
        return $default(
            _that.id,
            _that.conversationId,
            _that.sender,
            _that.timestamp,
            _that.status,
            _that.imageUrls,
            _that.thumbnailUrls,
            _that.caption,
            _that.widths,
            _that.heights);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ImageMessage extends ImageMessage with DiagnosticableTreeMixin {
  const _ImageMessage(
      {required this.id,
      required this.conversationId,
      required this.sender,
      required this.timestamp,
      this.status = MessageStatus.sent,
      required final List<String> imageUrls,
      final List<String> thumbnailUrls = const [],
      this.caption,
      final List<int> widths = const [],
      final List<int> heights = const []})
      : _imageUrls = imageUrls,
        _thumbnailUrls = thumbnailUrls,
        _widths = widths,
        _heights = heights,
        super._();
  factory _ImageMessage.fromJson(Map<String, dynamic> json) =>
      _$ImageMessageFromJson(json);

  /// 消息唯一标识符。
  @override
  final String id;

  /// 所属会话 ID。
  @override
  final String conversationId;

  /// 消息发送者。
  @override
  final MessageSender sender;

  /// 消息发送时间。
  @override
  final DateTime timestamp;

  /// 消息状态。
  @override
  @JsonKey()
  final MessageStatus status;

  /// 图片 URL 列表（支持多图）。
  final List<String> _imageUrls;

  /// 图片 URL 列表（支持多图）。
  @override
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  /// 缩略图 URL 列表（与图片一一对应）。
  final List<String> _thumbnailUrls;

  /// 缩略图 URL 列表（与图片一一对应）。
  @override
  @JsonKey()
  List<String> get thumbnailUrls {
    if (_thumbnailUrls is EqualUnmodifiableListView) return _thumbnailUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_thumbnailUrls);
  }

  /// 图片说明/描述。
  @override
  final String? caption;

  /// 图片宽度列表（像素）。
  final List<int> _widths;

  /// 图片宽度列表（像素）。
  @override
  @JsonKey()
  List<int> get widths {
    if (_widths is EqualUnmodifiableListView) return _widths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_widths);
  }

  /// 图片高度列表（像素）。
  final List<int> _heights;

  /// 图片高度列表（像素）。
  @override
  @JsonKey()
  List<int> get heights {
    if (_heights is EqualUnmodifiableListView) return _heights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_heights);
  }

  /// Create a copy of ImageMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ImageMessageCopyWith<_ImageMessage> get copyWith =>
      __$ImageMessageCopyWithImpl<_ImageMessage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ImageMessageToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'ImageMessage'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('conversationId', conversationId))
      ..add(DiagnosticsProperty('sender', sender))
      ..add(DiagnosticsProperty('timestamp', timestamp))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('imageUrls', imageUrls))
      ..add(DiagnosticsProperty('thumbnailUrls', thumbnailUrls))
      ..add(DiagnosticsProperty('caption', caption))
      ..add(DiagnosticsProperty('widths', widths))
      ..add(DiagnosticsProperty('heights', heights));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ImageMessage &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            const DeepCollectionEquality()
                .equals(other._thumbnailUrls, _thumbnailUrls) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            const DeepCollectionEquality().equals(other._widths, _widths) &&
            const DeepCollectionEquality().equals(other._heights, _heights));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      conversationId,
      sender,
      timestamp,
      status,
      const DeepCollectionEquality().hash(_imageUrls),
      const DeepCollectionEquality().hash(_thumbnailUrls),
      caption,
      const DeepCollectionEquality().hash(_widths),
      const DeepCollectionEquality().hash(_heights));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ImageMessage(id: $id, conversationId: $conversationId, sender: $sender, timestamp: $timestamp, status: $status, imageUrls: $imageUrls, thumbnailUrls: $thumbnailUrls, caption: $caption, widths: $widths, heights: $heights)';
  }
}

/// @nodoc
abstract mixin class _$ImageMessageCopyWith<$Res>
    implements $ImageMessageCopyWith<$Res> {
  factory _$ImageMessageCopyWith(
          _ImageMessage value, $Res Function(_ImageMessage) _then) =
      __$ImageMessageCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String conversationId,
      MessageSender sender,
      DateTime timestamp,
      MessageStatus status,
      List<String> imageUrls,
      List<String> thumbnailUrls,
      String? caption,
      List<int> widths,
      List<int> heights});
}

/// @nodoc
class __$ImageMessageCopyWithImpl<$Res>
    implements _$ImageMessageCopyWith<$Res> {
  __$ImageMessageCopyWithImpl(this._self, this._then);

  final _ImageMessage _self;
  final $Res Function(_ImageMessage) _then;

  /// Create a copy of ImageMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? sender = null,
    Object? timestamp = null,
    Object? status = null,
    Object? imageUrls = null,
    Object? thumbnailUrls = null,
    Object? caption = freezed,
    Object? widths = null,
    Object? heights = null,
  }) {
    return _then(_ImageMessage(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _self.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      sender: null == sender
          ? _self.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as MessageSender,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatus,
      imageUrls: null == imageUrls
          ? _self._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      thumbnailUrls: null == thumbnailUrls
          ? _self._thumbnailUrls
          : thumbnailUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      caption: freezed == caption
          ? _self.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      widths: null == widths
          ? _self._widths
          : widths // ignore: cast_nullable_to_non_nullable
              as List<int>,
      heights: null == heights
          ? _self._heights
          : heights // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

// dart format on
