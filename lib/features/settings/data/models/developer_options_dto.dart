/// Developer options DTO for serialization.
library;

import 'package:flutter_project_template/features/settings/domain/entities/developer_options.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'developer_options_dto.g.dart';

/// Developer options DTO.
@JsonSerializable()
class DeveloperOptionsDto {
  /// Creates developer options DTO.
  const DeveloperOptionsDto({
    this.customApiBaseUrl,
    this.logLevel = 'debug',
    this.loggingEnabled = true,
    this.networkLogEnabled = true,
    this.performanceMonitorEnabled = false,
    this.showDebugInfo = false,
    this.experimentalFeatures,
  });

  /// Creates DTO from JSON.
  factory DeveloperOptionsDto.fromJson(Map<String, dynamic> json) =>
      _$DeveloperOptionsDtoFromJson(json);

  /// Creates DTO from entity.
  factory DeveloperOptionsDto.fromEntity(DeveloperOptions entity) => DeveloperOptionsDto(
      customApiBaseUrl: entity.customApiBaseUrl,
      logLevel: entity.logLevel.name,
      loggingEnabled: entity.loggingEnabled,
      networkLogEnabled: entity.networkLogEnabled,
      performanceMonitorEnabled: entity.performanceMonitorEnabled,
      showDebugInfo: entity.showDebugInfo,
      experimentalFeatures:
          Map<String, dynamic>.from(entity.experimentalFeatures)
              .map((key, value) => MapEntry(key, value as bool)),
    );

  /// Custom API base URL.
  final String? customApiBaseUrl;

  /// Log level as string.
  final String logLevel;

  /// Whether logging is enabled.
  final bool loggingEnabled;

  /// Whether network logging is enabled.
  final bool networkLogEnabled;

  /// Whether performance monitoring is enabled.
  final bool performanceMonitorEnabled;

  /// Whether to show debug info.
  final bool showDebugInfo;

  /// Experimental features.
  final Map<String, dynamic>? experimentalFeatures;

  /// Converts to JSON.
  Map<String, dynamic> toJson() => _$DeveloperOptionsDtoToJson(this);

  /// Converts to entity.
  DeveloperOptions toEntity() => DeveloperOptions(
      customApiBaseUrl: customApiBaseUrl,
      logLevel: LogLevel.values.firstWhere(
        (e) => e.name == logLevel,
        orElse: () => LogLevel.debug,
      ),
      loggingEnabled: loggingEnabled,
      networkLogEnabled: networkLogEnabled,
      performanceMonitorEnabled: performanceMonitorEnabled,
      showDebugInfo: showDebugInfo,
      experimentalFeatures: experimentalFeatures?.map(
            (key, value) => MapEntry(key, value as bool),
          ) ??
          {},
    );
}
