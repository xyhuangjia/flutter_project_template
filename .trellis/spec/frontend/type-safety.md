# Type Safety

> Type safety patterns in this project.

---

## Overview

This project leverages Dart's sound null safety system and multiple code generation packages to ensure type safety at compile time and runtime. We use:

- **json_serializable** - JSON serialization/deserialization with type safety
- **freezed** - Immutable data classes with union types and pattern matching
- **Drift** - Type-safe SQL database with compile-time query validation
- **retrofit** - Type-safe HTTP client generation

All models must be strongly typed. Avoid `dynamic` and raw `Map<String, dynamic>` outside of serialization boundaries.

---

## Null Safety Best Practices

### Core Principles

1. **Prefer non-nullable types by default** - Only use `?` when null is a valid state
2. **Use late for deferred initialization** - When you can guarantee initialization before use
3. **Avoid ! operator** - Use null checks or provide default values instead
4. **Handle null explicitly** - Document why a value can be null

### Do's

```dart
// Good: Provide default values
String get displayName => user.name ?? 'Anonymous';

// Good: Use null-aware operators
final length = optionalString?.length ?? 0;

// Good: Use if-null for transformations
final result = input ?? defaultValue;

// Good: Early return for null checks
Future<User> fetchUser(String id) async {
  final response = await api.getUser(id);
  if (response == null) {
    throw UserNotFoundException(id);
  }
  return response;
}
```

### Don'ts

```dart
// Bad: Force unwrap without check
final name = user.name!; // Crashes if null

// Bad: Using dynamic
dynamic data = jsonDecode(response); // Loses type safety

// Bad: Nullable where non-null is appropriate
String? calculateTotal(List<Item> items) {
  // Should never return null, just return 0.0
}
```

---

## json_serializable Model Creation

### Setup

Add to `pubspec.yaml`:

```yaml
dependencies:
  json_annotation: ^4.8.0

dev_dependencies:
  json_serializable: ^6.6.0
  build_runner: ^2.4.0
```

### Complete Model Example

```dart
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// User model representing an authenticated user.
///
/// All fields are required unless explicitly marked nullable.
@JsonSerializable(explicitToJson: true)
class User {
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.avatarUrl,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Unique identifier for the user.
  final String id;

  /// User's email address (validated server-side).
  final String email;

  /// Display name shown in the UI.
  final String name;

  /// User's role for authorization.
  final UserRole role;

  /// Optional URL to user's avatar image.
  final String? avatarUrl;

  /// Additional metadata that may vary by user.
  final Map<String, dynamic>? metadata;

  /// When the user account was created.
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// When the user account was last updated.
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  /// Creates a User from JSON map.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Converts User to JSON map.
  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// Creates a copy of this User with optionally overridden fields.
  User copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    String? avatarUrl,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Enumeration of possible user roles.
@JsonEnum(alwaysCreate: true)
enum UserRole {
  @JsonValue('admin')
  admin,
  @JsonValue('moderator')
  moderator,
  @JsonValue('member')
  member,
  @JsonValue('guest')
  guest,
}
```

### Custom JSON Converters

For complex types like DateTime in nested objects:

```dart
/// Custom converter for Unix timestamp to DateTime.
class UnixDateTimeConverter implements JsonConverter<DateTime, int> {
  const UnixDateTimeConverter();

  @override
  DateTime fromJson(int json) =>
      DateTime.fromMillisecondsSinceEpoch(json * 1000);

  @override
  int toJson(DateTime object) => object.millisecondsSinceEpoch ~/ 1000;
}

// Usage in model
@JsonSerializable()
class Event {
  const Event({
    required this.id,
    @UnixDateTimeConverter() required this.timestamp,
  });

  final String id;
  final DateTime timestamp;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
}
```

### Running Code Generation

```bash
# Generate once
dart run build_runner build --delete-conflicting-outputs

# Watch for changes during development
dart run build_runner watch --delete-conflicting-outputs
```

---

## freezed for Immutable Models

### Setup

```yaml
dependencies:
  freezed_annotation: ^2.4.0

dev_dependencies:
  freezed: ^2.4.0
```

### Immutable Data Class Example

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

/// Immutable product model with generated equality, toString, and copyWith.
@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String description,
    required double price,
    @Default(0) int stockQuantity,
    @Default(false) bool isActive,
    required List<String> imageUrls,
    String? category,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
```

### Union Types (Sealed Classes)

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

/// Represents different authentication states using union types.
@freezed
sealed class AuthState with _$AuthState {
  /// User is not authenticated.
  const factory AuthState.unauthenticated() = AuthUnauthenticated;

  /// Authentication is in progress.
  const factory AuthState.authenticating() = AuthAuthenticating;

  /// User is successfully authenticated.
  const factory AuthState.authenticated({
    required User user,
    required String accessToken,
    required DateTime expiresAt,
  }) = AuthAuthenticated;

  /// Authentication failed with an error.
  const factory AuthState.error({
    required String message,
    AuthException? exception,
  }) = AuthError;
}

// Usage with pattern matching
Widget buildAuthWidget(AuthState state) {
  return switch (state) {
    AuthUnauthenticated() => const LoginScreen(),
    AuthAuthenticating() => const LoadingSpinner(),
    AuthAuthenticated(:final user) => HomeScreen(user: user),
    AuthError(:final message) => ErrorDisplay(message: message),
  };
}
```

---

## Drift Database Table Definitions

### Setup

```yaml
dependencies:
  drift: ^2.14.0
  sqlite3_flutter_libs: ^0.5.0

dev_dependencies:
  drift_dev: ^2.14.0
  build_runner: ^2.4.0
```

### Table Definition Example

```dart
import 'package:drift/drift.dart';

/// Users table definition.
///
/// Stores user profile information synced from the server.
class Users extends Table {
  /// Unique identifier (matches server ID).
  TextColumn get id => text()();

  /// User's email address.
  TextColumn get email => text().withLength(min: 5, max: 254)();

  /// Display name.
  TextColumn get name => text().withLength(min: 1, max: 100)();

  /// User role as string enum.
  TextColumn get role => textEnum<UserRole>()();

  /// Optional avatar URL.
  TextColumn get avatarUrl => text().nullable()();

  /// Server sync timestamp.
  DateTimeColumn get syncedAt => dateTime()();

  /// Local creation timestamp.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Sets the primary key.
  @override
  Set<Column> get primaryKey => {id};

  /// Unique constraint on email.
  @override
  List<Set<Column>>? get uniqueKeys => [
        {email}
      ];
}

/// Posts table with foreign key relationship.
class Posts extends Table {
  TextColumn get id => text()();
  TextColumn get authorId => text().references(Users, #id)();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get content => text()();
  BoolColumn get isPublished => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
```

### Database Definition with Queries

```dart
import 'package:drift/drift.dart';

part 'app_database.g.dart';

/// Application database with typed queries.
@DriftDatabase(tables: [Users, Posts])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Add migration code for version 2
        }
      },
    );
  }

  /// Fetches all active users.
  Future<List<User>> getAllUsers() => select(users).get();

  /// Fetches a user by ID.
  Future<User?> getUserById(String id) {
    return (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();
  }

  /// Watches users with role filter.
  Stream<List<User>> watchUsersByRole(UserRole role) {
    return (select(users)..where((u) => u.role.equals(role))).watch();
  }

  /// Inserts or updates a user.
  Future<void> upsertUser(UsersCompanion user) {
    return into(users).insertOnConflictUpdate(user);
  }

  /// Complex query with joins.
  Future<List<PostWithAuthor>> getPublishedPostsWithAuthors() {
    final query = select(posts).join([
      innerJoin(users, users.id.equalsExp(posts.authorId)),
    ])
      ..where(posts.isPublished.equals(true))
      ..orderBy([
        OrderingTerm.desc(posts.createdAt),
      ]);

    return query.map((row) {
      return PostWithAuthor(
        post: row.readTable(posts),
        author: row.readTable(users),
      );
    }).get();
  }
}

/// Result class for joined queries.
class PostWithAuthor {
  PostWithAuthor({required this.post, required this.author});

  final Post post;
  final User author;
}
```

---

## Type-safe API Responses with retrofit

### Setup

```yaml
dependencies:
  retrofit: ^4.0.0
  dio: ^5.4.0

dev_dependencies:
  retrofit_generator: ^8.0.0
  build_runner: ^2.4.0
```

### API Service Example

```dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

/// Type-safe REST API client.
@RestApi(baseUrl: 'https://api.example.com/v1')
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  /// Fetches all users with optional filtering.
  @GET('/users')
  Future<List<User>> getUsers({
    @Query('role') UserRole? role,
    @Query('page') int page = 1,
    @Query('limit') int limit = 20,
  });

  /// Fetches a single user by ID.
  @GET('/users/{id}')
  Future<User> getUserById(@Path('id') String id);

  /// Creates a new user.
  @POST('/users')
  Future<User> createUser(@Body() CreateUserRequest request);

  /// Updates an existing user.
  @PATCH('/users/{id}')
  Future<User> updateUser(
    @Path('id') String id,
    @Body() UpdateUserRequest request,
  );

  /// Deletes a user.
  @DELETE('/users/{id}')
  Future<void> deleteUser(@Path('id') String id);

  /// Uploads user avatar.
  @POST('/users/{id}/avatar')
  @MultiPart()
  Future<User> uploadAvatar(
    @Path('id') String id,
    @Part(name: 'file') File file,
  );
}

/// Request model for creating a user.
@JsonSerializable()
class CreateUserRequest {
  const CreateUserRequest({
    required this.email,
    required this.name,
    required this.role,
  });

  final String email;
  final String name;
  final UserRole role;

  factory CreateUserRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateUserRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateUserRequestToJson(this);
}

/// Request model for updating a user (partial updates).
@JsonSerializable()
class UpdateUserRequest {
  const UpdateUserRequest({
    this.email,
    this.name,
    this.role,
    this.avatarUrl,
  });

  final String? email;
  final String? name;
  final UserRole? role;
  final String? avatarUrl;

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateUserRequestToJson(this);
}
```

### API Response Wrapper

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

/// Generic API response wrapper for standardized error handling.
@freezed
class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse.success({
    required T data,
    String? message,
  }) = ApiSuccess<T>;

  const factory ApiResponse.error({
    required String code,
    required String message,
    Map<String, dynamic>? details,
  }) = ApiError<T>;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);
}
```

---

## Generic Type Usage

### Result Pattern

```dart
/// Generic result type for operations that can fail.
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(Exception error) failure,
  });

  T getOrElse(T Function() orElse);
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(Exception error) failure,
  }) =>
      success(data);

  @override
  T getOrElse(T Function() orElse) => data;
}

final class Failure<T> extends Result<T> {
  const Failure(this.error);

  final Exception error;

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(Exception error) failure,
  }) =>
      failure(error);

  @override
  T getOrElse(T Function() orElse) => orElse();
}

// Usage
Future<Result<User>> fetchUser(String id) async {
  try {
    final user = await apiClient.getUserById(id);
    return Success(user);
  } on DioException catch (e) {
    return Failure(NetworkException(e.message));
  }
}
```

### Generic Repository Pattern

```dart
/// Base repository interface with common CRUD operations.
abstract class Repository<T, Id> {
  Future<Result<T>> findById(Id id);
  Future<Result<List<T>>> findAll();
  Future<Result<T>> save(T entity);
  Future<Result<void>> delete(Id id);
}

/// Implementation with generic type constraints.
class UserRepository implements Repository<User, String> {
  UserRepository(this._apiClient, this._database);

  final ApiClient _apiClient;
  final AppDatabase _database;

  @override
  Future<Result<User>> findById(String id) async {
    try {
      // Try local database first
      final local = await _database.getUserById(id);
      if (local != null) {
        return Success(local);
      }

      // Fetch from API
      final remote = await _apiClient.getUserById(id);
      await _database.upsertUser(remote.toCompanion());
      return Success(remote);
    } catch (e) {
      return Failure(RepositoryException(e.toString()));
    }
  }

  @override
  Future<Result<List<User>>> findAll() async {
    // Implementation
    throw UnimplementedError();
  }

  @override
  Future<Result<User>> save(User entity) async {
    // Implementation
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> delete(String id) async {
    // Implementation
    throw UnimplementedError();
  }
}
```

---

## Type Casting Do's and Don'ts

### Safe Type Casting

```dart
// Good: Use as with type check first
if (value is User) {
  final user = value; // Dart promotes automatically
  print(user.name);
}

// Good: Use as? pattern (Dart 3)
final user = value as User?; // Returns null if not User

// Good: Pattern matching with types
switch (value) {
  case User(:final name):
    print('User: $name');
  case Product(:final name):
    print('Product: $name');
  default:
    print('Unknown type');
}
```

### Unsafe Type Casting

```dart
// Bad: Unsafe cast without check
final user = value as User; // Throws if not User

// Bad: Casting List<dynamic> directly
final users = json['users'] as List<User>; // Throws at runtime

// Good: Safe list casting
final users = (json['users'] as List)
    .cast<Map<String, dynamic>>()
    .map(User.fromJson)
    .toList();
```

### Type Checking Utilities

```dart
/// Type-safe JSON parsing utilities.
extension JsonParsing on Map<String, dynamic> {
  /// Parses a required string field.
  String parseString(String key) {
    final value = this[key];
    if (value is! String) {
      throw JsonParseException('Field "$key" must be a string');
    }
    return value;
  }

  /// Parses an optional string field.
  String? parseOptionalString(String key) {
    final value = this[key];
    return value is String ? value : null;
  }

  /// Parses a required list field.
  List<T> parseList<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    final value = this[key];
    if (value is! List) {
      throw JsonParseException('Field "$key" must be a list');
    }
    return value
        .cast<Map<String, dynamic>>()
        .map(fromJson)
        .toList();
  }
}
```

---

## Type Organization

### Directory Structure

```
lib/
├── models/
│   ├── user/
│   │   ├── user.dart          # Re-exports user.freezed.dart, user.g.dart
│   │   ├── user.freezed.dart  # Generated by freezed
│   │   └── user.g.dart        # Generated by json_serializable
│   ├── product/
│   └── ...
├── services/
│   └── api/
│       ├── api_client.dart
│       ├── api_client.g.dart  # Generated by retrofit
│       └── api_response.dart
├── database/
│   ├── tables/
│   │   ├── users.dart
│   │   └── posts.dart
│   ├── app_database.dart
│   └── app_database.g.dart    # Generated by drift
└── types/
    ├── result.dart            # Generic Result type
    └── json_parse_extension.dart
```

### Barrel Exports

```dart
// lib/models/user/user.dart
export 'user.freezed.dart';
export 'user.g.dart';

// Re-export with documentation
/// User model and related types.
library;

export 'user.freezed.dart' show User, _$User;
export 'user.g.dart' show _$UserFromJson, _$UserToJson;
```

---

## Forbidden Patterns

### Never Use These

1. **`dynamic` type** - Use `Object?` and type checks instead
2. **Implicit casts** - Always check before casting
3. **`!` operator without prior null check** - Use null-safe alternatives
4. **Raw `Map<String, dynamic>` in business logic** - Convert to typed models at boundaries
5. **Type toasts** - Quick `as` casts without validation

### Warning: Use Sparingly

1. **`late` keyword** - Only when initialization is guaranteed before access
2. **`Object` type** - Prefer specific types or generics
3. **`covariant` keyword** - Only in specific override scenarios

---

## Common Mistakes

1. **Forgetting `part` directives** - Causes build_runner to fail
2. **Mixing nullable and non-nullable in API models** - Be consistent with API contract
3. **Not handling `null` in JSON parsing** - Server may omit fields
4. **Using `dynamic` for "flexibility"** - Creates runtime errors instead of compile-time safety
5. **Forgetting `explicitToJson: true`** - Nested models won't serialize correctly
