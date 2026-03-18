# Environment Configuration

环境配置模块允许开发者通过开发者菜单切换 App 的运行环境（开发/测试/线上）。

## 功能特性

- 三种环境类型：Development、Staging、Production
- 每种环境都有独立的配置项
- 使用 SharedPreferences 持久化保存
- 在开发者菜单中提供切换入口
- 仅在 Debug 模式下显示开发者选项

## 环境类型

### Development (开发环境)
```dart
baseUrl: 'https://dev-api.example.com'
logLevel: LogLevel.debug
debugMode: true
analyticsEnabled: false
crashlyticsEnabled: false
```

### Staging (测试环境)
```dart
baseUrl: 'https://staging-api.example.com'
logLevel: LogLevel.info
debugMode: true
analyticsEnabled: true
crashlyticsEnabled: true
```

### Production (生产环境)
```dart
baseUrl: 'https://api.example.com'
logLevel: LogLevel.warning
debugMode: false
analyticsEnabled: true
crashlyticsEnabled: true
```

## 使用方法

### 1. 获取当前环境配置

```dart
import 'package:flutter_project_template/core/config/environment_provider.dart';

// 在 Widget 中
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environment = ref.watch(environmentProvider);
    
    print('Current environment: ${environment.type}');
    print('Base URL: ${environment.baseUrl}');
    print('Debug mode: ${environment.debugMode}');
    
    return Container();
  }
}
```

### 2. 切换环境

```dart
// 切换到开发环境
await ref.read(environmentProvider.notifier)
    .switchEnvironment(EnvironmentType.development);

// 切换到测试环境
await ref.read(environmentProvider.notifier)
    .switchEnvironment(EnvironmentType.staging);

// 切换到生产环境
await ref.read(environmentProvider.notifier)
    .switchEnvironment(EnvironmentType.production);
```

### 3. 检查当前环境

```dart
final envNotifier = ref.read(environmentProvider.notifier);

if (envNotifier.isDevelopment) {
  // 在开发环境中执行特定逻辑
}

if (envNotifier.isProduction) {
  // 在生产环境中执行特定逻辑
}
```

### 4. 检查是否显示开发者选项

```dart
final showDeveloperOptions = ref.watch(showDeveloperOptionsProvider);

if (showDeveloperOptions) {
  // 显示开发者选项
}
```

### 5. 在 DioClient 中使用环境配置

```dart
import 'package:flutter_project_template/core/config/environment_provider.dart';
import 'package:flutter_project_template/core/network/dio_client.dart';

// 创建 DioClient 时使用环境配置
final environment = ref.read(environmentProvider);
final dioClient = DioClient(baseUrl: environment.baseUrl);

// 或者动态更新 baseUrl
dioClient.updateBaseUrl(newBaseUrl);
```

## 配置自定义环境

如果需要自定义环境配置：

```dart
final customConfig = EnvironmentConfig(
  type: EnvironmentType.staging,
  baseUrl: 'https://custom-api.example.com',
  logLevel: LogLevel.debug,
  debugMode: true,
  analyticsEnabled: false,
  crashlyticsEnabled: false,
);

await ref.read(environmentProvider.notifier).setCustomConfig(customConfig);
```

## 重置环境

```dart
// 重置到默认环境（Debug 模式下为 Development，Release 模式下为 Production）
await ref.read(environmentProvider.notifier).resetToDefault();
```

## 在 UI 中使用

设置页面已经集成了环境选择器。切换环境后会显示确认对话框，提示用户需要重启应用才能使环境更改完全生效。

```dart
// 在设置页面中使用
EnvironmentSelector(
  currentEnvironment: null,
  onEnvironmentChanged: (type) {
    // 处理环境切换
  },
)
```

## 注意事项

1. **Release 模式限制**：在 Release 模式下，开发者选项默认隐藏，且始终使用 Production 环境配置。

2. **重启提示**：切换环境后，建议重启应用以确保所有配置都生效。

3. **持久化**：用户选择的环境会被保存到 SharedPreferences 中，下次启动应用时会自动加载。

4. **第三方服务**：根据环境配置，Analytics 和 Crashlytics 可能会被禁用（如在开发环境中）。

## 文件结构

```
lib/core/config/
├── config.dart                    # Barrel export
├── environment.dart               # 环境枚举和配置类
├── environment_provider.dart      # Riverpod Provider
└── environment_provider.g.dart    # 生成的代码
```

## 相关文件

- `lib/core/network/dio_client.dart` - Dio HTTP 客户端
- `lib/features/settings/presentation/widgets/environment_selector.dart` - 环境选择器组件
- `lib/features/settings/presentation/screens/settings_screen.dart` - 设置页面
