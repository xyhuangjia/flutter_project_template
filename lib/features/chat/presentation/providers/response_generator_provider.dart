/// 响应生成器 Provider。
///
/// 提供动态创建和管理响应生成器的能力。
library;

import 'package:flutter_project_template/features/chat/data/services/universal_ai_service.dart';
import 'package:flutter_project_template/features/chat/domain/plugins/impl/ai_response_generator.dart';
import 'package:flutter_project_template/features/chat/presentation/providers/ai_config_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'response_generator_provider.g.dart';

/// 响应生成器管理器。
///
/// 管理所有响应生成器实例，支持：
/// - 根据配置创建生成器
/// - 缓存生成器实例
/// - 动态更新配置
class ResponseGeneratorManager {
  /// 创建响应生成器管理器。
  ResponseGeneratorManager();

  final Map<String, AIResponseGenerator> _generators = {};

  /// 获取或创建响应生成器。
  ///
  /// - [provider] 服务提供者：'openai', 'claude', 'custom'。
  /// - [baseUrl] 自定义端点 URL（仅 custom 需要）。
  /// - [apiFormat] API 格式（仅 custom 需要）。
  AIResponseGenerator getOrCreate({
    required String provider,
    String? baseUrl,
    String apiFormat = 'openai',
  }) {
    final key = _createKey(provider, baseUrl, apiFormat);

    if (_generators.containsKey(key)) {
      return _generators[key]!;
    }

    final generator = ResponseGeneratorFactory.create(
      provider: provider,
      baseUrl: baseUrl,
      apiFormat: apiFormat,
    ) as AIResponseGenerator;

    _generators[key] = generator;
    return generator;
  }

  /// 创建缓存键。
  String _createKey(String provider, String? baseUrl, String apiFormat) {
    if (provider == 'custom' && baseUrl != null) {
      return 'custom_$baseUrl${apiFormat}_';
    }
    return provider;
  }

  /// 清除所有缓存的生成器。
  void clear() {
    for (final generator in _generators.values) {
      generator.dispose();
    }
    _generators.clear();
  }

  /// 移除指定的生成器。
  void remove(String provider, {String? baseUrl, String apiFormat = 'openai'}) {
    final key = _createKey(provider, baseUrl, apiFormat);
    _generators[key]?.dispose();
    _generators.remove(key);
  }
}

/// 响应生成器管理器 Provider。
@Riverpod(keepAlive: true)
ResponseGeneratorManager responseGeneratorManager(Ref ref) {
  final manager = ResponseGeneratorManager();

  ref.onDispose(() {
    manager.clear();
  });

  return manager;
}

/// 默认响应生成器 Provider。
///
/// 根据默认 AI 配置创建响应生成器。
@riverpod
AIResponseGenerator? defaultResponseGenerator(Ref ref) {
  final aiConfigState = ref.watch(aIConfigProvider).value;
  final defaultConfig = aiConfigState?.defaultConfig;

  if (defaultConfig == null) {
    return null;
  }

  final manager = ref.watch(responseGeneratorManagerProvider);

  return manager.getOrCreate(
    provider: defaultConfig.provider,
    baseUrl: defaultConfig.baseUrl,
    apiFormat: defaultConfig.apiFormat,
  );
}

/// 可用的响应生成器列表 Provider。
@riverpod
List<AIResponseGenerator> availableGenerators(Ref ref) {
  final generators = <AIResponseGenerator>[];

  // 添加预置生成器
  generators.add(OpenAIResponseGenerator());
  generators.add(ClaudeResponseGenerator());

  // 添加自定义配置的生成器
  final aiConfigState = ref.watch(aIConfigProvider).value;
  final configs = aiConfigState?.configs ?? [];

  for (final config in configs) {
    if (config.provider == 'custom' && config.baseUrl != null) {
      try {
        generators.add(
          UniversalResponseGenerator(
            baseUrl: config.baseUrl!,
            apiFormat: config.apiFormat == 'claude'
                ? APIFormat.claude
                : APIFormat.openai,
          ),
        );
      } catch (_) {
        // 忽略无效配置
      }
    }
  }

  return generators;
}