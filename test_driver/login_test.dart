/// Test driver for login integration tests.
///
/// Run with: flutter drive --target=test_driver/login_test.dart
library;

import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_project_template/main.dart' as app;

void main() {
  enableFlutterDriverExtension();
  app.main();
}