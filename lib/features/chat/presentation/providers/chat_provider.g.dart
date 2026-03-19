// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatNotifierHash() => r'87976863d8452995525e8657c6b61f090315fd33';

/// Provider for managing chat conversations.
///
/// Copied from [ChatNotifier].
@ProviderFor(ChatNotifier)
final chatNotifierProvider = AutoDisposeAsyncNotifierProvider<ChatNotifier,
    List<ChatConversation>>.internal(
  ChatNotifier.new,
  name: r'chatNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatNotifier = AutoDisposeAsyncNotifier<List<ChatConversation>>;
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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
