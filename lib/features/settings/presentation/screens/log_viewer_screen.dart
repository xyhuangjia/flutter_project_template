/// 日志查看页面。
///
/// 使用 talker_flutter 内置的日志查看界面。
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/logging/talker_config.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// 日志查看页面。
///
/// 直接使用 talker_flutter 提供的 TalkerScreen 组件。
class LogViewerScreen extends StatelessWidget {
  /// 创建日志查看页面。
  const LogViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return TalkerScreen(
      talker: talker,
      appBarTitle: localizations.logViewerTitle,
      theme: TalkerScreenTheme(
        cardColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        textColor: Theme.of(context).colorScheme.onSurface,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      ),
    );
  }
}
