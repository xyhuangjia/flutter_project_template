# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a production-ready Flutter template using Clean Architecture principles. The app features modular design with separation of concerns across Domain, Data, and Presentation layers.

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
- **Domain Layer**: Contains entities, use cases, and repository interfaces
- **Data Layer**: Contains data sources, repository implementations, and models
- **Presentation Layer**: Contains screens, providers, and widgets

### Key Patterns
- **Riverpod for State Management**: Uses `@riverpod` for providers and `Notifier`/`AsyncNotifier` for state
- **Repository Pattern**: Abstract repository interfaces with concrete implementations
- **Use Cases**: Business logic encapsulation in domain layer
- **Dependency Injection**: Using `get_it` and `injectable`

### Project Structure
```
lib/
├── core/                    # Core functionality
│   ├── config/             # Environment and configuration
│   ├── constants/          # App constants
│   ├── errors/             # Error handling
│   ├── logging/            # Logging configuration (Talker)
│   ├── network/            # HTTP client (Dio) configuration
│   ├── providers/          # Global providers
│   ├── router/             # Routing configuration (GoRouter)
│   ├── storage/            # Database (Drift) and storage
│   ├── theme/              # App theming
│   └── utils/              # Utility functions and extensions
├── features/               # Feature modules
│   ├── auth/               # Authentication
│   ├── chat/               # Chat functionality
│   ├── home/               # Home screen
│   ├── settings/           # Settings management
│   └── webview/            # WebView integration
└── shared/                 # Shared components
    ├── models/             # Shared data models
    └── widgets/            # Reusable widgets
```

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

### State Management Patterns
```dart
// AsyncNotifier for async state
@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  Future<HomeEntity> build() async {
    // Initialize state
    return await ref.watch(homeRepositoryProvider).getHomeData();
  }
}

// Regular Notifier for sync state
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeState build() {
    return const ThemeState();
  }
}
```

### Feature Development Workflow
1. Create feature module under `lib/features/`
2. Follow domain → data → presentation layers
3. Update routing in `lib/core/router/app_router.dart`
4. Register dependencies if needed
5. Generate code after creating model files

## Code Generation Details

### Model Generation
Models use `freezed` and `json_serializable`:
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

### Provider Generation
Providers use `riverpod_annotation` and `riverpod_generator`:
```dart
@riverpod
class UserProfileNotifier extends _$UserProfileNotifier {
  @override
  UserProfileState build() {
    return UserProfileInitial();
  }
}
```

### Database Generation
Drift database tables and queries:
```dart
@DriftTable()
class Users extends Table {
  TextColumn get id => text()();
  // ... other columns
}
```

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