/// Chat provider using Riverpod code generation.
///
/// Manages chat conversations and messages with real AI integration.
library;

import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_project_template/core/storage/database.dart'
    hide ChatConversation;
import 'package:flutter_project_template/features/chat/data/services/ai_service.dart';
import 'package:flutter_project_template/features/chat/data/services/claude_service.dart';
import 'package:flutter_project_template/features/chat/data/services/openai_service.dart';
import 'package:flutter_project_template/features/chat/data/services/universal_ai_service.dart';
import 'package:flutter_project_template/features/chat/domain/entities/chat_message.dart'
    as domain;
import 'package:flutter_project_template/features/chat/presentation/providers/ai_config_provider.dart';
import 'package:flutter_project_template/features/chat/presentation/providers/chat_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_provider.g.dart';

/// Provider for AI services registry.
@riverpod
Map<String, AIService> aiServices(Ref ref) {
  final services = <String, AIService>{
    'openai': OpenAIService(),
    'claude': ClaudeService(),
  };

  ref.onDispose(() {
    for (final service in services.values) {
      service.dispose();
    }
  });

  return services;
}

/// Chat state containing conversations and messages.
class ChatState {
  /// Creates a chat state.
  const ChatState({
    this.conversations = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery,
  });

  /// All conversations.
  final List<domain.ChatConversation> conversations;

  /// Loading state.
  final bool isLoading;

  /// Error message.
  final String? error;

  /// Current search query.
  final String? searchQuery;

  /// Filtered conversations based on search query.
  List<domain.ChatConversation> get filteredConversations {
    if (searchQuery == null || searchQuery!.isEmpty) {
      return conversations;
    }
    final query = searchQuery!.toLowerCase();
    return conversations
        .where((c) =>
            c.title.toLowerCase().contains(query) ||
            c.lastMessage.toLowerCase().contains(query))
        .toList();
  }

  /// Creates a copy with updated fields.
  ChatState copyWith({
    List<domain.ChatConversation>? conversations,
    bool? isLoading,
    String? error,
    String? searchQuery,
    bool clearError = false,
    bool clearSearchQuery = false,
  }) {
    return ChatState(
      conversations: conversations ?? this.conversations,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
    );
  }
}

/// Provider for managing chat conversations.
@riverpod
class ChatNotifier extends _$ChatNotifier {
  @override
  Future<ChatState> build() async {
    final localDataSource = ref.read(chatLocalDataSourceProvider);
    final conversations = await localDataSource.getAllConversations();

    // Load messages for each conversation
    final conversationsWithMessages = await Future.wait(
      conversations.map((c) async {
        final messages =
            await localDataSource.getMessagesByConversationId(c.id);
        return domain.ChatConversation(
          id: c.id,
          title: c.title,
          lastMessage: c.lastMessage ?? '',
          updatedAt: c.updatedAt,
          unreadCount: c.unreadCount,
          messages: _convertMessages(messages),
        );
      }),
    );

    return ChatState(conversations: conversationsWithMessages);
  }

  /// Creates a new conversation.
  Future<String> createConversation(String title) async {
    final localDataSource = ref.read(chatLocalDataSourceProvider);
    final now = DateTime.now();
    final id = now.millisecondsSinceEpoch.toString();

    await localDataSource.upsertConversation(
      ChatConversationsCompanion(
        id: Value(id),
        title: Value(title),
        lastMessage: const Value(null),
        unreadCount: const Value(0),
        totalTokens: const Value(0),
        updatedAt: Value(now),
      ),
    );

    // Refresh state
    ref.invalidateSelf();

    return id;
  }

  /// Updates a conversation's title.
  Future<void> renameConversation(String id, String newTitle) async {
    final localDataSource = ref.read(chatLocalDataSourceProvider);
    await localDataSource.updateConversationTitle(id, newTitle);

    // Update local state
    final currentState = state.value;
    if (currentState != null) {
      final updated = currentState.conversations.map((c) {
        if (c.id == id) {
          return domain.ChatConversation(
            id: c.id,
            title: newTitle,
            lastMessage: c.lastMessage,
            updatedAt: c.updatedAt,
            unreadCount: c.unreadCount,
            messages: c.messages,
          );
        }
        return c;
      }).toList();

      state = AsyncValue.data(currentState.copyWith(conversations: updated));
    }
  }

  /// Deletes a conversation.
  Future<void> deleteConversation(String conversationId) async {
    final localDataSource = ref.read(chatLocalDataSourceProvider);
    await localDataSource.deleteConversation(conversationId);

    // Update local state
    final currentState = state.value;
    if (currentState != null) {
      final updated = currentState.conversations
          .where((c) => c.id != conversationId)
          .toList();
      state = AsyncValue.data(currentState.copyWith(conversations: updated));
    }
  }

  /// Deletes a message.
  Future<void> deleteMessage(String messageId) async {
    final localDataSource = ref.read(chatLocalDataSourceProvider);
    await localDataSource.deleteMessage(messageId);

    // Refresh state
    ref.invalidateSelf();
  }

  /// Sends a message and streams AI response.
  Stream<ChatMessageEvent> sendMessageStream(
    String conversationId,
    String content, {
    String? selectedModel,
  }) async* {
    final localDataSource = ref.read(chatLocalDataSourceProvider);
    final now = DateTime.now();

    // Create user message
    final userMessageId = '${now.millisecondsSinceEpoch}_user';
    await localDataSource.insertMessage(
      ChatMessagesCompanion(
        id: Value(userMessageId),
        conversationId: Value(conversationId),
        content: Value(content),
        sender: const Value(0),
        status: const Value(1),
        timestamp: Value(now),
      ),
    );

    // Update conversation
    await localDataSource.upsertConversation(
      ChatConversationsCompanion(
        id: Value(conversationId),
        lastMessage: Value(content),
        updatedAt: Value(now),
      ),
    );

    // Yield user message event
    yield ChatUserMessageCreated(
      domain.ChatMessage(
        id: userMessageId,
        content: content,
        sender: domain.MessageSender.user,
        timestamp: now,
        status: domain.MessageStatus.sent,
      ),
    );

    // Get AI config
    final aiConfigState = ref.read(aIConfigProvider).value;
    final aiConfigEntity = aiConfigState?.defaultConfig;
    if (aiConfigEntity == null) {
      yield ChatAIResponseError(
          'No AI configuration found. Please configure an AI model in settings.');
      return;
    }

    // Determine which model to use
    final modelToUse = selectedModel ?? aiConfigEntity.currentModel;
    if (modelToUse.isEmpty) {
      yield ChatAIResponseError('No model available for this configuration.');
      return;
    }

    // Get secure storage for API key
    final secureStorage = ref.read(secureStorageProvider);
    final apiKey =
        await secureStorage.read(key: 'ai_api_key_${aiConfigEntity.id}');
    if (apiKey == null) {
      yield ChatAIResponseError(
          'API key not found. Please reconfigure the AI model.');
      return;
    }

    // Get conversation history
    final dbMessages =
        await localDataSource.getMessagesByConversationId(conversationId);
    final aiMessages = dbMessages.map((m) {
      return AIMessage(
        role: m.sender == 0 ? 'user' : 'assistant',
        content: m.content,
      );
    }).toList();

    // Create AI message placeholder
    final aiMessageId = '${DateTime.now().millisecondsSinceEpoch}_ai';
    await localDataSource.insertMessage(
      ChatMessagesCompanion(
        id: Value(aiMessageId),
        conversationId: Value(conversationId),
        content: const Value(''),
        sender: const Value(1),
        status: const Value(0),
        timestamp: Value(DateTime.now()),
      ),
    );

    // Get AI service
    AIService? service;
    if (aiConfigEntity.provider == 'custom') {
      // Create dynamic service for custom provider
      if (aiConfigEntity.baseUrl == null) {
        yield ChatAIResponseError('Custom provider missing base URL');
        return;
      }
      service = UniversalAIService(
        baseUrl: aiConfigEntity.baseUrl!,
        apiFormat: aiConfigEntity.apiFormat == 'claude'
            ? APIFormat.claude
            : APIFormat.openai,
      );
    } else {
      final services = ref.read(aiServicesProvider);
      service = services[aiConfigEntity.provider];
    }

    if (service == null) {
      yield ChatAIResponseError(
          'Unknown AI provider: ${aiConfigEntity.provider}');
      return;
    }

    // Stream AI response
    var fullContent = '';

    try {
      final stream = service.streamMessage(
        config: AIRequestConfig(
          model: modelToUse,
          apiKey: apiKey,
        ),
        messages: aiMessages,
      );

      await for (final chunk in stream) {
        if (chunk.error != null) {
          yield ChatAIResponseError(chunk.error!);
          return;
        }

        fullContent += chunk.content;

        // Update message in database
        await localDataSource.updateMessageContent(aiMessageId, fullContent);

        yield ChatAIResponseChunk(
          messageId: aiMessageId,
          content: chunk.content,
          isDone: chunk.isDone,
        );

        if (chunk.isDone) {
          // Mark as sent
          await localDataSource.updateMessageStatus(aiMessageId, 1);

          // Update conversation
          await localDataSource.upsertConversation(
            ChatConversationsCompanion(
              id: Value(conversationId),
              lastMessage: Value(fullContent),
              updatedAt: Value(DateTime.now()),
            ),
          );
        }
      }
    } catch (e) {
      await localDataSource.updateMessageStatus(aiMessageId, 3);
      yield ChatAIResponseError(e.toString());
    } finally {
      // Dispose custom service if created
      if (aiConfigEntity.provider == 'custom') {
        service.dispose();
      }
    }

    // Refresh conversations
    ref.invalidateSelf();
  }

  /// Sends a message (non-streaming, for backward compatibility).
  Future<void> sendMessage(String conversationId, String content) async {
    // Just consume the stream
    await sendMessageStream(conversationId, content).drain<dynamic>();
  }

  /// Searches conversations.
  void search(String? query) {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(
      currentState.copyWith(
        searchQuery: query,
        clearSearchQuery: query == null || query.isEmpty,
      ),
    );
  }

  /// Clears search.
  void clearSearch() => search(null);

  /// Gets a specific conversation by ID.
  domain.ChatConversation? getConversation(String conversationId) {
    final currentState = state.value;
    if (currentState == null) return null;

    return currentState.conversations
        .where((c) => c.id == conversationId)
        .firstOrNull;
  }

  /// Exports a conversation as markdown.
  Future<String> exportConversation(String conversationId) async {
    final localDataSource = ref.read(chatLocalDataSourceProvider);
    final conversation =
        await localDataSource.getConversationById(conversationId);
    if (conversation == null) {
      throw StateError('Conversation not found');
    }

    final messages =
        await localDataSource.getMessagesByConversationId(conversationId);
    final buffer = StringBuffer();

    buffer.writeln('# ${conversation.title}');
    buffer.writeln();
    buffer.writeln('Exported: ${DateTime.now().toIso8601String()}');
    buffer.writeln();
    buffer.writeln('---');
    buffer.writeln();

    for (final msg in messages) {
      final sender = msg.sender == 0 ? 'You' : 'AI';
      buffer.writeln('### $sender');
      buffer.writeln();
      buffer.writeln(msg.content);
      buffer.writeln();
    }

    return buffer.toString();
  }

  List<domain.ChatMessage> _convertMessages(List<ChatMessage> dbMessages) {
    return dbMessages.map((m) {
      return domain.ChatMessage(
        id: m.id,
        content: m.content,
        sender:
            m.sender == 0 ? domain.MessageSender.user : domain.MessageSender.ai,
        timestamp: m.timestamp,
        status: domain.MessageStatus.values[m.status.clamp(0, 3)],
      );
    }).toList();
  }
}

/// Stream event types for chat messages.
sealed class ChatMessageEvent {}

/// User message created event.
class ChatUserMessageCreated extends ChatMessageEvent {
  /// Creates a user message created event.
  ChatUserMessageCreated(this.message);

  /// The created message.
  final domain.ChatMessage message;
}

/// AI response chunk event.
class ChatAIResponseChunk extends ChatMessageEvent {
  /// Creates an AI response chunk event.
  ChatAIResponseChunk({
    required this.messageId,
    required this.content,
    this.isDone = false,
  });

  /// The AI message ID.
  final String messageId;

  /// Content delta.
  final String content;

  /// Whether this is the final chunk.
  final bool isDone;
}

/// Stream error event.
class ChatAIResponseError extends ChatMessageEvent {
  /// Creates a stream error event.
  ChatAIResponseError(this.message);

  /// Error message.
  final String message;
}

/// Provider for checking if AI is typing.
@riverpod
class IsTyping extends _$IsTyping {
  @override
  bool build() => false;

  /// Sets the typing state.
  // ignore: use_setters_to_change_properties, avoid_positional_boolean_parameters
  void setTyping(bool value) => state = value;
}

/// Provider for streaming message content.
@riverpod
class StreamingMessage extends _$StreamingMessage {
  @override
  String build(String messageId) => '';
}

/// Provider for messages of a specific conversation.
@riverpod
Stream<List<domain.ChatMessage>> conversationMessages(
  Ref ref,
  String conversationId,
) {
  final localDataSource = ref.watch(chatLocalDataSourceProvider);
  return localDataSource.watchMessagesByConversationId(conversationId).map(
        (messages) => messages
            .map((m) => domain.ChatMessage(
                  id: m.id,
                  content: m.content,
                  sender: m.sender == 0
                      ? domain.MessageSender.user
                      : domain.MessageSender.ai,
                  timestamp: m.timestamp,
                  status: domain.MessageStatus.values[m.status.clamp(0, 3)],
                ))
            .toList(),
      );
}

/// Provider for selected model in a conversation.
@riverpod
class SelectedModel extends _$SelectedModel {
  @override
  String? build(String conversationId) => null;

  /// Sets the selected model for the conversation.
  void setModel(String? modelId) => state = modelId;
}
