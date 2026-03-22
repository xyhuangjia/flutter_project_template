// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for secure storage.

@ProviderFor(secureStorage)
final secureStorageProvider = SecureStorageProvider._();

/// Provider for secure storage.

final class SecureStorageProvider extends $FunctionalProvider<
    FlutterSecureStorage,
    FlutterSecureStorage,
    FlutterSecureStorage> with $Provider<FlutterSecureStorage> {
  /// Provider for secure storage.
  SecureStorageProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'secureStorageProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$secureStorageHash();

  @$internal
  @override
  $ProviderElement<FlutterSecureStorage> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FlutterSecureStorage create(Ref ref) {
    return secureStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FlutterSecureStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FlutterSecureStorage>(value),
    );
  }
}

String _$secureStorageHash() => r'39b6a2355a8398a2c25bb6e7dd3111ede1fc9c9b';

/// Provider for AI configuration management.

@ProviderFor(AIConfigNotifier)
final aIConfigProvider = AIConfigNotifierProvider._();

/// Provider for AI configuration management.
final class AIConfigNotifierProvider
    extends $AsyncNotifierProvider<AIConfigNotifier, AIConfigState> {
  /// Provider for AI configuration management.
  AIConfigNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'aIConfigProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$aIConfigNotifierHash();

  @$internal
  @override
  AIConfigNotifier create() => AIConfigNotifier();
}

String _$aIConfigNotifierHash() => r'9dffc2acb6310d36910f8e4b6b48c1048408df47';

/// Provider for AI configuration management.

abstract class _$AIConfigNotifier extends $AsyncNotifier<AIConfigState> {
  FutureOr<AIConfigState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AIConfigState>, AIConfigState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<AIConfigState>, AIConfigState>,
        AsyncValue<AIConfigState>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// Provider for available AI models.

@ProviderFor(availableModels)
final availableModelsProvider = AvailableModelsProvider._();

/// Provider for available AI models.

final class AvailableModelsProvider extends $FunctionalProvider<
    List<AIModelInfo>,
    List<AIModelInfo>,
    List<AIModelInfo>> with $Provider<List<AIModelInfo>> {
  /// Provider for available AI models.
  AvailableModelsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'availableModelsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$availableModelsHash();

  @$internal
  @override
  $ProviderElement<List<AIModelInfo>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<AIModelInfo> create(Ref ref) {
    return availableModels(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<AIModelInfo> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<AIModelInfo>>(value),
    );
  }
}

String _$availableModelsHash() => r'bdc3a391deee831517a9842d6db60d6171099e39';
