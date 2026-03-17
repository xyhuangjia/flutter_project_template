# Add Multi-Language Support

## Goal

为 Flutter 项目添加完整的国际化（i18n）支持，使应用能够根据系统语言或用户选择显示不同语言的文本。

## Requirements

### 1. 依赖配置
- 添加 `flutter_localizations` 和 `intl` 包
- 配置 `l10n.yaml` 文件
- 更新 `pubspec.yaml`

### 2. 多语言资源
- 支持中文（简体）和英文
- 使用 ARB 文件格式
- 创建 `lib/l10n/` 目录存放语言资源

### 3. 应用配置
- 在 `MaterialApp` 中配置 `localizationsDelegates`
- 配置 `supportedLocales`

### 4. 语言切换功能
- 创建 `LocaleProvider` 管理当前语言
- 支持运行时切换语言
- 持久化用户语言偏好（使用 SharedPreferences）

### 5. UI 更新
- 更新 `HomeScreen` 使用国际化字符串
- 添加语言切换入口（在设置页面或直接在 Home 页）

## Acceptance Criteria

- [ ] 应用支持中文和英文两种语言
- [ ] 默认跟随系统语言
- [ ] 用户可以手动切换语言
- [ ] 语言偏好被持久化保存
- [ ] 所有 UI 文本使用国际化字符串
- [ ] 切换语言后 UI 立即更新

## Technical Notes

### 依赖
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.2
  shared_preferences: ^2.3.3

dev_dependencies:
  intl_utils: ^2.8.0
```

### 目录结构
```
lib/
├── l10n/
│   ├── app_en.arb    # 英文资源
│   └── app_zh.arb    # 中文资源
├── core/
│   └── providers/
│       └── locale_provider.dart
└── generated/
    └── l10n/
        └── app_localizations.dart
```

### ARB 文件示例
```json
{
  "@@locale": "en",
  "appTitle": "Flutter Project Template",
  "@appTitle": {
    "description": "Application title"
  },
  "welcomeMessage": "Welcome!",
  "home": "Home",
  "settings": "Settings"
}
```

### 关键实现

1. **LocaleProvider** - 使用 Riverpod 管理语言状态
2. **SharedPreferences** - 持久化用户语言选择
3. **intl_utils** - 生成类型安全的国际化代码