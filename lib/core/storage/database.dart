/// Database configuration using Drift.
///
/// This file defines the database schema and provides
/// database access methods.
library;

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

/// Users table definition.
///
/// Stores user profile information.
class Users extends Table {
  /// Unique identifier.
  TextColumn get id => text()();

  /// User's email address.
  TextColumn get email => text().withLength(min: 5, max: 254)();

  /// Display name.
  TextColumn get name => text().withLength(min: 1, max: 100)();

  /// Optional avatar URL.
  TextColumn get avatarUrl => text().nullable()();

  /// When the user account was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// When the user account was last updated.
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>>? get uniqueKeys => [
        {email},
      ];
}

/// Chat conversations table definition.
///
/// Stores conversation metadata.
class ChatConversations extends Table {
  /// Unique identifier.
  TextColumn get id => text()();

  /// Conversation title.
  TextColumn get title => text().withLength(min: 1, max: 200)();

  /// Preview of the last message.
  TextColumn get lastMessage => text().nullable()();

  /// Number of unread messages.
  IntColumn get unreadCount => integer().withDefault(const Constant(0))();

  /// Associated AI model ID (optional).
  TextColumn get aiModelId => text().nullable()();

  /// Total tokens used in this conversation.
  IntColumn get totalTokens => integer().withDefault(const Constant(0))();

  /// When the conversation was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// When the conversation was last updated.
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Chat messages table definition.
///
/// Stores individual messages within conversations.
/// Supports multiple message types (text, image, etc.).
class ChatMessages extends Table {
  /// Unique identifier.
  TextColumn get id => text()();

  /// Associated conversation ID.
  TextColumn get conversationId => text()();

  /// Message content (text or JSON for complex types).
  TextColumn get content => text()();

  /// Message sender: 0 = user, 1 = ai.
  IntColumn get sender => integer()();

  /// Message status: 0 = sending, 1 = sent, 2 = read, 3 = error.
  IntColumn get status => integer().withDefault(const Constant(1))();

  /// Tokens used for this message (AI responses only).
  IntColumn get tokens => integer().nullable()();

  /// When the message was created.
  DateTimeColumn get timestamp => dateTime()();

  /// Message type: 0 = text, 1 = image.
  /// Defaults to 0 (text) for backward compatibility.
  IntColumn get messageType => integer().withDefault(const Constant(0))();

  /// Image URL for image messages (JSON array for multiple images).
  TextColumn get imageUrl => text().nullable()();

  /// Thumbnail URL for image messages (JSON array for multiple thumbnails).
  TextColumn get thumbnailUrl => text().nullable()();

  /// Caption for image messages.
  TextColumn get caption => text().nullable()();

  /// Additional metadata as JSON.
  TextColumn get metadata => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  /// Foreign key reference to conversations table.
  /// Note: In Drift, use column.references() for proper foreign key support.
  // ignore: unnecessary_getters_override
  List<Set<Column>> get foreignKeys => [
        {conversationId},
      ];
}

/// AI configurations table definition.
///
/// Stores AI model configurations and API keys.
class AIConfigs extends Table {
  /// Unique identifier.
  TextColumn get id => text()();

  /// Display name for this configuration.
  TextColumn get name => text().withLength(min: 1, max: 100)();

  /// AI provider: 'openai', 'claude', or 'custom'.
  TextColumn get provider => text()();

  /// Model identifiers as JSON array (e.g., '["gpt-4o", "gpt-4o-mini"]').
  TextColumn get models => text()();

  /// Default model identifier.
  TextColumn get defaultModel => text()();

  /// Encrypted API key.
  TextColumn get apiKeyEncrypted => text()();

  /// Whether this is the default configuration.
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  /// Custom API endpoint URL (for custom providers).
  TextColumn get baseUrl => text().nullable()();

  /// API format type: 'openai' or 'claude' (for custom providers).
  TextColumn get apiFormat => text().withDefault(const Constant('openai'))();

  /// Additional configuration as JSON.
  TextColumn get configJson => text().nullable()();

  /// When the configuration was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// When the configuration was last updated.
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Application database.
///
/// Defines all tables and provides database access methods.
/// Registered as a lazy singleton in GetIt for dependency injection.
@DriftDatabase(tables: [Users, ChatConversations, ChatMessages, AIConfigs])
@lazySingleton
class AppDatabase extends _$AppDatabase {
  /// Creates the application database.
  AppDatabase() : super(_openConnection());

  /// Creates the application database with a specified executor.
  AppDatabase.connect(super.connection) : super();

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // Add chat tables for schema version 2
            await m.createTable(chatConversations);
            await m.createTable(chatMessages);
            await m.createTable(aIConfigs);
            // Fresh install with new schema, no data migration needed for v4
          }
          if (from >= 2 && from < 3) {
            // Add baseUrl and apiFormat columns for custom providers
            await m.addColumn(aIConfigs, aIConfigs.baseUrl);
            await m.addColumn(aIConfigs, aIConfigs.apiFormat);
          }
          if (from >= 2 && from < 4) {
            // Migrate from single model to multiple models
            // Add new columns first
            await m.addColumn(aIConfigs, aIConfigs.models);
            await m.addColumn(aIConfigs, aIConfigs.defaultModel);

            // Migrate existing data using custom SQL
            // Only run if the old 'model' column exists
            try {
              await customStatement('''
                UPDATE aI_configs
                SET models = '["' || model || '"]',
                    defaultModel = model
                WHERE models IS NULL OR models = ''
              ''');
            } catch (_) {
              // Column 'model' doesn't exist, skip migration
            }
          }
          if (from >= 2 && from < 5) {
            // Add multi-type message support columns
            await m.addColumn(chatMessages, chatMessages.messageType);
            await m.addColumn(chatMessages, chatMessages.imageUrl);
            await m.addColumn(chatMessages, chatMessages.thumbnailUrl);
            await m.addColumn(chatMessages, chatMessages.caption);
            await m.addColumn(chatMessages, chatMessages.metadata);
          }
        },
        beforeOpen: (details) async =>
            customStatement('PRAGMA foreign_keys = ON'),
      );

  // ==================== Users ====================

  /// Fetches all users.
  Future<List<User>> getAllUsers() => select(users).get();

  /// Fetches a user by ID.
  Future<User?> getUserById(String id) =>
      (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();

  /// Fetches a user by email.
  Future<User?> getUserByEmail(String email) =>
      (select(users)..where((u) => u.email.equals(email))).getSingleOrNull();

  /// Watches users for changes.
  Stream<List<User>> watchAllUsers() => select(users).watch();

  /// Inserts or updates a user.
  Future<void> upsertUser(UsersCompanion user) =>
      into(users).insertOnConflictUpdate(user);

  /// Deletes a user by ID.
  Future<int> deleteUser(String id) =>
      (delete(users)..where((u) => u.id.equals(id))).go();

  /// Clears all users.
  Future<int> clearAllUsers() => delete(users).go();

  // ==================== Chat Conversations ====================

  /// Fetches all conversations ordered by updatedAt desc.
  Future<List<ChatConversation>> getAllConversations() =>
      (select(chatConversations)
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
          .get();

  /// Watches all conversations for changes.
  Stream<List<ChatConversation>> watchAllConversations() =>
      (select(chatConversations)
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
          .watch();

  /// Fetches a conversation by ID.
  Future<ChatConversation?> getConversationById(String id) =>
      (select(chatConversations)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  /// Watches a single conversation for changes.
  Stream<ChatConversation?> watchConversationById(String id) =>
      (select(chatConversations)..where((t) => t.id.equals(id)))
          .watchSingleOrNull();

  /// Inserts or updates a conversation.
  Future<void> upsertConversation(ChatConversationsCompanion conversation) =>
      into(chatConversations).insertOnConflictUpdate(conversation);

  /// Deletes a conversation and its messages.
  Future<void> deleteConversation(String id) async {
    // Delete messages first
    await (delete(chatMessages)..where((t) => t.conversationId.equals(id)))
        .go();
    // Then delete conversation
    await (delete(chatConversations)..where((t) => t.id.equals(id))).go();
  }

  /// Updates conversation's last message and timestamp.
  Future<void> updateConversationLastMessage(
    String id, {
    required String lastMessage,
    required DateTime updatedAt,
    int? tokenCount,
  }) async {
    final conversation = await getConversationById(id);
    if (conversation == null) return;

    await (update(chatConversations)..where((t) => t.id.equals(id))).write(
      ChatConversationsCompanion(
        lastMessage: Value(lastMessage),
        updatedAt: Value(updatedAt),
        totalTokens: tokenCount != null
            ? Value(conversation.totalTokens + tokenCount)
            : Value(conversation.totalTokens),
      ),
    );
  }

  /// Updates conversation title.
  Future<void> updateConversationTitle(String id, String title) async {
    await (update(chatConversations)..where((t) => t.id.equals(id))).write(
      ChatConversationsCompanion(title: Value(title)),
    );
  }

  // ==================== Chat Messages ====================

  /// Fetches all messages for a conversation.
  Future<List<ChatMessage>> getMessagesByConversationId(
          String conversationId) =>
      (select(chatMessages)
            ..where((t) => t.conversationId.equals(conversationId))
            ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
          .get();

  /// Watches messages for a conversation.
  Stream<List<ChatMessage>> watchMessagesByConversationId(
    String conversationId,
  ) =>
      (select(chatMessages)
            ..where((t) => t.conversationId.equals(conversationId))
            ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
          .watch();

  /// Fetches a message by ID.
  Future<ChatMessage?> getMessageById(String id) =>
      (select(chatMessages)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Inserts a new message.
  Future<void> insertMessage(ChatMessagesCompanion message) =>
      into(chatMessages).insert(message);

  /// Inserts or updates a message.
  Future<void> upsertMessage(ChatMessagesCompanion message) =>
      into(chatMessages).insertOnConflictUpdate(message);

  /// Updates a message's content.
  Future<void> updateMessageContent(String id, String content) async {
    await (update(chatMessages)..where((t) => t.id.equals(id)))
        .write(ChatMessagesCompanion(content: Value(content)));
  }

  /// Updates a message's status.
  Future<void> updateMessageStatus(String id, int status) async {
    await (update(chatMessages)..where((t) => t.id.equals(id)))
        .write(ChatMessagesCompanion(status: Value(status)));
  }

  /// Fetches messages by type for a conversation.
  ///
  /// - [messageType]: 0 = text, 1 = image.
  Future<List<ChatMessage>> getMessagesByType(
    String conversationId,
    int messageType,
  ) =>
      (select(chatMessages)
            ..where((t) =>
                t.conversationId.equals(conversationId) &
                t.messageType.equals(messageType))
            ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
          .get();

  /// Counts messages by type for a conversation.
  Future<int> countMessagesByType(String conversationId, int messageType) async {
    final count = chatMessages.id.count();
    final query = selectOnly(chatMessages)
      ..where(chatMessages.conversationId.equals(conversationId) &
          chatMessages.messageType.equals(messageType))
      ..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Deletes a message.
  Future<int> deleteMessage(String id) =>
      (delete(chatMessages)..where((t) => t.id.equals(id))).go();

  /// Deletes all messages for a conversation.
  Future<int> deleteMessagesByConversationId(String conversationId) =>
      (delete(chatMessages)
            ..where((t) => t.conversationId.equals(conversationId)))
          .go();

  // ==================== AI Configs ====================

  /// Fetches all AI configurations.
  Future<List<AIConfig>> getAllAIConfigs() => select(aIConfigs).get();

  /// Fetches the default AI configuration.
  Future<AIConfig?> getDefaultAIConfig() =>
      (select(aIConfigs)..where((t) => t.isDefault.equals(true)))
          .getSingleOrNull();

  /// Fetches an AI configuration by ID.
  Future<AIConfig?> getAIConfigById(String id) =>
      (select(aIConfigs)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Inserts or updates an AI configuration.
  Future<void> upsertAIConfig(AIConfigsCompanion config) =>
      into(aIConfigs).insertOnConflictUpdate(config);

  /// Sets an AI configuration as default (unsets others).
  Future<void> setDefaultAIConfig(String id) async {
    // Unset all defaults first
    await (update(aIConfigs)..where((t) => t.isDefault.equals(true)))
        .write(const AIConfigsCompanion(isDefault: Value(false)));
    // Set the specified one as default
    await (update(aIConfigs)..where((t) => t.id.equals(id)))
        .write(const AIConfigsCompanion(isDefault: Value(true)));
  }

  /// Deletes an AI configuration.
  Future<int> deleteAIConfig(String id) =>
      (delete(aIConfigs)..where((t) => t.id.equals(id))).go();
}

/// Opens the database connection.
LazyDatabase _openConnection() => LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'app.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
