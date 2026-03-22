// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for chat local data source.

@ProviderFor(chatLocalDataSource)
final chatLocalDataSourceProvider = ChatLocalDataSourceProvider._();

/// Provider for chat local data source.

final class ChatLocalDataSourceProvider extends $FunctionalProvider<
    ChatLocalDataSource,
    ChatLocalDataSource,
    ChatLocalDataSource> with $Provider<ChatLocalDataSource> {
  /// Provider for chat local data source.
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

/// Provider for AI services registry.

@ProviderFor(aiServices)
final aiServicesProvider = AiServicesProvider._();

/// Provider for AI services registry.

final class AiServicesProvider extends $FunctionalProvider<
    Map<String, AIService>,
    Map<String, AIService>,
    Map<String, AIService>> with $Provider<Map<String, AIService>> {
  /// Provider for AI services registry.
  AiServicesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'aiServicesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$aiServicesHash();

  @$internal
  @override
  $ProviderElement<Map<String, AIService>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Map<String, AIService> create(Ref ref) {
    return aiServices(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, AIService> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, AIService>>(value),
    );
  }
}

String _$aiServicesHash() => r'10e1972a4420561e3ebd0b9b3c886a00a1fcc420';

/// Provider for managing chat conversations.

@ProviderFor(ChatNotifier)
final chatProvider = ChatNotifierProvider._();

/// Provider for managing chat conversations.
final class ChatNotifierProvider
    extends $AsyncNotifierProvider<ChatNotifier, ChatState> {
  /// Provider for managing chat conversations.
  ChatNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'chatProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$chatNotifierHash();

  @$internal
  @override
  ChatNotifier create() => ChatNotifier();
}

String _$chatNotifierHash() => r'd0ed4efa8d42750c1fe57bb56a36fd91e74d313a';

/// Provider for managing chat conversations.

abstract class _$ChatNotifier extends $AsyncNotifier<ChatState> {
  FutureOr<ChatState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ChatState>, ChatState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<ChatState>, ChatState>,
        AsyncValue<ChatState>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// Provider for checking if AI is typing.

@ProviderFor(IsTyping)
final isTypingProvider = IsTypingProvider._();

/// Provider for checking if AI is typing.
final class IsTypingProvider extends $NotifierProvider<IsTyping, bool> {
  /// Provider for checking if AI is typing.
  IsTypingProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'isTypingProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$isTypingHash();

  @$internal
  @override
  IsTyping create() => IsTyping();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isTypingHash() => r'80a930a55d0261d9781eb7bf2e3e664df378289d';

/// Provider for checking if AI is typing.

abstract class _$IsTyping extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<bool, bool>, bool, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

/// Provider for streaming message content.

@ProviderFor(StreamingMessage)
final streamingMessageProvider = StreamingMessageFamily._();

/// Provider for streaming message content.
final class StreamingMessageProvider
    extends $NotifierProvider<StreamingMessage, String> {
  /// Provider for streaming message content.
  StreamingMessageProvider._(
      {required StreamingMessageFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'streamingMessageProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$streamingMessageHash();

  @override
  String toString() {
    return r'streamingMessageProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  StreamingMessage create() => StreamingMessage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StreamingMessageProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$streamingMessageHash() => r'03f46eac658a965d3a64b05ce0b1740f81706a5f';

/// Provider for streaming message content.

final class StreamingMessageFamily extends $Family
    with
        $ClassFamilyOverride<StreamingMessage, String, String, String, String> {
  StreamingMessageFamily._()
      : super(
          retry: null,
          name: r'streamingMessageProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider for streaming message content.

  StreamingMessageProvider call(
    String messageId,
  ) =>
      StreamingMessageProvider._(argument: messageId, from: this);

  @override
  String toString() => r'streamingMessageProvider';
}

/// Provider for streaming message content.

abstract class _$StreamingMessage extends $Notifier<String> {
  late final _$args = ref.$arg as String;
  String get messageId => _$args;

  String build(
    String messageId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}

/// Provider for messages of a specific conversation.

@ProviderFor(conversationMessages)
final conversationMessagesProvider = ConversationMessagesFamily._();

/// Provider for messages of a specific conversation.

final class ConversationMessagesProvider extends $FunctionalProvider<
        AsyncValue<List<domain.ChatMessage>>,
        List<domain.ChatMessage>,
        Stream<List<domain.ChatMessage>>>
    with
        $FutureModifier<List<domain.ChatMessage>>,
        $StreamProvider<List<domain.ChatMessage>> {
  /// Provider for messages of a specific conversation.
  ConversationMessagesProvider._(
      {required ConversationMessagesFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'conversationMessagesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$conversationMessagesHash();

  @override
  String toString() {
    return r'conversationMessagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<domain.ChatMessage>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<domain.ChatMessage>> create(Ref ref) {
    final argument = this.argument as String;
    return conversationMessages(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ConversationMessagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$conversationMessagesHash() =>
    r'bbe4d0ed72e04d6b28cc5165ae6ec57b1ce9d55f';

/// Provider for messages of a specific conversation.

final class ConversationMessagesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<domain.ChatMessage>>, String> {
  ConversationMessagesFamily._()
      : super(
          retry: null,
          name: r'conversationMessagesProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider for messages of a specific conversation.

  ConversationMessagesProvider call(
    String conversationId,
  ) =>
      ConversationMessagesProvider._(argument: conversationId, from: this);

  @override
  String toString() => r'conversationMessagesProvider';
}

/// Provider for selected model in a conversation.

@ProviderFor(SelectedModel)
final selectedModelProvider = SelectedModelFamily._();

/// Provider for selected model in a conversation.
final class SelectedModelProvider
    extends $NotifierProvider<SelectedModel, String?> {
  /// Provider for selected model in a conversation.
  SelectedModelProvider._(
      {required SelectedModelFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'selectedModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$selectedModelHash();

  @override
  String toString() {
    return r'selectedModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SelectedModel create() => SelectedModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$selectedModelHash() => r'0350239a67555a244040fa2972875d337e0c7a6f';

/// Provider for selected model in a conversation.

final class SelectedModelFamily extends $Family
    with
        $ClassFamilyOverride<SelectedModel, String?, String?, String?, String> {
  SelectedModelFamily._()
      : super(
          retry: null,
          name: r'selectedModelProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider for selected model in a conversation.

  SelectedModelProvider call(
    String conversationId,
  ) =>
      SelectedModelProvider._(argument: conversationId, from: this);

  @override
  String toString() => r'selectedModelProvider';
}

/// Provider for selected model in a conversation.

abstract class _$SelectedModel extends $Notifier<String?> {
  late final _$args = ref.$arg as String;
  String get conversationId => _$args;

  String? build(
    String conversationId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String?, String?>, String?, Object?, Object?>;
    element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
