# Flutter Project Template

一个基于 Clean Architecture 的 Flutter 项目模板，遵循最佳实践和现代化开发流程。

## 功能特性

- 🏗️ **Clean Architecture** - 清晰的分层架构（Domain、Data、Presentation）
- 🔄 **Riverpod 状态管理** - 使用 riverpod_generator 进行代码生成
- 📝 **Talker 日志系统** - 完整的日志解决方案
- 🌐 **Dio HTTP 客户端** - 配置完善的网络请求层
- 💾 **Drift 数据库** - 类型安全的本地数据库
- 🚀 **GoRouter 路由** - 声明式路由管理
- 🔒 **类型安全** - freezed + json_serializable 强类型模型
- 🎨 **代码规范** - 完善的 lint 规则

## 技术栈

| 类别 | 技术 |
|------|------|
| 状态管理 | flutter_riverpod, riverpod_annotation |
| 网络请求 | dio, talker_dio_logger |
| 本地数据库 | drift, sqlite3_flutter_libs |
| 路由 | go_router |
| 依赖注入 | get_it, injectable |
| 序列化 | json_serializable, freezed |
| 日志 | talker, talker_flutter, talker_riverpod_logger |
| 工具 | intl, uuid, connectivity_plus, flutter_secure_storage |

## 环境要求

- Flutter SDK: >=3.38.10
- Dart SDK: >=3.6.0

## 快速开始

### 1. 克隆项目

```bash
git clone https://github.com/xyhuangjia/flutte_project_template.git
cd flutte_project_template
```

### 2. 安装依赖

```bash
flutter pub get
```

### 3. 生成代码

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. 运行项目

```bash
flutter run
```

## 目录结构

```
lib/
├── app.dart                    # MaterialApp 配置
├── main.dart                   # 应用入口
├── core/                       # 核心层
│   ├── constants/              # 常量定义
│   │   ├── app_colors.dart     # 颜色常量
│   │   ├── app_constants.dart  # 应用常量
│   │   └── app_strings.dart    # 字符串常量
│   ├── errors/                 # 错误处理
│   │   ├── exceptions.dart     # 自定义异常
│   │   ├── failures.dart       # 失败类型
│   │   └── error_handler.dart  # 错误处理器
│   ├── logging/                # 日志配置
│   │   └── talker_config.dart  # Talker 配置
│   ├── network/                # 网络层
│   │   ├── dio_client.dart     # Dio 客户端
│   │   ├── api_interceptor.dart # API 拦截器
│   │   └── api_result.dart     # API 结果封装
│   ├── router/                 # 路由
│   │   ├── app_router.dart     # GoRouter 配置
│   │   ├── router_guard.dart   # 路由守卫
│   │   └── routes.dart         # 路由定义
│   ├── storage/                # 存储
│   │   ├── database.dart       # Drift 数据库
│   │   └── database_provider.dart
│   └── utils/                  # 工具类
│       ├── date_utils.dart
│       ├── validators.dart
│       └── extensions/
├── features/                   # 功能模块
│   └── home/                   # Home 模块示例
│       ├── data/               # 数据层
│       │   ├── datasources/    # 数据源
│       │   ├── models/         # 数据模型
│       │   └── repositories/   # 仓库实现
│       ├── domain/             # 领域层
│       │   ├── entities/       # 实体
│       │   ├── repositories/   # 仓库接口
│       │   └── usecases/       # 用例
│       └── presentation/       # 表现层
│           ├── providers/      # Riverpod Providers
│           ├── screens/        # 页面
│           └── widgets/        # 组件
└── shared/                     # 共享模块
    ├── models/                 # 共享模型
    └── widgets/                # 共享组件
```

## 架构说明

### Clean Architecture 分层

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                    │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │   Screens   │  │  Providers  │  │   Widgets   │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
└─────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│                     Domain Layer                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │  Entities   │  │ Repositories│  │   UseCases  │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
└─────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│                      Data Layer                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │ DataSources │  │   Models    │  │ Repository  │     │
│  │  (Remote/   │  │   (DTOs)    │  │    Impl     │     │
│  │   Local)    │  │             │  │             │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
└─────────────────────────────────────────────────────────┘
```

### 数据流向

```
UI (Screen) → Provider → UseCase → Repository → DataSource
                    ↓
              State Update
                    ↓
UI Rebuild
```

## 代码规范

### Provider 定义

```dart
@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  Future<HomeEntity> build() async {
    // 初始化逻辑
  }
}
```

### 模型定义

```dart
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    String? avatarUrl,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

### 错误处理

```dart
try {
  final result = await repository.getData();
  return Success(result);
} on NetworkException catch (e) {
  return Failure(NetworkFailure(e.message));
}
```

## 测试

```bash
# 运行所有测试
flutter test

# 运行特定测试
flutter test test/widget_test.dart
```

## 代码生成

```bash
# 一次性生成
dart run build_runner build --delete-conflicting-outputs

# 监听模式
dart run build_runner watch --delete-conflicting-outputs
```

## 日志查看

应用内置 Talker 日志系统，支持：

- 控制台日志输出
- Flutter 框架错误捕获
- Riverpod 状态变更日志
- Dio 网络请求日志

在 Debug 模式下自动启用，Release 模式下禁用。

## 环境配置

项目使用 `.env` 文件管理环境变量：

```env
API_BASE_URL=https://api.example.com
APP_NAME=Flutter Project Template
```

## License

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request！