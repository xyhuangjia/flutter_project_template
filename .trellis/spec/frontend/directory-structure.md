# Directory Structure

> Clean Architecture directory structure for Flutter projects.

---

## Overview

This project follows **Clean Architecture** principles with a feature-first organization. The architecture separates concerns into distinct layers, making the codebase:

- **Testable**: Business logic is isolated from UI and external dependencies
- **Maintainable**: Changes in one layer don't ripple to others
- **Scalable**: New features follow the same pattern
- **Independent**: Domain layer has no dependencies on frameworks

---

## Directory Layout

```
lib/
├── app.dart                    # MaterialApp configuration
├── main.dart                   # Application entry point
├── core/                       # Shared infrastructure layer
│   ├── constants/              # Application-wide constants
│   │   ├── api_constants.dart
│   │   ├── app_colors.dart
│   │   └── app_strings.dart
│   ├── errors/                 # Exception and failure classes
│   │   ├── exceptions.dart
│   │   ├── failures.dart
│   │   └── error_handler.dart
│   ├── network/                # Dio/Retrofit configuration
│   │   ├── dio_client.dart
│   │   ├── api_interceptor.dart
│   │   └── api_result.dart
│   ├── router/                 # GoRouter configuration
│   │   ├── app_router.dart
│   │   ├── router_guard.dart
│   │   └── routes.dart
│   ├── storage/                # Drift database configuration
│   │   ├── database.dart
│   │   ├── database_provider.dart
│   │   └── migrations/
│   └── utils/                  # Utility functions
│       ├── date_utils.dart
│       ├── validators.dart
│       └── extensions/
├── features/                   # Feature modules (Clean Architecture)
│   └── {feature}/              # e.g., auth, profile, settings
│       ├── data/               # Data layer
│       │   ├── datasources/    # Local and remote data sources
│       │   │   ├── local/
│       │   │   │   └── {feature}_local_data_source.dart
│       │   │   └── remote/
│       │   │       └── {feature}_remote_data_source.dart
│       │   ├── models/         # DTOs (json_serializable)
│       │   │   ├── {feature}_dto.dart
│       │   │   ├── {feature}_dto.freezed.dart
│       │   │   └── {feature}_dto.g.dart
│       │   └── repositories/   # Repository implementations
│       │       └── {feature}_repository_impl.dart
│       ├── domain/             # Domain layer (pure Dart)
│       │   ├── entities/       # Business entities
│       │   │   └── {feature}.dart
│       │   ├── repositories/   # Repository interfaces
│       │   │   └── {feature}_repository.dart
│       │   └── usecases/       # Use cases (optional)
│       │       ├── get_{feature}.dart
│       │       └── save_{feature}.dart
│       └── presentation/       # Presentation layer
│           ├── providers/      # Riverpod providers
│           │   ├── {feature}_provider.dart
│           │   └── {feature}_state.dart
│           ├── screens/        # Full pages
│           │   ├── {feature}_screen.dart
│           │   └── {feature}_detail_screen.dart
│           └── widgets/        # Feature-specific widgets
│               ├── {feature}_card.dart
│               └── {feature}_list_item.dart
└── shared/                     # Cross-feature shared code
    ├── models/                 # Shared DTOs/models
    │   ├── pagination_dto.dart
    │   └── user_dto.dart
    └── widgets/                # Shared widgets
        ├── loading_indicator.dart
        ├── error_widget.dart
        └── empty_state_widget.dart
```

---

## Layer Responsibilities

### 1. Core Layer (`core/`)

**Purpose**: Contains shared infrastructure code used across all features.

| Directory | Responsibility |
|-----------|----------------|
| `constants/` | Application-wide constants: API endpoints, colors, strings, dimensions |
| `errors/` | Custom exception classes, failure types, error handling utilities |
| `network/` | HTTP client setup (Dio/Retrofit), interceptors, response wrappers |
| `router/` | Navigation configuration (GoRouter), route definitions, guards |
| `storage/` | Local database setup (Drift), migrations, database provider |
| `utils/` | Helper functions, validators, extension methods |

**Rules**:
- Core code should be **framework-agnostic** where possible
- No business logic in core layer
- Keep it minimal - only truly shared code belongs here

### 2. Features Layer (`features/`)

**Purpose**: Contains all feature modules following Clean Architecture.

Each feature is divided into three sub-layers:

#### 2.1 Data Layer (`data/`)

**Purpose**: Handles data operations and implements repository interfaces.

| Directory | Responsibility |
|-----------|----------------|
| `datasources/` | Abstract data sources (local DB, remote API, cache) |
| `models/` | Data Transfer Objects (DTOs) with JSON serialization |
| `repositories/` | Concrete implementations of domain repositories |

**Key Points**:
- DTOs should use `json_serializable` or `freezed` for serialization
- Data sources should be abstract classes for testability
- Repository implementations coordinate between data sources

```dart
// Example: data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final dto = await _remoteDataSource.login(email, password);
      await _localDataSource.cacheToken(dto.token);
      return Right(dto.toEntity());
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
```

#### 2.2 Domain Layer (`domain/`)

**Purpose**: Contains pure business logic with **zero external dependencies**.

| Directory | Responsibility |
|-----------|----------------|
| `entities/` | Business objects with no serialization logic |
| `repositories/` | Abstract interfaces defining data contracts |
| `usecases/` | Single-responsibility business operations (optional) |

**Key Points**:
- **NO dependencies** on Flutter, Dio, or any external package
- Entities are immutable and contain business validation
- Use cases encapsulate single business actions (optional, can be skipped for simpler apps)

```dart
// Example: domain/entities/user.dart
class User {
  final String id;
  final String email;
  final String name;

  const User({
    required this.id,
    required this.email,
    required this.name,
  });

  bool get isValidEmail => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
}
```

#### 2.3 Presentation Layer (`presentation/`)

**Purpose**: UI components and state management.

| Directory | Responsibility |
|-----------|----------------|
| `providers/` | Riverpod providers and state classes |
| `screens/` | Full-page widgets (routable) |
| `widgets/` | Reusable components specific to this feature |

**Key Points**:
- Screens should be composed of smaller widgets
- Providers handle state and business logic
- Widgets should be dumb and receive data via parameters

```dart
// Example: presentation/providers/auth_provider.dart
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<AuthState> build() => AsyncData(AuthState.initial());

  Future<void> login(String email, String password) async {
    state = AsyncLoading();
    final result = await _repository.login(email, password);
    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (user) => AsyncData(AuthState.authenticated(user)),
    );
  }
}
```

### 3. Shared Layer (`shared/`)

**Purpose**: Code shared across multiple features but not infrastructure.

| Directory | Responsibility |
|-----------|----------------|
| `models/` | DTOs used by multiple features (e.g., User, Pagination) |
| `widgets/` | Reusable UI components (LoadingIndicator, ErrorWidget) |

---

## Naming Conventions

### Files and Folders

| Type | Convention | Example |
|------|------------|---------|
| Directories | `snake_case` | `auth/`, `user_profile/` |
| Dart files | `snake_case.dart` | `auth_repository.dart` |
| Generated files | `.freezed.dart`, `.g.dart` | `user_dto.freezed.dart` |
| Feature folder | Singular noun | `auth/` (not `auths/`) |

### Classes

| Type | Convention | Example |
|------|------------|---------|
| Entities | PascalCase, noun | `User`, `Product`, `Order` |
| DTOs | PascalCase + `Dto` suffix | `UserDto`, `ProductDto` |
| Repositories (interface) | PascalCase + `Repository` | `AuthRepository` |
| Repositories (impl) | PascalCase + `RepositoryImpl` | `AuthRepositoryImpl` |
| Data Sources | PascalCase + `DataSource` | `AuthRemoteDataSource` |
| Use Cases | PascalCase, verb + noun | `GetUserProfile`, `SaveSettings` |
| Screens | PascalCase + `Screen` | `LoginScreen`, `ProfileScreen` |
| Widgets | PascalCase, descriptive | `UserCard`, `ProductListItem` |
| Providers | PascalCase + `Provider` | `AuthProvider`, `UserProvider` |
| States | PascalCase + `State` | `AuthState`, `UserState` |

### Variables and Functions

| Type | Convention | Example |
|------|------------|---------|
| Variables | `camelCase` | `currentUser`, `isLoading` |
| Private members | `_camelCase` | `_repository`, `_handleError` |
| Constants | `camelCase` or `SCREAMING_SNAKE` | `defaultTimeout`, `MAX_RETRY_COUNT` |
| Functions | `camelCase`, verb first | `fetchUsers()`, `calculateTotal()` |
| Async functions | `camelCase`, verb first | `loadData()`, `saveChanges()` |

---

## When to Create a New Feature Module

### Criteria for a New Feature

Create a new feature module when:

1. **Distinct business domain**: The functionality represents a separate business concern
2. **Multiple screens**: The feature has more than one related screen
3. **Own data model**: The feature manages its own entities/data
4. **Independent development**: Can be developed and tested in isolation

### Examples

| Feature | Justification |
|---------|---------------|
| `auth` | Login, registration, password reset - distinct user authentication flow |
| `profile` | User profile viewing and editing - separate from auth logic |
| `settings` | App preferences, theme, notifications - configuration domain |
| `cart` | Shopping cart management - e-commerce specific |
| `notifications` | Push notifications, in-app messages - communication domain |

### When NOT to Create a New Feature

- **Single screen**: Put in `shared/` or within existing feature
- **Shared utilities**: Belongs in `core/utils/`
- **Generic widgets**: Belongs in `shared/widgets/`
- **Configuration**: Belongs in `core/`

---

## Anti-Patterns to Avoid

### 1. Layer Violations

**WRONG**: Domain layer depending on Flutter or external packages

```dart
// DON'T: Domain entity with Flutter dependency
import 'package:flutter/material.dart';

class User {
  final Color themeColor; // Flutter dependency in domain!
}
```

**CORRECT**: Keep domain pure

```dart
// DO: Pure Dart domain entity
class User {
  final String themeColorHex; // Platform-agnostic

  const User({required this.themeColorHex});
}
```

### 2. God Classes / Bloated Features

**WRONG**: One feature handling too many responsibilities

```
features/
└── user/              # TOO BROAD
    ├── data/
    │   ├── datasources/
    │   │   ├── auth_data_source.dart      # Auth logic
    │   │   ├── profile_data_source.dart   # Profile logic
    │   │   └── settings_data_source.dart  # Settings logic
    └── ...
```

**CORRECT**: Split into focused features

```
features/
├── auth/              # Authentication only
├── profile/           # Profile management
└── settings/          # App settings
```

### 3. Business Logic in Widgets

**WRONG**: Logic embedded in UI

```dart
// DON'T: Business logic in widget
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // API call directly in widget!
        final response = await dio.post('/login', data: {...});
        if (response.statusCode == 200) {
          Navigator.pushNamed(context, '/home');
        }
      },
      child: Text('Login'),
    );
  }
}
```

**CORRECT**: Logic in providers/use cases

```dart
// DO: Logic handled by provider
class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return ElevatedButton(
      onPressed: () => ref.read(authNotifierProvider.notifier).login(
        emailController.text,
        passwordController.text,
      ),
      child: Text('Login'),
    );
  }
}
```

### 4. Skipping Repository Pattern

**WRONG**: UI directly accessing data sources

```dart
// DON'T: Widget calling data source directly
final user = await ref.read(remoteDataSourceProvider).getUser();
```

**CORRECT**: Always go through repository

```dart
// DO: Use repository abstraction
final user = await ref.read(authRepositoryProvider).getUser();
```

### 5. Mutable State in Entities

**WRONG**: Mutable domain entities

```dart
// DON'T: Mutable entity
class User {
  String name;
  String email;

  User({required this.name, required this.email});

  void updateEmail(String newEmail) {
    email = newEmail;
  }
}
```

**CORRECT**: Immutable entities with copyWith

```dart
// DO: Immutable entity
class User {
  final String name;
  final String email;

  const User({required this.name, required this.email});

  User copyWith({String? name, String? email}) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}
```

### 6. Tight Coupling Between Features

**WRONG**: Direct imports between features

```dart
// DON'T: Importing another feature directly
import 'package:app/features/auth/presentation/providers/auth_provider.dart';
```

**CORRECT**: Use shared domain or core layer

```dart
// DO: Use shared interfaces or core providers
import 'package:app/core/router/routes.dart';
import 'package:app/shared/models/user_dto.dart';
```

---

## Migration Guide

When adding a new feature, follow this order:

1. **Create feature directory structure**
   ```bash
   mkdir -p lib/features/{feature}/{data/{datasources/{local,remote},models,repositories},domain/{entities,repositories,usecases},presentation/{providers,screens,widgets}}
   ```

2. **Define domain entities** (pure Dart, no dependencies)

3. **Create repository interfaces** (domain layer)

4. **Implement DTOs** (data layer, with serialization)

5. **Create data sources** (abstract classes)

6. **Implement repository** (coordinates data sources)

7. **Create providers** (state management)

8. **Build screens and widgets** (UI layer)

9. **Register routes** (in `core/router/`)

---

## Quick Reference

### Layer Dependency Rule

```
Presentation --> Domain <-- Data
     |            ^          |
     v            |          v
   Core          NO      Core
              Dependencies
```

- **Domain**: Zero external dependencies
- **Presentation**: Depends on Domain and Core
- **Data**: Depends on Domain and Core

### File Count Guidelines

| Layer | Typical Files per Feature |
|-------|--------------------------|
| Domain | 2-5 entities, 1-2 repositories, 0-5 use cases |
| Data | 2-3 data sources, 2-5 DTOs, 1-2 repository impls |
| Presentation | 1-3 providers, 2-5 screens, 3-10 widgets |

---

## Summary

Following this directory structure ensures:

- Clear separation of concerns
- Testable business logic
- Scalable codebase
- Consistent patterns across features
- Easy onboarding for new developers

**Core Philosophy**: Domain is king. Everything else serves the domain layer.
