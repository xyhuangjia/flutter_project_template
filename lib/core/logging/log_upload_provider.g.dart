// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_upload_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 日志配置 Provider。
///
/// 提供 LogConfig 实例，可在外部覆盖配置。

@ProviderFor(logConfig)
final logConfigProvider = LogConfigProvider._();

/// 日志配置 Provider。
///
/// 提供 LogConfig 实例，可在外部覆盖配置。

final class LogConfigProvider
    extends $FunctionalProvider<LogConfig, LogConfig, LogConfig>
    with $Provider<LogConfig> {
  /// 日志配置 Provider。
  ///
  /// 提供 LogConfig 实例，可在外部覆盖配置。
  LogConfigProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'logConfigProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$logConfigHash();

  @$internal
  @override
  $ProviderElement<LogConfig> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LogConfig create(Ref ref) {
    return logConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LogConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LogConfig>(value),
    );
  }
}

String _$logConfigHash() => r'e3fab609d2e43195068bba1699410cf48e9e0571';

/// 日志持久化服务 Provider。

@ProviderFor(logPersistence)
final logPersistenceProvider = LogPersistenceProvider._();

/// 日志持久化服务 Provider。

final class LogPersistenceProvider extends $FunctionalProvider<
    LogPersistenceService?,
    LogPersistenceService?,
    LogPersistenceService?> with $Provider<LogPersistenceService?> {
  /// 日志持久化服务 Provider。
  LogPersistenceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'logPersistenceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$logPersistenceHash();

  @$internal
  @override
  $ProviderElement<LogPersistenceService?> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LogPersistenceService? create(Ref ref) {
    return logPersistence(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LogPersistenceService? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LogPersistenceService?>(value),
    );
  }
}

String _$logPersistenceHash() => r'e0ba5fd95c4a8a0e3972c0ab9c24a7f12935d40a';

/// 日志上传服务 Provider。

@ProviderFor(logUploadService)
final logUploadServiceProvider = LogUploadServiceProvider._();

/// 日志上传服务 Provider。

final class LogUploadServiceProvider extends $FunctionalProvider<
    LogUploadService?,
    LogUploadService?,
    LogUploadService?> with $Provider<LogUploadService?> {
  /// 日志上传服务 Provider。
  LogUploadServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'logUploadServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$logUploadServiceHash();

  @$internal
  @override
  $ProviderElement<LogUploadService?> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LogUploadService? create(Ref ref) {
    return logUploadService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LogUploadService? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LogUploadService?>(value),
    );
  }
}

String _$logUploadServiceHash() => r'0503f28a429450ccb7d03af4a5ac1e03840c146d';

/// 日志上传状态管理器。
///
/// 管理日志上传的状态，提供手动上传和自动上传功能。

@ProviderFor(LogUploadNotifier)
final logUploadProvider = LogUploadNotifierProvider._();

/// 日志上传状态管理器。
///
/// 管理日志上传的状态，提供手动上传和自动上传功能。
final class LogUploadNotifierProvider
    extends $NotifierProvider<LogUploadNotifier, LogUploadState> {
  /// 日志上传状态管理器。
  ///
  /// 管理日志上传的状态，提供手动上传和自动上传功能。
  LogUploadNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'logUploadProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$logUploadNotifierHash();

  @$internal
  @override
  LogUploadNotifier create() => LogUploadNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LogUploadState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LogUploadState>(value),
    );
  }
}

String _$logUploadNotifierHash() => r'9b31a14c24ca7762f3b234185abde25485ca3d34';

/// 日志上传状态管理器。
///
/// 管理日志上传的状态，提供手动上传和自动上传功能。

abstract class _$LogUploadNotifier extends $Notifier<LogUploadState> {
  LogUploadState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<LogUploadState, LogUploadState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<LogUploadState, LogUploadState>,
        LogUploadState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
