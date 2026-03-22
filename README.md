<div align="center">
  <h1>Flutter Project Template</h1>
  
  <p><strong>A production-ready Flutter template with Clean Architecture</strong></p>
  
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
    <a href="#features">Features</a> •
    <a href="#getting-started">Getting Started</a> •
    <a href="#documentation">Documentation</a> •
    <a href="README-CN.md">中文文档</a>
  </p>
</div>

---

## 📋 Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Requirements](#requirements)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Architecture](#architecture)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

## ✨ Features

### Core Features
- 🏗️ **Clean Architecture** - Clear layered architecture (Domain, Data, Presentation)
- 🔄 **Riverpod State Management** - Code generation with riverpod_generator
- 📝 **Talker Logging** - Complete logging solution
- 🌐 **Dio HTTP Client** - Well-configured network layer
- 💾 **Drift Database** - Type-safe local database
- 🚀 **GoRouter Routing** - Declarative routing management
- 🌍 **Internationalization** - Multi-language support (English/Chinese)
- 🔒 **Type Safety** - freezed + json_serializable strongly typed models
- 🎨 **Code Standards** - Comprehensive lint rules

### Feature Modules

The template includes the following feature modules:

#### 🔐 Authentication (`features/auth`)
- Login with email/password
- User registration with validation
- Forgot password flow
- Secure token storage with flutter_secure_storage
- Social login ready architecture

#### 👤 Profile (`features/profile`)
- User profile management
- Change password with validation
- Account information display
- Avatar management
- Account deletion support

#### 💬 AI Chat (`features/chat`)
- AI-powered conversations (OpenAI/Claude compatible)
- Message persistence to local database
- Conversation history management
- AI configuration management
- Real-time message streaming

#### 🏠 Home (`features/home`)
- Main dashboard screen
- Feature navigation hub
- Quick access to all features
- User-specific content display

#### ⚙️ Settings (`features/settings`)
- Theme switching (Light/Dark/System)
- Language preferences
- Notification settings
- Developer options
- App version information

#### 🔒 Privacy Policy (`features/privacy`)
- Privacy policy display
- Terms of service
- User consent management
- Data collection preferences
- Regional settings

#### 🌐 WebView (`features/webview`)
- Full-featured WebView with JavaScript bridge
- Custom navigation controls
- Error handling and loading states
- Local storage, cookies, and session management

## 🛠 Tech Stack

| Category | Technology |
|----------|------------|
| State Management | flutter_riverpod, riverpod_annotation, riverpod_generator |
| Networking | dio, talker_dio_logger |
| Local Database | drift, sqlite3_flutter_libs, path_provider |
| Routing | go_router |
| Dependency Injection | get_it, injectable |
| Serialization | json_serializable, freezed |
| Logging | talker, talker_flutter, talker_dio_logger, talker_riverpod_logger |
| i18n | flutter_localizations, intl, intl_utils |
| Secure Storage | flutter_secure_storage |
| Preferences | shared_preferences |
| WebView | webview_flutter |
| Utils | uuid, connectivity_plus, crypto, collection |
| UI | flutter_pickers, image_picker, url_launcher, permission_handler, vibration |
| App Info | package_info_plus |

## 📦 Requirements

- Flutter SDK: `>=3.38.10`
- Dart SDK: `>=3.6.0`

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.38.10 or higher)
- [Dart SDK](https://dart.dev/get-dart) (3.6.0 or higher)
- A code editor ([VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio))

### Installation

#### 1. Clone the repository

```bash
git clone https://github.com/xyhuangjia/flutter_project_template.git
cd flutter_project_template
```

#### 2. Install dependencies

```bash
flutter pub get
```

#### 3. Generate code

```bash
dart run build_runner build --delete-conflicting-outputs
```

#### 4. Configure environment

Create a `.env` file in the root directory:

```env
API_BASE_URL=https://api.example.com
APP_NAME=Flutter Project Template
```

#### 5. Run the project

```bash
flutter run
```

## 📁 Project Structure

```
lib/
├── app.dart                    # MaterialApp configuration
├── main.dart                   # App entry point
├── core/                       # Core layer
│   ├── config/                 # Environment configuration
│   ├── constants/              # App constants
│   ├── errors/                 # Error handling
│   ├── logging/                # Logging config (Talker)
│   ├── network/                # Network layer (Dio)
│   ├── providers/              # Global providers
│   ├── router/                 # Routing (GoRouter)
│   ├── splash/                 # Splash screen
│   ├── storage/                # Database (Drift) & storage
│   ├── theme/                  # App theming
│   └── utils/                  # Utilities & extensions
├── features/                   # Feature modules
│   ├── auth/                   # Authentication module
│   │   ├── data/               # Data layer (repository impl, data sources)
│   │   ├── domain/             # Domain layer (entities, repositories, use cases)
│   │   └── presentation/       # Presentation layer (screens, providers, widgets)
│   ├── chat/                   # AI Chat module
│   │   ├── data/               # Message persistence, AI API integration
│   │   ├── domain/             # Chat entities, conversation management
│   │   ├── presentation/       # Chat UI, message components
│   │   └── utils/              # Chat utilities
│   ├── home/                   # Home module
│   │   ├── data/               # Home data layer
│   │   ├── domain/             # Home entities
│   │   └── presentation/       # Home screen UI
│   ├── profile/                 # Profile module
│   │   ├── data/               # Profile data layer
│   │   ├── domain/             # Profile entities
│   │   └── presentation/       # Profile screen UI (change password, etc.)
│   ├── privacy/                # Privacy policy module
│   │   ├── data/               # Privacy data
│   │   ├── domain/             # Privacy entities
│   │   └── presentation/       # Privacy screen
│   ├── settings/               # Settings module
│   │   ├── data/               # Settings persistence
│   │   ├── domain/             # Settings entities
│   │   └── presentation/       # Settings screen
│   └── webview/                # WebView module
│       ├── data/               # WebView state management
│       ├── domain/             # WebView configuration
│       └── presentation/       # WebView screen with controls
├── shared/                     # Shared modules
│   ├── models/                 # Shared data models
│   └── widgets/                # Reusable widgets
├── l10n/                       # Internationalization
│   ├── app_en.arb              # English translations
│   └── app_zh.arb              # Chinese translations
└── generated/                  # Generated code
    └── intl/                   # Generated i18n files
```

## 🏗 Architecture

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

### Feature Module Architecture

Each feature follows Clean Architecture with three layers:

```
features/{feature}/
├── data/                          # Data Layer
│   ├── datasources/               # Remote & Local data sources
│   ├── models/                    # Data transfer objects (DTOs)
│   └── repositories/              # Repository implementations
├── domain/                        # Domain Layer
│   ├── entities/                  # Business objects
│   ├── repositories/              # Repository interfaces
│   └── usecases/                  # Business logic use cases
└── presentation/                  # Presentation Layer
    ├── providers/                 # Riverpod providers (state management)
    ├── screens/                   # UI screens/pages
    └── widgets/                   # Feature-specific widgets
```

## 📖 Documentation

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

#### Riverpod 3.x Breaking Changes

The project has been upgraded to Riverpod 3.x. Here are the important API changes to note:

**1. Simplified Provider Names**
- Generated provider names no longer include "Provider" suffix
- `AuthNotifier` class → generated provider is `authProvider` (not `authNotifierProvider`)
- 2.x syntax: `authNotifierProvider`
- 3.x syntax: `authProvider`

**2. Unified Ref Type**
- All provider parameter Ref types are unified to `Ref`
- 2.x: Required specific `*Ref` types like `DioClientRef`
- 3.x: Unified `Ref`

```dart
// 3.x standard syntax
@riverpod
DioClient dioClient(Ref ref) { ... }
```

**3. AsyncValue API Changes**
- `AsyncValue.valueOrNull` has been removed
- Use `.value` directly with null-aware operators

```dart
// 2.x
final user = state.valueOrNull?.user;

// 3.x
final user = state.value?.user;
```

**4. Notifier Internal State Access**
- Inside Notifiers, use `state` directly
- No longer use `this.ref.state`

```dart
// 2.x
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  void increment() => this.ref.state++;
}

// 3.x
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  void increment() => state++;
}
```

For complete migration guide, see: [Riverpod 3.x Migration Documentation](https://riverpod.dev/docs/3.0_migration)

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

This project uses code generation for:
- **Riverpod Providers** - State management
- **Freezed Models** - Immutable data classes
- **JSON Serialization** - fromJson/toJson methods
- **Drift Database** - Type-safe database code
- **Injectable** - Dependency injection

```bash
# Generate all code files
dart run build_runner build --delete-conflicting-outputs

# Watch mode for development (auto-generates on changes)
dart run build_runner watch --delete-conflicting-outputs

# Generate localization files
flutter gen-l10n
```

### Internationalization

The app supports multiple languages. To add a new translation:

1. Add keys to `lib/l10n/app_en.arb` and `lib/l10n/app_zh.arb`
2. Run `flutter gen-l10n`
3. Use in code: `AppLocalizations.of(context)!.yourKey`

### Environment Configuration

The project uses `.env` file for environment variables:

```env
# App Configuration
APP_NAME=Flutter Project Template
ENVIRONMENT=development  # development | staging | production

# API Configuration
API_BASE_URL=https://api.example.com

# AI Configuration (for Chat module)
OPENAI_API_KEY=your_openai_api_key
AI_MODEL=gpt-4
```

Available environments: `development`, `staging`, `production`

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📮 Contact

Project Link: [https://github.com/xyhuangjia/flutter_project_template](https://github.com/xyhuangjia/flutter_project_template)

---

<div align="center">
  <p>Made with ❤️ by the Flutter Community</p>
  <p>
    <a href="#top">Back to Top</a>
  </p>
</div>