/// Claude (Anthropic) service implementation.
///
/// Provides integration with Anthropic's Claude API
/// with streaming support.
library;

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_project_template/features/chat/data/services/ai_service.dart';
import 'package:flutter_project_template/features/chat/data/services/openai_service.dart';

/// Claude API service implementation.
class ClaudeService implements AIService {
  /// Creates a Claude service.
  ClaudeService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;
  static const String _baseUrl = 'https://api.anthropic.com/v1';
  static const String _apiVersion = '2023-06-01';

  @override
  String get providerName => 'claude';

  @override
  List<String> get availableModels => [
        'claude-3-5-sonnet-20241022',
        'claude-3-5-haiku-20241022',
        'claude-3-opus-20240229',
        'claude-3-sonnet-20240229',
        'claude-3-haiku-20240307',
      ];

  @override
  Future<String> sendMessage({
    required AIRequestConfig config,
    required List<AIMessage> messages,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_baseUrl/messages',
        options: Options(
          headers: {
            'x-api-key': config.apiKey,
            'anthropic-version': _apiVersion,
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'model': config.model,
          'max_tokens': config.maxTokens,
          'messages': _buildMessages(messages),
          'system': config.systemPrompt,
        },
      );

      final data = response.data;
      if (data == null) {
        throw AIServiceException('Empty response from Claude');
      }

      final content = data['content'] as List<dynamic>?;
      if (content == null || content.isEmpty) {
        throw AIServiceException('No content in Claude response');
      }

      final firstContent = content[0] as Map<String, dynamic>?;
      final text = firstContent?['text'] as String?;
      if (text == null) {
        throw AIServiceException('No text in Claude response');
      }

      return text;
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
        '$_baseUrl/messages',
        options: Options(
          headers: {
            'x-api-key': config.apiKey,
            'anthropic-version': _apiVersion,
            'Content-Type': 'application/json',
          },
          responseType: ResponseType.stream,
        ),
        data: {
          'model': config.model,
          'max_tokens': config.maxTokens,
          'messages': _buildMessages(messages),
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
            // Skip invalid JSON
            continue;
          }
        }
      }
    } on DioException catch (e) {
      yield AIStreamChunk(
          content: '', isDone: true, error: _handleDioError(e).message);
    }
  }

  @override
  Future<bool> validateApiKey(String apiKey) async {
    try {
      // Claude doesn't have a simple validate endpoint, so we try a minimal request
      await _dio.post<Map<String, dynamic>>(
        '$_baseUrl/messages',
        options: Options(
          headers: {
            'x-api-key': apiKey,
            'anthropic-version': _apiVersion,
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
    } on DioException catch (e) {
      // 401 means invalid key, other errors might be temporary
      return e.response?.statusCode != 401;
    }
  }

  @override
  void dispose() {
    _dio.close();
  }

  List<Map<String, dynamic>> _buildMessages(List<AIMessage> messages) {
    // Claude uses 'user' and 'assistant' roles
    // Convert 'system' messages to 'user' if needed
    return messages
        .where((m) => m.role != 'system')
        .map((m) => {
              'role': m.role == 'user' ? 'user' : 'assistant',
              'content': m.content,
            })
        .toList();
  }

  AIServiceException _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = switch (statusCode) {
      401 => 'Invalid API key',
      403 => 'Access forbidden. Check your API permissions.',
      429 => 'Rate limit exceeded. Please wait and try again.',
      500 || 502 || 503 => 'Claude service is temporarily unavailable',
      _ => e.message ?? 'Unknown error occurred',
    };
    return AIServiceException(message, statusCode: statusCode);
  }
}
