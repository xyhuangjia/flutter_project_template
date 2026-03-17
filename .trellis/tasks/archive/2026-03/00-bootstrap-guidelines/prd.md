# Bootstrap: Fill Project Development Guidelines

## Goal

为 Flutter 项目模板填充完整的开发指南，让 AI 代理能够按照项目规范编写代码。

## Technical Stack Decisions

| Category | Choice | Notes |
|----------|--------|-------|
| Project Type | 纯 Flutter 应用 | 无后端代码 |
| State Management | Riverpod | 编译时安全，测试友好 |
| Architecture | Clean Architecture | 严格分层 (domain/data/presentation) |
| Routing | go_router | 声明式路由，支持深链接 |
| Serialization | json_serializable | 标准 JSON 序列化 |
| API Client | retrofit | 基于 dio，类型安全 |
| Local Storage | drift | SQLite + 代码生成 |
| Code Quality | 严格 Lint | flutter_lints + 自定义规则 |

## Requirements

### Frontend Guidelines (6 files)

| File | Content |
|------|---------|
| `directory-structure.md` | Clean Architecture 目录组织、各层职责 |
| `component-guidelines.md` | Widget 编写规范、最佳实践、命名约定 |
| `state-management.md` | Riverpod Provider 类型选择、使用模式 |
| `type-safety.md` | json_serializable 模型、Drift 表定义 |
| `quality-guidelines.md` | Lint 配置、测试策略、代码审查标准 |
| `hook-guidelines.md` | Riverpod Provider 编写模式（Flutter 等效） |

### Backend Guidelines

- 标记为"纯 Flutter 项目，无需后端指南"
- 保留模板文件，添加说明

## Acceptance Criteria

- [ ] 6 个 Frontend 指南文件已填充
- [ ] 每个文件包含 2-3 个代码示例
- [ ] 包含反模式/禁止事项
- [ ] Backend 指南已标记为不适用
- [ ] 指南之间保持一致性

## Definition of Done

- [ ] 所有指南文件已填充
- [ ] 代码示例符合 Flutter 最佳实践
- [ ] Riverpod + Clean Architecture + go_router 模式一致
- [ ] retrofit + drift 使用规范完整

## Out of Scope

- 后端代码规范（纯 Flutter 项目）
- CI/CD 配置
- 国际化 (i18n) 具体实现
- 多环境配置具体实现

## Technical Notes

### Directory Structure Template

```
lib/
├── app.dart                    # MaterialApp 配置
├── main.dart                   # 入口
├── core/                       # 共享基础设施
│   ├── constants/              # 常量
│   ├── errors/                 # 异常类
│   ├── network/                # dio/retrofit 配置
│   ├── router/                 # go_router 配置
│   ├── storage/                # drift 数据库配置
│   └── utils/                  # 工具函数
├── features/                   # 功能模块
│   └── {feature}/
│       ├── data/               # 数据层
│       │   ├── datasources/    # 本地/远程数据源
│       │   ├── models/         # DTO (json_serializable)
│       │   └── repositories/   # Repository 实现
│       ├── domain/             # 领域层
│       │   ├── entities/       # 业务实体
│       │   ├── repositories/   # Repository 接口
│       │   └── usecases/       # 用例 (可选)
│       └── presentation/       # 表现层
│           ├── providers/      # Riverpod providers
│           ├── screens/        # 页面
│           └── widgets/        # 组件
└── shared/                     # 跨功能共享
    ├── models/
    └── widgets/
```

### Key Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.x
  go_router: ^14.x
  dio: ^5.x
  retrofit: ^4.x
  json_annotation: ^4.x
  drift: ^2.x
  sqlite3_flutter_libs: ^2.x

dev_dependencies:
  riverpod_generator: ^2.x
  build_runner: ^2.x
  retrofit_generator: ^8.x
  json_serializable: ^6.x
  drift_dev: ^2.x
  flutter_lints: ^3.x
  custom_lint: ^0.6.x
  riverpod_lint: ^2.x
  change_app_package_name: ^1.x
  flutter_launcher_icons: ^0.14.x
```
