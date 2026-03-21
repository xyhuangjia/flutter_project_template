// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'developer_options_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeveloperOptionsDto _$DeveloperOptionsDtoFromJson(Map<String, dynamic> json) =>
    DeveloperOptionsDto(
      customApiBaseUrl: json['customApiBaseUrl'] as String?,
      logLevel: json['logLevel'] as String? ?? 'debug',
      loggingEnabled: json['loggingEnabled'] as bool? ?? true,
      networkLogEnabled: json['networkLogEnabled'] as bool? ?? true,
      performanceMonitorEnabled:
          json['performanceMonitorEnabled'] as bool? ?? false,
      showDebugInfo: json['showDebugInfo'] as bool? ?? false,
      experimentalFeatures:
          json['experimentalFeatures'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$DeveloperOptionsDtoToJson(
        DeveloperOptionsDto instance) =>
    <String, dynamic>{
      'customApiBaseUrl': instance.customApiBaseUrl,
      'logLevel': instance.logLevel,
      'loggingEnabled': instance.loggingEnabled,
      'networkLogEnabled': instance.networkLogEnabled,
      'performanceMonitorEnabled': instance.performanceMonitorEnabled,
      'showDebugInfo': instance.showDebugInfo,
      'experimentalFeatures': instance.experimentalFeatures,
    };
