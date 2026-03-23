# Hook Guidelines

> Riverpod provider patterns for Flutter - the equivalent of React hooks in the Flutter ecosystem.

---

## Overview

In Flutter with Riverpod, providers serve a similar purpose to React hooks: they encapsulate and manage stateful logic in a reusable, composable way. This document covers best practices for writing and organizing Riverpod providers.

**Note**: Flutter doesn't use React hooks. Instead, Riverpod providers combined with `ConsumerWidget` and `ConsumerStatefulWidget` provide similar functionality for state management and side effects.

> **Riverpod 3.x 注意事项**：
> - 所有 provider 函数参数统一使用 `Ref` 类型（不再是 `*Ref`）
> - `WidgetRef` 在 ConsumerWidget 中保持不变
> - 详细变更参见 [state-management.md](./state-management.md#riverpod-3x-重要变更)

---

## Notifier Class Structure

### Basic Notifier Pattern

Use `Notifier` for synchronous state with business logic.

```dart
part 'counter_provider.g.dart';

@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
}
```

```dart
// Notifier with complex state
@freezed
class TodoState with _$TodoState {
  const factory TodoState({
    required List<Todo> todos,
    required TodoFilter filter,
    required bool isLoading,
  }) = _TodoState;
}

@riverpod
class TodoList extends _$TodoList {
  @override
  TodoState build() => const TodoState(
    todos: [],
    filter: TodoFilter.all,
    isLoading: false,
  );

  void addTodo(Todo todo) {
    state = state.copyWith(
      todos: [...state.todos, todo],
    );
  }

  void setFilter(TodoFilter filter) {
    state = state.copyWith(filter: filter);
  }

  List<Todo> get filteredTodos {
    return switch (state.filter) {
      TodoFilter.all => state.todos,
      TodoFilter.completed => state.todos.where((t) => t.completed).toList(),
      TodoFilter.pending => state.todos.where((t) => !t.completed).toList(),
    };
  }
}
```

### Notifier with Dependencies

```dart
@riverpod
class Auth extends _$Auth {
  @override
  AsyncValue<AuthState> build() {
    // Listen to token changes to auto-logout
    ref.listen<AsyncValue<Token>>(tokenProvider, (previous, next) {
      if (next.hasError) {
        state = const AsyncValue.data(AuthState.unauthenticated());
      }
    });

    return const AsyncValue.data(AuthState.unauthenticated());
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    final repository = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(() => repository.login(email, password));
  }

  Future<void> logout() async {
    final repository = ref.read(authRepositoryProvider);
    await repository.logout();
    state = const AsyncValue.data(AuthState.unauthenticated());
  }
}
```

### Notifier with Lifecycle Management

```dart
@riverpod
class ConnectivityStatus extends _$ConnectivityStatus {
  StreamSubscription? _subscription;

  @override
  ConnectivityState build() {
    // Cleanup when provider is disposed
    ref.onDispose(() {
      _subscription?.cancel();
    });

    // Start listening
    _subscription = Connectivity().onConnectivityChanged.listen(
      (result) => state = ConnectivityState.fromResult(result),
    );

    return ConnectivityState.initial();
  }
}
```

---

## AsyncNotifier for Async Operations

### Basic AsyncNotifier Pattern

Use `AsyncNotifier` when state requires async initialization or operations.

```dart
part 'user_provider.g.dart';

@riverpod
class AsyncUser extends _$AsyncUser {
  @override
  FutureOr<User> build() async {
    final repository = ref.read(userRepositoryProvider);
    return repository.fetchCurrentUser();
  }

  Future<void> updateProfile(UserProfile profile) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(userRepositoryProvider);
      await repository.updateProfile(profile);
      return repository.fetchCurrentUser();
    });
  }
}
```

### AsyncNotifier with Parameters

```dart
@riverpod
class AsyncProduct extends _$AsyncProduct {
  @override
  Future<Product> build(String productId) async {
    final repository = ref.read(productRepositoryProvider);
    return repository.fetch(productId);
  }

  Future<void> updateStock(int quantity) async {
    final currentProduct = state.value;
    if (currentProduct == null) return;

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(productRepositoryProvider);
      await repository.updateStock(productId, quantity);
      return repository.fetch(productId);
    });
  }
}
```

### AsyncNotifier with Caching and Refresh

```dart
@Riverpod(keepAlive: true)
class CachedProducts extends _$CachedProducts {
  @override
  Future<List<Product>> build() async {
    final repository = ref.read(productRepositoryProvider);
    return repository.fetchAll();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(productRepositoryProvider);
      return repository.fetchAll();
    });
  }

  Future<void> invalidate() async {
    ref.invalidateSelf();
    await future;
  }
}
```

### AsyncNotifier with Pagination

```dart
@riverpod
class PaginatedProducts extends _$PaginatedProducts {
  @override
  Future<PaginatedResult<Product>> build() async {
    return _fetchPage(1);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasNextPage) return;

    state = AsyncValue.data(
      current.copyWith(isLoadingMore: true),
    );

    final nextPage = await _fetchPage(current.page + 1);

    state = AsyncValue.data(
      PaginatedResult(
        items: [...current.items, ...nextPage.items],
        page: nextPage.page,
        totalPages: nextPage.totalPages,
        hasMore: nextPage.page < nextPage.totalPages,
      ),
    );
  }

  Future<PaginatedResult<Product>> _fetchPage(int page) async {
    final repository = ref.read(productRepositoryProvider);
    return repository.fetchProducts(page: page);
  }
}
```

### AsyncNotifier with Optimistic Updates

```dart
@riverpod
class TodoOperations extends _$TodoOperations {
  @override
  Future<List<Todo>> build() async {
    final repository = ref.read(todoRepositoryProvider);
    return repository.fetchAll();
  }

  Future<void> toggleComplete(String todoId) async {
    final currentTodos = state.value;
    if (currentTodos == null) return;

    // Optimistic update
    final updatedTodos = currentTodos.map((todo) {
      if (todo.id == todoId) {
        return todo.copyWith(completed: !todo.completed);
      }
      return todo;
    }).toList();

    state = AsyncValue.data(updatedTodos);

    // Sync with server
    final result = await AsyncValue.guard(() async {
      final repository = ref.read(todoRepositoryProvider);
      await repository.toggleComplete(todoId);
      return repository.fetchAll();
    });

    if (result.hasError) {
      // Rollback on error
      state = AsyncValue.data(currentTodos);
      // Could also set error state
      // state = AsyncValue.error(result.error!, result.stackTrace);
    } else {
      state = result;
    }
  }
}
```

---

## Combining Multiple Providers

### Derived State Pattern

Create providers that combine state from multiple sources.

```dart
// Base providers
@riverpod
class Cart extends _$Cart {
  @override
  List<CartItem> build() => [];

  void add(Product product, int quantity) {
    state = [...state, CartItem(product: product, quantity: quantity)];
  }

  void remove(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }
}

@riverpod
Future<List<Coupon>> availableCoupons(Ref ref) async {
  final repository = ref.read(couponRepositoryProvider);
  return repository.fetchAvailable();
}

// Derived provider
@riverpod
CartSummary cartSummary(Ref ref) {
  final cart = ref.watch(cartProvider);
  final coupons = ref.watch(availableCouponsProvider);

  final subtotal = cart.fold(
    0.0,
    (sum, item) => sum + (item.product.price * item.quantity),
  );

  final applicableCoupon = coupons.value?.firstWhere(
    (c) => c.minPurchase <= subtotal,
    orElse: () => null,
  );

  final discount = applicableCoupon?.discount ?? 0;
  final total = subtotal - discount;

  return CartSummary(
    subtotal: subtotal,
    discount: discount,
    total: total,
    appliedCoupon: applicableCoupon,
  );
}
```

### Provider Composition with Listen

```dart
@riverpod
class AppLifecycle extends _$AppLifecycle {
  @override
  AppState build() {
    // React to auth changes
    ref.listen<AsyncValue<AuthState>>(authProvider, (previous, next) {
      if (previous?.value?.isAuthenticated == true &&
          next.value?.isAuthenticated == false) {
        // User logged out, clear sensitive data
        ref.read(cartProvider.notifier).clear();
        ref.read(userPreferencesProvider.notifier).reset();
      }
    });

    // React to connectivity changes
    ref.listen<ConnectivityState>(connectivityProvider, (previous, next) {
      if (next.isOffline) {
        // Show offline mode
        ref.read(notificationProvider.notifier).showOffline();
      }
    });

    return AppState.initial();
  }
}
```

### Filtering and Sorting Pattern

```dart
@riverpod
class ProductFilter extends _$ProductFilter {
  @override
  FilterState build() => const FilterState();

  void setCategory(String? category) {
    state = state.copyWith(category: category);
  }

  void setPriceRange(double? min, double? max) {
    state = state.copyWith(minPrice: min, maxPrice: max);
  }

  void setSortOrder(SortOrder order) {
    state = state.copyWith(sortOrder: order);
  }
}

@riverpod
List<Product> filteredProducts(Ref ref) {
  final products = ref.watch(productListProvider).value ?? [];
  final filter = ref.watch(productFilterProvider);

  var result = products;

  // Apply category filter
  if (filter.category != null) {
    result = result.where((p) => p.category == filter.category).toList();
  }

  // Apply price filter
  if (filter.minPrice != null) {
    result = result.where((p) => p.price >= filter.minPrice!).toList();
  }
  if (filter.maxPrice != null) {
    result = result.where((p) => p.price <= filter.maxPrice!).toList();
  }

  // Apply sorting
  result = switch (filter.sortOrder) {
    SortOrder.priceAsc => result..sort((a, b) => a.price.compareTo(b.price)),
    SortOrder.priceDesc => result..sort((a, b) => b.price.compareTo(a.price)),
    SortOrder.nameAsc => result..sort((a, b) => a.name.compareTo(b.name)),
    SortOrder.nameDesc => result..sort((a, b) => b.name.compareTo(a.name)),
    SortOrder.none => result,
  };

  return result;
}
```

---

## Dependency Injection with Providers

### Repository Injection Pattern

```dart
// Core interfaces
abstract class UserRepository {
  Future<User> fetchCurrentUser();
  Future<void> updateProfile(UserProfile profile);
}

abstract class AuthRepository {
  Future<AuthState> login(String email, String password);
  Future<void> logout();
}

// Implementation
class UserRepositoryImpl implements UserRepository {
  final ApiService _apiService;

  UserRepositoryImpl(this._apiService);

  @override
  Future<User> fetchCurrentUser() => _apiService.get<User>('/user/me');

  @override
  Future<void> updateProfile(UserProfile profile) =>
      _apiService.put('/user/profile', profile.toJson());
}

// Providers
@riverpod
ApiService apiService(Ref ref) {
  return ApiService(baseUrl: EnvironmentConfig.apiBaseUrl);
}

@riverpod
UserRepository userRepository(Ref ref) {
  return UserRepositoryImpl(ref.watch(apiServiceProvider));
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(ref.watch(apiServiceProvider));
}
```

### Environment-Based Configuration

```dart
@riverpod
EnvironmentConfig environmentConfig(Ref ref) {
  // Could be determined by build flavor
  const environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');

  return switch (environment) {
    'production' => EnvironmentConfig.production(),
    'staging' => EnvironmentConfig.staging(),
    _ => EnvironmentConfig.development(),
  };
}

@riverpod
ApiService apiService(Ref ref) {
  final config = ref.watch(environmentConfigProvider);
  return ApiService(baseUrl: config.apiBaseUrl);
}
```

### Testing with Provider Overrides

```dart
// In tests
void main() {
  testWidgets('shows user profile', (tester) async {
    final mockUserRepository = MockUserRepository();
    when(() => mockUserRepository.fetchCurrentUser())
        .thenAnswer((_) async => User(name: 'Test User'));

    final container = ProviderContainer(
      overrides: [
        userRepositoryProvider.overrideWithValue(mockUserRepository),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: ProfileScreen()),
      ),
    );

    expect(find.text('Test User'), findsOneWidget);

    container.dispose();
  });
}
```

---

## Provider Lifecycle Management

### Resource Cleanup Pattern

```dart
@riverpod
Stream<Location> locationStream(Ref ref) {
  final controller = StreamController<Location>();
  final locationService = ref.watch(locationServiceProvider);

  final subscription = locationService.stream.listen(
    (location) => controller.add(location),
    onError: (error) => controller.addError(error),
  );

  // Cleanup when provider is disposed
  ref.onDispose(() {
    subscription.cancel();
    controller.close();
  });

  return controller.stream;
}
```

### Keep-Alive vs AutoDispose

```dart
// AutoDispose (default): Provider is disposed when not listened
@riverpod
Future<SearchResult> search(SearchRef ref, String query) async {
  // Results are cached only while widget is visible
  final service = ref.watch(searchServiceProvider);
  return service.search(query);
}

// Keep-Alive: Provider persists until app ends
@Riverpod(keepAlive: true)
Future<Configuration> configuration(Ref ref) async {
  // Configuration is cached for app lifetime
  final service = ref.watch(configServiceProvider);
  return service.load();
}
```

### Manual Invalidation

```dart
@riverpod
class CacheManager extends _$CacheManager {
  @override
  Map<String, DateTime> build() => {};

  void invalidateStale() {
    final now = DateTime.now();
    final staleKeys = state.entries
        .where((e) => now.difference(e.value).inMinutes > 5)
        .map((e) => e.key)
        .toList();

    for (final key in staleKeys) {
      ref.invalidate(productProvider(key));
    }

    state = Map.fromEntries(
      state.entries.where((e) => !staleKeys.contains(e.key)),
    );
  }

  void refresh(String key) {
    ref.invalidate(productProvider(key));
  }
}
```

### Conditional Keep-Alive

```dart
@riverpod
Stream<List<Message>> messages(MessagesRef ref, String chatId) {
  // Keep alive only for active chat
  final activeChat = ref.watch(activeChatProvider);

  if (activeChat != chatId) {
    // Will be disposed when not active
    ref.keepAliveExternally = false;
  }

  final repository = ref.watch(chatRepositoryProvider);
  return repository.watchMessages(chatId);
}
```

---

## Best Practices for Complex State Logic

### Use Freezed for Immutable State

```dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState.unauthenticated() = Unauthenticated;
  const factory AuthState.authenticated({
    required String userId,
    required String email,
    required String name,
  }) = Authenticated;
  const factory AuthState.error(String message) = AuthError;
}

@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() => const AuthState.unauthenticated();

  Future<void> login(String email, String password) async {
    state = const AuthState.unauthenticated(); // Reset before loading

    final result = await _repository.login(email, password);

    result.fold(
      (error) => state = AuthState.error(error.message),
      (user) => state = AuthState.authenticated(
        userId: user.id,
        email: user.email,
        name: user.name,
      ),
    );
  }
}
```

### Separate Concerns with Multiple Providers

```dart
// Data provider
@riverpod
Future<List<Todo>> todoData(Ref ref) async {
  final repository = ref.watch(todoRepositoryProvider);
  return repository.fetchAll();
}

// Filter state provider
@riverpod
class TodoFilter extends _$TodoFilter {
  @override
  TodoFilterState build() => const TodoFilterState();

  void setStatus(TodoStatus? status) {
    state = state.copyWith(status: status);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

// Combined view model provider
@riverpod
TodoViewModel todoViewModel(Ref ref) {
  final todos = ref.watch(todoDataProvider);
  final filter = ref.watch(todoFilterProvider);

  return todos.when(
    data: (data) {
      var filtered = data;

      if (filter.status != null) {
        filtered = filtered.where((t) => t.status == filter.status).toList();
      }

      if (filter.searchQuery.isNotEmpty) {
        filtered = filtered
            .where((t) =>
                t.title.toLowerCase().contains(filter.searchQuery.toLowerCase()))
            .toList();
      }

      return TodoViewModel(
        todos: filtered,
        isLoading: false,
        error: null,
      );
    },
    loading: () => const TodoViewModel(todos: [], isLoading: true),
    error: (e, s) => TodoViewModel(todos: [], error: e.toString()),
  );
}
```

### Command Pattern for Actions

```dart
@freezed
class TodoCommand with _$TodoCommand {
  const factory TodoCommand.add(Todo todo) = AddTodo;
  const factory TodoCommand.toggle(String id) = ToggleTodo;
  const factory TodoCommand.delete(String id) = DeleteTodo;
  const factory TodoCommand.reorder(int oldIndex, int newIndex) = ReorderTodos;
}

@riverpod
class TodoCommandHandler extends _$TodoCommandHandler {
  @override
  void build() {
    // No state, just a command handler
  }

  Future<void> execute(TodoCommand command) async {
    final repository = ref.read(todoRepositoryProvider);

    await switch (command) {
      AddTodo(:final todo) => repository.add(todo),
      ToggleTodo(:final id) => repository.toggleComplete(id),
      DeleteTodo(:final id) => repository.delete(id),
      ReorderTodos(:final oldIndex, :final newIndex) =>
        repository.reorder(oldIndex, newIndex),
    };

    // Refresh the data
    ref.invalidate(todoDataProvider);
  }
}

// Usage in widget
ref.read(todoCommandHandlerProvider).execute(
  TodoCommand.add(Todo(title: 'New Task')),
);
```

### Error Recovery Pattern

```dart
@riverpod
class ResilientData extends _$ResilientData {
  int _retryCount = 0;
  static const _maxRetries = 3;

  @override
  Future<Data> build() async {
    final repository = ref.read(dataRepositoryProvider);
    return repository.fetch();
  }

  Future<void> retry() async {
    if (_retryCount >= _maxRetries) {
      return; // Max retries reached
    }

    _retryCount++;
    state = const AsyncValue.loading();

    await Future.delayed(Duration(seconds: _retryCount));

    state = await AsyncValue.guard(() async {
      final repository = ref.read(dataRepositoryProvider);
      final data = await repository.fetch();
      _retryCount = 0; // Reset on success
      return data;
    });
  }

  bool get canRetry => _retryCount < _maxRetries;
}
```

---

## Quick Reference

### Provider Type Selection

| Scenario | Use |
|----------|-----|
| Simple computed value | `@riverpod T builder(...)` |
| Simple mutable state | `@riverpod class` with `@override T build()` |
| Complex sync state | `@riverpod class extends _$Name` |
| Async initialization | `@riverpod class extends _$AsyncName` |
| Async data read-only | `@riverpod Future<T> builder(...)` |
| Real-time streams | `@riverpod Stream<T> builder(...)` |

### Key Methods

| Method | Purpose |
|--------|---------|
| `ref.watch(provider)` | Subscribe and rebuild on change |
| `ref.read(provider)` | Read without subscribing |
| `ref.listen(provider, callback)` | React to changes with side effects |
| `ref.invalidate(provider)` | Force refresh a provider |
| `ref.onDispose(callback)` | Cleanup when provider is disposed |
| `ref.invalidateSelf()` | Refresh current provider |

### Generator Annotations

```dart
@riverpod                    // Basic provider (autoDispose by default)
@Riverpod(keepAlive: true)   // Never dispose
@Riverpod(dependencies: [])  // Explicit dependencies
```

### Code Generation

```bash
# Generate once
dart run build_runner build

# Watch for changes
dart run build_runner watch

# Clean and rebuild
dart run build_runner build --delete-conflicting-outputs
```
