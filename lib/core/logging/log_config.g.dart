// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LogUploadConfig _$LogUploadConfigFromJson(Map<String, dynamic> json) =>
    _LogUploadConfig(
      uploadUrl: json['uploadUrl'] as String,
      headers: (json['headers'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      autoUpload: json['autoUpload'] as bool? ?? false,
      batchSize: (json['batchSize'] as num?)?.toInt() ?? 100,
      uploadIntervalMinutes:
          (json['uploadIntervalMinutes'] as num?)?.toInt() ?? 30,
      wifiOnly: json['wifiOnly'] as bool? ?? true,
    );

Map<String, dynamic> _$LogUploadConfigToJson(_LogUploadConfig instance) =>
    <String, dynamic>{
      'uploadUrl': instance.uploadUrl,
      'headers': instance.headers,
      'autoUpload': instance.autoUpload,
      'batchSize': instance.batchSize,
      'uploadIntervalMinutes': instance.uploadIntervalMinutes,
      'wifiOnly': instance.wifiOnly,
    };

_LogStorageConfig _$LogStorageConfigFromJson(Map<String, dynamic> json) =>
    _LogStorageConfig(
      maxCapacity: (json['maxCapacity'] as num?)?.toInt() ?? 1000,
      maxFileSize: (json['maxFileSize'] as num?)?.toInt() ?? 5242880,
      retentionPeriod: $enumDecodeNullable(
              _$LogRetentionPeriodEnumMap, json['retentionPeriod']) ??
          LogRetentionPeriod.thirtyDays,
      enableFileLogging: json['enableFileLogging'] as bool? ?? true,
      enableHiveLogging: json['enableHiveLogging'] as bool? ?? true,
      bufferSize: (json['bufferSize'] as num?)?.toInt() ?? 0,
      flushOnError: json['flushOnError'] as bool? ?? true,
    );

Map<String, dynamic> _$LogStorageConfigToJson(_LogStorageConfig instance) =>
    <String, dynamic>{
      'maxCapacity': instance.maxCapacity,
      'maxFileSize': instance.maxFileSize,
      'retentionPeriod': _$LogRetentionPeriodEnumMap[instance.retentionPeriod]!,
      'enableFileLogging': instance.enableFileLogging,
      'enableHiveLogging': instance.enableHiveLogging,
      'bufferSize': instance.bufferSize,
      'flushOnError': instance.flushOnError,
    };

const _$LogRetentionPeriodEnumMap = {
  LogRetentionPeriod.oneDay: 'oneDay',
  LogRetentionPeriod.threeDays: 'threeDays',
  LogRetentionPeriod.sevenDays: 'sevenDays',
  LogRetentionPeriod.fourteenDays: 'fourteenDays',
  LogRetentionPeriod.thirtyDays: 'thirtyDays',
  LogRetentionPeriod.ninetyDays: 'ninetyDays',
};

_LogConfig _$LogConfigFromJson(Map<String, dynamic> json) => _LogConfig(
      storage: json['storage'] == null
          ? const LogStorageConfig()
          : LogStorageConfig.fromJson(json['storage'] as Map<String, dynamic>),
      upload: json['upload'] == null
          ? null
          : LogUploadConfig.fromJson(json['upload'] as Map<String, dynamic>),
      enabled: json['enabled'] as bool? ?? true,
      logLevel: $enumDecodeNullable(_$AppLogLevelEnumMap, json['logLevel']) ??
          AppLogLevel.info,
      logName: json['logName'] as String? ?? 'app_logs',
    );

Map<String, dynamic> _$LogConfigToJson(_LogConfig instance) =>
    <String, dynamic>{
      'storage': instance.storage,
      'upload': instance.upload,
      'enabled': instance.enabled,
      'logLevel': _$AppLogLevelEnumMap[instance.logLevel]!,
      'logName': instance.logName,
    };

const _$AppLogLevelEnumMap = {
  AppLogLevel.verbose: 'verbose',
  AppLogLevel.debug: 'debug',
  AppLogLevel.info: 'info',
  AppLogLevel.warning: 'warning',
  AppLogLevel.error: 'error',
  AppLogLevel.critical: 'critical',
  AppLogLevel.none: 'none',
};
