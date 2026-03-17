# Flutter Project Template

[English](#english) | [中文](#中文)

---

<a name="english"></a>
## English

A Flutter project template based on Clean Architecture, following best practices and modern development workflows.

### Features

- 🏗️ **Clean Architecture** - Clear layered architecture (Domain, Data, Presentation)
- 🔄 **Riverpod State Management** - Code generation with riverpod_generator
- 📝 **Talker Logging** - Complete logging solution
- 🌐 **Dio HTTP Client** - Well-configured network layer
- 💾 **Drift Database** - Type-safe local database
- 🚀 **GoRouter Routing** - Declarative routing management
- 🌍 **Internationalization** - Multi-language support (English/Chinese)
- 🔒 **Type Safety** - freezed + json_serializable strongly typed models
- 🎨 **Code Standards** - Comprehensive lint rules

### Tech Stack

| Category | Technology |
|----------|------------|
| State Management | flutter_riverpod, riverpod_annotation |
| Networking | dio, talker_dio_logger |
| Local Database | drift, sqlite3_flutter_libs |
| Routing | go_router |
| Dependency Injection | get_it, injectable |
| Serialization | json_serializable, freezed |
| Logging | talker, talker_flutter, talker_riverpod_logger |
| i18n | flutter_localizations, intl |
| Utils | uuid, connectivity_plus, flutter_secure_storage |

### Requirements

- Flutter SDK: >=3.38.10
- Dart SDK: >=3.6.0

### Quick Start

#### 1. Clone the project

```bash
git clone https://github.com/xyhuangjia/flutte_project_template.git
cd flutte_project_template
```

#### 2. Install dependencies

```bash
flutter pub get
```

#### 3. Generate code

```bash
dart run build_runner build --delete-conflicting-outputs
```

#### 4. Run the project

```bash
flutter run
```

### Directory Structure

```
lib/
├── app.dart                    # MaterialApp configuration
├── main.dart                   # App entry point
├── core/                       # Core layer
│   ├── constants/              # Constants
│   ├── errors/                 # Error handling
│   ├── logging/                # Logging config
│   ├── network/                # Network layer
│   ├── providers/              # Global providers
│   ├── router/                 # Routing
│   ├── storage/                # Storage
│   └── utils/                  # Utilities
├── features/                   # Feature modules
│   └── home/                   # Home module example
│       ├── data/               # Data layer
│       ├── domain/             # Domain layer
│       └── presentation/       # Presentation layer
└── shared/                     # Shared modules
    ├── models/                 # Shared models
    └── widgets/                # Shared widgets
```

### Architecture

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
│  └─────────────┘  └─────────────┘  └─────────────┘     │
└─────────────────────────────────────────────────────────┘
```

### Data Flow

```
UI (Screen) → Provider → UseCase → Repository → DataSource
                    ↓
              State Update
                    ↓
UI Rebuild
```

### Code Standards

#### Provider Definition

```dart
@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  Future<HomeEntity> build() async {
    // Initialization logic
  }
}
```

#### Model Definition

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

### Testing

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/widget_test.dart
```

### Code Generation

```bash
# Generate once
dart run build_runner build --delete-conflicting-outputs

# Watch mode
dart run build_runner watch --delete-conflicting-outputs
```

### Internationalization

The app supports multiple languages. To add a new translation:

1. Add keys to `lib/l10n/app_en.arb` and `lib/l10n/app_zh.arb`
2. Run `flutter gen-l10n`
3. Use in code: `AppLocalizations.of(context)!.yourKey`

### Environment Configuration

The project uses `.env` file for environment variables:

```env
API_BASE_URL=https://api.example.com
APP_NAME=Flutter Project Template
```

### License

MIT License

### Contributing

Issues and Pull Requests are welcome!

---

<a name="中文"></a>
## 中文

一个基于 Clean Architecture 的 Flutter 项目模板，遵循最佳实践和现代化开发流程。

### 功能特性

- 🏗️ **Clean Architecture** - 清晰的分层架构（Domain、Data、Presentation）
- 🔄 **Riverpod 状态管理** - 使用 riverpod_generator 进行代码生成
- 📝 **Talker 日志系统** - 完整的日志解决方案
- 🌐 **Dio HTTP 客户端** - 配置完善的网络请求层
- 💾 **Drift 数据库** - 类型安全的本地数据库
- 🚀 **GoRouter 路由** - 声明式路由管理
- 🌍 **国际化支持** - 多语言支持（中英文）
- 🔒 **类型安全** - freezed + json_serializable 强类型模型
- 🎨 **代码规范** - 完善的 lint 规则

### 技术栈

| 类别 | 技术 |
|------|------|
| 状态管理 | flutter_riverpod, riverpod_annotation |
| 网络请求 | dio, talker_dio_logger |
| 本地数据库 | drift, sqlite3_flutter_libs |
| 路由 | go_router |
| 依赖注入 | get_it, injectable |
| 序列化 | json_serializable, freezed |
| 日志 | talker, talker_flutter, talker_riverpod_logger |
| 国际化 | flutter_localizations, intl |
| 工具 | uuid, connectivity_plus, flutter_secure_storage |

### 环境要求

- Flutter SDK: >=3.38.10
- Dart SDK: >=3.6.0

### 快速开始

#### 1. 克隆项目

```bash
git clone https://github.com/xyhuangjia/flutte_project_template.git
cd flutte_project_template
```

#### 2. 安装依赖

```bash
flutter pub get
```

#### 3. 生成代码

```bash
dart run build_runner build --delete-conflicting-outputs
```

#### 4. 运行项目

```bash
flutter run
```

### 目录结构

```
lib/
├── app.dart                    # MaterialApp 配置
├── main.dart                   # 应用入口
├── core/                       # 核心层
│   ├── constants/              # 常量定义
│   ├── errors/                 # 错误处理
│   ├── logging/                # 日志配置
│   ├── network/                # 网络层
│   ├── providers/              # 全局 Provider
│   ├── router/                 # 路由
│   ├── storage/                # 存储
│   └── utils/                  # 工具类
├── features/                   # 功能模块
│   └── home/                   # Home 模块示例
│       ├── data/               # 数据层
│       ├── domain/             # 领域层
│       └── presentation/       # 表现层
└── shared/                     # 共享模块
    ├── models/                 # 共享模型
    └── widgets/                # 共享组件
```

### 架构说明

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

### 代码规范

#### Provider 定义

```dart
@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  Future<HomeEntity> build() async {
    // 初始化逻辑
  }
}
```

#### 模型定义

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

### 测试

```bash
# 运行所有测试
flutter test

# 运行特定测试
flutter test test/widget_test.dart
```

### 代码生成

```bash
# 一次性生成
dart run build_runner build --delete-conflicting-outputs

# 监听模式
dart run build_runner watch --delete-conflicting-outputs
```

### 国际化

应用支持多语言。添加新翻译步骤：

1. 在 `lib/l10n/app_en.arb` 和 `lib/l10n/app_zh.arb` 中添加键值
2. 运行 `flutter gen-l10n`
3. 在代码中使用：`AppLocalizations.of(context)!.yourKey`

### 环境配置

项目使用 `.env` 文件管理环境变量：

```env
API_BASE_URL=https://api.example.com
APP_NAME=Flutter Project Template
```

### License

MIT License

### 贡献

欢迎提交 Issue 和 Pull Request！