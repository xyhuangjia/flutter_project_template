/// WebView configuration DTO.
///
/// Data Transfer Object for WebView configuration.
library;

import 'package:flutter_project_template/features/webview/domain/entities/webview_config.dart';
import 'package:json_annotation/json_annotation.dart';

part 'webview_config_dto.g.dart';

/// WebView configuration DTO.
///
/// Used for serialization and deserialization of WebView configuration.
@JsonSerializable()
class WebViewConfigDto {
  /// Creates a webview config DTO.
  const WebViewConfigDto({
    required this.url,
    this.title,
    this.showAppBar = true,
    this.enableJavaScript = true,
    this.enableDomStorage = true,
    this.enableCache = true,
    this.userAgent,
    this.headers,
    this.blockedUrls = const [],
    this.allowedSchemes = const ['http', 'https'],
    this.enableFileDownload = true,
    this.enableFileUpload = true,
    this.enableNavigationControls = true,
    this.enablePullToRefresh = true,
  });

  /// Creates a DTO from a domain entity.
  factory WebViewConfigDto.fromEntity(WebViewConfig entity) {
    return WebViewConfigDto(
      url: entity.url,
      title: entity.title,
      showAppBar: entity.showAppBar,
      enableJavaScript: entity.enableJavaScript,
      enableDomStorage: entity.enableDomStorage,
      enableCache: entity.enableCache,
      userAgent: entity.userAgent,
      headers: entity.headers,
      blockedUrls: entity.blockedUrls,
      allowedSchemes: entity.allowedSchemes,
      enableFileDownload: entity.enableFileDownload,
      enableFileUpload: entity.enableFileUpload,
      enableNavigationControls: entity.enableNavigationControls,
      enablePullToRefresh: entity.enablePullToRefresh,
    );
  }

  /// Creates a DTO from JSON.
  factory WebViewConfigDto.fromJson(Map<String, dynamic> json) =>
      _$WebViewConfigDtoFromJson(json);

  /// The URL to load in the WebView.
  final String url;

  /// The title to display in the AppBar.
  final String? title;

  /// Whether to show the AppBar.
  @JsonKey(defaultValue: true)
  final bool showAppBar;

  /// Whether to enable JavaScript.
  @JsonKey(defaultValue: true)
  final bool enableJavaScript;

  /// Whether to enable DOM storage.
  @JsonKey(defaultValue: true)
  final bool enableDomStorage;

  /// Whether to enable caching.
  @JsonKey(defaultValue: true)
  final bool enableCache;

  /// Custom user agent string.
  final String? userAgent;

  /// Additional HTTP headers to send with the request.
  final Map<String, String>? headers;

  /// List of URL patterns to block.
  @JsonKey(defaultValue: [])
  final List<String> blockedUrls;

  /// List of allowed URL schemes.
  @JsonKey(defaultValue: ['http', 'https'])
  final List<String> allowedSchemes;

  /// Whether to enable file download.
  @JsonKey(defaultValue: true)
  final bool enableFileDownload;

  /// Whether to enable file upload.
  @JsonKey(defaultValue: true)
  final bool enableFileUpload;

  /// Whether to show navigation controls.
  @JsonKey(defaultValue: true)
  final bool enableNavigationControls;

  /// Whether to enable pull-to-refresh.
  @JsonKey(defaultValue: true)
  final bool enablePullToRefresh;

  /// Converts the DTO to a domain entity.
  WebViewConfig toEntity() {
    return WebViewConfig(
      url: url,
      title: title,
      showAppBar: showAppBar,
      enableJavaScript: enableJavaScript,
      enableDomStorage: enableDomStorage,
      enableCache: enableCache,
      userAgent: userAgent,
      headers: headers,
      blockedUrls: blockedUrls,
      allowedSchemes: allowedSchemes,
      enableFileDownload: enableFileDownload,
      enableFileUpload: enableFileUpload,
      enableNavigationControls: enableNavigationControls,
      enablePullToRefresh: enablePullToRefresh,
    );
  }

  /// Converts the DTO to JSON.
  Map<String, dynamic> toJson() => _$WebViewConfigDtoToJson(this);
}
