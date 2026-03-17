// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$greetingMessageHash() => r'23be66f00ce17b97edecd46dbf9e78e0d1ceee2a';

/// Provider for greeting message based on time of day.
///
/// Copied from [greetingMessage].
@ProviderFor(greetingMessage)
final greetingMessageProvider = AutoDisposeProvider<String>.internal(
  greetingMessage,
  name: r'greetingMessageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$greetingMessageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GreetingMessageRef = AutoDisposeProviderRef<String>;
String _$homeNotifierHash() => r'd56d28abe592461e33f2fa1083cefcbc829d35f6';

/// Home state notifier provider.
///
/// Manages the state for the home screen.
///
/// Copied from [HomeNotifier].
@ProviderFor(HomeNotifier)
final homeNotifierProvider =
    AutoDisposeAsyncNotifierProvider<HomeNotifier, HomeEntity>.internal(
  HomeNotifier.new,
  name: r'homeNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$homeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HomeNotifier = AutoDisposeAsyncNotifier<HomeEntity>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
