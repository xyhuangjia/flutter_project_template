<div align="center">
  <h1>Flutter 项目模板</h1>
  
  <p><strong>基于 Clean Architecture 的生产级 Flutter 模板</strong></p>
  
  <p>
    <a href="https://flutter.dev">
      <img src="https://img.shields.io/badge/Flutter-3.38.10+-02569B?style=for-the-badge&logo=flutter" alt="Flutter">
    </a>
    <a href="https://dart.dev">
      <img src="https://img.shields.io/badge/Dart-3.6.0+-0175C2?style=for-the-badge&logo=dart" alt="Dart">
    </a>
    <a href="LICENSE">
      <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="License">
    </a>
  </p>
  
  <p>
    <a href="#功能特性">功能特性</a> •
    <a href="#快速开始">快速开始</a> •
    <a href="#文档">文档</a> •
    <a href="README.md">English</a>
  </p>
</div>

---

## 📋 目录

- [功能特性](#功能特性)
- [技术栈](#技术栈)
- [环境要求](#环境要求)
- [快速开始](#快速开始)
- [项目结构](#项目结构)
- [架构说明](#架构说明)
- [文档](#文档)
- [贡献](#贡献)
- [许可证](#许可证)

## ✨ 功能特性
 
 - 🏗️ **Clean Architecture** - 清晰的分层架构（Domain、Data、Presentation）
 - 🔄 **Riverpod 状态管理** - 使用 riverpod_generator 进行代码生成
 - 📝 **Talker 日志系统** - 完整的日志解决方案
 - 🌐 **Dio HTTP 客户端** - 配置完善的网络请求层
 - 💾 **Drift 数据库** - 类型安全的本地数据库
 - 🚀 **GoRouter 路由** - 声明式路由管理
 - 🌍 **国际化支持** - 多语言支持（中英文）
 - 🔒 **类型安全** - freezed + json_serializable 强类型模型
 - 🎨 **代码规范** - 完善的 lint 规则

### 功能模块

该模板包含以下功能模块：

#### 🔐 认证模块 (`features/auth`)
- 邮箱密码登录
- 用户注册与验证
- 忘记密码流程
- 使用 flutter_secure_storage 安全存储 Token
- 社交登录架构预留

#### 👤 用户资料 (`features/profile`)
- 用户资料管理
- 修改密码与验证
- 账户信息展示
- 头像管理
- 账户删除支持

#### 💬 AI 聊天 (`features/chat`)
- AI 对话功能（支持 OpenAI/Claude）
- 消息持久化到本地数据库
- 对话历史管理
- AI 配置管理
- 实时消息流

#### 🏠 首页 (`features/home`)
- 主仪表盘界面
- 功能导航中心
- 快速访问所有功能
- 用户个性化内容展示

#### ⚙️ 设置 (`features/settings`)
- 主题切换（亮色/暗色/系统）
- 语言偏好设置
- 通知设置
- 开发者选项
- 应用版本信息

#### 🔒 隐私政策 (`features/privacy`)
- 隐私政策展示
- 服务条款
- 用户同意管理
- 数据收集偏好
- 区域设置

#### 🌐 网页浏览 (`features/webview`)
- 功能完整的 WebView（支持 JavaScript Bridge）
- 自定义导航控件
- 错误处理和加载状态
- 本地存储、Cookie 和会话管理

## 🛠 技术栈

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

## 📦 环境要求

- Flutter SDK: `>=3.38.10`
- Dart SDK: `>=3.6.0`

## 🚀 快速开始

### 前置要求

确保已安装以下工具：
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.38.10 或更高版本)
- [Dart SDK](https://dart.dev/get-dart) (3.6.0 或更高版本)
- 代码编辑器（[VS Code](https://code.visualstudio.com/) 或 [Android Studio](https://developer.android.com/studio)）

### 安装步骤

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

#### 4. 配置环境

在项目根目录创建 `.env` 文件：

```env
API_BASE_URL=https://api.example.com
APP_NAME=Flutter Project Template
```

#### 5. 运行项目

```bash
flutter run
```

## 📁 项目结构

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
│   ├── auth/                   # 认证模块
│   │   ├── data/               # 数据层（仓库实现、数据源）
│   │   ├── domain/             # 领域层（实体、仓库、用例）
│   │   └── presentation/       # 表现层（屏幕、Provider、组件）
│   ├── chat/                   # AI 聊天模块
│   │   ├── data/               # 消息持久化、AI API 集成
│   │   ├── domain/             # 聊天实体、对话管理
│   │   ├── presentation/       # 聊天 UI、消息组件
│   │   └── utils/              # 聊天工具
│   ├── home/                   # 首页模块
│   │   ├── data/               # 首页数据层
│   │   ├── domain/             # 首页实体
│   │   └── presentation/       # 首页屏幕 UI
│   ├── profile/                 # 用户资料模块
│   │   ├── data/               # 资料数据层
│   │   ├── domain/             # 资料实体
│   │   └── presentation/       # 资料屏幕 UI（修改密码等）
│   ├── privacy/                # 隐私政策模块
│   │   ├── data/               # 隐私数据
│   │   ├── domain/             # 隐私实体
│   │   └── presentation/       # 隐私屏幕
│   ├── settings/               # 设置模块
│   │   ├── data/               # 设置持久化
│   │   ├── domain/             # 设置实体
│   │   └── presentation/       # 设置屏幕
│   └── webview/                # 网页浏览模块
│       ├── data/               # WebView 状态管理
│       ├── domain/             # WebView 配置
│       └── presentation/       # WebView 屏幕与控件
└── shared/                     # 共享模块
    ├── models/                 # 共享模型
    └── widgets/                # 共享组件
```

## 🏗 架构说明

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

## 📖 文档

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

## 🤝 贡献

欢迎贡献代码！请随时提交 Pull Request。

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 提交 Pull Request

## 📝 许可证

本项目采用 MIT 许可证 - 详情请查看 [LICENSE](LICENSE) 文件。

## 📮 联系方式

项目链接: [https://github.com/xyhuangjia/flutte_project_template](https://github.com/xyhuangjia/flutte_project_template)

---

<div align="center">
  <p>由 Flutter 社区用 ❤️ 打造</p>
  <p>
    <a href="#top">返回顶部</a>
  </p>
</div>