/// 插件注册中心 Provider。
///
/// 提供全局的 IM 插件注册中心实例。
library;

import 'package:flutter_project_template/features/chat/domain/plugins/impl/ai_message_renderer.dart';
import 'package:flutter_project_template/features/chat/domain/plugins/impl/echo_handler.dart';
import 'package:flutter_project_template/features/chat/domain/plugins/impl/image_message_renderer.dart';
import 'package:flutter_project_template/features/chat/domain/plugins/plugin_registry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'plugin_registry_provider.g.dart';

/// 插件注册中心 Provider。
///
/// 提供全局的 IMPluginRegistry 实例，用于管理所有消息处理器、
/// 渲染器和响应生成器。
///
/// ## 使用示例
///
/// ```dart
/// // 在 Widget 中获取注册中心
/// final registry = ref.watch(pluginRegistryProvider);
///
/// // 注册处理器
/// registry.registerHandler(AIChatHandler());
///
/// // 注册渲染器
/// registry.registerRenderer(TextMessageRenderer());
///
/// // 注册生成器
/// registry.registerGenerator(OpenAIGenerator());
/// ```
@Riverpod(keepAlive: true)
IMPluginRegistry pluginRegistry(Ref ref) {
  final registry = IMPluginRegistry();

  // 注册默认消息渲染器
  // 优先级：图片 > 文本
  registry.registerRenderer(ImageMessageRenderer());
  registry.registerRenderer(AIMessageRenderer());

  // 注册示例处理器（优先级较低，仅用于演示）
  // 实际应用中应该根据配置注册对应的处理器
  registry.registerHandler(EchoHandler());

  // 在 dispose 时清理
  ref.onDispose(registry.clear);

  return registry;
}
