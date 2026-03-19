/// JS Bridge message DTO.
///
/// Data Transfer Object for JavaScript bridge messages.
library;

import 'package:flutter_project_template/features/webview/domain/entities/js_bridge_message.dart';
import 'package:json_annotation/json_annotation.dart';

part 'js_bridge_message_dto.g.dart';

/// JS Bridge message DTO.
///
/// Used for serialization and deserialization of JS bridge messages.
@JsonSerializable()
class JsBridgeMessageDto {
  /// Creates a JS bridge message DTO.
  const JsBridgeMessageDto({
    required this.type,
    required this.data,
    this.messageId,
    this.timestamp,
  });

  /// Creates a DTO from a domain entity.
  factory JsBridgeMessageDto.fromEntity(JsBridgeMessage entity) {
    return JsBridgeMessageDto(
      type: entity.type,
      data: entity.data,
      messageId: entity.messageId,
      timestamp: entity.timestamp?.millisecondsSinceEpoch,
    );
  }

  /// Creates a DTO from JSON.
  factory JsBridgeMessageDto.fromJson(Map<String, dynamic> json) =>
      _$JsBridgeMessageDtoFromJson(json);

  /// The type of the message.
  final String type;

  /// The message payload.
  final Map<String, dynamic> data;

  /// Unique identifier for the message.
  final String? messageId;

  /// The timestamp in milliseconds since epoch.
  final int? timestamp;

  /// Converts the DTO to a domain entity.
  JsBridgeMessage toEntity() {
    return JsBridgeMessage(
      type: type,
      data: data,
      messageId: messageId,
      timestamp: timestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(timestamp!)
          : null,
    );
  }

  /// Converts the DTO to JSON.
  Map<String, dynamic> toJson() => _$JsBridgeMessageDtoToJson(this);
}
