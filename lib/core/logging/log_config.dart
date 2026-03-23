/// 日志系统配置。
///
/// 定义日志系统的配置，包括上传设置、保留策略和存储选项。
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'log_config.freezed.dart';
part 'log_config.g.dart';

/// 日志保留周期枚举。
enum LogRetentionPeriod {
  /// 保留 1 天。
  oneDay(1),

  /// 保留 3 天。
  threeDays(3),

  /// 保留 7 天。
  sevenDays(7),

  /// 保留 14 天。
  fourteenDays(14),

  /// 保留 30 天。
  thirtyDays(30),

  /// 保留 90 天。
  ninetyDays(90);

  const LogRetentionPeriod(this.days);

  /// 保留天数。
  final int days;
}

/// HTTP 上传配置。
///
/// 配置日志上传到服务器的相关参数。
@freezed
sealed class LogUploadConfig with _$LogUploadConfig {
  const factory LogUploadConfig({
    /// 服务器 URL。
    /// 示例: 'https://api.example.com/logs/upload'
    required String uploadUrl,

    /// 自定义 HTTP 请求头。
    /// 示例: {'Authorization': 'Bearer token', 'X-API-Key': 'key'}
    @Default({}) Map<String, String> headers,

    /// 是否启用自动上传。
    @Default(false) bool autoUpload,

    /// 上传批量大小（每次请求的日志数量）。
    @Default(100) int batchSize,

    /// 自动上传间隔（分钟）。
    @Default(30) int uploadIntervalMinutes,

    /// 是否仅在 WiFi 下上传。
    @Default(true) bool wifiOnly,
  }) = _LogUploadConfig;

  factory LogUploadConfig.fromJson(Map<String, dynamic> json) =>
      _$LogUploadConfigFromJson(json);
}

/// 日志存储配置。
@freezed
sealed class LogStorageConfig with _$LogStorageConfig {
  const factory LogStorageConfig({
    /// 内存中保留的最大日志数量。
    @Default(1000) int maxCapacity,

    /// 最大文件大小（字节），默认 5MB。
    @Default(5242880) int maxFileSize,

    /// 日志保留周期。
    @Default(LogRetentionPeriod.thirtyDays) LogRetentionPeriod retentionPeriod,

    /// 是否启用文件日志。
    @Default(true) bool enableFileLogging,

    /// 是否启用 Hive 数据库日志。
    @Default(true) bool enableHiveLogging,

    /// 批量写入缓冲区大小（0 表示立即写入）。
    @Default(0) int bufferSize,

    /// 发生错误时是否立即刷新缓冲区。
    @Default(true) bool flushOnError,
  }) = _LogStorageConfig;

  factory LogStorageConfig.fromJson(Map<String, dynamic> json) =>
      _$LogStorageConfigFromJson(json);
}

/// 完整的日志系统配置。
@freezed
sealed class LogConfig with _$LogConfig {
  const factory LogConfig({
    /// 存储配置。
    @Default(LogStorageConfig()) LogStorageConfig storage,

    /// 上传配置（null 表示禁用上传）。
    LogUploadConfig? upload,

    /// 是否启用日志。
    @Default(true) bool enabled,

    /// 最低日志级别。
    @Default(AppLogLevel.info) AppLogLevel logLevel,

    /// 持久化存储的日志名称。
    @Default('app_logs') String logName,
  }) = _LogConfig;

  factory LogConfig.fromJson(Map<String, dynamic> json) =>
      _$LogConfigFromJson(json);
}

/// 应用日志级别枚举。
enum AppLogLevel {
  /// 详细日志 - 所有消息。
  verbose,

  /// 调试日志 - 调试及以上级别。
  debug,

  /// 信息日志 - 信息及以上级别。
  info,

  /// 警告日志 - 警告及以上级别。
  warning,

  /// 错误日志 - 错误及以上级别。
  error,

  /// 严重日志 - 仅严重错误。
  critical,

  /// 无日志。
  none;
}
