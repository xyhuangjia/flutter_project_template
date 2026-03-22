/// Universal AI service implementation for custom providers.
///
/// Supports OpenAI and Claude API formats with custom endpoints.
library;

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_project_template/features/chat/data/services/ai_service.dart';
import 'package:flutter_project_template/features/chat/data/services/openai_service.dart';

/// API format types for custom providers.
enum APIFormat {
  /// OpenAI-compatible API format.
  openai,

  /// Claude-compatible API format.
  claude,
}

/// Universal AI service for custom providers.
///
/// Supports both OpenAI and Claude API formats with custom baseUrl.
class UniversalAIService implements AIService {
  /// Creates a universal AI service.
  UniversalAIService({
    required this.baseUrl,
    required this.apiFormat,
    Dio? dio,
  }) : _dio = dio ?? Dio();

  /// The base URL for the API.
  final String baseUrl;

  /// The API format to use.
  final APIFormat apiFormat;

  final Dio _dio;

  static const String _claudeApiVersion = '2023-06-01';

  @override
  String get providerName => 'custom';

  @override
  List<String> get availableModels => [];

  @override
  Future<String> sendMessage({
    required AIRequestConfig config,
    required List<AIMessage> messages,
  }) async {
    switch (apiFormat) {
      case APIFormat.openai:
        return _sendOpenAIRequest(config, messages);
      case APIFormat.claude:
        return _sendClaudeRequest(config, messages);
    }
  }

  @override
  Stream<AIStreamChunk> streamMessage({
    required AIRequestConfig config,
    required List<AIMessage> messages,
  }) async* {
    switch (apiFormat) {
      case APIFormat.openai:
        yield* _streamOpenAIRequest(config, messages);
      case APIFormat.claude:
        yield* _streamClaudeRequest(config, messages);
    }
  }

  @override
  Future<bool> validateApiKey(String apiKey) async {
    try {
      switch (apiFormat) {
        case APIFormat.openai:
          await _dio.get<List<dynamic>>(
            '$baseUrl/models',
            options: Options(
              headers: {
                'Authorization': 'Bearer $apiKey',
              },
            ),
          );
          return true;
        case APIFormat.claude:
          // Claude doesn't have a simple validate endpoint
          await _dio.post<Map<String, dynamic>>(
            '$baseUrl/messages',
            options: Options(
              headers: {
                'x-api-key': apiKey,
                'anthropic-version': _claudeApiVersion,
                'Content-Type': 'application/json',
              },
            ),
            data: {
              'model': 'claude-3-haiku-20240307',
              'max_tokens': 1,
              'messages': [
                {'role': 'user', 'content': 'Hi'},
              ],
            },
          );
          return true;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    _dio.close();
  }

  // ==================== OpenAI Format ====================

  Future<String> _sendOpenAIRequest(
    AIRequestConfig config,
    List<AIMessage> messages,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$baseUrl/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${config.apiKey}',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'model': config.model,
          'messages': _buildOpenAIMessages(messages, config.systemPrompt),
          'max_tokens': config.maxTokens,
          'temperature': config.temperature,
        },
      );

      final data = response.data;
      if (data == null) {
        throw AIServiceException('Empty response from API');
      }

      final choices = data['choices'] as List<dynamic>?;
      if (choices == null || choices.isEmpty) {
        throw AIServiceException('No choices in response');
      }

      final message = choices[0]['message'] as Map<String, dynamic>?;
      final content = message?['content'] as String?;
      if (content == null) {
        throw AIServiceException('No content in response');
      }

      return content;
    } on DioException catch (e) {
      throw _handleOpenAIDioError(e);
    }
  }

  Stream<AIStreamChunk> _streamOpenAIRequest(
    AIRequestConfig config,
    List<AIMessage> messages,
  ) async* {
    try {
      final response = await _dio.post<ResponseBody>(
        '$baseUrl/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${config.apiKey}',
            'Content-Type': 'application/json',
          },
          responseType: ResponseType.stream,
        ),
        data: {
          'model': config.model,
          'messages': _buildOpenAIMessages(messages, config.systemPrompt),
          'max_tokens': config.maxTokens,
          'temperature': config.temperature,
          'stream': true,
        },
      );

      final stream = response.data?.stream;
      if (stream == null) {
        throw AIServiceException('No stream in response');
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

            final finishReason = choices[0]['finish_reason'] as String?;
            if (finishReason == 'stop') {
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
            continue;
          }
        }
      }
    } on DioException catch (e) {
      yield AIStreamChunk(
          content: '', isDone: true, error: _handleOpenAIDioError(e).message);
    }
  }

  List<Map<String, dynamic>> _buildOpenAIMessages(
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

  AIServiceException _handleOpenAIDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = switch (statusCode) {
      401 => 'Invalid API key',
      429 => 'Rate limit exceeded. Please wait and try again.',
      500 || 502 || 503 => 'Service is temporarily unavailable',
      _ => e.message ?? 'Unknown error occurred',
    };
    return AIServiceException(message, statusCode: statusCode);
  }

  // ==================== Claude Format ====================

  Future<String> _sendClaudeRequest(
    AIRequestConfig config,
    List<AIMessage> messages,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$baseUrl/messages',
        options: Options(
          headers: {
            'x-api-key': config.apiKey,
            'anthropic-version': _claudeApiVersion,
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'model': config.model,
          'max_tokens': config.maxTokens,
          'messages': _buildClaudeMessages(messages),
          'system': config.systemPrompt,
        },
      );

      final data = response.data;
      if (data == null) {
        throw AIServiceException('Empty response from API');
      }

      final content = data['content'] as List<dynamic>?;
      if (content == null || content.isEmpty) {
        throw AIServiceException('No content in response');
      }

      final firstContent = content[0] as Map<String, dynamic>?;
      final text = firstContent?['text'] as String?;
      if (text == null) {
        throw AIServiceException('No text in response');
      }

      return text;
    } on DioException catch (e) {
      throw _handleClaudeDioError(e);
    }
  }

  Stream<AIStreamChunk> _streamClaudeRequest(
    AIRequestConfig config,
    List<AIMessage> messages,
  ) async* {
    try {
      final response = await _dio.post<ResponseBody>(
        '$baseUrl/messages',
        options: Options(
          headers: {
            'x-api-key': config.apiKey,
            'anthropic-version': _claudeApiVersion,
            'Content-Type': 'application/json',
          },
          responseType: ResponseType.stream,
        ),
        data: {
          'model': config.model,
          'max_tokens': config.maxTokens,
          'messages': _buildClaudeMessages(messages),
          'system': config.systemPrompt,
          'stream': true,
        },
      );

      final stream = response.data?.stream;
      if (stream == null) {
        throw AIServiceException('No stream in response');
      }

      await for (final chunk in stream) {
        final text = utf8.decode(chunk);
        final lines = text.split('\n');

        for (final line in lines) {
          if (!line.startsWith('data: ')) continue;

          final data = line.substring(6).trim();
          if (data.isEmpty) continue;

          try {
            final json = jsonDecode(data) as Map<String, dynamic>;
            final type = json['type'] as String?;

            switch (type) {
              case 'content_block_delta':
                final delta = json['delta'] as Map<String, dynamic>?;
                final content = delta?['text'] as String?;
                if (content != null) {
                  yield AIStreamChunk(content: content);
                }

              case 'message_delta':
                final usage = json['usage'] as Map<String, dynamic>?;
                final outputTokens = usage?['output_tokens'] as int?;
                if (outputTokens != null) {
                  yield AIStreamChunk(
                    content: '',
                    isDone: true,
                    totalTokens: outputTokens,
                  );
                }

              case 'message_stop':
                yield const AIStreamChunk(content: '', isDone: true);
                return;

              case 'error':
                final error = json['error'] as Map<String, dynamic>?;
                final errorMessage = error?['message'] as String?;
                yield AIStreamChunk(
                  content: '',
                  isDone: true,
                  error: errorMessage ?? 'Unknown error',
                );
                return;
            }
          } on FormatException {
            continue;
          }
        }
      }
    } on DioException catch (e) {
      yield AIStreamChunk(
          content: '', isDone: true, error: _handleClaudeDioError(e).message);
    }
  }

  List<Map<String, dynamic>> _buildClaudeMessages(List<AIMessage> messages) {
    return messages
        .where((m) => m.role != 'system')
        .map((m) => {
              'role': m.role == 'user' ? 'user' : 'assistant',
              'content': m.content,
            })
        .toList();
  }

  AIServiceException _handleClaudeDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = switch (statusCode) {
      401 => 'Invalid API key',
      403 => 'Access forbidden. Check your API permissions.',
      429 => 'Rate limit exceeded. Please wait and try again.',
      500 || 502 || 503 => 'Service is temporarily unavailable',
      _ => e.message ?? 'Unknown error occurred',
    };
    return AIServiceException(message, statusCode: statusCode);
  }
}