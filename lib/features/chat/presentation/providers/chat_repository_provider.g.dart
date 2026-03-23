// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 聊天本地数据源 Provider。

@ProviderFor(chatLocalDataSource)
final chatLocalDataSourceProvider = ChatLocalDataSourceProvider._();

/// 聊天本地数据源 Provider。

final class ChatLocalDataSourceProvider extends $FunctionalProvider<
    ChatLocalDataSource,
    ChatLocalDataSource,
    ChatLocalDataSource> with $Provider<ChatLocalDataSource> {
  /// 聊天本地数据源 Provider。
  ChatLocalDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'chatLocalDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$chatLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<ChatLocalDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatLocalDataSource create(Ref ref) {
    return chatLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatLocalDataSource>(value),
    );
  }
}

String _$chatLocalDataSourceHash() =>
    r'c9f1e2563ea6e753c023161bf60bf458c0f35ffd';

/// 聊天仓库 Provider。

@ProviderFor(chatRepository)
final chatRepositoryProvider = ChatRepositoryProvider._();

/// 聊天仓库 Provider。

final class ChatRepositoryProvider
    extends $FunctionalProvider<ChatRepository, ChatRepository, ChatRepository>
    with $Provider<ChatRepository> {
  /// 聊天仓库 Provider。
  ChatRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'chatRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$chatRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatRepository create(Ref ref) {
    return chatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRepository>(value),
    );
  }
}

String _$chatRepositoryHash() => r'57c04ede88d97a1a16ec86f9c48b87af0be29e39';
