// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TextMessage _$TextMessageFromJson(Map<String, dynamic> json) => _TextMessage(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      sender: $enumDecode(_$MessageSenderEnumMap, json['sender']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: $enumDecodeNullable(_$MessageStatusEnumMap, json['status']) ??
          MessageStatus.sent,
      content: json['content'] as String,
    );

Map<String, dynamic> _$TextMessageToJson(_TextMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'sender': _$MessageSenderEnumMap[instance.sender]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'status': _$MessageStatusEnumMap[instance.status]!,
      'content': instance.content,
    };

const _$MessageSenderEnumMap = {
  MessageSender.user: 'user',
  MessageSender.assistant: 'assistant',
  MessageSender.system: 'system',
};

const _$MessageStatusEnumMap = {
  MessageStatus.sending: 'sending',
  MessageStatus.sent: 'sent',
  MessageStatus.read: 'read',
  MessageStatus.error: 'error',
};

_ImageMessage _$ImageMessageFromJson(Map<String, dynamic> json) =>
    _ImageMessage(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      sender: $enumDecode(_$MessageSenderEnumMap, json['sender']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: $enumDecodeNullable(_$MessageStatusEnumMap, json['status']) ??
          MessageStatus.sent,
      imageUrls:
          (json['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
      thumbnailUrls: (json['thumbnailUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      caption: json['caption'] as String?,
      widths: (json['widths'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      heights: (json['heights'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ImageMessageToJson(_ImageMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'sender': _$MessageSenderEnumMap[instance.sender]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'status': _$MessageStatusEnumMap[instance.status]!,
      'imageUrls': instance.imageUrls,
      'thumbnailUrls': instance.thumbnailUrls,
      'caption': instance.caption,
      'widths': instance.widths,
      'heights': instance.heights,
    };
