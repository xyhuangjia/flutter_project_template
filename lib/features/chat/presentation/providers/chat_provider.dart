/// Chat provider using Riverpod code generation.
library;

import 'dart:async';

import 'package:flutter_project_template/features/chat/domain/entities/chat_message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_provider.g.dart';

/// Provider for managing chat conversations.
@riverpod
class ChatNotifier extends _$ChatNotifier {
  @override
  Future<List<ChatConversation>> build() async {
    // Simulate loading delay
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _getMockConversations();
  }

  /// Creates a new conversation.
  Future<String> createConversation(String title) async {
    final currentConversations = state.valueOrNull ?? [];
    final now = DateTime.now();
    final newConversation = ChatConversation(
      id: now.millisecondsSinceEpoch.toString(),
      title: title,
      lastMessage: 'New conversation started',
      updatedAt: now,
    );

    state = AsyncValue.data([newConversation, ...currentConversations]);
    return newConversation.id;
  }

  /// Sends a message and gets an AI response.
  Future<void> sendMessage(String conversationId, String content) async {
    final conversations = state.valueOrNull ?? [];
    final conversationIndex =
        conversations.indexWhere((c) => c.id == conversationId);

    if (conversationIndex == -1) return;

    final conversation = conversations[conversationIndex];
    final now = DateTime.now();

    // Create user message
    final userMessage = ChatMessage(
      id: now.millisecondsSinceEpoch.toString(),
      content: content,
      sender: MessageSender.user,
      timestamp: now,
      status: MessageStatus.sending,
    );

    // Update with user message
    var updatedMessages = [...conversation.messages, userMessage];
    var updatedConversation = conversation.copyWith(
      messages: updatedMessages,
      lastMessage: content,
      updatedAt: now,
    );

    var updatedConversations = List<ChatConversation>.from(conversations);
    updatedConversations[conversationIndex] = updatedConversation;
    state = AsyncValue.data(updatedConversations);

    // Simulate AI response delay
    await Future<void>.delayed(const Duration(seconds: 1));

    // Mark user message as sent
    updatedMessages = updatedMessages.map((m) {
      if (m.id == userMessage.id) {
        return m.copyWith(status: MessageStatus.sent);
      }
      return m;
    }).toList();

    final aiNow = DateTime.now();
    // Create AI response
    final aiResponse = ChatMessage(
      id: '${aiNow.millisecondsSinceEpoch}_ai',
      content: _generateAIResponse(content),
      sender: MessageSender.ai,
      timestamp: aiNow,
    );

    updatedMessages = [...updatedMessages, aiResponse];
    updatedConversation = updatedConversation.copyWith(
      messages: updatedMessages,
      lastMessage: aiResponse.content,
      updatedAt: aiNow,
    );

    updatedConversations = List<ChatConversation>.from(conversations);
    updatedConversations[conversationIndex] = updatedConversation;
    state = AsyncValue.data(updatedConversations);
  }

  /// Deletes a conversation.
  Future<void> deleteConversation(String conversationId) async {
    final conversations = state.valueOrNull ?? [];
    final updatedConversations =
        conversations.where((c) => c.id != conversationId).toList();
    state = AsyncValue.data(updatedConversations);
  }

  /// Gets a specific conversation by ID.
  ChatConversation? getConversation(String conversationId) {
    final conversations = state.valueOrNull ?? [];
    return conversations.where((c) => c.id == conversationId).firstOrNull;
  }

  String _generateAIResponse(String userMessage) {
    // Simple mock AI responses
    final responses = [
      "That's an interesting question! Let me think about it...",
      "I understand what you're asking. Here's my perspective...",
      "Great point! I'd be happy to help with that.",
      "Thanks for sharing that with me. Here's what I think...",
      "That's a thoughtful question. Let me provide some insights...",
    ];
    return responses[DateTime.now().second % responses.length];
  }

  List<ChatConversation> _getMockConversations() {
    final now = DateTime.now();
    return [
      ChatConversation(
        id: '1',
        title: 'Project Planning',
        lastMessage: 'I can help you create a timeline for that.',
        updatedAt: now.subtract(const Duration(minutes: 5)),
        unreadCount: 2,
        messages: [
          ChatMessage(
            id: '1',
            content: 'Hi! I need help planning my project.',
            sender: MessageSender.user,
            timestamp: now.subtract(const Duration(minutes: 10)),
          ),
          ChatMessage(
            id: '2',
            content: "Hello! I'd be happy to help you with project planning. "
                "What kind of project are you working on?",
            sender: MessageSender.ai,
            timestamp: now.subtract(const Duration(minutes: 9)),
          ),
          ChatMessage(
            id: '3',
            content: "I'm building a mobile app for task management.",
            sender: MessageSender.user,
            timestamp: now.subtract(const Duration(minutes: 8)),
          ),
          ChatMessage(
            id: '4',
            content: 'I can help you create a timeline for that.',
            sender: MessageSender.ai,
            timestamp: now.subtract(const Duration(minutes: 7)),
          ),
        ],
      ),
      ChatConversation(
        id: '2',
        title: 'Code Review',
        lastMessage: 'The code looks good, just a few suggestions...',
        updatedAt: now.subtract(const Duration(hours: 2)),
        messages: [
          ChatMessage(
            id: '5',
            content: 'Can you review my React code?',
            sender: MessageSender.user,
            timestamp: now.subtract(const Duration(hours: 2, minutes: 5)),
          ),
          ChatMessage(
            id: '6',
            content: 'The code looks good, just a few suggestions...',
            sender: MessageSender.ai,
            timestamp: now.subtract(const Duration(hours: 2)),
          ),
        ],
      ),
      ChatConversation(
        id: '3',
        title: 'Learning Python',
        lastMessage: 'Python is great for beginners! Start with...',
        updatedAt: now.subtract(const Duration(days: 1)),
        messages: [
          ChatMessage(
            id: '7',
            content: "What's the best way to learn Python?",
            sender: MessageSender.user,
            timestamp: now.subtract(const Duration(days: 1, minutes: 5)),
          ),
          ChatMessage(
            id: '8',
            content: 'Python is great for beginners! Start with...',
            sender: MessageSender.ai,
            timestamp: now.subtract(const Duration(days: 1)),
          ),
        ],
      ),
    ];
  }
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
