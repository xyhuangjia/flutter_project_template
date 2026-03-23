/// 响应生成器插件接口。
///
/// 定义响应生成器的标准接口，用于生成 AI 或自动回复响应。
library;

import 'dart:async';

import 'package:flutter_project_template/features/chat/domain/plugins/message_handler.dart';

/// 响应块。
///
/// 表示流式响应中的一个数据块。
class ResponseChunk {
  /// 创建响应块。
  const ResponseChunk({
    required this.content,
    this.isDone = false,
    this.errorMessage,
    this.totalTokens,
    this.promptTokens,
  });

  /// 内容增量。
  ///
  /// 本次新增的内容文本。
  final String content;

  /// 是否为最后一个块。
  ///
  /// 当为 `true` 时，表示响应生成完成。
  final bool isDone;

  /// 错误信息。
  ///
  /// 如果生成过程中发生错误，包含错误描述。
  final String? errorMessage;

  /// 总 Token 数量。
  ///
  /// 仅在最后一个块中提供（如果可用）。
  final int? totalTokens;

  /// 提示词 Token 数量。
  ///
  /// 仅在最后一个块中提供（如果可用）。
  final int? promptTokens;

  /// 是否有错误。
  bool get hasError => errorMessage != null;

  /// 空响应块。
  static const empty = ResponseChunk(content: '');

  /// 完成响应块。
  static const done = ResponseChunk(content: '', isDone: true);

  /// 创建错误响应块。
  static ResponseChunk withError(String message) =>
      ResponseChunk(content: '', errorMessage: message, isDone: true);
}

/// 响应生成器配置。
///
/// 包含生成响应所需的配置信息。
class ResponseGeneratorConfig {
  /// 创建响应生成器配置。
  const ResponseGeneratorConfig({
    required this.model,
    required this.apiKey,
    this.baseUrl,
    this.maxTokens = 4096,
    this.temperature = 0.7,
    this.systemPrompt,
    this.topP,
    this.presencePenalty,
    this.frequencyPenalty,
    this.stopSequences,
  });

  /// 模型标识符。
  final String model;

  /// API 密钥。
  final String apiKey;

  /// API 基础 URL（可选，用于自定义端点）。
  final String? baseUrl;

  /// 最大生成 Token 数。
  final int maxTokens;

  /// 温度参数（0-2）。
  ///
  /// 控制输出的随机性。值越高输出越随机。
  final double temperature;

  /// 系统提示词。
  final String? systemPrompt;

  /// Top-P 采样参数。
  final double? topP;

  /// 存在惩罚参数。
  final double? presencePenalty;

  /// 频率惩罚参数。
  final double? frequencyPenalty;

  /// 停止序列。
  final List<String>? stopSequences;
}

/// 响应生成器插件接口。
///
/// 实现此接口以提供响应生成能力，如 AI 模型调用。
/// 生成器支持流式输出，适用于实时显示生成过程。
///
/// ## 使用示例
///
/// ```dart
/// class OpenAIGenerator implements ResponseGenerator {
///   @override
///   String get id => 'openai';
///
///   @override
///   String get name => 'OpenAI';
///
///   @override
///   Stream<ResponseChunk> generate(
///     MessageContext context,
///     ResponseGeneratorConfig config,
///   ) async* {
///     final stream = openAIService.streamChat(
///       messages: context.history,
///       config: config,
///     );
///
///     await for (final chunk in stream) {
///       yield ResponseChunk(
///         content: chunk.content,
///         isDone: chunk.isDone,
///       );
///     }
///   }
///
///   @override
///   void stop() {
///     openAIService.cancelCurrentRequest();
///   }
/// }
/// ```
abstract class ResponseGenerator {
  /// 生成器唯一标识符。
  ///
  /// 用于在注册中心查找和管理生成器。
  String get id;

  /// 生成器名称（用于显示）。
  ///
  /// 在 UI 中显示的友好名称。
  String get name;

  /// 生成器描述。
  ///
  /// 说明该生成器的功能和使用场景。
  String get description => '';

  /// 生成器图标（可选）。
  ///
  /// 用于在 UI 中显示的图标路径或标识。
  String? get icon => null;

  /// 支持的模型列表。
  ///
  /// 返回该生成器支持的所有模型标识符。
  List<String> get supportedModels;

  /// 默认模型。
  ///
  /// 未指定模型时使用的默认模型。
  String get defaultModel => supportedModels.first;

  /// 生成响应（流式）。
  ///
  /// 根据上下文和配置生成响应，以流的形式返回。
  ///
  /// - [context] 消息上下文，包含历史消息等。
  /// - [config] 生成器配置，包含模型、API 密钥等。
  ///
  /// 返回响应块的流，每个块包含增量内容。
  Stream<ResponseChunk> generate(
    MessageContext context,
    ResponseGeneratorConfig config,
  );

  /// 停止生成。
  ///
  /// 取消当前的生成操作。
  void stop();

  /// 验证 API 密钥。
  ///
  /// 检查提供的 API 密钥是否有效。
  Future<bool> validateApiKey(String apiKey);

  /// 是否支持多模态输入。
  ///
  /// 如果为 `true`，该生成器可以处理图片等非文本输入。
  bool get supportsMultimodal => false;

  /// 是否支持函数调用。
  ///
  /// 如果为 `true`，该生成器支持调用外部函数/工具。
  bool get supportsFunctionCalling => false;
}
