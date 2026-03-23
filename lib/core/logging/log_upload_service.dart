/// 日志上传服务。
///
/// 使用 Dio 将本地日志文件上传到服务器。
/// 支持配置服务器 URL、认证 Headers、重试机制等。
library;

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_project_template/core/logging/log_config.dart';

/// 日志上传结果。
sealed class LogUploadResult {
  const LogUploadResult();
}

/// 上传成功。
class LogUploadSuccess extends LogUploadResult {
  /// 创建上传成功结果。
  const LogUploadSuccess({
    required this.uploadedFiles,
    required this.totalBytes,
  });

  /// 成功上传的文件列表。
  final List<File> uploadedFiles;

  /// 上传的总字节数。
  final int totalBytes;
}

/// 上传失败。
class LogUploadFailure extends LogUploadResult {
  /// 创建上传失败结果。
  const LogUploadFailure({
    required this.error,
    this.failedFiles,
    this.uploadedFiles,
  });

  /// 错误信息。
  final String error;

  /// 上传失败的文件列表。
  final List<File>? failedFiles;

  /// 部分成功的文件列表（如果有）。
  final List<File>? uploadedFiles;
}

/// 日志上传服务。
///
/// 提供将日志文件上传到服务器的功能：
/// - 支持 multipart/form-data 文件上传
/// - 支持自定义 Headers（认证信息等）
/// - 支持重试机制（最多 3 次）
/// - 上传成功后可选择删除已上传日志
class LogUploadService {
  /// 创建日志上传服务实例。
  ///
  /// [config] 上传配置，包含服务器 URL、Headers 等。
  /// [dio] 可选的 Dio 实例，如果不提供则创建新实例。
  LogUploadService({
    required LogUploadConfig config,
    Dio? dio,
  })  : _config = config,
        _dio = dio ?? Dio(),
        _ownsDio = dio == null;

  /// 上传配置。
  final LogUploadConfig _config;

  /// Dio HTTP 客户端。
  final Dio _dio;

  /// 是否拥有 Dio 实例（用于判断是否需要在 dispose 时关闭）。
  final bool _ownsDio;

  /// 最大重试次数。
  static const int _maxRetries = 3;

  /// 重试延迟（毫秒）。
  static const int _retryDelayMs = 1000;

  /// 上传单个日志文件。
  ///
  /// [file] 要上传的日志文件。
  /// 返回上传结果。
  Future<LogUploadResult> uploadFile(File file) =>
      _uploadWithRetry(() => _uploadSingleFile(file));

  /// 批量上传日志文件。
  ///
  /// [files] 要上传的日志文件列表。
  /// [deleteAfterUpload] 上传成功后是否删除文件。
  /// 返回上传结果。
  Future<LogUploadResult> uploadFiles({
    required List<File> files,
    bool deleteAfterUpload = false,
  }) async {
    if (files.isEmpty) {
      return const LogUploadSuccess(uploadedFiles: [], totalBytes: 0);
    }

    final uploadedFiles = <File>[];
    final failedFiles = <File>[];
    var totalBytes = 0;

    for (final file in files) {
      final result = await uploadFile(file);

      if (result is LogUploadSuccess) {
        uploadedFiles.add(file);
        totalBytes += result.totalBytes;

        // 上传成功后删除文件
        if (deleteAfterUpload) {
          try {
            await file.delete();
            debugPrint('日志上传服务：已删除上传成功的日志文件 ${file.path}');
          } on Exception catch (e) {
            debugPrint('日志上传服务：删除日志文件失败 - $e');
          }
        }
      } else if (result is LogUploadFailure) {
        failedFiles.add(file);
      }
    }

    // 全部成功
    if (failedFiles.isEmpty) {
      return LogUploadSuccess(
        uploadedFiles: uploadedFiles,
        totalBytes: totalBytes,
      );
    }

    // 全部失败
    if (uploadedFiles.isEmpty) {
      return LogUploadFailure(
        error: '所有文件上传失败',
        failedFiles: failedFiles,
      );
    }

    // 部分成功
    return LogUploadFailure(
      error: '${failedFiles.length} 个文件上传失败',
      failedFiles: failedFiles,
      uploadedFiles: uploadedFiles,
    );
  }

  /// 上传所有日志文件。
  ///
  /// [logFiles] 日志文件列表。
  /// [deleteAfterUpload] 上传成功后是否删除文件。
  /// 返回上传结果。
  Future<LogUploadResult> uploadAllLogs({
    required List<File> logFiles,
    bool deleteAfterUpload = false,
  }) => uploadFiles(files: logFiles, deleteAfterUpload: deleteAfterUpload);

  /// 带重试机制的上传操作。
  Future<LogUploadResult> _uploadWithRetry(
    Future<LogUploadResult> Function() uploadOperation,
  ) async {
    var lastError = '未知错误';

    for (var attempt = 1; attempt <= _maxRetries; attempt++) {
      try {
        return await uploadOperation();
      } on Exception catch (e) {
        lastError = e.toString();
        debugPrint('日志上传服务：上传失败（第 $attempt 次尝试）- $e');

        if (attempt < _maxRetries) {
          // 等待后重试
          await Future<void>.delayed(
            Duration(milliseconds: _retryDelayMs * attempt),
          );
        }
      }
    }

    return LogUploadFailure(
      error: '上传失败，已重试 $_maxRetries 次: $lastError',
    );
  }

  /// 上传单个文件。
  Future<LogUploadResult> _uploadSingleFile(File file) async {
    if (!await file.exists()) {
      return LogUploadFailure(error: '文件不存在: ${file.path}');
    }

    final fileSize = await file.length();
    final fileName = file.path.split('/').last;

    try {
      // 创建 multipart/form-data 请求
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
        'filename': fileName,
        'size': fileSize,
      });

      // 发送上传请求
      final response = await _dio.post<dynamic>(
        _config.uploadUrl,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            ..._config.headers,
          },
        ),
      );

      // 检查响应状态
      if (response.statusCode == null ||
          response.statusCode! < 200 ||
          response.statusCode! >= 300) {
        return LogUploadFailure(
          error: '服务器返回错误状态: ${response.statusCode}',
        );
      }

      debugPrint('日志上传服务：文件上传成功 $fileName ($fileSize bytes)');
      return LogUploadSuccess(uploadedFiles: [file], totalBytes: fileSize);
    } on DioException catch (e) {
      final errorMessage = _getDioErrorMessage(e);
      debugPrint('日志上传服务：Dio 异常 - $errorMessage');
      return LogUploadFailure(error: errorMessage);
    } on Exception catch (e) {
      debugPrint('日志上传服务：上传异常 - $e');
      return LogUploadFailure(error: e.toString());
    }
  }

  /// 获取 Dio 异常的错误信息。
  String _getDioErrorMessage(DioException e) => switch (e.type) {
        DioExceptionType.connectionTimeout => '连接超时',
        DioExceptionType.sendTimeout => '发送超时',
        DioExceptionType.receiveTimeout => '接收超时',
        DioExceptionType.badCertificate => '证书错误',
        DioExceptionType.badResponse => '服务器返回错误: ${e.response?.statusCode}',
        DioExceptionType.cancel => '请求已取消',
        DioExceptionType.connectionError => '连接错误: ${e.message}',
        DioExceptionType.unknown => '未知错误: ${e.message}',
      };

  /// 释放资源。
  ///
  /// 仅当 Dio 实例是内部创建时才会关闭它。
  /// 如果传入了外部的 Dio 实例，调用者需要自行管理其生命周期。
  void dispose() {
    if (_ownsDio) {
      _dio.close();
    }
  }
}
