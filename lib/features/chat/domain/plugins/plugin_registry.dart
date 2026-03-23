/// IM 插件注册中心。
///
/// 管理所有消息处理器、渲染器和响应生成器的注册和查找。
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_project_template/features/chat/domain/entities/message.dart';
import 'package:flutter_project_template/features/chat/domain/plugins/message_handler.dart';
import 'package:flutter_project_template/features/chat/domain/plugins/message_renderer.dart';
import 'package:flutter_project_template/features/chat/domain/plugins/response_generator.dart';

/// IM 插件注册中心。
///
/// 提供统一的插件管理接口，支持：
/// - 注册和注销消息处理器
/// - 注册和注销消息渲染器
/// - 注册和注销响应生成器
/// - 根据消息类型查找合适的处理器和渲染器
///
/// ## 使用示例
///
/// ```dart
/// final registry = IMPluginRegistry();
///
/// // 注册处理器
/// registry.registerHandler(AIChatHandler());
/// registry.registerHandler(CustomerServiceHandler());
///
/// // 注册渲染器
/// registry.registerRenderer(TextMessageRenderer());
/// registry.registerRenderer(ImageMessageRenderer());
///
/// // 注册生成器
/// registry.registerGenerator(OpenAIGenerator());
/// registry.registerGenerator(ClaudeGenerator());
///
/// // 使用处理器处理消息
/// final handler = registry.getHandler(message);
/// if (handler != null) {
///   final response = await handler.handle(message, context);
/// }
///
/// // 使用渲染器渲染消息
/// final renderer = registry.getRenderer(message);
/// if (renderer != null) {
///   return renderer.render(message, context);
/// }
/// ```
class IMPluginRegistry {
  final List<MessageHandler> _handlers = [];
  final List<MessageRenderer> _renderers = [];
  final Map<String, ResponseGenerator> _generators = {};

  /// 所有已注册的消息处理器。
  List<MessageHandler> get handlers => List.unmodifiable(_handlers);

  /// 所有已注册的消息渲染器。
  List<MessageRenderer> get renderers => List.unmodifiable(_renderers);

  /// 所有已注册的响应生成器。
  List<ResponseGenerator> get generators =>
      List.unmodifiable(_generators.values);

  /// 注册消息处理器。
  ///
  /// 如果已存在相同 ID 的处理器，将覆盖旧的处理器。
  /// 处理器会根据优先级自动排序。
  void registerHandler(MessageHandler handler) {
    // 移除相同 ID 的旧处理器
    _handlers.removeWhere((h) => h.id == handler.id);
    _handlers.add(handler);
    // 按优先级排序（优先级高的在前）
    _handlers.sort((a, b) => b.priority.compareTo(a.priority));
  }

  /// 注销消息处理器。
  ///
  /// 根据 ID 移除已注册的处理器。
  void unregisterHandler(String handlerId) {
    _handlers.removeWhere((h) => h.id == handlerId);
  }

  /// 注册消息渲染器。
  ///
  /// 如果已存在相同 ID 的渲染器，将覆盖旧的渲染器。
  /// 渲染器会根据优先级自动排序。
  void registerRenderer(MessageRenderer renderer) {
    // 移除相同 ID 的旧渲染器
    _renderers.removeWhere((r) => r.id == renderer.id);
    _renderers.add(renderer);
    // 按优先级排序（优先级高的在前）
    _renderers.sort((a, b) => b.priority.compareTo(a.priority));
  }

  /// 注销消息渲染器。
  ///
  /// 根据 ID 移除已注册的渲染器。
  void unregisterRenderer(String rendererId) {
    _renderers.removeWhere((r) => r.id == rendererId);
  }

  /// 注册响应生成器。
  ///
  /// 如果已存在相同 ID 的生成器，将覆盖旧的生成器。
  void registerGenerator(ResponseGenerator generator) {
    _generators[generator.id] = generator;
  }

  /// 注销响应生成器。
  ///
  /// 根据 ID 移除已注册的生成器。
  void unregisterGenerator(String generatorId) {
    _generators.remove(generatorId);
  }

  /// 获取适合处理该消息的处理器。
  ///
  /// 遍历所有已注册的处理器，返回第一个能处理该消息的处理器。
  /// 处理器按优先级排序，优先级高的优先选择。
  ///
  /// 如果没有合适的处理器，返回 `null`。
  MessageHandler? getHandler(Message message) {
    for (final handler in _handlers) {
      if (handler.canHandle(message)) {
        return handler;
      }
    }
    return null;
  }

  /// 获取所有能处理该消息的处理器。
  ///
  /// 返回所有能处理该消息的处理器列表，按优先级排序。
  List<MessageHandler> getAllHandlers(Message message) {
    return _handlers.where((h) => h.canHandle(message)).toList();
  }

  /// 根据 ID 获取处理器。
  ///
  /// 返回指定 ID 的处理器，如果不存在则返回 `null`。
  MessageHandler? getHandlerById(String id) {
    try {
      return _handlers.firstWhere((h) => h.id == id);
    } catch (_) {
      return null;
    }
  }

  /// 获取适合渲染该消息的渲染器。
  ///
  /// 遍历所有已注册的渲染器，返回第一个能渲染该消息的渲染器。
  /// 渲染器按优先级排序，优先级高的优先选择。
  ///
  /// 如果没有合适的渲染器，返回 `null`。
  MessageRenderer? getRenderer(Message message) {
    for (final renderer in _renderers) {
      if (renderer.canRender(message)) {
        return renderer;
      }
    }
    return null;
  }

  /// 获取所有能渲染该消息的渲染器。
  ///
  /// 返回所有能渲染该消息的渲染器列表，按优先级排序。
  List<MessageRenderer> getAllRenderers(Message message) {
    return _renderers.where((r) => r.canRender(message)).toList();
  }

  /// 根据 ID 获取渲染器。
  ///
  /// 返回指定 ID 的渲染器，如果不存在则返回 `null`。
  MessageRenderer? getRendererById(String id) {
    try {
      return _renderers.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  /// 根据 ID 获取响应生成器。
  ///
  /// 返回指定 ID 的生成器，如果不存在则返回 `null`。
  ResponseGenerator? getGenerator(String id) {
    return _generators[id];
  }

  /// 获取所有响应生成器。
  ///
  /// 返回所有已注册的生成器列表。
  List<ResponseGenerator> getAllGenerators() {
    return _generators.values.toList();
  }

  /// 使用注册的渲染器渲染消息。
  ///
  /// 查找合适的渲染器并渲染消息。
  /// 如果没有找到渲染器，返回默认的文本显示。
  ///
  /// - [message] 要渲染的消息。
  /// - [context] Build 上下文。
  /// - [fallback] 可选的后备渲染函数，当没有找到渲染器时使用。
  Widget renderMessage(
    Message message,
    BuildContext context, {
    Widget Function(Message)? fallback,
  }) {
    final renderer = getRenderer(message);
    if (renderer != null) {
      return renderer.render(message, context);
    }

    // 使用后备渲染或默认显示
    if (fallback != null) {
      return fallback(message);
    }

    return _buildDefaultMessageWidget(message);
  }

  /// 使用注册的处理器处理消息。
  ///
  /// 查找合适的处理器并处理消息。
  ///
  /// - [message] 要处理的消息。
  /// - [context] 消息处理上下文。
  ///
  /// 返回处理结果消息，如果没有合适的处理器则返回 `null`。
  Future<Message?> handleMessage(
    Message message,
    MessageContext context,
  ) async {
    final handler = getHandler(message);
    if (handler != null) {
      return handler.handle(message, context);
    }
    return null;
  }

  /// 使用注册的生成器生成响应。
  ///
  /// 根据生成器 ID 查找生成器并生成响应。
  ///
  /// - [generatorId] 生成器 ID。
  /// - [context] 消息处理上下文。
  /// - [config] 生成器配置。
  ///
  /// 返回响应块的流，如果生成器不存在则返回空流。
  Stream<ResponseChunk> generateResponse(
    String generatorId,
    MessageContext context,
    ResponseGeneratorConfig config,
  ) {
    final generator = getGenerator(generatorId);
    if (generator != null) {
      return generator.generate(context, config);
    }
    return Stream.value(
        ResponseChunk.withError('Generator not found: $generatorId'));
  }

  /// 清除所有已注册的插件。
  void clear() {
    _handlers.clear();
    _renderers.clear();
    _generators.clear();
  }

  /// 构建默认的消息 Widget。
  ///
  /// 当没有找到合适的渲染器时使用。
  Widget _buildDefaultMessageWidget(Message message) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(
        message.text ?? '[${message.type.name}]',
        style: const TextStyle(
          fontStyle: FontStyle.italic,
          color: Color(0xFF888888),
        ),
      ),
    );
  }
}
