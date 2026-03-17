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

- 🏗️ **Clean Architecture** - Clear layered architecture (Domain, Data, Presentation)
- 🔄 **Riverpod State Management** - Code generation with riverpod_generator
- 📝 **Talker Logging** - Complete logging solution
- 🌐 **Dio HTTP Client** - Well-configured network layer
- 💾 **Drift Database** - Type-safe local database
- 🚀 **GoRouter Routing** - Declarative routing management
- 🌍 **Internationalization** - Multi-language support (English/Chinese)
- 🔒 **Type Safety** - freezed + json_serializable strongly typed models
- 🎨 **Code Standards** - Comprehensive lint rules

## 🛠 Tech Stack

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

Your Name - [@your_twitter](https://twitter.com/your_twitter)

Project Link: [https://github.com/xyhuangjia/flutte_project_template](https://github.com/xyhuangjia/flutte_project_template)

---

<div align="center">
  <p>Made with ❤️ by the Flutter Community</p>
  <p>
    <a href="#top">Back to Top</a>
  </p>
</div>