# Initialize Flutter Project Skeleton

## Goal

创建符合 Clean Architecture 的 Flutter 项目基础结构。

## Requirements

### 目录结构

创建完整的 Clean Architecture 目录：

```
lib/
├── app.dart                    # MaterialApp 配置
├── main.dart                   # 应用入口
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── app_colors.dart
│   │   └── app_strings.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   ├── failures.dart
│   │   └── error_handler.dart
│   ├── network/
│   │   ├── dio_client.dart
│   │   ├── api_interceptor.dart
│   │   └── api_result.dart
│   ├── router/
│   │   ├── app_router.dart
│   │   ├── router_guard.dart
│   │   └── routes.dart
│   ├── storage/
│   │   ├── database.dart
│   │   ├── database_provider.dart
│   │   └── migrations/
│   └── utils/
│       ├── date_utils.dart
│       ├── validators.dart
│       └── extensions/
├── features/
│   └── home/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── providers/
│           ├── screens/
│           └── widgets/
└── shared/
    ├── models/
    └── widgets/
```

### 配置文件

1. **pubspec.yaml** - 包含所有依赖
2. **analysis_options.yaml** - Lint 配置
3. **flutter_launcher_icons.yaml** - 图标配置
4. **.gitignore** - Git 忽略规则

### 基础代码

1. main.dart - 应用入口，配置 ProviderScope
2. app.dart - MaterialApp 配置，主题、路由
3. core/constants/*.dart - 常量定义
4. core/errors/*.dart - 错误处理类
5. core/network/*.dart - 网络配置
6. core/router/*.dart - 路由配置（go_router）
7. core/storage/*.dart - 数据库配置（Drift）

### 示例 Feature

创建 `home` feature 作为示例：
- HomeScreen（简单的 Scaffold）
- HomeController（Riverpod provider）

## Acceptance Criteria

- [ ] 目录结构完整创建
- [ ] pubspec.yaml 包含所有定义的依赖
- [ ] analysis_options.yaml 包含完整 Lint 规则
- [ ] main.dart 和 app.dart 可运行
- [ ] home feature 可显示
- [ ] 代码遵循所有 Frontend 指南规范

## Technical Notes

遵循指南：
- `.trellis/spec/frontend/directory-structure.md`
- `.trellis/spec/frontend/component-guidelines.md`
- `.trellis/spec/frontend/state-management.md`
- `.trellis/spec/frontend/type-safety.md`
- `.trellis/spec/frontend/quality-guidelines.md`

## Dependencies

参考 PRD 中定义的依赖列表。
