// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPrefsHash() => r'74f4f8751b28b55d7d21780ebae5ce2a6826ca2a';

/// Async SharedPreferences provider for initialization.
///
/// Copied from [SharedPrefs].
@ProviderFor(SharedPrefs)
final sharedPrefsProvider =
    AutoDisposeAsyncNotifierProvider<SharedPrefs, SharedPreferences>.internal(
  SharedPrefs.new,
  name: r'sharedPrefsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sharedPrefsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SharedPrefs = AutoDisposeAsyncNotifier<SharedPreferences>;
String _$localeNotifierHash() => r'68590ac802d9acd5af5725061719261d12b37c08';

/// Locale notifier provider for managing app locale.
///
/// Supports:
/// - English (en)
/// - Chinese (zh)
/// - System default (null)
///
/// Copied from [LocaleNotifier].
@ProviderFor(LocaleNotifier)
final localeNotifierProvider =
    AutoDisposeAsyncNotifierProvider<LocaleNotifier, Locale?>.internal(
  LocaleNotifier.new,
  name: r'localeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LocaleNotifier = AutoDisposeAsyncNotifier<Locale?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
