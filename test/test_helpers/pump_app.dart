/// Test helpers for pumping widgets with proper setup.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps a widget with localization support.
Future<void> pumpLocalizedWidget(
  WidgetTester tester, {
  required Widget widget,
  Locale locale = const Locale('en'),
}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: Scaffold(body: widget),
    ),
  );
}

/// Extension on WidgetTester for convenient localized pumping.
extension LocalizedPump on WidgetTester {
  /// Pumps a widget with localization support.
  Future<void> pumpLocalizedApp(Widget widget, {Locale locale = const Locale('en')}) async {
    await pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        home: Scaffold(body: widget),
      ),
    );
  }
}