// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$secureStorageHash() => r'3e5177aefc9c0d43d9cb4fdca3bdc2dfcb36f13e';

/// Provider for secure storage.
///
/// Copied from [secureStorage].
@ProviderFor(secureStorage)
final secureStorageProvider =
    AutoDisposeProvider<FlutterSecureStorage>.internal(
  secureStorage,
  name: r'secureStorageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$secureStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SecureStorageRef = AutoDisposeProviderRef<FlutterSecureStorage>;
String _$availableModelsHash() => r'18d96091e6ba77aab7d40d224b8f4a5ab173654d';

/// Provider for available AI models.
///
/// Copied from [availableModels].
@ProviderFor(availableModels)
final availableModelsProvider = AutoDisposeProvider<List<AIModelInfo>>.internal(
  availableModels,
  name: r'availableModelsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availableModelsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableModelsRef = AutoDisposeProviderRef<List<AIModelInfo>>;
String _$aIConfigNotifierHash() => r'1588873507c05d41f43cd2cccd3f18c4df8dad04';

/// Provider for AI configuration management.
///
/// Copied from [AIConfigNotifier].
@ProviderFor(AIConfigNotifier)
final aIConfigNotifierProvider =
    AutoDisposeAsyncNotifierProvider<AIConfigNotifier, AIConfigState>.internal(
  AIConfigNotifier.new,
  name: r'aIConfigNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$aIConfigNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AIConfigNotifier = AutoDisposeAsyncNotifier<AIConfigState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
