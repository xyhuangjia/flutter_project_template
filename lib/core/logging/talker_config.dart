import 'package:flutter/foundation.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

final talker = Talker(
  settings: TalkerSettings(
    enabled: true,
    useConsoleLogs: kDebugMode,
  ),
  logger: TalkerLogger(
    settings: TalkerLoggerSettings(
      enableColors: true,
    ),
  ),
);

TalkerDioLogger get dioLogger => TalkerDioLogger(
      talker: talker,
      settings: TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printResponseHeaders: true,
        printResponseMessage: true,
        errorPen: AnsiPen()..red(),
        responsePen: AnsiPen()..green(),
        requestPen: AnsiPen()..cyan(),
      ),
    );
