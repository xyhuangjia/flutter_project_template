# State Management

> Riverpod state management patterns and best practices for this Flutter project.

---

## Overview

This project uses **Riverpod** with **riverpod_generator** for state management. Riverpod provides a reactive, compile-time safe, and testable approach to managing application state.

### Key Dependencies

```yaml
dependencies:
  flutter_riverpod: ^3.0.0
  riverpod_annotation: ^4.0.0

dev_dependencies:
  riverpod_generator: ^4.0.0
  build_runner: ^2.4.0
```

> **Riverpod 3.x 重要变化**：所有 provider 函数参数统一使用 `Ref` 类型，不再需要特定的 `*Ref` 类型。

---

## Provider Types and When to Use Each

### 1. Provider (Read-Only)

Use for simple values, dependency injection, or computed values that never change.

```dart
// With riverpod_generator (3.x) - 使用统一的 Ref 类型
@riverpod
String appName(Ref ref) {
  return 'My App';
}

@riverpod
UserRepository userRepository(Ref ref) {
  return UserRepositoryImpl();
}
```

```dart
// Traditional syntax
final appNameProvider = Provider<String>((ref) {
  return 'My App';
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl();
});
```

### 2. StateProvider (Simple Mutable State)

Use for simple state like counters, toggles, or selected values. Consider Notifier for complex state.

```dart
// With riverpod_generator (3.x)
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  void increment() => state++;
  void decrement() => state--;
}
```

### 3. NotifierProvider (Complex Synchronous State)

Use for complex state with business logic. Preferred over StateNotifierProvider.

```dart
// With riverpod_generator (3.x - recommended)
@riverpod
class TodoList extends _$TodoList {
  @override
  List<Todo> build() => [];

  void addTodo(Todo todo) {
    state = [...state, todo];
  }

  void toggleTodo(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id) todo.copyWith(completed: !todo.completed) else todo,
    ];
  }

  void removeTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }
}
```

### 4. AsyncNotifierProvider (Async Operations)

Use for state that requires async initialization or async operations.

```dart
// With riverpod_generator (3.x)
@riverpod
class AsyncUser extends _$AsyncUser {
  @override
  FutureOr<User> build(String userId) async {
    final repository = ref.read(userRepositoryProvider);
    return repository.fetchUser(userId);
  }

  Future<void> updateName(String name) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(userRepository);
      await repository.updateName(name);
      return repository.fetchUser(userId);
    });
  }
}
```

生成的 provider 名称：`asyncUserProvider`（不是 `asyncUserNotifierProvider`）

```dart
// Traditional syntax
class UserNotifier extends AsyncNotifier<User> {
  @override
  Future<User> build() async {
    final repository = ref.read(userRepositoryProvider);
    return repository.fetchCurrentUser();
  }
}

final userProvider = AsyncNotifierProvider<UserNotifier, User>(
  UserNotifier.new,
);
```

### 5. FutureProvider (One-Time Async Data)

Use for read-only async data that doesn't need to be updated.

```dart
// With riverpod_generator (3.x) - 使用统一的 Ref 类型
@riverpod
Future<Configuration> configuration(Ref ref) async {
  final repository = ref.read(configRepositoryProvider);
  return repository.load();
}
```

```dart
// Traditional syntax
final configurationProvider = FutureProvider<Configuration>((ref) async {
  final repository = ref.read(configRepositoryProvider);
  return repository.load();
});
```

### 6. StreamProvider (Real-Time Data)

Use for real-time data streams like WebSockets, Firebase snapshots, or periodic updates.

```dart
// With riverpod_generator (3.x) - 使用统一的 Ref 类型
@riverpod
Stream<List<Message>> messages(Ref ref, String chatId) {
  final repository = ref.read(chatRepositoryProvider);
  return repository.watchMessages(chatId);
}
```

```dart
// Traditional syntax
final messagesProvider = StreamProvider.family<List<Message>, String>(
  (ref, chatId) {
    final repository = ref.read(chatRepositoryProvider);
    return repository.watchMessages(chatId);
  },
);
```

### Decision Matrix

| State Type | Provider Type | Generator Annotation |
|------------|---------------|---------------------|
| Simple constant/injected dependency | Provider | `@riverpod` |
| Simple mutable state | StateProvider | `@riverpod class` |
| Complex synchronous state | NotifierProvider | `@riverpod class extends _$Name` |
| Complex async state | AsyncNotifierProvider | `@riverpod class extends _$AsyncName` |
| One-time async read | FutureProvider | `@riverpod Future<T>` |
| Real-time streams | StreamProvider | `@riverpod Stream<T>` |

---

## Code Generation with riverpod_generator

### Setup

```bash
# Generate once
dart run build_runner build

# Watch for changes
dart run build_runner watch

# Clean and rebuild
dart run build_runner build --delete-conflicting-outputs
```

### Basic Annotations

```dart
part 'my_provider.g.dart';

@riverpod
String simpleValue(Ref ref) {
  return 'Hello';
}

@riverpod
class MutableValue extends _$MutableValue {
  @override
  String build() => 'Initial';

  void update(String newValue) => state = newValue;
}
```

### Family Parameter (Parameterized Providers)

```dart
@riverpod
Future<Product> product(ProductRef ref, String productId) async {
  final repository = ref.read(productRepositoryProvider);
  return repository.fetch(productId);
}

// Usage
final product = ref.watch(productProvider('prod-123'));
```

### AutoDispose (Automatic Disposal)

```dart
@Riverpod(keepAlive: false) // Default behavior
class SearchResults extends _$SearchResults {
  @override
  Future<List<Result>> build(String query) async {
    // Provider is disposed when no longer watched
    return searchService.search(query);
  }
}

@Riverpod(keepAlive: true) // Never disposed
class PersistentCache extends _$PersistentCache {
  @override
  Map<String, dynamic> build() => {};
}
```

### Dependencies

```dart
@riverpod
class UserPreferences extends _$UserPreferences {
  @override
  Preferences build() {
    // Listen to another provider
    final theme = ref.watch(themeProvider);
    return Preferences(theme: theme);
  }
}
```

---

## Reading Providers in Widgets

### ref.watch (Reactive)

Use in `build` methods to reactively rebuild when state changes.

```dart
class TodoListWidget extends ConsumerWidget {
  const TodoListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);

    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return TodoTile(todo: todos[index]);
      },
    );
  }
}
```

```dart
// With async data
class UserProfileWidget extends ConsumerWidget {
  const UserProfileWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(asyncUserProvider);

    return asyncUser.when(
      data: (user) => Text('Hello, ${user.name}'),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

### ref.read (Non-Reactive)

Use in event handlers, callbacks, or when you don't need rebuilds.

```dart
class AddTodoButton extends ConsumerWidget {
  const AddTodoButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        // Use ref.read in event handlers
        ref.read(todoListProvider.notifier).addTodo(
          Todo(id: '1', title: 'New Task'),
        );
      },
      child: const Text('Add Todo'),
    );
  }
}
```

### ref.listen (Side Effects)

Use for navigation, dialogs, or notifications in response to state changes.

**Note:** Use `DialogUtil` instead of `ScaffoldMessenger` for showing messages and notifications.

```dart
import 'package:flutter_project_template/shared/widgets/dialog_util.dart';

class LoginWidget extends ConsumerStatefulWidget {
  const LoginWidget({super.key});

  @override
  ConsumerState<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends ConsumerState<LoginWidget> {
  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<AuthState>>(authProvider, (previous, next) {
      next.when(
        data: (auth) {
          if (auth.isAuthenticated) {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        },
        error: (error, stack) {
          DialogUtil.showErrorDialog(context, 'Login failed: $error');
        },
        loading: () {},
      );
    });

    return const LoginForm();
  }
}
```

### ConsumerWidget vs ConsumerStatefulWidget

```dart
// Use ConsumerWidget for stateless widgets
class PriceDisplay extends ConsumerWidget {
  const PriceDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final price = ref.watch(priceProvider);
    return Text('\$${price.toStringAsFixed(2)}');
  }
}

// Use ConsumerStatefulWidget for widgets with local state
class CounterWidget extends ConsumerStatefulWidget {
  const CounterWidget({super.key});

  @override
  ConsumerState<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends ConsumerState<CounterWidget> {
  int _localCount = 0;

  @override
  Widget build(BuildContext context) {
    final globalCount = ref.watch(counterProvider);

    return Column(
      children: [
        Text('Local: $_localCount'),
        Text('Global: $globalCount'),
        ElevatedButton(
          onPressed: () => setState(() => _localCount++),
          child: const Text('Increment Local'),
        ),
      ],
    );
  }
}
```

---

## Provider Modifiers

### .select (Fine-Grained Rebuilds)

Use to rebuild only when specific properties change.

```dart
class UserNameWidget extends ConsumerWidget {
  const UserNameWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only rebuilds when user.name changes, not other properties
    final name = ref.watch(userProvider.select((user) => user.name));

    return Text(name);
  }
}
```

```dart
class TodoCountWidget extends ConsumerWidget {
  const TodoCountWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only rebuilds when todo count changes
    final count = ref.watch(
      todoListProvider.select((todos) => todos.length),
    );

    return Text('$count todos');
  }
}
```

### .family (Parameterized Providers)

Use to create providers that depend on external parameters.

```dart
// With riverpod_generator
@riverpod
Future<Product> product(ProductRef ref, String productId) async {
  final repository = ref.read(productRepositoryProvider);
  return repository.fetch(productId);
}

// Usage
final product = ref.watch(productProvider('prod-123'));
```

```dart
// Multiple parameters
@riverpod
Future<List<Order>> orders(
  OrdersRef ref,
  String userId, {
  required OrderStatus status,
}) async {
  final repository = ref.read(orderRepositoryProvider);
  return repository.fetchOrders(userId, status: status);
}

// Usage
final orders = ref.watch(ordersProvider('user-1', status: OrderStatus.pending));
```

### .autoDispose (Automatic Cleanup)

Use for providers that should be disposed when no longer listened to.

```dart
// With riverpod_generator - autoDispose is the default
@riverpod
Future<SearchResult> search(SearchRef ref, String query) async {
  // Automatically disposed when search widget is removed
  final service = ref.read(searchServiceProvider);
  return service.search(query);
}

// Keep provider alive
@Riverpod(keepAlive: true)
Future<Configuration> configuration(Ref ref) async {
  // Never disposed, cached for app lifetime
  return configService.load();
}
```

---

## State Organization Patterns

### Feature-Based Organization

```
lib/
  features/
    auth/
      data/
        auth_repository.dart
      domain/
        user.dart
      providers/
        auth_provider.dart
        auth_provider.g.dart
      screens/
        login_screen.dart
    products/
      data/
        product_repository.dart
      domain/
        product.dart
      providers/
        product_provider.dart
        product_list_provider.dart
      screens/
        product_list_screen.dart
```

### Core Providers

```
lib/
  core/
    providers/
      app_state_provider.dart
      theme_provider.dart
      connectivity_provider.dart
```

### Provider Hierarchy

```dart
// 1. Low-level providers (repositories, services)
@riverpod
ApiService apiService(Ref ref) {
  return ApiService(baseUrl: 'https://api.example.com');
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(ref.watch(apiServiceProvider));
}

// 2. Domain providers (business logic)
@riverpod
class Auth extends _$Auth {
  @override
  AsyncValue<AuthState> build() => const AsyncValue.data(AuthState.unauthenticated());

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    final repository = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(() => repository.login(email, password));
  }
}

// 3. UI providers (view-specific state)
@riverpod
bool isLoggedIn(Ref ref) {
  final auth = ref.watch(authProvider);
  return auth.value?.isAuthenticated ?? false;
}
```

---

## Handling Async State (AsyncValue)

### Basic Pattern

```dart
class AsyncWidget extends ConsumerWidget {
  const AsyncWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(dataProvider);

    return asyncValue.when(
      data: (data) => DataDisplay(data),
      loading: () => const LoadingIndicator(),
      error: (error, stack) => ErrorDisplay(error: error),
    );
  }
}
```

### With Loading and Error States

```dart
@riverpod
class AsyncUserProfile extends _$AsyncUserProfile {
  @override
  Future<UserProfile> build(String userId) async {
    final repository = ref.read(userRepositoryProvider);
    return repository.fetchProfile(userId);
  }

  Future<void> updateProfile(UserProfile profile) async {
    // Preserve previous data while loading
    final previous = state.value;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(userRepositoryProvider);
      await repository.updateProfile(profile);
      return profile;
    });

    // Handle error with rollback
    if (state.hasError && previous != null) {
      // Optionally show error but keep previous data
      state = AsyncValue.data(previous);
    }
  }
}
```

### Pattern for CRUD Operations

```dart
@riverpod
class ProductList extends _$ProductList {
  @override
  Future<List<Product>> build() async {
    final repository = ref.read(productRepositoryProvider);
    return repository.fetchAll();
  }

  Future<void> addProduct(Product product) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(productRepositoryProvider);
      await repository.add(product);
      return repository.fetchAll();
    });
  }

  Future<void> deleteProduct(String id) async {
    // Optimistic update
    final previous = state.value ?? [];

    state = AsyncValue.data(
      previous.where((p) => p.id != id).toList(),
    );

    final result = await AsyncValue.guard(() async {
      final repository = ref.read(productRepositoryProvider);
      await repository.delete(id);
      return repository.fetchAll();
    });

    if (result.hasError) {
      // Rollback on error
      state = AsyncValue.data(previous);
    } else {
      state = result;
    }
  }
}
```

### Refresh and Retry

```dart
class RefreshableList extends ConsumerWidget {
  const RefreshableListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(productListProvider);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(productListProvider.future),
      child: asyncProducts.when(
        data: (products) => ProductListView(products: products),
        loading: () => const LoadingView(),
        error: (error, stack) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(productListProvider),
        ),
      ),
    );
  }
}
```

---

## Testing Providers

### Unit Testing Providers

```dart
void main() {
  test('counter increments correctly', () {
    // Create a test container
    final container = ProviderContainer();

    // Add cleanup
    addTearDown(container.dispose);

    // Read initial value
    expect(container.read(counterProvider), 0);

    // Perform action
    container.read(counterProvider.notifier).increment();

    // Verify new value
    expect(container.read(counterProvider), 1);
  });
}
```

### Testing Async Providers

```dart
void main() {
  test('fetches user successfully', () async {
    final container = ProviderContainer(
      overrides: [
        // Override repository with mock
        userRepositoryProvider.overrideWithValue(MockUserRepository()),
      ],
    );

    addTearDown(container.dispose);

    // Wait for async operation
    final user = await container.read(userProvider.future);

    expect(user.name, 'Test User');
  });
}
```

### Testing with Mocks

```dart
class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockUserRepository();
    container = ProviderContainer(
      overrides: [
        userRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('login updates auth state', () async {
    // Arrange
    when(() => mockRepository.login(any(), any()))
        .thenAnswer((_) async => AuthState.authenticated(userId: '123'));

    // Act
    await container.read(authProvider.notifier).login('test@example.com', 'password');

    // Assert
    final state = container.read(authProvider);
    expect(state.value?.isAuthenticated, true);
  });
}
```

### Widget Testing with Providers

```dart
void main() {
  testWidgets('displays user name', (tester) async {
    final container = ProviderContainer(
      overrides: [
        userProvider.overrideWith((ref) => User(name: 'Test User')),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: UserWidget()),
      ),
    );

    expect(find.text('Test User'), findsOneWidget);

    container.dispose();
  });
}
```

---

## Anti-Patterns to Avoid

### 1. Using ref.read in build method

```dart
// BAD: ref.read in build won't trigger rebuild
@override
Widget build(BuildContext context, WidgetRef ref) {
  final user = ref.read(userProvider); // Wrong!
  return Text(user.name);
}

// GOOD: Use ref.watch for reactive updates
@override
Widget build(BuildContext context, WidgetRef ref) {
  final user = ref.watch(userProvider);
  return Text(user.name);
}
```

### 2. Creating providers inside widgets

```dart
// BAD: Provider created inside build method
@override
Widget build(BuildContext context, WidgetRef ref) {
  final provider = StateProvider((ref) => 0); // Wrong!
  return Text('${ref.watch(provider)}');
}

// GOOD: Define providers at module level
final counterProvider = StateProvider<int>((ref) => 0);

@override
Widget build(BuildContext context, WidgetRef ref) {
  return Text('${ref.watch(counterProvider)}');
}
```

### 3. Storing BuildContext in providers

```dart
// BAD: Storing context can cause memory leaks
@riverpod
class Navigation extends _$Navigation {
  BuildContext? _context; // Never do this!

  void navigate(String route) {
    _context?.push(route);
  }
}

// GOOD: Pass context when needed or use navigator key
@riverpod
GlobalKey<NavigatorState> navigatorKey(Ref ref) {
  return GlobalKey<NavigatorState>();
}
```

### 4. Not disposing heavy resources

```dart
// BAD: No cleanup for subscriptions
@riverpod
Stream<Location> location(Ref ref) {
  return LocationService().stream; // Never disposed
}

// GOOD: Use ref.onDispose
@riverpod
Stream<Location> location(Ref ref) {
  final controller = StreamController<Location>();

  final subscription = LocationService().stream.listen(
    (data) => controller.add(data),
  );

  ref.onDispose(subscription.cancel);

  return controller.stream;
}
```

### 5. Overusing StateProvider for complex state

```dart
// BAD: StateProvider for complex state
final complexStateProvider = StateProvider<ComplexState>((ref) {
  return ComplexState.initial();
});

// Updating requires replacing entire object
ref.read(complexStateProvider.notifier).state =
  ref.read(complexStateProvider).copyWith(field: newValue);

// GOOD: Use Notifier for complex state
@riverpod
class ComplexState extends _$ComplexState {
  @override
  State build() => State.initial();

  void updateField(String value) {
    state = state.copyWith(field: value);
  }
}
```

### 6. Family with unstable parameters

```dart
// BAD: Family with object parameter (can cause memory leaks)
@riverpod
Future<Data> data(DataRef ref, Map<String, dynamic> params) async {
  return fetchData(params);
}
// Each call with new map creates new provider entry

// GOOD: Use stable parameters
@riverpod
Future<Data> data(DataRef ref, String id, String filter) async {
  return fetchData(id: id, filter: filter);
}

// Or use autoDispose for cleanup
@riverpod
Future<Data> searchData(SearchDataRef ref, String query) async {
  // Auto-disposed when not watched
  return searchData(query);
}
```

### 7. Blocking UI with sync heavy operations

```dart
// BAD: Heavy computation blocks UI
@riverpod
List<Result> heavyResult(Ref ref) {
  return processLargeDataSet(); // Blocks UI thread
}

// GOOD: Use compute or async
@riverpod
Future<List<Result>> heavyResult(Ref ref) async {
  return compute(processLargeDataSet, data);
}
```

### 8. Circular dependencies between providers

```dart
// BAD: Circular dependency
@riverpod
int providerA(Ref ref) {
  return ref.watch(providerBProvider) + 1;
}

@riverpod
int providerB(Ref ref) {
  return ref.watch(providerAProvider) + 1; // Infinite loop!
}

// GOOD: Restructure to avoid cycles
@riverpod
int baseValue(Ref ref) => 0;

@riverpod
int providerA(Ref ref) {
  return ref.watch(baseValueProvider) + 1;
}

@riverpod
int providerB(Ref ref) {
  return ref.watch(baseValueProvider) + 2;
}
```

---

## Quick Reference

### Provider Selection Guide

| Use Case | Recommended Provider |
|----------|---------------------|
| Configuration/Constants | `@riverpod` (Provider) |
| Simple mutable state | `@riverpod class` extending `_$Name` |
| Complex synchronous state | `@riverpod class` extending `_$Name` |
| Async data with mutations | `@riverpod class` extending `_$AsyncName` |
| One-time async fetch | `@riverpod Future<T>` |
| Real-time streams | `@riverpod Stream<T>` |
| Parameterized data | `@riverpod` with parameters (family) |

### Common Commands

```bash
# Generate provider code
dart run build_runner build

# Watch for changes
dart run build_runner watch

# Clean generated files
dart run build_runner clean
```

### Key Rules

1. Always use `ref.watch` in build methods
2. Use `ref.read` only in event handlers
3. Use `ref.listen` for side effects (navigation, snacks)
4. Use `.select` to minimize rebuilds
5. Use `autoDispose` (default) for search/temporary data
6. Use `keepAlive: true` for cached/persistent data
7. Always dispose resources in `ref.onDispose`
8. Prefer riverpod_generator over traditional syntax

## Riverpod 3.x 重要变更

> **项目已升级到 Riverpod 3.x**，以下是主要变更和注意事项。

### 1. Ref 类型统一（最重要）

所有 provider 函数参数统一使用 `Ref` 类型，不再需要特定的 `*Ref` 类型：

```dart
// ❌ 2.x 写法 - 需要特定 Ref 类型
@riverpod
DioClient dioClient(DioClientRef ref) { ... }

@riverpod
UserRepository userRepository(UserRepositoryRef ref) { ... }

// ✅ 3.x 写法 - 统一使用 Ref
@riverpod
DioClient dioClient(Ref ref) { ... }

@riverpod
UserRepository userRepository(Ref ref) { ... }
```

**注意**：`WidgetRef` 在 ConsumerWidget 的 build 方法中保持不变。

### 2. Provider 名称简化

Riverpod 3.x 会自动从生成的 provider 名称中去掉 "Notifier" 后缀：

```dart
@riverpod
class AuthNotifier extends _$AuthNotifier { ... }

// 2.x：生成 authNotifierProvider
// 3.x：生成 authProvider（自动去掉 Notifier 后缀）
```

**最佳实践**：建议直接使用语义化名称，避免 `Notifier` 后缀：

```dart
// ✅ 推荐：直接使用语义化名称
@riverpod
class Auth extends _$Auth { ... }  // 生成 authProvider

@riverpod
class Counter extends _$Counter { ... }  // 生成 counterProvider

// ❌ 不推荐：带 Notifier 后缀
@riverpod
class AuthNotifier extends _$AuthNotifier { ... }  // 生成 authProvider（命名冗余）
```

### 3. AsyncValue API 变更

`AsyncValue.valueOrNull` 已弃用，统一使用 `.value`：

```dart
// ❌ 2.x 写法
final user = state.valueOrNull?.user;

// ✅ 3.x 写法
final user = state.value?.user;
```

其他 AsyncValue 变更：
- `AsyncValue.data()` → 建议使用 `AsyncValue.data()` 或 `AsyncData()`
- `AsyncValue.loading()` → `AsyncLoading()`
- `AsyncValue.error()` → `AsyncError()`

### 4. Notifier 内部 state 访问简化

在 Notifier 内部，直接使用 `state` 属性：

```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  // ✅ 3.x - 直接使用 state
  void increment() => state++;

  // ❌ 2.x - 不再需要 this.ref
  // void increment() => this.ref.state++;
}
```

### 5. family 参数位置变化

带参数的 provider，参数直接跟在 `Ref ref` 后面：

```dart
// ✅ 3.x 写法
@riverpod
Future<Product> product(Ref ref, String productId) async {
  final repository = ref.read(productRepositoryProvider);
  return repository.fetch(productId);
}

// 使用
final product = ref.watch(productProvider('prod-123'));
```

### 迁移检查清单

从 Riverpod 2.x 升级到 3.x 时，检查以下内容：

- [ ] 所有 `*Ref` 类型改为 `Ref`（除了 `WidgetRef`）
- [ ] 将 `valueOrNull` 改为 `value`
- [ ] 检查生成的 provider 名称变化（Notifier 后缀自动移除）
- [ ] 更新 `pubspec.yaml` 中的版本号
- [ ] 运行 `dart run build_runner build --delete-conflicting-outputs` 重新生成代码
