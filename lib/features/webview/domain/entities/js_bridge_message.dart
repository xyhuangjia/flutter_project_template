/// JS Bridge message entity.
///
/// This is a domain entity with no external dependencies.
/// It represents a message exchanged between Flutter and WebView JavaScript.
library;

import 'package:flutter/foundation.dart';

/// JS Bridge message entity.
///
/// Represents a message sent between Flutter and WebView JavaScript
/// through the JavaScript bridge.
@immutable
class JsBridgeMessage {
  /// Creates a JS bridge message.
  const JsBridgeMessage({
    required this.type,
    required this.data,
    this.messageId,
    this.timestamp,
  });

  /// Creates a message from JSON.
  factory JsBridgeMessage.fromJson(Map<String, dynamic> json) {
    return JsBridgeMessage(
      type: json['type'] as String? ?? '',
      data: json['data'] as Map<String, dynamic>? ?? {},
      messageId: json['messageId'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int)
          : null,
    );
  }

  /// The type of the message.
  ///
  /// Used to identify the purpose of the message.
  final String type;

  /// The message payload.
  final Map<String, dynamic> data;

  /// Unique identifier for the message.
  ///
  /// Used for request-response correlation.
  final String? messageId;

  /// The timestamp when the message was created.
  final DateTime? timestamp;

  /// Converts the message to JSON.
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'data': data,
      if (messageId != null) 'messageId': messageId,
      if (timestamp != null)
        'timestamp': timestamp!.millisecondsSinceEpoch,
    };
  }

  /// Creates a copy of this message with optionally overridden fields.
  JsBridgeMessage copyWith({
    String? type,
    Map<String, dynamic>? data,
    String? messageId,
    DateTime? timestamp,
  }) {
    return JsBridgeMessage(
      type: type ?? this.type,
      data: data ?? this.data,
      messageId: messageId ?? this.messageId,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is JsBridgeMessage &&
        other.type == type &&
        _mapEquals(other.data, data) &&
        other.messageId == messageId &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return Object.hash(
      type,
      Object.hashAll(data.entries),
      messageId,
      timestamp,
    );
  }

  @override
  String toString() {
    return 'JsBridgeMessage(type: $type, data: $data, messageId: $messageId, '
        'timestamp: $timestamp)';
  }

  static bool _mapEquals<T>(Map<T, dynamic> a, Map<T, dynamic> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}
