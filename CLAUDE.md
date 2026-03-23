# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a production-ready Flutter template using Clean Architecture principles. The app features modular design with separation of concerns across Domain, Data, and Presentation layers.

## Technology Stack

### Core Framework
- **Flutter SDK**: 3.38.10
- **Dart SDK**: >=3.6.0 <4.0.0

### State Management
- **Riverpod 3.x**: `flutter_riverpod:^3.0.0` + `riverpod_annotation:^4.0.0`
- Uses code generation via `riverpod_generator:^4.0.0+1`
- **Key change**: All provider functions use unified `Ref` type (not `*Ref`)

### Networking
- **Dio**: `^5.8.0` - HTTP client with interceptors
- **Talker Dio Logger**: `^5.1.15` - Request/response logging

### Local Database
- **Drift**: `^2.26.0` - Type-safe SQLite with code generation
- **sqlite3_flutter_libs**: `^0.6.0+eol` - SQLite binaries

### JSON Serialization
- **Freezed**: `^3.2.3` - Immutable data classes with union types
- **json_serializable**: `^6.9.3` - JSON serialization code generation

### Routing
- **GoRouter**: `^17.1.0` - Declarative routing with deep linking

### Dependency Injection
- **GetIt**: `^9.2.1` - Service locator
- **Injectable**: `^2.7.1` - DI code generation

### Logging
- **Talker**: `^5.1.15` - Advanced logging with persistence
- **Talker Riverpod Logger**: `^5.1.14` - Provider state logging

### Other Key Dependencies
- **flutter_dotenv**: `^6.0.0` - Environment variables
- **flutter_secure_storage**: `^10.0.0` - Secure token storage
- **shared_preferences**: `^2.3.3` - Simple key-value storage
- **connectivity_plus**: `^7.0.0` - Network status
- **webview_flutter**: `^4.10.0` - WebView integration
- **intl**: `^0.20.2` - Internationalization

## Common Development Commands

### Code Generation
```bash
# Generate all code files (models, providers, database)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for development (auto-generates on changes)
dart run build_runner watch --delete-conflicting-outputs

# Regenerate specific files
dart run build_runner build --delete-conflicting-outputs
```

### Testing
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run widget tests
flutter test test/widget_test.dart

# Run integration tests
flutter test integration_test/
```

### Build and Run
```bash
# Run on device/emulator
flutter run

# Build for release
flutter build apk --release
flutter build appbundle --release

# Clean build cache
flutter clean
```

### Linting and Code Quality
```bash
# Run Dart analyzer
dart analyze

# Format code
dart format .

# Check for lint issues
flutter analyze
```

## Architecture Overview

### Clean Architecture Layers

The project follows **Clean Architecture** with a feature-first organization:

```
Presentation --> Domain <-- Data
     |            ^          |
     v            |          v
   Core      NO Dependencies  Core
```

- **Domain Layer**: Pure Dart with zero external dependencies. Contains entities, repository interfaces, and use cases.
- **Data Layer**: Implements repositories, handles data sources (local/remote), and contains DTOs with JSON serialization.
- **Presentation Layer**: UI components (screens/widgets) and Riverpod providers for state management.
- **Core Layer**: Shared infrastructure (networking, storage, routing, theming).

### Layer Dependency Rule
- Domain has **NO dependencies** on Flutter or external packages
- Presentation depends on Domain and Core
- Data depends on Domain and Core

### Project Structure
```
lib/
├── core/                    # Shared infrastructure
│   ├── config/             # Environment configuration
│   ├── constants/          # App constants
│   ├── errors/             # Exception/failure classes
│   ├── logging/            # Talker configuration
│   ├── network/            # Dio HTTP client setup
│   ├── providers/          # Global providers
│   ├── router/             # GoRouter configuration
│   ├── storage/            # Drift database
│   ├── theme/              # App theming (Material 3)
│   └── utils/              # Utilities and extensions
├── features/               # Feature modules
│   └── {feature}/
│       ├── data/           # DTOs, data sources, repository impls
│       ├── domain/         # Entities, repository interfaces
│       └── presentation/   # Providers, screens, widgets
└── shared/                 # Cross-feature shared code
    ├── models/             # Shared DTOs
    └── widgets/            # Reusable widgets
```

## Coding Standards

**IMPORTANT**: Before writing code, read the detailed guidelines in `.trellis/spec/frontend/`:

| Document | Purpose | When to Read |
|----------|---------|--------------|
| `directory-structure.md` | Clean Architecture organization | Creating new features |
| `state-management.md` | Riverpod 3.x patterns | Writing providers |
| `hook-guidelines.md` | Notifier/AsyncNotifier patterns | State management |
| `component-guidelines.md` | Widget patterns | Building UI |
| `chinese-app-style.md` | UI design style for Chinese apps | **Before any UI work** |
| `quality-guidelines.md` | Lint rules, testing standards | Code review |
| `type-safety.md` | json_serializable, Drift patterns | Data models |
| `i18n-guidelines.md` | Internationalization | Adding text |

### Riverpod 3.x Key Changes

```dart
// ✅ 3.x: Unified Ref type for all provider functions
@riverpod
UserRepository userRepository(Ref ref) {
  return UserRepositoryImpl();
}

// ❌ 2.x: No longer needed - specific Ref types
@riverpod
UserRepository userRepository(UserRepositoryRef ref) { ... }
```

### Provider Patterns

```dart
// AsyncNotifier for async state with mutations
@riverpod
class Auth extends _$Auth {
  @override
  AsyncValue<AuthState> build() => const AsyncValue.data(AuthState.unauthenticated());

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repository.login(email, password));
  }
}

// Notifier for synchronous state
@riverpod
class Theme extends _$Theme {
  @override
  ThemeMode build() => ThemeMode.system;

  void toggle() => state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
}
```

### Model Generation (Freezed + json_serializable)

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

### Code Quality Commands

```bash
# Run static analysis
dart analyze

# Format code
dart format .

# Run tests
flutter test

# Generate code (after model/provider changes)
dart run build_runner build --delete-conflicting-outputs
```

### Forbidden Patterns

- **Global mutable state** - Use Riverpod providers instead
- **Business logic in widgets** - Move to providers/use cases
- **Dynamic types** - Use proper type annotations
- **Hardcoded strings** - Use `AppLocalizations` for i18n
- **Magic numbers** - Use named constants or Theme values

## Key Features

### Database (Drift)
- Type-safe SQLite database with code generation
- Auto-migrations support
- Stored in `lib/core/storage/database.dart`

### Internationalization
- Multi-language support (EN/CN)
- ARB files in `lib/l10n/`
- Generated dart_tool/flutter_gen/gen_l10n/

### Environment Configuration
- `.env` file support via `flutter_dotenv`
- Environment switching via `EnvironmentProvider`
- Development, staging, and production environments

### Logging
- Comprehensive logging with Talker
- HTTP request/response logging with Dio
- Console logs in debug mode

### Feature Development Workflow
1. Create feature module under `lib/features/`
2. Follow domain → data → presentation layers
3. Update routing in `lib/core/router/app_router.dart`
4. Run `dart run build_runner build --delete-conflicting-outputs`
5. Write tests in `test/features/{feature}/`


## Integration Points

### WebView Module
- Full-featured WebView with JavaScript bridge
- Custom navigation controls
- Error handling and loading states
- Local storage, cookies, and session management

### Chat Module
- AI-powered chat with OpenAI/Claude integration
- Message persistence to local database
- Conversation history management
- AI configuration management

### Authentication
- Social login support
- Token-based auth with secure storage
- Automatic session management

## Environment Setup

Create `.env` file in root:
```env
API_BASE_URL=https://api.example.com
APP_NAME=Flutter Project Template
ENVIRONMENT=development
```

Available environments: `development`, `staging`, `production`