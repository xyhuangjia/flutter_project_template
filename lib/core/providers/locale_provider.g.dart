// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Async SharedPreferences provider for initialization.

@ProviderFor(SharedPrefs)
const sharedPrefsProvider = SharedPrefsProvider._();

/// Async SharedPreferences provider for initialization.
final class SharedPrefsProvider
    extends $AsyncNotifierProvider<SharedPrefs, SharedPreferences> {
  /// Async SharedPreferences provider for initialization.
  const SharedPrefsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPrefsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPrefsHash();

  @$internal
  @override
  SharedPrefs create() => SharedPrefs();
}

String _$sharedPrefsHash() => r'74f4f8751b28b55d7d21780ebae5ce2a6826ca2a';

/// Async SharedPreferences provider for initialization.

abstract class _$SharedPrefs extends $AsyncNotifier<SharedPreferences> {
  FutureOr<SharedPreferences> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<SharedPreferences>, SharedPreferences>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SharedPreferences>, SharedPreferences>,
              AsyncValue<SharedPreferences>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Locale notifier provider for managing app locale.
///
/// Supports:
/// - English (en)
/// - Chinese (zh)
/// - System default (null)

@ProviderFor(LocaleNotifier)
const localeProvider = LocaleNotifierProvider._();

/// Locale notifier provider for managing app locale.
///
/// Supports:
/// - English (en)
/// - Chinese (zh)
/// - System default (null)
final class LocaleNotifierProvider
    extends $AsyncNotifierProvider<LocaleNotifier, Locale?> {
  /// Locale notifier provider for managing app locale.
  ///
  /// Supports:
  /// - English (en)
  /// - Chinese (zh)
  /// - System default (null)
  const LocaleNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeNotifierHash();

  @$internal
  @override
  LocaleNotifier create() => LocaleNotifier();
}

String _$localeNotifierHash() => r'68590ac802d9acd5af5725061719261d12b37c08';

/// Locale notifier provider for managing app locale.
///
/// Supports:
/// - English (en)
/// - Chinese (zh)
/// - System default (null)

abstract class _$LocaleNotifier extends $AsyncNotifier<Locale?> {
  FutureOr<Locale?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Locale?>, Locale?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Locale?>, Locale?>,
              AsyncValue<Locale?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
