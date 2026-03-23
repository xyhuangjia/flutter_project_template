/// 日志上传状态管理。
///
/// 使用 Riverpod 管理日志上传的状态和操作。
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_project_template/core/logging/log_config.dart';
import 'package:flutter_project_template/core/logging/log_persistence_service.dart';
import 'package:flutter_project_template/core/logging/log_upload_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'log_upload_provider.g.dart';

/// 日志上传状态。
enum LogUploadStatus {
  /// 空闲状态。
  idle,

  /// 正在上传。
  uploading,

  /// 上传成功。
  success,

  /// 上传失败。
  error,
}

/// 日志上传状态数据。
class LogUploadState {
  /// 创建日志上传状态。
  const LogUploadState({
    this.status = LogUploadStatus.idle,
    this.message,
    this.uploadedCount = 0,
    this.totalCount = 0,
    this.lastUploadTime,
    this.error,
  });

  /// 当前上传状态。
  final LogUploadStatus status;

  /// 状态消息。
  final String? message;

  /// 已上传文件数。
  final int uploadedCount;

  /// 总文件数。
  final int totalCount;

  /// 最后上传时间。
  final DateTime? lastUploadTime;

  /// 错误信息。
  final String? error;

  /// 是否正在上传。
  bool get isUploading => status == LogUploadStatus.uploading;

  /// 是否有错误。
  bool get hasError => status == LogUploadStatus.error;

  /// 上传进度（0.0 - 1.0）。
  double get progress {
    if (totalCount == 0) return 0;
    return uploadedCount / totalCount;
  }

  /// 复制并更新状态。
  LogUploadState copyWith({
    LogUploadStatus? status,
    String? message,
    int? uploadedCount,
    int? totalCount,
    DateTime? lastUploadTime,
    String? error,
  }) => LogUploadState(
        status: status ?? this.status,
        message: message ?? this.message,
        uploadedCount: uploadedCount ?? this.uploadedCount,
        totalCount: totalCount ?? this.totalCount,
        lastUploadTime: lastUploadTime ?? this.lastUploadTime,
        error: error,
      );
}

/// 日志配置 Provider。
///
/// 提供 LogConfig 实例，可在外部覆盖配置。
@riverpod
LogConfig logConfig(Ref ref) => const LogConfig();

/// 日志持久化服务 Provider。
@riverpod
LogPersistenceService? logPersistence(Ref ref) {
  final config = ref.watch(logConfigProvider);

  if (!config.storage.enableFileLogging) {
    return null;
  }

  final service = LogPersistenceService(
    config: config.storage,
    logName: config.logName,
  )..initialize();

  // 在 provider 销毁时清理资源
  ref.onDispose(() {
    debugPrint('日志持久化服务：Provider 已销毁');
  });

  return service;
}

/// 日志上传服务 Provider。
@riverpod
LogUploadService? logUploadService(Ref ref) {
  final config = ref.watch(logConfigProvider);

  if (config.upload == null) {
    return null;
  }

  final service = LogUploadService(config: config.upload!);

  ref.onDispose(() {
    service.dispose();
    debugPrint('日志上传服务：Provider 已销毁');
  });

  return service;
}

/// 日志上传状态管理器。
///
/// 管理日志上传的状态，提供手动上传和自动上传功能。
@riverpod
class LogUploadNotifier extends _$LogUploadNotifier {
  /// 自动上传定时器。
  Timer? _autoUploadTimer;

  @override
  LogUploadState build() {
    // 监听配置变化
    final config = ref.watch(logConfigProvider);

    // 如果启用了自动上传，启动定时器
    if (config.upload?.autoUpload ?? false) {
      _startAutoUpload(config.upload!.uploadIntervalMinutes);
    }

    // 清理定时器
    ref.onDispose(() {
      _autoUploadTimer?.cancel();
      debugPrint('日志上传管理器：定时器已取消');
    });

    return const LogUploadState();
  }

  /// 手动上传所有日志。
  ///
  /// [deleteAfterUpload] 上传成功后是否删除本地文件。
  /// 返回上传结果。
  Future<LogUploadResult> uploadLogs({
    bool deleteAfterUpload = false,
  }) async {
    final persistenceService = ref.read(logPersistenceProvider);
    final uploadService = ref.read(logUploadServiceProvider);

    if (persistenceService == null) {
      state = state.copyWith(
        status: LogUploadStatus.error,
        error: '日志持久化服务未初始化',
      );
      return const LogUploadFailure(error: '日志持久化服务未初始化');
    }

    if (uploadService == null) {
      state = state.copyWith(
        status: LogUploadStatus.error,
        error: '日志上传服务未配置',
      );
      return const LogUploadFailure(error: '日志上传服务未配置');
    }

    // 获取日志文件列表
    final logFiles = await persistenceService.getLogFiles();

    if (logFiles.isEmpty) {
      state = state.copyWith(
        status: LogUploadStatus.success,
        message: '没有日志文件需要上传',
        lastUploadTime: DateTime.now(),
      );
      return const LogUploadSuccess(uploadedFiles: [], totalBytes: 0);
    }

    // 更新状态为上传中
    state = state.copyWith(
      status: LogUploadStatus.uploading,
      message: '正在上传日志...',
      totalCount: logFiles.length,
      uploadedCount: 0,
    );

    try {
      // 执行上传
      final result = await uploadService.uploadFiles(
        files: logFiles,
        deleteAfterUpload: deleteAfterUpload,
      );

      // 更新状态
      if (result is LogUploadSuccess) {
        state = state.copyWith(
          status: LogUploadStatus.success,
          message: '成功上传 ${result.uploadedFiles.length} 个日志文件',
          uploadedCount: result.uploadedFiles.length,
          lastUploadTime: DateTime.now(),
        );
        debugPrint(
          '日志上传管理器：上传成功 - ${result.uploadedFiles.length} 个文件',
        );
      } else if (result is LogUploadFailure) {
        state = state.copyWith(
          status: LogUploadStatus.error,
          error: result.error,
          uploadedCount: result.uploadedFiles?.length ?? 0,
        );
        debugPrint('日志上传管理器：上传失败 - ${result.error}');
      }

      return result;
    } on Exception catch (e) {
      state = state.copyWith(
        status: LogUploadStatus.error,
        error: e.toString(),
      );
      debugPrint('日志上传管理器：上传异常 - $e');
      return LogUploadFailure(error: e.toString());
    }
  }

  /// 手动上传指定日志文件。
  ///
  /// [files] 要上传的文件列表。
  /// [deleteAfterUpload] 上传成功后是否删除本地文件。
  Future<LogUploadResult> uploadSpecificFiles({
    required List<File> files,
    bool deleteAfterUpload = false,
  }) async {
    final uploadService = ref.read(logUploadServiceProvider);

    if (uploadService == null) {
      state = state.copyWith(
        status: LogUploadStatus.error,
        error: '日志上传服务未配置',
      );
      return const LogUploadFailure(error: '日志上传服务未配置');
    }

    if (files.isEmpty) {
      return const LogUploadSuccess(uploadedFiles: [], totalBytes: 0);
    }

    // 更新状态
    state = state.copyWith(
      status: LogUploadStatus.uploading,
      message: '正在上传日志...',
      totalCount: files.length,
      uploadedCount: 0,
    );

    try {
      final result = await uploadService.uploadFiles(
        files: files,
        deleteAfterUpload: deleteAfterUpload,
      );

      if (result is LogUploadSuccess) {
        state = state.copyWith(
          status: LogUploadStatus.success,
          message: '成功上传 ${result.uploadedFiles.length} 个日志文件',
          uploadedCount: result.uploadedFiles.length,
          lastUploadTime: DateTime.now(),
        );
      } else if (result is LogUploadFailure) {
        state = state.copyWith(
          status: LogUploadStatus.error,
          error: result.error,
        );
      }

      return result;
    } on Exception catch (e) {
      state = state.copyWith(
        status: LogUploadStatus.error,
        error: e.toString(),
      );
      return LogUploadFailure(error: e.toString());
    }
  }

  /// 重置上传状态。
  void resetState() {
    state = const LogUploadState();
  }

  /// 启动自动上传定时器。
  void _startAutoUpload(int intervalMinutes) {
    _autoUploadTimer?.cancel();

    _autoUploadTimer = Timer.periodic(
      Duration(minutes: intervalMinutes),
      (_) {
        debugPrint('日志上传管理器：执行自动上传任务');
        uploadLogs();
      },
    );

    debugPrint('日志上传管理器：已启动自动上传定时器，间隔 $intervalMinutes 分钟');
  }

  /// 停止自动上传。
  void stopAutoUpload() {
    _autoUploadTimer?.cancel();
    _autoUploadTimer = null;
    debugPrint('日志上传管理器：已停止自动上传');
  }

  /// 重新启动自动上传。
  ///
  /// 使用当前配置的间隔时间。
  void restartAutoUpload() {
    final config = ref.read(logConfigProvider);
    if (config.upload?.autoUpload ?? false) {
      _startAutoUpload(config.upload!.uploadIntervalMinutes);
    }
  }

  /// 获取日志文件列表。
  Future<List<File>> getLogFiles() async {
    final persistenceService = ref.read(logPersistenceProvider);
    if (persistenceService == null) {
      return [];
    }
    return persistenceService.getLogFiles();
  }

  /// 删除所有本地日志。
  Future<void> deleteAllLogs() async {
    final persistenceService = ref.read(logPersistenceProvider);
    if (persistenceService != null) {
      await persistenceService.deleteAllLogs();
      debugPrint('日志上传管理器：已删除所有本地日志');
    }
  }
}
