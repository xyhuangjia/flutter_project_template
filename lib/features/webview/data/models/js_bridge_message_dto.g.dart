// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'js_bridge_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsBridgeMessageDto _$JsBridgeMessageDtoFromJson(Map<String, dynamic> json) =>
    JsBridgeMessageDto(
      type: json['type'] as String,
      data: json['data'] as Map<String, dynamic>,
      messageId: json['messageId'] as String?,
      timestamp: (json['timestamp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$JsBridgeMessageDtoToJson(JsBridgeMessageDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'data': instance.data,
      'messageId': instance.messageId,
      'timestamp': instance.timestamp,
    };
