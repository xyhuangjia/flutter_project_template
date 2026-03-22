// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatSecureStorageHash() => r'f231af0507b6dc839387e6862a7e4c1195cb6ffb';

/// Provider for secure storage.
///
/// Copied from [chatSecureStorage].
@ProviderFor(chatSecureStorage)
final chatSecureStorageProvider =
    AutoDisposeProvider<FlutterSecureStorage>.internal(
  chatSecureStorage,
  name: r'chatSecureStorageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatSecureStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatSecureStorageRef = AutoDisposeProviderRef<FlutterSecureStorage>;
String _$chatLocalDataSourceHash() =>
    r'68ca93a59aa14902268932496c43cc395dc9b82a';

/// Provider for chat local data source.
///
/// Copied from [chatLocalDataSource].
@ProviderFor(chatLocalDataSource)
final chatLocalDataSourceProvider =
    AutoDisposeProvider<ChatLocalDataSource>.internal(
  chatLocalDataSource,
  name: r'chatLocalDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatLocalDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatLocalDataSourceRef = AutoDisposeProviderRef<ChatLocalDataSource>;
String _$aiServicesHash() => r'0b37c33fbec8d37b77fe8953971624678c0c5848';

/// Provider for AI services registry.
///
/// Copied from [aiServices].
@ProviderFor(aiServices)
final aiServicesProvider = AutoDisposeProvider<Map<String, AIService>>.internal(
  aiServices,
  name: r'aiServicesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$aiServicesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AiServicesRef = AutoDisposeProviderRef<Map<String, AIService>>;
String _$conversationMessagesHash() =>
    r'73449c3ade6abde7dab587820e517e584d819c4a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider for messages of a specific conversation.
///
/// Copied from [conversationMessages].
@ProviderFor(conversationMessages)
const conversationMessagesProvider = ConversationMessagesFamily();

/// Provider for messages of a specific conversation.
///
/// Copied from [conversationMessages].
class ConversationMessagesFamily
    extends Family<AsyncValue<List<domain.ChatMessage>>> {
  /// Provider for messages of a specific conversation.
  ///
  /// Copied from [conversationMessages].
  const ConversationMessagesFamily();

  /// Provider for messages of a specific conversation.
  ///
  /// Copied from [conversationMessages].
  ConversationMessagesProvider call(
    String conversationId,
  ) {
    return ConversationMessagesProvider(
      conversationId,
    );
  }

  @override
  ConversationMessagesProvider getProviderOverride(
    covariant ConversationMessagesProvider provider,
  ) {
    return call(
      provider.conversationId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'conversationMessagesProvider';
}

/// Provider for messages of a specific conversation.
///
/// Copied from [conversationMessages].
class ConversationMessagesProvider
    extends AutoDisposeStreamProvider<List<domain.ChatMessage>> {
  /// Provider for messages of a specific conversation.
  ///
  /// Copied from [conversationMessages].
  ConversationMessagesProvider(
    String conversationId,
  ) : this._internal(
          (ref) => conversationMessages(
            ref as ConversationMessagesRef,
            conversationId,
          ),
          from: conversationMessagesProvider,
          name: r'conversationMessagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$conversationMessagesHash,
          dependencies: ConversationMessagesFamily._dependencies,
          allTransitiveDependencies:
              ConversationMessagesFamily._allTransitiveDependencies,
          conversationId: conversationId,
        );

  ConversationMessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.conversationId,
  }) : super.internal();

  final String conversationId;

  @override
  Override overrideWith(
    Stream<List<domain.ChatMessage>> Function(ConversationMessagesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConversationMessagesProvider._internal(
        (ref) => create(ref as ConversationMessagesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        conversationId: conversationId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<domain.ChatMessage>> createElement() {
    return _ConversationMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConversationMessagesProvider &&
        other.conversationId == conversationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, conversationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ConversationMessagesRef
    on AutoDisposeStreamProviderRef<List<domain.ChatMessage>> {
  /// The parameter `conversationId` of this provider.
  String get conversationId;
}

class _ConversationMessagesProviderElement
    extends AutoDisposeStreamProviderElement<List<domain.ChatMessage>>
    with ConversationMessagesRef {
  _ConversationMessagesProviderElement(super.provider);

  @override
  String get conversationId =>
      (origin as ConversationMessagesProvider).conversationId;
}

String _$chatNotifierHash() => r'5cda27e93dbca39848d2db550b7c83041678c557';

/// Provider for managing chat conversations.
///
/// Copied from [ChatNotifier].
@ProviderFor(ChatNotifier)
final chatNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ChatNotifier, ChatState>.internal(
  ChatNotifier.new,
  name: r'chatNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatNotifier = AutoDisposeAsyncNotifier<ChatState>;
String _$isTypingHash() => r'80a930a55d0261d9781eb7bf2e3e664df378289d';

/// Provider for checking if AI is typing.
///
/// Copied from [IsTyping].
@ProviderFor(IsTyping)
final isTypingProvider = AutoDisposeNotifierProvider<IsTyping, bool>.internal(
  IsTyping.new,
  name: r'isTypingProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isTypingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IsTyping = AutoDisposeNotifier<bool>;
String _$streamingMessageHash() => r'03f46eac658a965d3a64b05ce0b1740f81706a5f';

abstract class _$StreamingMessage extends BuildlessAutoDisposeNotifier<String> {
  late final String messageId;

  String build(
    String messageId,
  );
}

/// Provider for streaming message content.
///
/// Copied from [StreamingMessage].
@ProviderFor(StreamingMessage)
const streamingMessageProvider = StreamingMessageFamily();

/// Provider for streaming message content.
///
/// Copied from [StreamingMessage].
class StreamingMessageFamily extends Family<String> {
  /// Provider for streaming message content.
  ///
  /// Copied from [StreamingMessage].
  const StreamingMessageFamily();

  /// Provider for streaming message content.
  ///
  /// Copied from [StreamingMessage].
  StreamingMessageProvider call(
    String messageId,
  ) {
    return StreamingMessageProvider(
      messageId,
    );
  }

  @override
  StreamingMessageProvider getProviderOverride(
    covariant StreamingMessageProvider provider,
  ) {
    return call(
      provider.messageId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'streamingMessageProvider';
}

/// Provider for streaming message content.
///
/// Copied from [StreamingMessage].
class StreamingMessageProvider
    extends AutoDisposeNotifierProviderImpl<StreamingMessage, String> {
  /// Provider for streaming message content.
  ///
  /// Copied from [StreamingMessage].
  StreamingMessageProvider(
    String messageId,
  ) : this._internal(
          () => StreamingMessage()..messageId = messageId,
          from: streamingMessageProvider,
          name: r'streamingMessageProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$streamingMessageHash,
          dependencies: StreamingMessageFamily._dependencies,
          allTransitiveDependencies:
              StreamingMessageFamily._allTransitiveDependencies,
          messageId: messageId,
        );

  StreamingMessageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.messageId,
  }) : super.internal();

  final String messageId;

  @override
  String runNotifierBuild(
    covariant StreamingMessage notifier,
  ) {
    return notifier.build(
      messageId,
    );
  }

  @override
  Override overrideWith(StreamingMessage Function() create) {
    return ProviderOverride(
      origin: this,
      override: StreamingMessageProvider._internal(
        () => create()..messageId = messageId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        messageId: messageId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<StreamingMessage, String> createElement() {
    return _StreamingMessageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StreamingMessageProvider && other.messageId == messageId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, messageId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StreamingMessageRef on AutoDisposeNotifierProviderRef<String> {
  /// The parameter `messageId` of this provider.
  String get messageId;
}

class _StreamingMessageProviderElement
    extends AutoDisposeNotifierProviderElement<StreamingMessage, String>
    with StreamingMessageRef {
  _StreamingMessageProviderElement(super.provider);

  @override
  String get messageId => (origin as StreamingMessageProvider).messageId;
}

String _$selectedModelHash() => r'0350239a67555a244040fa2972875d337e0c7a6f';

abstract class _$SelectedModel extends BuildlessAutoDisposeNotifier<String?> {
  late final String conversationId;

  String? build(
    String conversationId,
  );
}

/// Provider for selected model in a conversation.
///
/// Copied from [SelectedModel].
@ProviderFor(SelectedModel)
const selectedModelProvider = SelectedModelFamily();

/// Provider for selected model in a conversation.
///
/// Copied from [SelectedModel].
class SelectedModelFamily extends Family<String?> {
  /// Provider for selected model in a conversation.
  ///
  /// Copied from [SelectedModel].
  const SelectedModelFamily();

  /// Provider for selected model in a conversation.
  ///
  /// Copied from [SelectedModel].
  SelectedModelProvider call(
    String conversationId,
  ) {
    return SelectedModelProvider(
      conversationId,
    );
  }

  @override
  SelectedModelProvider getProviderOverride(
    covariant SelectedModelProvider provider,
  ) {
    return call(
      provider.conversationId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'selectedModelProvider';
}

/// Provider for selected model in a conversation.
///
/// Copied from [SelectedModel].
class SelectedModelProvider
    extends AutoDisposeNotifierProviderImpl<SelectedModel, String?> {
  /// Provider for selected model in a conversation.
  ///
  /// Copied from [SelectedModel].
  SelectedModelProvider(
    String conversationId,
  ) : this._internal(
          () => SelectedModel()..conversationId = conversationId,
          from: selectedModelProvider,
          name: r'selectedModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$selectedModelHash,
          dependencies: SelectedModelFamily._dependencies,
          allTransitiveDependencies:
              SelectedModelFamily._allTransitiveDependencies,
          conversationId: conversationId,
        );

  SelectedModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.conversationId,
  }) : super.internal();

  final String conversationId;

  @override
  String? runNotifierBuild(
    covariant SelectedModel notifier,
  ) {
    return notifier.build(
      conversationId,
    );
  }

  @override
  Override overrideWith(SelectedModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: SelectedModelProvider._internal(
        () => create()..conversationId = conversationId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        conversationId: conversationId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SelectedModel, String?> createElement() {
    return _SelectedModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedModelProvider &&
        other.conversationId == conversationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, conversationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SelectedModelRef on AutoDisposeNotifierProviderRef<String?> {
  /// The parameter `conversationId` of this provider.
  String get conversationId;
}

class _SelectedModelProviderElement
    extends AutoDisposeNotifierProviderElement<SelectedModel, String?>
    with SelectedModelRef {
  _SelectedModelProviderElement(super.provider);

  @override
  String get conversationId => (origin as SelectedModelProvider).conversationId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
