/// Chat message model.
///
/// Represents a single message in a chat conversation.
library;

import 'package:flutter/foundation.dart';

/// Enum representing the sender of a message.
enum MessageSender {
  /// Message from the current user.
  user,

  /// Message from the AI assistant.
  ai,
}

/// Enum representing the status of a message.
enum MessageStatus {
  /// Message is being sent.
  sending,

  /// Message was sent successfully.
  sent,

  /// Message was read by the recipient.
  read,

  /// Message failed to send.
  error,
}

/// Model representing a chat message.
@immutable
class ChatMessage {
  /// Creates a chat message.
  const ChatMessage({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
    this.status = MessageStatus.sent,
  });

  /// Unique identifier for the message.
  final String id;

  /// Text content of the message.
  final String content;

  /// Who sent the message.
  final MessageSender sender;

  /// When the message was sent.
  final DateTime timestamp;

  /// Current status of the message.
  final MessageStatus status;

  /// Whether this message is from the AI.
  bool get isFromAI => sender == MessageSender.ai;

  /// Creates a copy with optionally overridden fields.
  ChatMessage copyWith({
    String? id,
    String? content,
    MessageSender? sender,
    DateTime? timestamp,
    MessageStatus? status,
  }) => ChatMessage(
    id: id ?? this.id,
    content: content ?? this.content,
    sender: sender ?? this.sender,
    timestamp: timestamp ?? this.timestamp,
    status: status ?? this.status,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessage &&
          other.id == id &&
          other.content == content &&
          other.sender == sender &&
          other.timestamp == timestamp &&
          other.status == status;

  @override
  int get hashCode => Object.hash(id, content, sender, timestamp, status);
}

/// Model representing a chat conversation.
@immutable
class ChatConversation {
  /// Creates a chat conversation.
  const ChatConversation({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.updatedAt,
    this.unreadCount = 0,
    this.messages = const [],
  });

  /// Unique identifier for the conversation.
  final String id;

  /// Title of the conversation.
  final String title;

  /// Preview of the last message.
  final String lastMessage;

  /// When the conversation was last updated.
  final DateTime updatedAt;

  /// Number of unread messages.
  final int unreadCount;

  /// All messages in the conversation.
  final List<ChatMessage> messages;

  /// Creates a copy with optionally overridden fields.
  ChatConversation copyWith({
    String? id,
    String? title,
    String? lastMessage,
    DateTime? updatedAt,
    int? unreadCount,
    List<ChatMessage>? messages,
  }) => ChatConversation(
    id: id ?? this.id,
    title: title ?? this.title,
    lastMessage: lastMessage ?? this.lastMessage,
    updatedAt: updatedAt ?? this.updatedAt,
    unreadCount: unreadCount ?? this.unreadCount,
    messages: messages ?? this.messages,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatConversation &&
          other.id == id &&
          other.title == title &&
          other.lastMessage == lastMessage &&
          other.updatedAt == updatedAt &&
          other.unreadCount == unreadCount;

  @override
  int get hashCode =>
      Object.hash(id, title, lastMessage, updatedAt, unreadCount);
}
