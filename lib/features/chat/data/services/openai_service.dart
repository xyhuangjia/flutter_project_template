/// OpenAI service implementation.
///
/// Provides integration with OpenAI's chat completion API
/// with streaming support.
library;

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_project_template/features/chat/data/services/ai_service.dart';

/// OpenAI API service implementation.
class OpenAIService implements AIService {
  /// Creates an OpenAI service.
  OpenAIService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;
  static const String _baseUrl = 'https://api.openai.com/v1';

  @override
  String get providerName => 'openai';

  @override
  List<String> get availableModels => [
        'gpt-4o',
        'gpt-4o-mini',
        'gpt-4-turbo',
        'gpt-4',
        'gpt-3.5-turbo',
      ];

  @override
  Future<String> sendMessage({
    required AIRequestConfig config,
    required List<AIMessage> messages,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_baseUrl/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${config.apiKey}',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'model': config.model,
          'messages': _buildMessages(messages, config.systemPrompt),
          'max_tokens': config.maxTokens,
          'temperature': config.temperature,
        },
      );

      final data = response.data;
      if (data == null) {
        throw const AIServiceException('Empty response from OpenAI');
      }

      final choices = data['choices'] as List<dynamic>?;
      if (choices == null || choices.isEmpty) {
        throw const AIServiceException('No choices in OpenAI response');
      }

      final message = choices[0]['message'] as Map<String, dynamic>?;
      final content = message?['content'] as String?;
      if (content == null) {
        throw const AIServiceException('No content in OpenAI response');
      }

      return content;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Stream<AIStreamChunk> streamMessage({
    required AIRequestConfig config,
    required List<AIMessage> messages,
  }) async* {
    try {
      final response = await _dio.post<ResponseBody>(
        '$_baseUrl/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${config.apiKey}',
            'Content-Type': 'application/json',
          },
          responseType: ResponseType.stream,
        ),
        data: {
          'model': config.model,
          'messages': _buildMessages(messages, config.systemPrompt),
          'max_tokens': config.maxTokens,
          'temperature': config.temperature,
          'stream': true,
        },
      );

      final stream = response.data?.stream;
      if (stream == null) {
        throw const AIServiceException('No stream in response');
      }

      await for (final chunk in stream) {
        final text = utf8.decode(chunk);
        final lines = text.split('\n');

        for (final line in lines) {
          if (!line.startsWith('data: ')) continue;

          final data = line.substring(6).trim();
          if (data == '[DONE]') {
            yield const AIStreamChunk(content: '', isDone: true);
            return;
          }

          try {
            final json = jsonDecode(data) as Map<String, dynamic>;
            final choices = json['choices'] as List<dynamic>?;
            if (choices == null || choices.isEmpty) continue;

            final delta = choices[0]['delta'] as Map<String, dynamic>?;
            final content = delta?['content'] as String?;
            if (content != null) {
              yield AIStreamChunk(content: content);
            }

            // Check for finish reason
            final finishReason = choices[0]['finish_reason'] as String?;
            if (finishReason == 'stop') {
              // Try to get usage info
              final usage = json['usage'] as Map<String, dynamic>?;
              final totalTokens = usage?['total_tokens'] as int?;
              yield AIStreamChunk(
                content: '',
                isDone: true,
                totalTokens: totalTokens,
              );
              return;
            }
          } on FormatException {
            // Skip invalid JSON
            continue;
          }
        }
      }
    } on DioException catch (e) {
      yield AIStreamChunk(
          content: '', isDone: true, error: _handleDioError(e).message,);
    }
  }

  @override
  Future<bool> validateApiKey(String apiKey) async {
    try {
      await _dio.get<List<dynamic>>(
        '$_baseUrl/models',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
          },
        ),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _dio.close();
  }

  List<Map<String, dynamic>> _buildMessages(
    List<AIMessage> messages,
    String? systemPrompt,
  ) {
    final result = <Map<String, dynamic>>[];

    if (systemPrompt != null && systemPrompt.isNotEmpty) {
      result.add({'role': 'system', 'content': systemPrompt});
    }

    for (final msg in messages) {
      result.add(msg.toJson());
    }

    return result;
  }

  AIServiceException _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = switch (statusCode) {
      401 => 'Invalid API key',
      429 => 'Rate limit exceeded. Please wait and try again.',
      500 || 502 || 503 => 'OpenAI service is temporarily unavailable',
      _ => e.message ?? 'Unknown error occurred',
    };
    return AIServiceException(message, statusCode: statusCode);
  }
}

/// Exception thrown by AI services.
class AIServiceException implements Exception {
  /// Creates an AI service exception.
  const AIServiceException(this.message, {this.statusCode});

  /// Error message.
  final String message;

  /// HTTP status code if applicable.
  final int? statusCode;

  @override
  String toString() => 'AIServiceException: $message';
}
