/// 回声处理器（示例插件）。
///
/// 简单地将用户消息回显，用于演示插件扩展机制。
library;

import 'package:flutter_project_template/features/chat/domain/entities/message.dart';
import 'package:flutter_project_template/features/chat/domain/plugins/message_handler.dart';

/// 回声处理器（示例插件）。
///
/// 这是一个简单的示例处理器，将用户发送的消息原样返回。
/// 主要用于演示插件系统的扩展能力。
///
/// ## 使用示例
///
/// ```dart
/// final registry = IMPluginRegistry();
///
/// // 注册回声处理器
/// registry.registerHandler(EchoHandler());
///
/// // 处理消息
/// final handler = registry.getHandler(message);
/// final response = await handler?.handle(message, context);
/// // response.text == 'Echo: ${message.text}'
/// ```
class EchoHandler extends MessageHandler {
  /// 创建回声处理器。
  ///
  /// - [prefix] 回声前缀，默认为 'Echo: '。
  EchoHandler({
    this.prefix = 'Echo: ',
  });

  /// 回声前缀。
  final String prefix;

  @override
  String get id => 'echo';

  @override
  String get name => 'Echo Handler';

  @override
  String get description =>
      'A simple example handler that echoes user messages. Used for demonstrating plugin extensions.';

  @override
  int get priority => 0;

  @override
  bool get isAsync => false;

  @override
  bool canHandle(Message message) {
    // 处理所有用户文本消息
    return message.sender == MessageSender.user && message is TextMessage;
  }

  @override
  Future<Message?> handle(Message message, MessageContext context) async {
    if (message is! TextMessage) return null;

    // 创建回声响应
    return TextMessage(
      id: '${DateTime.now().millisecondsSinceEpoch}_echo',
      conversationId: context.conversationId,
      sender: MessageSender.assistant,
      timestamp: DateTime.now(),
      content: '$prefix${message.content}',
    );
  }
}

/// 反转处理器（示例插件）。
///
/// 将用户消息反转后返回，用于演示插件扩展机制。
class ReverseHandler extends MessageHandler {
  /// 创建反转处理器。
  ReverseHandler();

  @override
  String get id => 'reverse';

  @override
  String get name => 'Reverse Handler';

  @override
  String get description =>
      'An example handler that reverses user messages. Used for demonstrating plugin extensions.';

  @override
  int get priority => 0;

  @override
  bool get isAsync => false;

  @override
  bool canHandle(Message message) {
    // 处理所有用户文本消息
    return message.sender == MessageSender.user && message is TextMessage;
  }

  @override
  Future<Message?> handle(Message message, MessageContext context) async {
    if (message is! TextMessage) return null;

    // 反转消息内容
    final reversed = message.content.split('').reversed.join();

    return TextMessage(
      id: '${DateTime.now().millisecondsSinceEpoch}_reverse',
      conversationId: context.conversationId,
      sender: MessageSender.assistant,
      timestamp: DateTime.now(),
      content: reversed,
    );
  }
}

/// 大写处理器（示例插件）。
///
/// 将用户消息转换为大写后返回，用于演示插件扩展机制。
class UppercaseHandler extends MessageHandler {
  /// 创建大写处理器。
  UppercaseHandler();

  @override
  String get id => 'uppercase';

  @override
  String get name => 'Uppercase Handler';

  @override
  String get description =>
      'An example handler that converts user messages to uppercase. Used for demonstrating plugin extensions.';

  @override
  int get priority => 0;

  @override
  bool get isAsync => false;

  @override
  bool canHandle(Message message) {
    // 处理所有用户文本消息
    return message.sender == MessageSender.user && message is TextMessage;
  }

  @override
  Future<Message?> handle(Message message, MessageContext context) async {
    if (message is! TextMessage) return null;

    // 转换为大写
    final uppercased = message.content.toUpperCase();

    return TextMessage(
      id: '${DateTime.now().millisecondsSinceEpoch}_upper',
      conversationId: context.conversationId,
      sender: MessageSender.assistant,
      timestamp: DateTime.now(),
      content: uppercased,
    );
  }
}