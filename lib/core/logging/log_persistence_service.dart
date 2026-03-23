/// 日志持久化服务。
///
/// 基于 TalkerObserver 实现日志持久化，将日志写入本地文件。
/// 支持配置文件大小限制、保留天数等选项。
library;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_project_template/core/logging/log_config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talker/talker.dart' as talker;

/// 日志持久化服务。
///
/// 实现 [TalkerObserver] 接口，捕获所有日志条目并写入本地文件。
/// 支持以下功能：
/// - 自动创建日志目录
/// - 文件大小限制（超过限制自动创建新文件）
/// - 按日期清理过期日志
/// - 提供获取日志文件列表的方法
class LogPersistenceService implements talker.TalkerObserver {
  /// 创建日志持久化服务实例。
  ///
  /// [config] 存储配置，包含文件大小限制、保留天数等。
  /// [logName] 日志文件名称前缀，默认为 'app_logs'。
  LogPersistenceService({
    required LogStorageConfig config,
    String logName = 'app_logs',
  })  : _config = config,
        _logName = logName;

  /// 存储配置。
  final LogStorageConfig _config;

  /// 日志文件名称前缀。
  final String _logName;

  /// 当前日志文件的路径。
  String? _currentLogFilePath;

  /// 当前日志文件大小。
  int _currentFileSize = 0;

  /// 日志目录路径。
  String? _logDirectoryPath;

  /// 初始化日志持久化服务。
  ///
  /// 必须在使用前调用此方法进行初始化。
  /// 会创建日志目录并清理过期日志。
  Future<void> initialize() async {
    if (!_config.enableFileLogging) {
      debugPrint('日志持久化服务：文件日志已禁用');
      return;
    }

    try {
      // 获取应用文档目录
      final directory = await getApplicationDocumentsDirectory();
      _logDirectoryPath = '${directory.path}/logs';

      // 创建日志目录
      final logDir = Directory(_logDirectoryPath!);
      if (!await logDir.exists()) {
        await logDir.create(recursive: true);
        debugPrint('日志持久化服务：已创建日志目录 $_logDirectoryPath');
      }

      // 清理过期日志
      await _cleanExpiredLogs();

      // 获取或创建当前日志文件
      await _getOrCreateCurrentLogFile();

      debugPrint('日志持久化服务：初始化完成');
    } on Exception catch (e, stackTrace) {
      debugPrint('日志持久化服务：初始化失败 - $e');
      debugPrint('$stackTrace');
    }
  }

  /// 获取日志目录路径。
  ///
  /// 如果服务未初始化，返回 null。
  String? get logDirectoryPath => _logDirectoryPath;

  /// 获取当前日志文件路径。
  ///
  /// 如果服务未初始化，返回 null。
  String? get currentLogFilePath => _currentLogFilePath;

  /// 获取所有日志文件列表。
  ///
  /// 返回按修改时间降序排列的日志文件列表。
  /// 如果服务未初始化或目录不存在，返回空列表。
  Future<List<File>> getLogFiles() async {
    if (_logDirectoryPath == null) {
      return [];
    }

    try {
      final logDir = Directory(_logDirectoryPath!);
      if (!await logDir.exists()) {
        return [];
      }

      final files = await logDir
          .list()
          .where((entity) => entity is File && entity.path.endsWith('.log'))
          .cast<File>()
          .toList();

      // 按修改时间降序排序
      files.sort((a, b) {
        final aStat = a.statSync();
        final bStat = b.statSync();
        return bStat.modified.compareTo(aStat.modified);
      });

      return files;
    } on Exception catch (e) {
      debugPrint('日志持久化服务：获取日志文件列表失败 - $e');
      return [];
    }
  }

  /// 删除所有日志文件。
  ///
  /// 谨慎使用，此操作不可恢复。
  Future<void> deleteAllLogs() async {
    if (_logDirectoryPath == null) {
      return;
    }

    try {
      final logDir = Directory(_logDirectoryPath!);
      if (await logDir.exists()) {
        await logDir.delete(recursive: true);
        debugPrint('日志持久化服务：已删除所有日志文件');
      }

      // 重新创建目录和当前日志文件
      await initialize();
    } on Exception catch (e) {
      debugPrint('日志持久化服务：删除日志文件失败 - $e');
    }
  }

  /// 手动刷新日志缓冲区。
  ///
  /// 如果使用缓冲写入，调用此方法强制写入磁盘。
  Future<void> flush() async {
    // 当前实现使用同步写入，不需要刷新操作
    // 如果将来改为缓冲写入，可在此实现刷新逻辑
  }

  @override
  void onError(talker.TalkerError err) {
    _writeLogEntry(
      '[ERROR] ${err.message ?? "Unknown error"}\n'
      '${err.error ?? ""}\n'
      '${err.stackTrace ?? ""}',
    );

    // 如果配置了错误时刷新，则刷新缓冲区
    if (_config.flushOnError) {
      flush();
    }
  }

  @override
  void onException(talker.TalkerException err) {
    _writeLogEntry(
      '[EXCEPTION] ${err.message ?? "Unknown exception"}\n'
      '${err.exception ?? ""}\n'
      '${err.stackTrace ?? ""}',
    );

    // 如果配置了错误时刷新，则刷新缓冲区
    if (_config.flushOnError) {
      flush();
    }
  }

  @override
  void onLog(talker.TalkerData log) {
    final level = _getLogLevelString(log.logLevel);
    final timestamp =
        log.time.toIso8601String();
    final message = log.message?.toString() ?? '';

    _writeLogEntry('[$timestamp] [$level] $message');
  }

  /// 将日志级别转换为字符串。
  ///
  /// 使用 talker 包的 LogLevel 枚举。
  String _getLogLevelString(talker.LogLevel? level) => switch (level) {
        talker.LogLevel.verbose => 'VERBOSE',
        talker.LogLevel.debug => 'DEBUG',
        talker.LogLevel.info => 'INFO',
        talker.LogLevel.warning => 'WARNING',
        talker.LogLevel.error => 'ERROR',
        talker.LogLevel.critical => 'CRITICAL',
        null => 'INFO',
      };

  /// 写入日志条目到文件。
  void _writeLogEntry(String entry) {
    if (!_config.enableFileLogging || _currentLogFilePath == null) {
      return;
    }

    try {
      final file = File(_currentLogFilePath!);
      final content = '$entry\n';
      final bytes = content.length;

      // 检查文件大小限制
      if (_currentFileSize + bytes > _config.maxFileSize) {
        _createNewLogFile();
      }

      // 追加写入
      file.writeAsStringSync(content, mode: FileMode.append);
      _currentFileSize += bytes;
    } on Exception catch (e) {
      debugPrint('日志持久化服务：写入日志失败 - $e');
    }
  }

  /// 获取或创建当前日志文件。
  Future<void> _getOrCreateCurrentLogFile() async {
    if (_logDirectoryPath == null) {
      return;
    }

    try {
      final logDir = Directory(_logDirectoryPath!);
      final today = _getDateFileName();

      // 查找今天的日志文件
      final files = await logDir
          .list()
          .where((entity) => entity is File && entity.path.contains(today))
          .cast<File>()
          .toList();

      if (files.isNotEmpty) {
        // 使用最新的文件
        files.sort((a, b) => b.path.compareTo(a.path));
        _currentLogFilePath = files.first.path;
        _currentFileSize = files.first.lengthSync();
      } else {
        // 创建新文件
        await _createNewLogFile();
      }
    } on Exception catch (e) {
      debugPrint('日志持久化服务：获取日志文件失败 - $e');
      await _createNewLogFile();
    }
  }

  /// 创建新的日志文件。
  Future<void> _createNewLogFile() async {
    if (_logDirectoryPath == null) {
      return;
    }

    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    _currentLogFilePath = '$_logDirectoryPath/$_logName-$timestamp.log';
    _currentFileSize = 0;

    final file = File(_currentLogFilePath!);
    await file.create(recursive: true);

    debugPrint('日志持久化服务：创建新日志文件 $_currentLogFilePath');
  }

  /// 获取日期文件名部分。
  String _getDateFileName([DateTime? date]) {
    final d = date ?? DateTime.now();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}'
        '-${d.day.toString().padLeft(2, '0')}';
  }

  /// 清理过期日志。
  Future<void> _cleanExpiredLogs() async {
    if (_logDirectoryPath == null) {
      return;
    }

    try {
      final logDir = Directory(_logDirectoryPath!);
      if (!await logDir.exists()) {
        return;
      }

      final now = DateTime.now();
      final retentionDays = _config.retentionPeriod.days;
      final cutoffDate = now.subtract(Duration(days: retentionDays));

      final files = await logDir
          .list()
          .where((entity) => entity is File)
          .cast<File>()
          .toList();

      var deletedCount = 0;
      for (final file in files) {
        final stat = file.statSync();
        if (stat.modified.isBefore(cutoffDate)) {
          await file.delete();
          deletedCount++;
        }
      }

      if (deletedCount > 0) {
        debugPrint('日志持久化服务：已清理 $deletedCount 个过期日志文件');
      }
    } on Exception catch (e) {
      debugPrint('日志持久化服务：清理过期日志失败 - $e');
    }
  }
}
