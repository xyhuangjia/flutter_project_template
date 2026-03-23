// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_generator_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 响应生成器管理器 Provider。

@ProviderFor(responseGeneratorManager)
final responseGeneratorManagerProvider = ResponseGeneratorManagerProvider._();

/// 响应生成器管理器 Provider。

final class ResponseGeneratorManagerProvider extends $FunctionalProvider<
    ResponseGeneratorManager,
    ResponseGeneratorManager,
    ResponseGeneratorManager> with $Provider<ResponseGeneratorManager> {
  /// 响应生成器管理器 Provider。
  ResponseGeneratorManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'responseGeneratorManagerProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$responseGeneratorManagerHash();

  @$internal
  @override
  $ProviderElement<ResponseGeneratorManager> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ResponseGeneratorManager create(Ref ref) {
    return responseGeneratorManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResponseGeneratorManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResponseGeneratorManager>(value),
    );
  }
}

String _$responseGeneratorManagerHash() =>
    r'b1fd066e7f0cad5b35e6f7ca863cafa0d6640ad2';

/// 默认响应生成器 Provider。
///
/// 根据默认 AI 配置创建响应生成器。

@ProviderFor(defaultResponseGenerator)
final defaultResponseGeneratorProvider = DefaultResponseGeneratorProvider._();

/// 默认响应生成器 Provider。
///
/// 根据默认 AI 配置创建响应生成器。

final class DefaultResponseGeneratorProvider extends $FunctionalProvider<
    AIResponseGenerator?,
    AIResponseGenerator?,
    AIResponseGenerator?> with $Provider<AIResponseGenerator?> {
  /// 默认响应生成器 Provider。
  ///
  /// 根据默认 AI 配置创建响应生成器。
  DefaultResponseGeneratorProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'defaultResponseGeneratorProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$defaultResponseGeneratorHash();

  @$internal
  @override
  $ProviderElement<AIResponseGenerator?> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AIResponseGenerator? create(Ref ref) {
    return defaultResponseGenerator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AIResponseGenerator? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AIResponseGenerator?>(value),
    );
  }
}

String _$defaultResponseGeneratorHash() =>
    r'a3007eaf81d1c9cd4706bd9cc4f0df9b7ec4c7cb';

/// 可用的响应生成器列表 Provider。

@ProviderFor(availableGenerators)
final availableGeneratorsProvider = AvailableGeneratorsProvider._();

/// 可用的响应生成器列表 Provider。

final class AvailableGeneratorsProvider extends $FunctionalProvider<
    List<AIResponseGenerator>,
    List<AIResponseGenerator>,
    List<AIResponseGenerator>> with $Provider<List<AIResponseGenerator>> {
  /// 可用的响应生成器列表 Provider。
  AvailableGeneratorsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'availableGeneratorsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$availableGeneratorsHash();

  @$internal
  @override
  $ProviderElement<List<AIResponseGenerator>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<AIResponseGenerator> create(Ref ref) {
    return availableGenerators(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<AIResponseGenerator> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<AIResponseGenerator>>(value),
    );
  }
}

String _$availableGeneratorsHash() =>
    r'4a7f56d543119bee7c87eef0016729305f3b7f50';
