/// 消息处理器插件接口。
///
/// 定义消息处理器的标准接口，用于处理接收到的消息并生成响应。
library;

import 'package:flutter_project_template/features/chat/domain/entities/message.dart';

/// 消息处理上下文。
///
/// 提供处理消息时所需的上下文信息。
class MessageContext {
  /// 创建消息处理上下文。
  const MessageContext({
    required this.conversationId,
    this.history = const [],
    this.metadata = const {},
  });

  /// 当前会话 ID。
  final String conversationId;

  /// 历史消息列表。
  final List<Message> history;

  /// 额外元数据。
  final Map<String, dynamic> metadata;

  /// 创建消息上下文副本。
  MessageContext copyWith({
    String? conversationId,
    List<Message>? history,
    Map<String, dynamic>? metadata,
  }) => MessageContext(
      conversationId: conversationId ?? this.conversationId,
      history: history ?? this.history,
      metadata: metadata ?? this.metadata,
    );
}

/// 消息处理器插件接口。
///
/// 实现此接口以处理特定类型的消息。
/// 处理器可以生成响应消息，也可以仅处理消息而不生成响应。
///
/// ## 使用示例
///
/// ```dart
/// class AIChatHandler implements MessageHandler {
///   @override
///   String get id => 'ai_chat';
///
///   @override
///   bool canHandle(Message message) => message is TextMessage;
///
///   @override
///   Future<Message?> handle(Message message, MessageContext context) async {
///     // 调用 AI 服务生成响应
///     final response = await aiService.generateResponse(message.text);
///     return TextMessage(
///       id: generateId(),
///       conversationId: context.conversationId,
///       sender: MessageSender.assistant,
///       timestamp: DateTime.now(),
///       content: response,
///     );
///   }
/// }
/// ```
abstract class MessageHandler {
  /// 插件唯一标识符。
  ///
  /// 用于在注册中心查找和管理处理器。
  String get id;

  /// 插件名称（用于显示）。
  ///
  /// 如果未提供，默认使用 [id]。
  String get name => id;

  /// 插件描述。
  ///
  /// 说明该处理器的功能和使用场景。
  String get description => '';

  /// 判断是否能处理该消息。
  ///
  /// 返回 `true` 表示该处理器可以处理此消息。
  /// 注册中心会调用此方法来确定使用哪个处理器。
  bool canHandle(Message message);

  /// 处理消息。
  ///
  /// 处理接收到的消息，并可选择返回响应消息。
  ///
  /// - [message] 要处理的消息。
  /// - [context] 处理上下文，包含会话信息和历史消息。
  ///
  /// 返回响应消息，或返回 `null` 表示不生成响应。
  Future<Message?> handle(Message message, MessageContext context);

  /// 处理器优先级。
  ///
  /// 数值越大优先级越高。当多个处理器都能处理同一消息时，
  /// 优先级高的处理器会被优先选择。
  /// 默认为 0。
  int get priority => 0;

  /// 是否为异步处理器。
  ///
  /// 如果为 `true`，处理过程可能需要较长时间，
  /// 调用方应该显示加载状态。
  /// 默认为 `true`。
  bool get isAsync => true;
}
