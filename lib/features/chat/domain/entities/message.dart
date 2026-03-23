/// 消息基类和类型定义。
///
/// 定义了 IM 系统的核心消息类型，使用 sealed class 实现类型安全的消息体系。
library;

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

/// 消息发送者类型。
enum MessageSender {
  /// 当前用户发送的消息。
  user,

  /// AI 助手发送的消息。
  assistant,

  /// 系统消息（如通知、提示等）。
  system,
}

/// 消息状态。
enum MessageStatus {
  /// 消息正在发送中。
  sending,

  /// 消息已成功发送。
  sent,

  /// 消息已被对方阅读。
  read,

  /// 消息发送失败。
  error,
}

/// 消息类型枚举。
enum MessageType {
  /// 文本消息。
  text,

  /// 图片消息。
  image,

  /// 文件消息。
  file,

  /// 语音消息。
  voice,

  /// 视频消息。
  video,

  /// 自定义消息。
  custom,
}

/// 消息基类。
///
/// 使用 sealed class 实现类型安全的消息体系，所有消息类型必须在此文件中定义。
/// 支持 JSON 序列化和数据库存储。
sealed class Message {
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

  /// 消息类型。
  MessageType get type;

  /// 消息文本内容（可选，用于显示预览）。
  String? get text;

  /// 将消息转换为 JSON Map。
  Map<String, dynamic> toJson();
}

/// 文本消息模型。
///
/// 表示一条纯文本消息，是最常用的消息类型。
@freezed
sealed class TextMessage with _$TextMessage implements Message {
  /// 创建文本消息。
  const factory TextMessage({
    /// 消息唯一标识符。
    required String id,

    /// 所属会话 ID。
    required String conversationId,

    /// 消息发送者。
    required MessageSender sender,

    /// 消息发送时间。
    required DateTime timestamp,

    /// 消息状态。
    @Default(MessageStatus.sent) MessageStatus status,

    /// 文本内容。
    required String content,
  }) = _TextMessage;

  const TextMessage._();

  /// 从 JSON Map 创建文本消息。
  factory TextMessage.fromJson(Map<String, dynamic> json) =>
      _$TextMessageFromJson(json);

  @override
  MessageType get type => MessageType.text;

  @override
  String? get text => content;
}

/// 图片消息模型。
///
/// 表示一条图片消息，支持多图和图片说明。
@freezed
sealed class ImageMessage with _$ImageMessage implements Message {
  /// 创建图片消息。
  const factory ImageMessage({
    /// 消息唯一标识符。
    required String id,

    /// 所属会话 ID。
    required String conversationId,

    /// 消息发送者。
    required MessageSender sender,

    /// 消息发送时间。
    required DateTime timestamp,

    /// 消息状态。
    @Default(MessageStatus.sent) MessageStatus status,

    /// 图片 URL 列表（支持多图）。
    required List<String> imageUrls,

    /// 缩略图 URL 列表（与图片一一对应）。
    @Default([]) List<String> thumbnailUrls,

    /// 图片说明/描述。
    String? caption,

    /// 图片宽度列表（像素）。
    @Default([]) List<int> widths,

    /// 图片高度列表（像素）。
    @Default([]) List<int> heights,
  }) = _ImageMessage;

  const ImageMessage._();

  /// 从 JSON Map 创建图片消息。
  factory ImageMessage.fromJson(Map<String, dynamic> json) =>
      _$ImageMessageFromJson(json);

  @override
  MessageType get type => MessageType.image;

  @override
  String? get text => caption;

  /// 是否为多图消息。
  bool get isMultipleImages => imageUrls.length > 1;

  /// 获取图片数量。
  int get imageCount => imageUrls.length;

  /// 获取指定索引的缩略图 URL。
  String? getThumbnailUrl(int index) {
    if (index < 0 || index >= imageUrls.length) return null;
    if (index < thumbnailUrls.length) return thumbnailUrls[index];
    return null;
  }

  /// 获取指定索引的图片尺寸。
  ({int? width, int? height})? getDimensions(int index) {
    if (index < 0 || index >= imageUrls.length) return null;
    final width = index < widths.length ? widths[index] : null;
    final height = index < heights.length ? heights[index] : null;
    return (width: width, height: height);
  }
}

/// 消息附件。
///
/// 表示消息中携带的附件信息，如图片、文件等。
@immutable
class MessageAttachment {
  /// 创建消息附件。
  const MessageAttachment({
    required this.id,
    required this.type,
    required this.url,
    this.thumbnailUrl,
    this.fileName,
    this.fileSize,
    this.mimeType,
    this.width,
    this.height,
    this.duration,
    this.metadata = const {},
  });

  /// 附件唯一标识符。
  final String id;

  /// 附件类型。
  final AttachmentType type;

  /// 附件 URL。
  final String url;

  /// 缩略图 URL（图片/视频）。
  final String? thumbnailUrl;

  /// 文件名。
  final String? fileName;

  /// 文件大小（字节）。
  final int? fileSize;

  /// MIME 类型。
  final String? mimeType;

  /// 图片/视频宽度。
  final int? width;

  /// 图片/视频高度。
  final int? height;

  /// 音频/视频时长（毫秒）。
  final int? duration;

  /// 额外元数据。
  final Map<String, dynamic> metadata;

  /// 将附件转换为 JSON Map。
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'url': url,
        'thumbnailUrl': thumbnailUrl,
        'fileName': fileName,
        'fileSize': fileSize,
        'mimeType': mimeType,
        'width': width,
        'height': height,
        'duration': duration,
        'metadata': metadata,
      };

  /// 从 JSON Map 创建附件。
  factory MessageAttachment.fromJson(Map<String, dynamic> json) =>
      MessageAttachment(
        id: json['id'] as String,
        type: AttachmentType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => AttachmentType.file,
        ),
        url: json['url'] as String,
        thumbnailUrl: json['thumbnailUrl'] as String?,
        fileName: json['fileName'] as String?,
        fileSize: json['fileSize'] as int?,
        mimeType: json['mimeType'] as String?,
        width: json['width'] as int?,
        height: json['height'] as int?,
        duration: json['duration'] as int?,
        metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
      );

  /// 创建附件副本。
  MessageAttachment copyWith({
    String? id,
    AttachmentType? type,
    String? url,
    String? thumbnailUrl,
    String? fileName,
    int? fileSize,
    String? mimeType,
    int? width,
    int? height,
    int? duration,
    Map<String, dynamic>? metadata,
  }) =>
      MessageAttachment(
        id: id ?? this.id,
        type: type ?? this.type,
        url: url ?? this.url,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        fileName: fileName ?? this.fileName,
        fileSize: fileSize ?? this.fileSize,
        mimeType: mimeType ?? this.mimeType,
        width: width ?? this.width,
        height: height ?? this.height,
        duration: duration ?? this.duration,
        metadata: metadata ?? this.metadata,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAttachment &&
          other.id == id &&
          other.url == url &&
          other.type == type;

  @override
  int get hashCode => Object.hash(id, url, type);
}

/// 附件类型枚举。
enum AttachmentType {
  /// 图片。
  image,

  /// 文件。
  file,

  /// 音频。
  voice,

  /// 视频。
  video,
}
