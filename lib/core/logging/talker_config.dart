/// Talker 日志配置。
///
/// 配置全局 Talker 实例，支持日志持久化和 Dio 日志记录。
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_project_template/core/logging/log_persistence_service.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

/// 全局 Talker 实例。
///
/// 提供应用范围内的日志记录功能。
/// 使用前应调用 [initTalkerPersistence] 初始化持久化。
final talker = Talker(logger: TalkerLogger());

/// 初始化 Talker 日志持久化。
///
/// [persistenceService] 日志持久化服务实例。
/// 应在应用启动时调用此方法以启用日志持久化。
void initTalkerPersistence(LogPersistenceService persistenceService) {
  talker.configure(observer: persistenceService);
  debugPrint('Talker 配置：已添加日志持久化 Observer');
}

/// 获取 Dio 日志拦截器。
///
/// 用于记录 HTTP 请求和响应日志。
/// 仅在 Debug 模式下启用详细日志。
TalkerDioLogger get dioLogger => TalkerDioLogger(
      talker: talker,
      settings: TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printResponseHeaders: true,
        errorPen: AnsiPen()..red(),
        responsePen: AnsiPen()..green(),
        requestPen: AnsiPen()..cyan(),
      ),
    );
