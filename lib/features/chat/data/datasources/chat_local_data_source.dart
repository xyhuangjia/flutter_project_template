/// Chat local data source for database operations.
///
/// Provides CRUD operations for chat conversations and messages
/// using the Drift database.
library;

import 'package:flutter_project_template/core/storage/database.dart';
import 'package:injectable/injectable.dart';

/// Abstract chat local data source.
///
/// Defines the contract for local data operations.
abstract class ChatLocalDataSource {
  /// Fetches all conversations.
  Future<List<ChatConversation>> getAllConversations();

  /// Watches all conversations for changes.
  Stream<List<ChatConversation>> watchAllConversations();

  /// Fetches a conversation by ID.
  Future<ChatConversation?> getConversationById(String id);

  /// Watches a single conversation for changes.
  Stream<ChatConversation?> watchConversationById(String id);

  /// Creates or updates a conversation.
  Future<void> upsertConversation(ChatConversationsCompanion conversation);

  /// Deletes a conversation and its messages.
  Future<void> deleteConversation(String id);

  /// Updates conversation title.
  Future<void> updateConversationTitle(String id, String title);

  /// Fetches all messages for a conversation.
  Future<List<ChatMessage>> getMessagesByConversationId(String conversationId);

  /// Watches messages for a conversation.
  Stream<List<ChatMessage>> watchMessagesByConversationId(
      String conversationId);

  /// Creates a new message.
  Future<void> insertMessage(ChatMessagesCompanion message);

  /// Creates or updates a message.
  Future<void> upsertMessage(ChatMessagesCompanion message);

  /// Updates message content (for streaming).
  Future<void> updateMessageContent(String id, String content);

  /// Updates message status.
  Future<void> updateMessageStatus(String id, int status);

  /// Deletes a message.
  Future<void> deleteMessage(String id);

  /// Fetches all AI configurations.
  Future<List<AIConfig>> getAllAIConfigs();

  /// Fetches an AI configuration by ID.
  Future<AIConfig?> getAIConfigById(String id);

  /// Fetches the default AI configuration.
  Future<AIConfig?> getDefaultAIConfig();

  /// Creates or updates an AI configuration.
  Future<void> upsertAIConfig(AIConfigsCompanion config);

  /// Sets an AI configuration as default.
  Future<void> setDefaultAIConfig(String id);

  /// Deletes an AI configuration.
  Future<void> deleteAIConfig(String id);
}

/// Chat local data source implementation.
///
/// Implements local storage using Drift database.
/// Registered as a lazy singleton in GetIt.
@LazySingleton(as: ChatLocalDataSource)
class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  /// Creates a chat local data source.
  ChatLocalDataSourceImpl(this._database);

  final AppDatabase _database;

  @override
  Future<List<ChatConversation>> getAllConversations() =>
      _database.getAllConversations();

  @override
  Stream<List<ChatConversation>> watchAllConversations() =>
      _database.watchAllConversations();

  @override
  Future<ChatConversation?> getConversationById(String id) =>
      _database.getConversationById(id);

  @override
  Stream<ChatConversation?> watchConversationById(String id) =>
      _database.watchConversationById(id);

  @override
  Future<void> upsertConversation(ChatConversationsCompanion conversation) =>
      _database.upsertConversation(conversation);

  @override
  Future<void> deleteConversation(String id) =>
      _database.deleteConversation(id);

  @override
  Future<void> updateConversationTitle(String id, String title) =>
      _database.updateConversationTitle(id, title);

  @override
  Future<List<ChatMessage>> getMessagesByConversationId(
          String conversationId) =>
      _database.getMessagesByConversationId(conversationId);

  @override
  Stream<List<ChatMessage>> watchMessagesByConversationId(
    String conversationId,
  ) =>
      _database.watchMessagesByConversationId(conversationId);

  @override
  Future<void> insertMessage(ChatMessagesCompanion message) =>
      _database.insertMessage(message);

  @override
  Future<void> upsertMessage(ChatMessagesCompanion message) =>
      _database.upsertMessage(message);

  @override
  Future<void> updateMessageContent(String id, String content) =>
      _database.updateMessageContent(id, content);

  @override
  Future<void> updateMessageStatus(String id, int status) =>
      _database.updateMessageStatus(id, status);

  @override
  Future<void> deleteMessage(String id) => _database.deleteMessage(id);

  @override
  Future<List<AIConfig>> getAllAIConfigs() => _database.getAllAIConfigs();

  @override
  Future<AIConfig?> getAIConfigById(String id) => _database.getAIConfigById(id);

  @override
  Future<AIConfig?> getDefaultAIConfig() => _database.getDefaultAIConfig();

  @override
  Future<void> upsertAIConfig(AIConfigsCompanion config) =>
      _database.upsertAIConfig(config);

  @override
  Future<void> setDefaultAIConfig(String id) =>
      _database.setDefaultAIConfig(id);

  @override
  Future<void> deleteAIConfig(String id) => _database.deleteAIConfig(id);
}
