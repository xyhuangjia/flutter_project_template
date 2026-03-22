// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for ForgotPasswordRepository.

@ProviderFor(forgotPasswordRepository)
final forgotPasswordRepositoryProvider = ForgotPasswordRepositoryProvider._();

/// Provider for ForgotPasswordRepository.

final class ForgotPasswordRepositoryProvider extends $FunctionalProvider<
    ForgotPasswordRepository,
    ForgotPasswordRepository,
    ForgotPasswordRepository> with $Provider<ForgotPasswordRepository> {
  /// Provider for ForgotPasswordRepository.
  ForgotPasswordRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'forgotPasswordRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$forgotPasswordRepositoryHash();

  @$internal
  @override
  $ProviderElement<ForgotPasswordRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ForgotPasswordRepository create(Ref ref) {
    return forgotPasswordRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ForgotPasswordRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ForgotPasswordRepository>(value),
    );
  }
}

String _$forgotPasswordRepositoryHash() =>
    r'7e76612a66e344480ba0ef3f707d71f3cfb4909e';

/// Forgot password state notifier provider.
///
/// Manages the forgot password flow state.

@ProviderFor(ForgotPasswordNotifier)
final forgotPasswordProvider = ForgotPasswordNotifierProvider._();

/// Forgot password state notifier provider.
///
/// Manages the forgot password flow state.
final class ForgotPasswordNotifierProvider
    extends $NotifierProvider<ForgotPasswordNotifier, ForgotPasswordState> {
  /// Forgot password state notifier provider.
  ///
  /// Manages the forgot password flow state.
  ForgotPasswordNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'forgotPasswordProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$forgotPasswordNotifierHash();

  @$internal
  @override
  ForgotPasswordNotifier create() => ForgotPasswordNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ForgotPasswordState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ForgotPasswordState>(value),
    );
  }
}

String _$forgotPasswordNotifierHash() =>
    r'7e044ed22c313f822b9e67a7ddc94f2bf8141221';

/// Forgot password state notifier provider.
///
/// Manages the forgot password flow state.

abstract class _$ForgotPasswordNotifier extends $Notifier<ForgotPasswordState> {
  ForgotPasswordState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ForgotPasswordState, ForgotPasswordState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ForgotPasswordState, ForgotPasswordState>,
        ForgotPasswordState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
