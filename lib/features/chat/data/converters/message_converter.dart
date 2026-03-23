/// 消息转换器。
///
/// 提供数据库 DTO 与领域 Message 之间的转换功能。
/// 支持向后兼容旧版 ChatMessage 格式。
library;

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_project_template/core/storage/database.dart';
import 'package:flutter_project_template/features/chat/domain/entities/chat_message.dart'
    as domain;
import 'package:flutter_project_template/features/chat/domain/entities/message.dart';

/// 消息转换器。
///
/// 提供以下转换功能：
/// - 数据库 ChatMessage -> 领域 Message
/// - 领域 Message -> 数据库 ChatMessagesCompanion
/// - 旧版领域 ChatMessage -> 新版 Message
/// - 新版 Message -> 旧版 ChatMessage
class MessageConverter {
  /// 将数据库 DTO 转换为领域 Message。
  ///
  /// 根据 [messageType] 字段判断消息类型：
  /// - 0: 文本消息 (TextMessage)
  /// - 1: 图片消息 (ImageMessage)
  static Message fromDto(ChatMessage dto) {
    final sender = dto.sender == 0 ? MessageSender.user : MessageSender.assistant;
    final status = MessageStatus.values[dto.status.clamp(0, 3)];

    // 根据消息类型创建不同的消息对象
    switch (dto.messageType) {
      case 1: // 图片消息
        return _createImageMessage(dto, sender, status);
      case 0:
      default: // 文本消息
        return TextMessage(
          id: dto.id,
          conversationId: dto.conversationId,
          sender: sender,
          timestamp: dto.timestamp,
          status: status,
          content: dto.content,
        );
    }
  }

  /// 创建图片消息。
  static ImageMessage _createImageMessage(
    ChatMessage dto,
    MessageSender sender,
    MessageStatus status,
  ) {
    // 解析图片 URL 列表
    List<String> imageUrls = [];
    if (dto.imageUrl != null && dto.imageUrl!.isNotEmpty) {
      try {
        final decoded = jsonDecode(dto.imageUrl!);
        if (decoded is List) {
          imageUrls = decoded.cast<String>();
        } else if (decoded is String) {
          imageUrls = [decoded];
        }
      } catch (_) {
        // 如果不是 JSON，直接作为单个 URL
        imageUrls = [dto.imageUrl!];
      }
    }

    // 解析缩略图 URL 列表
    List<String> thumbnailUrls = [];
    if (dto.thumbnailUrl != null && dto.thumbnailUrl!.isNotEmpty) {
      try {
        final decoded = jsonDecode(dto.thumbnailUrl!);
        if (decoded is List) {
          thumbnailUrls = decoded.cast<String>();
        } else if (decoded is String) {
          thumbnailUrls = [decoded];
        }
      } catch (_) {
        thumbnailUrls = [dto.thumbnailUrl!];
      }
    }

    // 解析图片尺寸
    List<int> widths = [];
    List<int> heights = [];
    if (dto.metadata != null) {
      try {
        final metadata = jsonDecode(dto.metadata!) as Map<String, dynamic>;
        if (metadata['widths'] is List) {
          widths = (metadata['widths'] as List).cast<int>();
        }
        if (metadata['heights'] is List) {
          heights = (metadata['heights'] as List).cast<int>();
        }
      } catch (_) {
        // 忽略解析错误
      }
    }

    return ImageMessage(
      id: dto.id,
      conversationId: dto.conversationId,
      sender: sender,
      timestamp: dto.timestamp,
      status: status,
      imageUrls: imageUrls,
      thumbnailUrls: thumbnailUrls,
      caption: dto.caption,
      widths: widths,
      heights: heights,
    );
  }

  /// 将领域 Message 转换为数据库 Companion。
  ///
  /// 用于插入或更新数据库记录。
  static ChatMessagesCompanion toCompanion(Message message) {
    return switch (message) {
      TextMessage(:final id, :final conversationId, :final sender, :final timestamp, :final status, :final content) =>
        ChatMessagesCompanion(
          id: Value(id),
          conversationId: Value(conversationId),
          content: Value(content),
          sender: Value(sender == MessageSender.user ? 0 : 1),
          status: Value(status.index),
          timestamp: Value(timestamp),
          messageType: const Value(0),
          imageUrl: const Value(null),
          thumbnailUrl: const Value(null),
          caption: const Value(null),
          metadata: const Value(null),
        ),
      ImageMessage(:final id, :final conversationId, :final sender, :final timestamp, :final status, :final imageUrls, :final thumbnailUrls, :final caption, :final widths, :final heights) =>
        ChatMessagesCompanion(
          id: Value(id),
          conversationId: Value(conversationId),
          content: Value(caption ?? ''),
          sender: Value(sender == MessageSender.user ? 0 : 1),
          status: Value(status.index),
          timestamp: Value(timestamp),
          messageType: const Value(1),
          imageUrl: Value(imageUrls.isNotEmpty ? jsonEncode(imageUrls) : null),
          thumbnailUrl: Value(thumbnailUrls.isNotEmpty ? jsonEncode(thumbnailUrls) : null),
          caption: Value(caption),
          metadata: Value(_buildImageMetadata(widths, heights)),
        ),
    };
  }

  /// 构建图片元数据 JSON。
  static String? _buildImageMetadata(List<int> widths, List<int> heights) {
    if (widths.isEmpty && heights.isEmpty) return null;
    return jsonEncode({
      'widths': widths,
      'heights': heights,
    });
  }

  /// 将数据库消息列表转换为领域消息列表。
  static List<Message> fromDtoList(List<ChatMessage> dtos) {
    return dtos.map(fromDto).toList();
  }

  /// 将新版 Message 转换为旧版 ChatMessage。
  ///
  /// 用于向后兼容现有的 UI 代码。
  static domain.ChatMessage toLegacyChatMessage(Message message) {
    return domain.ChatMessage(
      id: message.id,
      content: message.text ?? '',
      sender: message.sender == MessageSender.user
          ? domain.MessageSender.user
          : domain.MessageSender.ai,
      timestamp: message.timestamp,
      status: domain.MessageStatus.values[message.status.index],
    );
  }

  /// 将新版 Message 列表转换为旧版 ChatMessage 列表。
  static List<domain.ChatMessage> toLegacyChatMessageList(
    List<Message> messages,
  ) {
    return messages.map(toLegacyChatMessage).toList();
  }

  /// 将旧版 ChatMessage 转换为新版 TextMessage。
  ///
  /// 旧版消息统一转换为文本消息。
  static TextMessage fromLegacyChatMessage(
    domain.ChatMessage legacy, {
    required String conversationId,
  }) {
    return TextMessage(
      id: legacy.id,
      conversationId: conversationId,
      sender: legacy.sender == domain.MessageSender.user
          ? MessageSender.user
          : MessageSender.assistant,
      timestamp: legacy.timestamp,
      status: MessageStatus.values[legacy.status.index],
      content: legacy.content,
    );
  }
}