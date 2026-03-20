/// AI service abstraction for chat functionality.
///
/// Defines the contract for AI chat services that can be
/// implemented by different providers (OpenAI, Claude, etc.).
library;

import 'dart:async';

/// Message structure for AI API requests.
class AIMessage {
  /// Creates an AI message.
  const AIMessage({
    required this.role,
    required this.content,
  });

  /// Message role: 'user', 'assistant', or 'system'.
  final String role;

  /// Message content.
  final String content;

  /// Converts to API request format.
  Map<String, dynamic> toJson() => {
        'role': role,
        'content': content,
      };
}

/// AI configuration for API requests.
class AIRequestConfig {
  /// Creates an AI request config.
  const AIRequestConfig({
    required this.model,
    required this.apiKey,
    this.maxTokens = 4096,
    this.temperature = 0.7,
    this.systemPrompt,
  });

  /// Model identifier.
  final String model;

  /// API key for authentication.
  final String apiKey;

  /// Maximum tokens in response.
  final int maxTokens;

  /// Response randomness (0-2).
  final double temperature;

  /// Optional system prompt.
  final String? systemPrompt;
}

/// Streaming chunk from AI API.
class AIStreamChunk {
  /// Creates a stream chunk.
  const AIStreamChunk({
    required this.content,
    this.isDone = false,
    this.error,
    this.totalTokens,
  });

  /// Content delta.
  final String content;

  /// Whether this is the final chunk.
  final bool isDone;

  /// Error message if any.
  final String? error;

  /// Total tokens used (in final chunk).
  final int? totalTokens;
}

/// Abstract AI service interface.
///
/// Implement this interface to add support for different AI providers.
abstract class AIService {
  /// Service provider name.
  String get providerName;

  /// Available models for this provider.
  List<String> get availableModels;

  /// Sends a message and returns the complete response.
  Future<String> sendMessage({
    required AIRequestConfig config,
    required List<AIMessage> messages,
  });

  /// Sends a message and streams the response.
  Stream<AIStreamChunk> streamMessage({
    required AIRequestConfig config,
    required List<AIMessage> messages,
  });

  /// Validates the API key.
  Future<bool> validateApiKey(String apiKey);

  /// Disposes any resources.
  void dispose();
}
