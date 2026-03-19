// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webview_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebViewConfigDto _$WebViewConfigDtoFromJson(Map<String, dynamic> json) =>
    WebViewConfigDto(
      url: json['url'] as String,
      title: json['title'] as String?,
      showAppBar: json['showAppBar'] as bool? ?? true,
      enableJavaScript: json['enableJavaScript'] as bool? ?? true,
      enableDomStorage: json['enableDomStorage'] as bool? ?? true,
      enableCache: json['enableCache'] as bool? ?? true,
      userAgent: json['userAgent'] as String?,
      headers: (json['headers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      blockedUrls: (json['blockedUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      allowedSchemes: (json['allowedSchemes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          ['http', 'https'],
      enableFileDownload: json['enableFileDownload'] as bool? ?? true,
      enableFileUpload: json['enableFileUpload'] as bool? ?? true,
      enableNavigationControls:
          json['enableNavigationControls'] as bool? ?? true,
      enablePullToRefresh: json['enablePullToRefresh'] as bool? ?? true,
    );

Map<String, dynamic> _$WebViewConfigDtoToJson(WebViewConfigDto instance) =>
    <String, dynamic>{
      'url': instance.url,
      'title': instance.title,
      'showAppBar': instance.showAppBar,
      'enableJavaScript': instance.enableJavaScript,
      'enableDomStorage': instance.enableDomStorage,
      'enableCache': instance.enableCache,
      'userAgent': instance.userAgent,
      'headers': instance.headers,
      'blockedUrls': instance.blockedUrls,
      'allowedSchemes': instance.allowedSchemes,
      'enableFileDownload': instance.enableFileDownload,
      'enableFileUpload': instance.enableFileUpload,
      'enableNavigationControls': instance.enableNavigationControls,
      'enablePullToRefresh': instance.enablePullToRefresh,
    };
