// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plugin_registry_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(pluginRegistry)
final pluginRegistryProvider = PluginRegistryProvider._();

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

final class PluginRegistryProvider extends $FunctionalProvider<IMPluginRegistry,
    IMPluginRegistry, IMPluginRegistry> with $Provider<IMPluginRegistry> {
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
  PluginRegistryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'pluginRegistryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$pluginRegistryHash();

  @$internal
  @override
  $ProviderElement<IMPluginRegistry> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IMPluginRegistry create(Ref ref) {
    return pluginRegistry(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IMPluginRegistry value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IMPluginRegistry>(value),
    );
  }
}

String _$pluginRegistryHash() => r'30398479727608325ff1db1b12d68081f46ae6df';
