/// Application entry point.
///
/// This file initializes the Flutter framework and runs the app
/// with the necessary providers configured via ProviderScope.
library;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_project_template/app.dart';
import 'package:flutter_project_template/core/config/environment_provider.dart';
import 'package:flutter_project_template/core/logging/talker_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    talker.handle(details.exception, details.stack);
  };

  await dotenv.load(fileName: '.env');

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      observers: [
        TalkerRiverpodObserver(talker: talker),
      ],
      child: const MyApp(),
    ),
  );
}
