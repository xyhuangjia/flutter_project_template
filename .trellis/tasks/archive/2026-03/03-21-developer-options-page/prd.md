# 设置模块开发者选项页面

## Goal
在设置模块中新增完整的开发者选项页面，提供环境切换、日志配置、缓存管理、API 配置、调试工具等功能。

## Requirements

### 功能需求
1. **环境切换**
   - 支持 Development/Staging/Production 三种环境
   - 切换环境后需要重启应用生效

2. **日志配置**
   - 日志级别设置（Debug/Info/Warning/Error/None）
   - 日志开关

3. **缓存管理**
   - 清除应用缓存
   - 清除数据库数据
   - 显示缓存大小

4. **API 配置**
   - 自定义 API 服务器地址
   - 重置为默认地址

5. **调试工具**
   - 网络请求日志开关
   - 性能监控开关
   - 显示调试信息

6. **实验性功能**
   - 实验性功能开关列表

### 技术需求
- 遵循 Clean Architecture 三层架构
- 使用 Riverpod 进行状态管理
- 使用 SharedPreferences 持久化开发者选项
- 支持国际化（中英文）
- 仅在 Debug 模式下显示入口

## Acceptance Criteria
- [ ] 开发者选项页面可从设置页导航进入
- [ ] 环境切换功能正常，切换后提示重启
- [ ] 日志级别可配置并持久化
- [ ] 缓存清除功能正常工作
- [ ] API 地址可自定义
- [ ] 调试开关可配置
- [ ] 实验性功能开关可配置
- [ ] 国际化文本完整

## Technical Notes

### 文件结构
```
lib/features/settings/
├── domain/
│   └── entities/
│       └── developer_options.dart      # 开发者选项实体
├── data/
│   ├── models/
│   │   └── developer_options_dto.dart  # 数据传输对象
│   ├── datasources/
│   │   └── developer_options_local_data_source.dart
│   └── repositories/
│       └── developer_options_repository_impl.dart
└── presentation/
    ├── providers/
    │   └── developer_options_provider.dart
    └── screens/
        └── developer_options_screen.dart
```

### 依赖
- SharedPreferences（已有）
- Riverpod（已有）
- GoRouter（已有）

### 入口位置
- 在设置页面 `SettingsScreen` 的开发者选项区域
- 点击后导航到 `/settings/developer-options`