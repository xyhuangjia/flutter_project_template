# Quality Guidelines

> Code quality standards for frontend development.

---

## Overview

This document defines the code quality standards for Flutter development in this project. All code must pass linting, include appropriate tests, and follow the patterns defined here.

---

## analysis_options.yaml Configuration

### Recommended Configuration

```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/*.gr.dart"
    - "lib/generated_plugin_registrant.dart"
    - "test/.test_coverage.dart"
    - "build/**"
    - ".dart_tool/**"

  errors:
    # Treat missing return as an error
    missing_return: error
    # Treat missing required parameter as an error
    missing_required_param: error
    # Treat unused imports as warnings
    unused_import: warning
    # Treat deprecated member use as info
    deprecated_member_use: info
    # Treat implicit dynamic as warning
    implicit_dynamic_parameter: warning
    implicit_dynamic_variable: warning

  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true

linter:
  rules:
    # Error rules
    - avoid_dynamic_calls
    - avoid_returning_null_for_future
    - avoid_slow_async_io
    - avoid_type_to_string
    - cancel_subscriptions
    - close_sinks
    - literal_only_boolean_expressions
    - no_adjacent_strings_in_list
    - test_types_in_equals
    - throw_in_finally
    - unnecessary_statements

    # Style rules
    - always_declare_return_types
    - always_put_required_named_parameters_first
    - always_use_package_imports
    - annotate_overrides
    - avoid_bool_literals_in_conditional_expressions
    - avoid_catches_without_on_clauses
    - avoid_catching_errors
    - avoid_double_and_int_checks
    - avoid_equals_and_hash_code_on_mutable_classes
    - avoid_escaping_inner_quotes
    - avoid_field_initializers_in_const_classes
    - avoid_final_parameters
    - avoid_function_literals_in_foreach_calls
    - avoid_implementing_value_types
    - avoid_init_to_null
    - avoid_multiple_declarations_per_line
    - avoid_null_checks_in_equality_operators
    - avoid_positional_boolean_parameters
    - avoid_private_typedef_functions
    - avoid_redundant_argument_values
    - avoid_renaming_method_parameters
    - avoid_return_types_on_setters
    - avoid_returning_null
    - avoid_returning_null_for_void
    - avoid_returning_this
    - avoid_setters_without_getters
    - avoid_shadowing_type_parameters
    - avoid_single_cascade_in_expression_statements
    - avoid_types_on_closure_parameters
    - avoid_unnecessary_containers
    - avoid_unused_constructor_parameters
    - avoid_void_async
    - await_only_futures
    - camel_case_extensions
    - camel_case_types
    - cascade_invocations
    - cast_nullable_to_non_nullable
    - combinators_ordering
    - conditional_uri_does_not_exist
    - constant_identifier_names
    - curly_braces_in_flow_control_structures
    - dangling_library_doc_comments
    - deprecated_consistency
    - directives_ordering
    - do_not_use_environment
    - empty_catches
    - empty_constructor_bodies
    - eol_at_end_of_file
    - exhaustive_cases
    - file_names
    - flutter_style_todos
    - hash_and_equals
    - implementation_imports
    - implicit_call_tearoffs
    - join_return_with_assignment
    - leading_newlines_in_multiline_strings
    - library_annotations
    - library_names
    - library_prefixes
    - library_private_types_in_public_api
    - lines_longer_than_80_chars
    - missing_whitespace_between_adjacent_strings
    - no_default_cases
    - no_leading_underscores_for_library_prefixes
    - no_leading_underscores_for_local_identifiers
    - no_literal_bool_comparisons
    - no_runtimeType_toString
    - non_constant_identifier_names
    - noop_primitive_operations
    - null_check_on_nullable_type_parameter
    - null_closures
    - omit_local_variable_types
    - one_member_abstracts
    - only_throw_errors
    - overridden_fields
    - package_api_docs
    - package_prefixed_library_names
    - parameter_assignments
    - prefer_adjacent_string_concatenation
    - prefer_asserts_in_initializer_lists
    - prefer_asserts_with_message
    - prefer_collection_literals
    - prefer_conditional_assignment
    - prefer_const_constructors
    - prefer_const_constructors_in_immutables
    - prefer_const_declarations
    - prefer_const_literals_to_create_immutables
    - prefer_constructors_over_static_methods
    - prefer_contains
    - prefer_expression_function_bodies
    - prefer_final_fields
    - prefer_final_in_for_each
    - prefer_final_locals
    - prefer_for_elements_to_map_fromIterable
    - prefer_function_declarations_over_variables
    - prefer_generic_function_type_aliases
    - prefer_if_elements_to_conditional_expressions
    - prefer_if_null_operators
    - prefer_initializing_formals
    - prefer_inlined_adds
    - prefer_int_literals
    - prefer_interpolation_to_compose_strings
    - prefer_is_empty
    - prefer_is_not_empty
    - prefer_is_not_operator
    - prefer_iterable_whereMethod
    - prefer_mixin
    - prefer_null_aware_method_calls
    - prefer_null_aware_operators
    - prefer_single_quotes
    - prefer_spread_collections
    - prefer_typing_uninitialized_variables
    - prefer_void_to_null
    - provide_deprecation_message
    - public_member_api_docs
    - recursive_getters
    - require_trailing_commas
    - sized_box_for_whitespace
    - slash_for_doc_comments
    - sort_child_properties_last
    - sort_constructors_first
    - sort_pub_dependencies
    - sort_unnamed_constructors_first
    - tighten_type_of_initializing_formals
    - type_annotate_public_apis
    - type_init_formals
    - unawaited_futures
    - unnecessary_await_in_return
    - unnecessary_brace_in_string_interpolations
    - unnecessary_const
    - unnecessary_constructor_name
    - unnecessary_getters_setters
    - unnecessary_lambdas
    - unnecessary_late
    - unnecessary_new
    - unnecessary_null_aware_assignments
    - unnecessary_null_aware_operator_on_extension_on_nullable
    - unnecessary_null_checks
    - unnecessary_null_in_if_null_operators
    - unnecessary_nullable_for_final_variable_declarations
    - unnecessary_overrides
    - unnecessary_parenthesis
    - unnecessary_raw_strings
    - unnecessary_string_escapes
    - unnecessary_string_interpolations
    - unnecessary_this
    - unnecessary_to_list_in_spreads
    - unreachable_from_main
    - unrelated_type_equality_checks
    - use_colored_box
    - use_decorated_box
    - use_enums
    - use_full_hex_values_for_flutter_colors
    - use_function_type_syntax_for_parameters
    - use_if_null_to_convert_nulls_to_bools
    - use_is_even_rather_than_modulo
    - use_late_for_private_fields_and_variables
    - use_named_constants
    - use_raw_strings
    - use_rethrow_when_possible
    - use_setters_to_change_properties
    - use_string_buffers
    - use_string_in_part_of_directives
    - use_super_parameters
    - use_test_throws_matchers
    - use_to_and_as_if_applicable
    - valid_regexps
    - void_checks
```

### Key Rules Explained

| Rule | Why It Matters |
|------|---------------|
| `always_declare_return_types` | Makes code intent explicit |
| `avoid_dynamic_calls` | Prevents runtime type errors |
| `prefer_const_constructors` | Improves performance by reusing instances |
| `prefer_final_locals` | Enforces immutability mindset |
| `require_trailing_commas` | Cleaner diffs and auto-formatting |
| `sort_child_properties_last` | Better readability in widget trees |
| `use_super_parameters` | Reduces boilerplate in constructors |

---

## Forbidden Patterns

### Never Use These Patterns

```dart
// FORBIDDEN: Global mutable state
int counter = 0;

// FORBIDDEN: Using dynamic
dynamic processData(dynamic input) => input;

// FORBIDDEN: Ignoring errors
try {
  doSomething();
} catch (_) {
  // Ignoring errors silently
}

// FORBIDDEN: Business logic in widgets
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Database call directly in build method
    final user = database.getUser(); // WRONG!
    return Text(user.name);
  }
}

// FORBIDDEN: Hardcoded strings without context
Text('Hello World'); // Use AppLocalizations instead

// FORBIDDEN: Magic numbers
Container(width: 16.0); // Use named constants or Theme
```

### Patterns Requiring Justification

```dart
// Requires comment explaining why
late final MyService _service;

// Requires documentation
// ignore: avoid_dynamic_calls
final result = json['data'];

// Requires explicit error handling
try {
  await riskyOperation();
} on ExpectedException catch (e) {
  // Handle expected exception
}
```

---

## Required Patterns

### Always Use These Patterns

```dart
// REQUIRED: Const constructors for stateless widgets
class MyCard extends StatelessWidget {
  const MyCard({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(child: Text(title));
  }
}

// REQUIRED: Proper error handling with typed exceptions
Future<User> fetchUser(String id) async {
  try {
    final response = await _api.get('/users/$id');
    return User.fromJson(response.data);
  } on DioException catch (e) {
    throw NetworkException(
      message: 'Failed to fetch user',
      statusCode: e.response?.statusCode,
    );
  }
}

// REQUIRED: Dispose controllers
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(controller: _controller);
  }
}

// REQUIRED: Use theme values
Container(
  color: Theme.of(context).colorScheme.primary,
  padding: Theme.of(context).padding.medium,
);
```

---

## Testing Strategy

### Test Pyramid

```
        /\
       /  \
      / E2E \          (Slow, Expensive)
     /______\
    /        \
   /Integration\      (Medium Speed)
  /____________\
 /              \
/   Unit Tests   \    (Fast, Cheap)
/_________________\
```

### Unit Tests

Unit tests should be fast, isolated, and test a single piece of functionality.

```dart
// test/models/user_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/models/user/user.dart';

void main() {
  group('User', () {
    group('fromJson', () {
      test('parses valid JSON correctly', () {
        final json = {
          'id': '123',
          'email': 'test@example.com',
          'name': 'Test User',
          'role': 'member',
          'created_at': '2024-01-01T00:00:00Z',
          'updated_at': '2024-01-01T00:00:00Z',
        };

        final user = User.fromJson(json);

        expect(user.id, '123');
        expect(user.email, 'test@example.com');
        expect(user.name, 'Test User');
        expect(user.role, UserRole.member);
      });

      test('handles nullable fields', () {
        final json = {
          'id': '123',
          'email': 'test@example.com',
          'name': 'Test User',
          'role': 'member',
          'avatar_url': null,
          'created_at': '2024-01-01T00:00:00Z',
          'updated_at': '2024-01-01T00:00:00Z',
        };

        final user = User.fromJson(json);

        expect(user.avatarUrl, isNull);
      });

      test('throws on missing required fields', () {
        final json = {
          'id': '123',
          // Missing email and name
          'role': 'member',
        };

        expect(() => User.fromJson(json), throwsA(isA<TypeError>()));
      });
    });

    group('toJson', () {
      test('serializes to correct JSON format', () {
        final user = User(
          id: '123',
          email: 'test@example.com',
          name: 'Test User',
          role: UserRole.member,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        final json = user.toJson();

        expect(json['id'], '123');
        expect(json['email'], 'test@example.com');
        expect(json['role'], 'member');
      });
    });

    group('copyWith', () {
      test('creates copy with updated fields', () {
        final user = User(
          id: '123',
          email: 'test@example.com',
          name: 'Test User',
          role: UserRole.member,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        final updated = user.copyWith(name: 'Updated Name');

        expect(updated.id, '123');
        expect(updated.name, 'Updated Name');
        expect(user.name, 'Test User'); // Original unchanged
      });
    });
  });
}
```

### Widget Tests

Widget tests verify UI components render correctly and respond to interactions.

```dart
// test/widgets/my_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/widgets/my_card.dart';

void main() {
  group('MyCard', () {
    testWidgets('renders title correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MyCard(title: 'Test Title'),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('calls onTap when card is tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyCard(
              title: 'Test',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(MyCard));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('displays loading indicator when isLoading is true',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MyCard(title: 'Test', isLoading: true),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test'), findsNothing);
    });

    testWidgets('applies custom colors from theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
            ),
          ),
          home: const Scaffold(
            body: MyCard(title: 'Test'),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      // Verify theme is applied
      expect(card.color, Colors.blue);
    });
  });
}
```

### Integration Tests

Integration tests verify complete user flows across multiple screens.

```dart
// integration_test/auth_flow_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow', () {
    testWidgets('user can log in successfully', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify we're on login screen
      expect(find.text('Sign In'), findsOneWidget);

      // Enter credentials
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );

      // Tap login button
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify successful navigation to home
      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('Sign In'), findsNothing);
    });

    testWidgets('shows error for invalid credentials', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('email_field')),
        'wrong@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'wrongpassword',
      );

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify error message
      expect(find.text('Invalid credentials'), findsOneWidget);
    });
  });
}
```

### Test Coverage Requirements

| Component | Minimum Coverage |
|-----------|-----------------|
| Models | 100% |
| Repositories | 90% |
| Services | 90% |
| BLoCs/Cubits | 85% |
| Widgets | 70% |

---

## Code Review Checklist

### Before Requesting Review

- [ ] All lint rules pass (`flutter analyze`)
- [ ] All tests pass (`flutter test`)
- [ ] Code coverage meets minimum requirements
- [ ] No hardcoded strings (use localization)
- [ ] No magic numbers (use constants)
- [ ] Public APIs have documentation comments
- [ ] Complex logic has inline comments
- [ ] Widget `const` constructors used where possible
- [ ] Controllers/listeners properly disposed
- [ ] Error handling is comprehensive

### For Reviewers

- [ ] Code follows project architecture
- [ ] Business logic is not in widgets
- [ ] State management is used correctly
- [ ] Performance implications considered
- [ ] Security implications considered
- [ ] Accessibility requirements met
- [ ] Edge cases are tested
- [ ] Error messages are user-friendly
- [ ] No duplicate code (DRY principle)
- [ ] Functions/methods are focused and small

---

## Documentation Standards

### Documentation Comments

```dart
/// A service for managing user authentication.
///
/// This service handles all authentication-related operations including
/// login, logout, and token management. It coordinates between the
/// API client and local storage.
///
/// Example usage:
/// ```dart
/// final authService = AuthService(apiClient, tokenStorage);
/// final result = await authService.login(email, password);
/// ```
///
/// See also:
/// - [ApiClient] for network operations
/// - [TokenStorage] for secure token persistence
class AuthService {
  /// Authenticates a user with the provided credentials.
  ///
  /// Returns [AuthResult.success] with user data on successful login,
  /// or [AuthResult.failure] with an error message on failure.
  ///
  /// Throws [NetworkException] if the request fails due to network issues.
  /// Throws [ValidationException] if [email] format is invalid.
  ///
  /// The [email] must be a valid email address format.
  /// The [password] must be at least 8 characters.
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    // Implementation
  }
}
```

### Inline Comments

```dart
// Good: Explains why, not what
// Using computed value to avoid rebuilding on every frame
final size = MediaQuery.sizeOf(context);

// Good: Documents non-obvious behavior
// API returns timestamps in seconds, not milliseconds
final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

// Bad: Explains what (obvious from code)
// Increment counter
counter++;
```

### README Structure

Each feature module should have a README:

```markdown
# Feature Name

Brief description of the feature.

## Architecture

- `bloc/` - State management
- `widgets/` - UI components
- `models/` - Data classes
- `repository/` - Data layer

## Usage

Example code showing how to use the feature.

## Testing

How to run tests for this feature.

## Dependencies

List of external dependencies and why they're needed.
```

---

## Performance Considerations

### Widget Optimization

```dart
// Good: Use const constructors
const Text('Hello');
const SizedBox(height: 16);

// Good: Avoid rebuilding expensive widgets
class ExpensiveWidget extends StatelessWidget {
  const ExpensiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // This widget is rebuilt only when parent key changes
    return const HeavyComputation();
  }
}

// Good: Use RepaintBoundary for isolated repaints
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return RepaintBoundary(
      key: ValueKey(items[index].id),
      child: ItemWidget(item: items[index]),
    );
  },
);

// Good: Use AutomaticKeepAliveClientMixin for preserving state
class PersistentTab extends StatefulWidget {
  @override
  State<PersistentTab> createState() => _PersistentTabState();
}

class _PersistentTabState extends State<PersistentTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Content();
  }
}
```

### List Optimization

```dart
// Good: Use ListView.builder for long lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemTile(item: items[index]),
);

// Good: Use ListView.separated for items with dividers
ListView.separated(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemTile(item: items[index]),
  separatorBuilder: (context, index) => const Divider(),
);

// Bad: Using Column with many children
Column(
  children: items.map((item) => ItemTile(item: item)).toList(),
);
```

### Image Optimization

```dart
// Good: Use cached network images
CachedNetworkImage(
  imageUrl: url,
  placeholder: (context, url) => const CircularProgressIndicator(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
  cacheKey: imageId, // Custom cache key for invalidation
  memCacheWidth: 300, // Limit memory usage
);

// Good: Precache images
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  precacheImage(NetworkImage(url), context);
}
```

### Async Operations

```dart
// Good: Cancel async operations on dispose
class _MyWidgetState extends State<MyWidget> {
  CancelableOperation? _operation;

  @override
  void dispose() {
    _operation?.cancel();
    super.dispose();
  }

  Future<void> loadData() async {
    _operation = CancelableOperation.fromFuture(
      api.fetchData(),
      onCancel: () => print('Operation cancelled'),
    );
    final data = await _operation?.value;
    if (mounted) {
      setState(() => _data = data);
    }
  }
}
```

---

## Accessibility Basics

### Semantics

```dart
// Good: Add semantic labels
Icon(
  Icons.favorite,
  semanticLabel: 'Add to favorites',
);

// Good: Use semantic buttons
Semantics(
  button: true,
  label: 'Add item to cart',
  child: GestureDetector(
    onTap: () => addToCart(),
    child: const Icon(Icons.add_shopping_cart),
  ),
);

// Good: Exclude decorative elements from semantics
Image.asset(
  'assets/decoration.png',
  excludeFromSemantics: true,
);
```

### Tap Targets

```dart
// Good: Minimum tap target size of 48x48
Material(
  child: InkWell(
    onTap: () {},
    child: const SizedBox(
      width: 48,
      height: 48,
      child: Center(
        child: Icon(Icons.menu),
      ),
    ),
  ),
);
```

### Screen Reader Support

```dart
// Good: Provide meaningful labels
TextField(
  decoration: InputDecoration(
    labelText: 'Email address',
    hintText: 'Enter your email',
  ),
);

// Good: Use MergeSemantics for related content
MergeSemantics(
  child: Column(
    children: [
      Text('Price: \$99.99'),
      Text('In stock'),
    ],
  ),
);
```

### Focus Navigation

```dart
// Good: Define focus traversal
FocusTraversalGroup(
  policy: OrderedTraversalPolicy(),
  child: Column(
    children: [
      FocusTraversalOrder(
        order: const NumericFocusOrder(1.0),
        child: TextField(),
      ),
      FocusTraversalOrder(
        order: const NumericFocusOrder(2.0),
        child: TextField(),
      ),
    ],
  ),
);
```

---

## Project Configuration Tools

### change_app_package_name

Use this tool to change the app's package name (Android) and bundle identifier (iOS).

**Installation:**

```yaml
# pubspec.yaml
dev_dependencies:
  change_app_package_name: ^1.x
```

**Usage:**

```bash
# Change package name for both Android and iOS
dart run change_app_package_name:main com.new.package.name

# Example: Change from default to production package
dart run change_app_package_name:main com.company.myapp
```

**What it changes:**

| Platform | Changes |
|----------|---------|
| Android | `applicationId` in `build.gradle`, package in `AndroidManifest.xml`, directory structure |
| iOS | `PRODUCT_BUNDLE_IDENTIFIER` in `project.pbxproj` |

**Best Practices:**

1. Run this early in project setup (before first commit)
2. Use reverse domain notation: `com.company.appname`
3. Avoid special characters and uppercase letters
4. Run on a clean git state (commit or stash changes first)

**Common Issues:**

```bash
# If the tool fails, manually verify:
# Android: android/app/build.gradle
android {
    defaultConfig {
        applicationId "com.company.myapp"  // Check this
    }
}

# iOS: ios/Runner.xcodeproj/project.pbxproj
PRODUCT_BUNDLE_IDENTIFIER = com.company.myapp;  // Check this
```

---

### flutter_launcher_icons

Use this tool to generate app icons for all platforms from a single source image.

**Installation:**

```yaml
# pubspec.yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.x
```

**Configuration:**

Create `flutter_launcher_icons.yaml` in your project root:

```yaml
# flutter_launcher_icons.yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"
  min_sdk_android: 21

  # Android adaptive icons (recommended)
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/icon/app_icon_foreground.png"

  # iOS configuration
  remove_alpha_ios: true
  background_color_ios: "#FFFFFF"

  # Web (optional)
  web:
    generate: true
    image_path: "assets/icon/app_icon.png"
    background_color: "#FFFFFF"
    theme_color: "#FFFFFF"

  # Windows (optional)
  windows:
    generate: true
    image_path: "assets/icon/app_icon.png"
    icon_size: 48

  # macOS (optional)
  macos:
    generate: true
    image_path: "assets/icon/app_icon.png"
```

**Usage:**

```bash
# Generate icons
dart run flutter_launcher_icons

# Or specify config file
dart run flutter_launcher_icons -f flutter_launcher_icons.yaml
```

**Icon Requirements:**

| Property | Requirement |
|----------|-------------|
| Format | PNG |
| Base icon size | 1024x1024 pixels (recommended) |
| Adaptive icon foreground | 1024x1024 with transparent background |
| Background | Solid color or image |

**Best Practices:**

1. Keep original icon in `assets/icon/` directory
2. Use adaptive icons for Android (separate foreground/background)
3. Remove alpha channel for iOS (`remove_alpha_ios: true`)
4. Commit generated icons to version control
5. Re-run after icon updates

**Directory Structure:**

```
assets/
└── icon/
    ├── app_icon.png              # Main icon (1024x1024)
    ├── app_icon_foreground.png   # Android adaptive foreground
    └── app_icon_background.png   # Android adaptive background (optional)
```

---

## Summary Checklist

| Category | Key Points |
|----------|------------|
| **Linting** | Use flutter_lints + custom rules, strict mode enabled |
| **Testing** | Unit > Widget > Integration, meet coverage minimums |
| **Documentation** | Public APIs documented, complex logic explained |
| **Performance** | Const widgets, builder patterns, proper caching |
| **Accessibility** | Semantic labels, 48px tap targets, screen reader support |
| **Code Review** | Follow checklist before requesting and during review |
| **Config Tools** | `change_app_package_name` for package ID, `flutter_launcher_icons` for icons |
