/// AI 响应生成器。
///
/// 使用 AI 服务（OpenAI、Claude、自定义端点）生成响应。
library;

import 'dart:async';

import 'package:flutter_project_template/features/chat/data/services/ai_service.dart';
import 'package:flutter_project_template/features/chat/data/services/claude_service.dart';
import 'package:flutter_project_template/features/chat/data/services/openai_service.dart';
import 'package:flutter_project_template/features/chat/data/services/universal_ai_service.dart';
import 'package:flutter_project_template/features/chat/domain/entities/message.dart';
import 'package:flutter_project_template/features/chat/domain/plugins/message_handler.dart';
import 'package:flutter_project_template/features/chat/domain/plugins/response_generator.dart';

/// AI 响应生成器基类。
///
/// 封装了 AI 服务的通用逻辑，子类只需提供具体的 AI 服务实例。
///
/// ## 使用示例
///
/// ```dart
/// final generator = OpenAIResponseGenerator(
///   apiKey: 'your-api-key',
///   model: 'gpt-4o',
/// );
///
/// final stream = generator.generate(context, config);
/// await for (final chunk in stream) {
///   print(chunk.content);
/// }
/// ```
abstract class AIResponseGenerator implements ResponseGenerator {
  /// 创建 AI 响应生成器。
  AIResponseGenerator({
    required AIService service,
  }) : _service = service;

  /// AI 服务实例。
  final AIService _service;

  /// 当前请求的取消令牌。
  Completer<void>? _cancelToken;

  @override
  String get description => 'Generates AI responses using ${_service.providerName}';

  @override
  String? get icon => null;

  @override
  bool get supportsMultimodal => false;

  @override
  bool get supportsFunctionCalling => false;

  @override
  Stream<ResponseChunk> generate(
    MessageContext context,
    ResponseGeneratorConfig config,
  ) async* {
    _cancelToken = Completer<void>();

    try {
      // 转换消息格式
      final aiMessages = _convertMessages(context.history);

      // 创建 AI 请求配置
      final aiConfig = AIRequestConfig(
        model: config.model,
        apiKey: config.apiKey,
        maxTokens: config.maxTokens,
        temperature: config.temperature,
        systemPrompt: config.systemPrompt,
      );

      // 使用流式生成
      final stream = _service.streamMessage(
        config: aiConfig,
        messages: aiMessages,
      );

      await for (final chunk in stream) {
        // 检查是否已取消
        if (_cancelToken?.isCompleted ?? false) {
          yield ResponseChunk.withError('Generation cancelled');
          return;
        }

        if (chunk.error != null) {
          yield ResponseChunk.withError(chunk.error!);
          return;
        }

        yield ResponseChunk(
          content: chunk.content,
          isDone: chunk.isDone,
          totalTokens: chunk.totalTokens,
        );

        if (chunk.isDone) {
          return;
        }
      }
    } catch (e) {
      yield ResponseChunk.withError(e.toString());
    } finally {
      _cancelToken = null;
    }
  }

  @override
  void stop() {
    _cancelToken?.complete();
  }

  @override
  Future<bool> validateApiKey(String apiKey) async {
    try {
      return await _service.validateApiKey(apiKey);
    } catch (_) {
      return false;
    }
  }

  /// 转换消息格式。
  List<AIMessage> _convertMessages(List<Message> messages) => messages.map((msg) {
      final role = switch (msg.sender) {
        MessageSender.user => 'user',
        MessageSender.assistant => 'assistant',
        MessageSender.system => 'system',
      };

      final content = msg.text ?? '';

      return AIMessage(role: role, content: content);
    }).toList();

  /// 释放资源。
  void dispose() {
    stop();
    _service.dispose();
  }
}

/// OpenAI 响应生成器。
///
/// 使用 OpenAI API 生成响应。
class OpenAIResponseGenerator extends AIResponseGenerator {
  /// 创建 OpenAI 响应生成器。
  OpenAIResponseGenerator() : super(service: OpenAIService());

  @override
  String get id => 'openai';

  @override
  String get name => 'OpenAI';

  @override
  List<String> get supportedModels => [
        'gpt-4o',
        'gpt-4o-mini',
        'gpt-4-turbo',
        'gpt-4',
        'gpt-3.5-turbo',
      ];

  @override
  String get defaultModel => 'gpt-4o';
}

/// Claude 响应生成器。
///
/// 使用 Anthropic Claude API 生成响应。
class ClaudeResponseGenerator extends AIResponseGenerator {
  /// 创建 Claude 响应生成器。
  ClaudeResponseGenerator() : super(service: ClaudeService());

  @override
  String get id => 'claude';

  @override
  String get name => 'Claude (Anthropic)';

  @override
  List<String> get supportedModels => [
        'claude-3-5-sonnet-20241022',
        'claude-3-5-haiku-20241022',
        'claude-3-opus-20240229',
        'claude-3-sonnet-20240229',
        'claude-3-haiku-20240307',
      ];

  @override
  String get defaultModel => 'claude-3-5-sonnet-20241022';
}

/// 自定义端点响应生成器。
///
/// 使用自定义 API 端点生成响应，支持 OpenAI 和 Claude API 格式。
class UniversalResponseGenerator extends AIResponseGenerator {
  /// 创建自定义端点响应生成器。
  UniversalResponseGenerator({
    required String baseUrl,
    required APIFormat apiFormat,
  })  : _baseUrl = baseUrl,
        _apiFormat = apiFormat,
        super(
          service: UniversalAIService(
            baseUrl: baseUrl,
            apiFormat: apiFormat,
          ),
        );

  final String _baseUrl;
  final APIFormat _apiFormat;

  @override
  String get id => 'custom_${_baseUrl.hashCode}';

  @override
  String get name => 'Custom ($_baseUrl)';

  @override
  String get description =>
      'Custom endpoint using ${_apiFormat.name} API format';

  @override
  List<String> get supportedModels => [];

  @override
  String get defaultModel => '';

  /// 获取 API 格式。
  APIFormat get apiFormat => _apiFormat;

  /// 获取基础 URL。
  String get baseUrl => _baseUrl;
}

/// 响应生成器工厂。
///
/// 根据配置创建合适的响应生成器。
class ResponseGeneratorFactory {
  /// 创建响应生成器。
  ///
  /// - [provider] 服务提供者：'openai', 'claude', 'custom'。
  /// - [baseUrl] 自定义端点的 URL（仅 custom 需要）。
  /// - [apiFormat] 自定义端点的 API 格式（仅 custom 需要）。
  static ResponseGenerator create({
    required String provider,
    String? baseUrl,
    String apiFormat = 'openai',
  }) {
    switch (provider) {
      case 'openai':
        return OpenAIResponseGenerator();
      case 'claude':
        return ClaudeResponseGenerator();
      case 'custom':
        if (baseUrl == null) {
          throw ArgumentError('baseUrl is required for custom provider');
        }
        return UniversalResponseGenerator(
          baseUrl: baseUrl,
          apiFormat: apiFormat == 'claude' ? APIFormat.claude : APIFormat.openai,
        );
      default:
        throw ArgumentError('Unknown provider: $provider');
    }
  }
}