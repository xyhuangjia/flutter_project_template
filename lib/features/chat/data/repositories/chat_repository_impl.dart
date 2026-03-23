/// 聊天仓库实现。
///
/// 实现聊天仓库接口，协调本地数据源进行数据操作。
library;

import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_project_template/core/storage/database.dart';
import 'package:flutter_project_template/features/chat/data/converters/message_converter.dart';
import 'package:flutter_project_template/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:flutter_project_template/features/chat/domain/entities/message.dart';
import 'package:flutter_project_template/features/chat/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';

/// 聊天仓库实现。
///
/// 使用 [ChatLocalDataSource] 进行数据持久化操作。
/// 通过 [MessageConverter] 在数据库 DTO 和领域模型之间转换。
@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  /// 创建聊天仓库实现。
  ChatRepositoryImpl(this._localDataSource);

  final ChatLocalDataSource _localDataSource;

  @override
  Future<List<Conversation>> getConversations() async {
    final dbConversations = await _localDataSource.getAllConversations();
    return dbConversations
        .map((c) => Conversation(
              id: c.id,
              title: c.title,
              lastMessage: c.lastMessage,
              updatedAt: c.updatedAt,
              unreadCount: c.unreadCount,
              type: 'ai', // 默认类型
              aiModelId: c.aiModelId,
              totalTokens: c.totalTokens,
            ))
        .toList();
  }

  @override
  Stream<List<Conversation>> watchConversations() {
    return _localDataSource.watchAllConversations().map((dbConversations) {
      return dbConversations
          .map((c) => Conversation(
                id: c.id,
                title: c.title,
                lastMessage: c.lastMessage,
                updatedAt: c.updatedAt,
                unreadCount: c.unreadCount,
                type: 'ai',
                aiModelId: c.aiModelId,
                totalTokens: c.totalTokens,
              ))
          .toList();
    });
  }

  @override
  Future<Conversation?> getConversation(String id) async {
    final dbConversation = await _localDataSource.getConversationById(id);
    if (dbConversation == null) return null;

    return Conversation(
      id: dbConversation.id,
      title: dbConversation.title,
      lastMessage: dbConversation.lastMessage,
      updatedAt: dbConversation.updatedAt,
      unreadCount: dbConversation.unreadCount,
      type: 'ai',
      aiModelId: dbConversation.aiModelId,
      totalTokens: dbConversation.totalTokens,
    );
  }

  @override
  Stream<Conversation?> watchConversation(String id) {
    return _localDataSource.watchConversationById(id).map((dbConversation) {
      if (dbConversation == null) return null;
      return Conversation(
        id: dbConversation.id,
        title: dbConversation.title,
        lastMessage: dbConversation.lastMessage,
        updatedAt: dbConversation.updatedAt,
        unreadCount: dbConversation.unreadCount,
        type: 'ai',
        aiModelId: dbConversation.aiModelId,
        totalTokens: dbConversation.totalTokens,
      );
    });
  }

  @override
  Future<Conversation> createConversation({
    required String title,
    String type = 'ai',
    String? aiModelId,
  }) async {
    final now = DateTime.now();
    final id = now.millisecondsSinceEpoch.toString();

    await _localDataSource.upsertConversation(
      ChatConversationsCompanion(
        id: Value(id),
        title: Value(title),
        lastMessage: const Value(null),
        unreadCount: const Value(0),
        totalTokens: const Value(0),
        updatedAt: Value(now),
        aiModelId: Value(aiModelId),
      ),
    );

    return Conversation(
      id: id,
      title: title,
      updatedAt: now,
      type: type,
      aiModelId: aiModelId,
      createdAt: now,
    );
  }

  @override
  Future<void> updateConversation(Conversation conversation) async {
    await _localDataSource.upsertConversation(
      ChatConversationsCompanion(
        id: Value(conversation.id),
        title: Value(conversation.title),
        lastMessage: Value(conversation.lastMessage),
        unreadCount: Value(conversation.unreadCount),
        totalTokens: Value(conversation.totalTokens),
        updatedAt: Value(conversation.updatedAt),
        aiModelId: Value(conversation.aiModelId),
      ),
    );
  }

  @override
  Future<void> deleteConversation(String id) async {
    await _localDataSource.deleteConversation(id);
  }

  @override
  Future<List<Message>> getMessages(String conversationId) async {
    final dbMessages = await _localDataSource.getMessagesByConversationId(conversationId);
    return MessageConverter.fromDtoList(dbMessages);
  }

  @override
  Stream<List<Message>> watchMessages(String conversationId) {
    return _localDataSource.watchMessagesByConversationId(conversationId).map(
          (dbMessages) => MessageConverter.fromDtoList(dbMessages),
        );
  }

  @override
  Future<Message> addMessage(Message message) async {
    final companion = MessageConverter.toCompanion(message);
    await _localDataSource.insertMessage(companion);

    // 更新会话的最后消息
    final text = message.text ?? '';
    await _localDataSource.upsertConversation(
      ChatConversationsCompanion(
        id: Value(message.conversationId),
        lastMessage: Value(text),
        updatedAt: Value(message.timestamp),
      ),
    );

    return message;
  }

  @override
  Future<void> updateMessage(Message message) async {
    if (message is TextMessage) {
      await _localDataSource.updateMessageContent(message.id, message.content);
    }
    await _localDataSource.updateMessageStatus(message.id, message.status.index);
  }

  @override
  Future<void> updateMessageStatus(String id, MessageStatus status) async {
    await _localDataSource.updateMessageStatus(id, status.index);
  }

  @override
  Future<void> deleteMessage(String id) async {
    await _localDataSource.deleteMessage(id);
  }

  @override
  Future<void> updateConversationLastMessage(
    String conversationId, {
    required String lastMessage,
    required DateTime updatedAt,
    int? tokenCount,
  }) async {
    final conversation = await _localDataSource.getConversationById(conversationId);
    if (conversation == null) return;

    await _localDataSource.upsertConversation(
      ChatConversationsCompanion(
        id: Value(conversationId),
        lastMessage: Value(lastMessage),
        updatedAt: Value(updatedAt),
        totalTokens: tokenCount != null
            ? Value(conversation.totalTokens + tokenCount)
            : Value(conversation.totalTokens),
      ),
    );
  }
}