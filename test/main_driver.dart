import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_project_template/main.dart' as app;

void main() {
  enableFlutterDriverExtension(); // 担心生产构建污染，可以用env控制
  app.main();
}
