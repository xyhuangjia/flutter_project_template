/// AI 聊天消息处理器。
///
/// 处理用户发送的消息并生成 AI 响应。
library;

import 'dart:async';

import 'package:flutter_project_template/features/chat/domain/entities/message.dart';
import 'package:flutter_project_template/features/chat/domain/plugins/message_handler.dart';
import 'package:flutter_project_template/features/chat/domain/plugins/response_generator.dart';

/// AI 聊天消息处理器。
///
/// 处理用户发送的消息，使用配置的 [ResponseGenerator] 生成 AI 响应。
/// 支持 OpenAI、Claude 和自定义 AI 服务。
///
/// ## 使用示例
///
/// ```dart
/// final handler = AIChatHandler(
///   responseGenerator: openAIGenerator,
///   config: ResponseGeneratorConfig(
///     model: 'gpt-4o',
///     apiKey: 'your-api-key',
///   ),
/// );
///
/// final response = await handler.handle(userMessage, context);
/// ```
class AIChatHandler extends MessageHandler {
  /// 创建 AI 聊天处理器。
  ///
  /// - [responseGenerator] 用于生成响应的生成器。
  /// - [config] 响应生成器配置。
  /// - [onStreamChunk] 流式响应回调（可选）。
  /// - [onError] 错误回调（可选）。
  AIChatHandler({
    required ResponseGenerator responseGenerator,
    required ResponseGeneratorConfig config,
    this.onStreamChunk,
    this.onError,
  })  : _responseGenerator = responseGenerator,
        _config = config;

  /// 响应生成器。
  final ResponseGenerator _responseGenerator;

  /// 响应生成器配置。
  ResponseGeneratorConfig _config;

  /// 流式响应回调。
  ///
  /// 当收到新的响应块时调用。
  final void Function(String content, bool isDone)? onStreamChunk;

  /// 错误回调。
  ///
  /// 当生成响应时发生错误时调用。
  final void Function(String error)? onError;

  /// 更新配置。
  // ignore: use_setters_to_change_properties
  void updateConfig(ResponseGeneratorConfig config) {
    _config = config;
  }

  @override
  String get id => 'ai_chat';

  @override
  String get name => 'AI Chat';

  @override
  String get description =>
      'Handles user messages and generates AI responses.';

  @override
  int get priority => 100;

  @override
  bool canHandle(Message message) {
    // 处理用户发送的文本消息
    if (message.sender != MessageSender.user) return false;
    return message is TextMessage;
  }

  @override
  Future<Message?> handle(Message message, MessageContext context) async {
    if (message is! TextMessage) return null;

    try {
      // 使用流式生成
      final stream = _responseGenerator.generate(context, _config);

      final buffer = StringBuffer();

      await for (final chunk in stream) {
        if (chunk.hasError) {
          onError?.call(chunk.errorMessage ?? 'Unknown error');
          return null;
        }

        buffer.write(chunk.content);

        // 调用流式回调
        onStreamChunk?.call(chunk.content, chunk.isDone);
      }

      // 返回 AI 响应消息
      return TextMessage(
        id: '${DateTime.now().millisecondsSinceEpoch}_ai',
        conversationId: context.conversationId,
        sender: MessageSender.assistant,
        timestamp: DateTime.now(),
        content: buffer.toString(),
      );
    } on Exception catch (e) {
      onError?.call(e.toString());
      return null;
    }
  }

  /// 流式处理消息。
  ///
  /// 返回响应消息的流，每个块包含增量内容。
  Stream<Message> handleStream(
    Message message,
    MessageContext context,
  ) async* {
    if (message is! TextMessage) return;

    final aiMessageId = '${DateTime.now().millisecondsSinceEpoch}_ai';
    final buffer = StringBuffer();

    try {
      final stream = _responseGenerator.generate(context, _config);

      await for (final chunk in stream) {
        if (chunk.hasError) {
          onError?.call(chunk.errorMessage ?? 'Unknown error');
          yield TextMessage(
            id: aiMessageId,
            conversationId: context.conversationId,
            sender: MessageSender.assistant,
            timestamp: DateTime.now(),
            content: buffer.toString(),
            status: MessageStatus.error,
          );
          return;
        }

        buffer.write(chunk.content);

        // 生成增量消息
        yield TextMessage(
          id: aiMessageId,
          conversationId: context.conversationId,
          sender: MessageSender.assistant,
          timestamp: DateTime.now(),
          content: buffer.toString(),
          status: chunk.isDone ? MessageStatus.sent : MessageStatus.sending,
        );

        if (chunk.isDone) {
          return;
        }
      }
    } on Exception catch (e) {
      onError?.call(e.toString());
      yield TextMessage(
        id: aiMessageId,
        conversationId: context.conversationId,
        sender: MessageSender.assistant,
        timestamp: DateTime.now(),
        content: buffer.toString(),
        status: MessageStatus.error,
      );
    }
  }
}