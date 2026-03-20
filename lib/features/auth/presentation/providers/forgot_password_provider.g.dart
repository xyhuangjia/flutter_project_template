// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$forgotPasswordRepositoryHash() =>
    r'd425cb74206c16014eee19cff011c91cd3456bb4';

/// Provider for ForgotPasswordRepository.
///
/// Copied from [forgotPasswordRepository].
@ProviderFor(forgotPasswordRepository)
final forgotPasswordRepositoryProvider =
    AutoDisposeProvider<ForgotPasswordRepository>.internal(
  forgotPasswordRepository,
  name: r'forgotPasswordRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$forgotPasswordRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ForgotPasswordRepositoryRef
    = AutoDisposeProviderRef<ForgotPasswordRepository>;
String _$forgotPasswordNotifierHash() =>
    r'319f9760260e257815d66a615085a400ae5d9322';

/// Forgot password state notifier provider.
///
/// Manages the forgot password flow state.
///
/// Copied from [ForgotPasswordNotifier].
@ProviderFor(ForgotPasswordNotifier)
final forgotPasswordNotifierProvider = AutoDisposeNotifierProvider<
    ForgotPasswordNotifier, ForgotPasswordState>.internal(
  ForgotPasswordNotifier.new,
  name: r'forgotPasswordNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$forgotPasswordNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ForgotPasswordNotifier = AutoDisposeNotifier<ForgotPasswordState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
