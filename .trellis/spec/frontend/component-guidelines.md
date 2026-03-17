# Component Guidelines

> Flutter Widget best practices and conventions.

---

## Overview

This document defines the standards for building Flutter widgets in this project. Following these guidelines ensures:

- Consistent code style across the team
- Optimal performance through proper widget usage
- Maintainable and testable UI components
- Clear separation between stateful and stateless logic

---

## Table of Contents

1. [Stateless vs Stateful Widget Choice](#stateless-vs-stateful-widget-choice)
2. [Widget Naming Conventions](#widget-naming-conventions)
3. [Props/Parameters Best Practices](#propsparameters-best-practices)
4. [Widget Composition Patterns](#widget-composition-patterns)
5. [Const Constructors Usage](#-const-constructors-usage)
6. [Performance Considerations](#performance-considerations)
7. [Anti-Patterns](#anti-patterns)

---

## Stateless vs Stateful Widget Choice

### Rule: Default to StatelessWidget

Use `StatelessWidget` as the default choice. Only use `StatefulWidget` when you genuinely need to manage local mutable state.

### When to Use StatelessWidget

- Widget receives all data from parent (props/providers)
- No internal state needs to be tracked
- Widget only transforms and displays data
- Side effects are handled by callbacks

**Example 1: Pure Display Widget**

```dart
// GOOD: StatelessWidget for display-only widget
class UserAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final VoidCallback? onTap;

  const UserAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 24.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl),
      ),
    );
  }
}
```

**Example 2: Consumer Widget with Provider**

```dart
// GOOD: StatelessWidget consuming provider state
class UserProfileCard extends ConsumerWidget {
  final String userId;

  const UserProfileCard({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider(userId));

    return userAsync.when(
      data: (user) => _UserContent(user: user),
      loading: () => const LoadingIndicator(),
      error: (error, stack) => ErrorWidget(message: error.toString()),
    );
  }
}
```

### When to Use StatefulWidget

- Managing animation controllers
- Text editing controllers that need disposal
- Scroll controllers with listeners
- Form state that isn't lifted to provider
- Temporary UI state (expanded/collapsed, tab selection)

**Example 3: Animation State**

```dart
// GOOD: StatefulWidget for animation management
class ExpandableCard extends StatefulWidget {
  final String title;
  final String content;

  const ExpandableCard({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(widget.title),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: _toggleExpanded,
            ),
          ),
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(widget.content),
            ),
          ),
        ],
      ),
    );
  }
}
```

### Decision Flowchart

```
Need mutable state?
    |
    +--> YES: Is it animation/controller? --> YES: StatefulWidget
    |           |
    |           +--> NO: Can it be in provider? --> YES: StatelessWidget + Provider
    |                                              |
    |                                              +--> NO: StatefulWidget
    |
    +--> NO: StatelessWidget
```

---

## Widget Naming Conventions

### General Rules

| Type | Pattern | Example |
|------|---------|---------|
| Screen | `{Feature}Screen` | `LoginScreen`, `ProfileScreen` |
| Dialog | `{Action}Dialog` | `ConfirmDialog`, `InputDialog` |
| Card/Item | `{Entity}{Variant}` | `UserCard`, `ProductListItem` |
| Button | `{Action}Button` | `SubmitButton`, `FollowButton` |
| Form | `{Purpose}Form` | `LoginForm`, `RegistrationForm` |
| Field | `{Field}Field` | `EmailField`, `PasswordField` |
| Indicator | `{Type}Indicator` | `LoadingIndicator`, `ProgressIndicator` |

### Private Widget Naming

Prefix with underscore when widget is private to a file:

```dart
// Public widget
class ProductList extends StatelessWidget {
  // ...
}

// Private helper widget (used only in this file)
class _ProductItem extends StatelessWidget {
  // ...
}

// Private state class
class _ProductListState extends State<ProductList> {
  // ...
}
```

### Example 1: Naming for a User Feature

```dart
// GOOD: Clear, descriptive naming
class UserScreen extends StatelessWidget { }           // Full page
class UserCard extends StatelessWidget { }              // Card component
class UserListItem extends StatelessWidget { }          // List item
class UserAvatar extends StatelessWidget { }            // Avatar widget
class UserStatsWidget extends StatelessWidget { }       // Stats section
class UserFollowButton extends StatelessWidget { }      // Action button

// BAD: Vague or inconsistent naming
class User extends StatelessWidget { }                  // Too generic
class UserWidget extends StatelessWidget { }            // Redundant suffix
class user_card extends StatelessWidget { }             // Wrong casing
class TheUserCardThatShowsProfile extends StatelessWidget { } // Too long
```

### Example 2: Naming for Form Components

```dart
// GOOD: Consistent form component naming
class LoginForm extends StatelessWidget { }
class EmailField extends StatelessWidget { }
class PasswordField extends StatelessWidget { }
class RememberMeCheckbox extends StatelessWidget { }
class ForgotPasswordLink extends StatelessWidget { }
class LoginSubmitButton extends StatelessWidget { }
```

### Example 3: Naming for Composite Widgets

```dart
// GOOD: Descriptive naming for composite widgets
class ProductDetailHeader extends StatelessWidget { }
class ProductDetailGallery extends StatelessWidget { }
class ProductDetailDescription extends StatelessWidget { }
class ProductDetailReviews extends StatelessWidget { }
class ProductDetailActions extends StatelessWidget { }
```

---

## Props/Parameters Best Practices

### Rule 1: Use Named Parameters

Always use named parameters for widgets. This improves readability and makes the API self-documenting.

```dart
// GOOD: Named parameters
class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;
  final bool showEmail;
  final EdgeInsetsGeometry padding;

  const UserCard({
    super.key,
    required this.user,
    this.onTap,
    this.showEmail = false,
    this.padding = const EdgeInsets.all(16.0),
  });
}

// BAD: Positional parameters
class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;

  const UserCard(this.user, this.onTap); // Hard to read at call site
}
```

### Rule 2: Required vs Optional

- Use `required` for parameters that must be provided
- Use nullable types (`?`) for truly optional parameters
- Provide sensible defaults for common optional parameters

```dart
// GOOD: Clear required vs optional distinction
class ProductCard extends StatelessWidget {
  final Product product;           // Required
  final VoidCallback? onTap;       // Optional callback
  final VoidCallback? onFavorite;  // Optional callback
  final bool showPrice;            // Optional with default
  final double imageHeight;        // Optional with default

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavorite,
    this.showPrice = true,
    this.imageHeight = 200.0,
  });
}
```

### Rule 3: Group Related Parameters

For widgets with many parameters, consider grouping into configuration classes.

```dart
// GOOD: Grouped parameters in a configuration class
class CardStyle {
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final double elevation;

  const CardStyle({
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius,
    this.backgroundColor,
    this.elevation = 1.0,
  });
}

class ProductCard extends StatelessWidget {
  final Product product;
  final CardStyle style;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.style = const CardStyle(),
    this.onTap,
  });
}
```

### Rule 4: Use Callbacks for Events

Pass callbacks for user interactions rather than handling navigation/logic inside widgets.

```dart
// GOOD: Widget receives callbacks
class UserListItem extends StatelessWidget {
  final User user;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final ValueChanged<bool> onFavoriteToggle;

  const UserListItem({
    super.key,
    required this.user,
    required this.onTap,
    required this.onLongPress,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserAvatar(imageUrl: user.avatarUrl),
      title: Text(user.name),
      subtitle: Text(user.email),
      onTap: onTap,
      onLongPress: onLongPress,
      trailing: IconButton(
        icon: Icon(user.isFavorite ? Icons.favorite : Icons.favorite_border),
        onPressed: () => onFavoriteToggle(!user.isFavorite),
      ),
    );
  }
}

// BAD: Widget handles navigation directly
class UserListItem extends StatelessWidget {
  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, '/user/${user.id}'); // Don't do this!
      },
    );
  }
}
```

### Rule 5: Leverage super.key

Always use `super.key` instead of declaring a separate Key parameter.

```dart
// GOOD
class MyWidget extends StatelessWidget {
  final String title;

  const MyWidget({
    super.key,  // Correct way
    required this.title,
  });
}

// BAD
class MyWidget extends StatelessWidget {
  final String title;
  final Key? key;  // Redundant declaration

  const MyWidget({
    this.key,  // Don't do this
    required this.title,
  }) : super(key: key);
}
```

---

## Widget Composition Patterns

### Rule 1: Prefer Composition Over Inheritance

Build complex widgets by composing smaller widgets rather than inheriting from them.

```dart
// GOOD: Composition - combining smaller widgets
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DashboardAppBar(),
      body: Column(
        children: [
          DashboardHeader(),
          Expanded(child: DashboardStats()),
          DashboardQuickActions(),
        ],
      ),
      bottomNavigationBar: DashboardBottomNav(),
    );
  }
}

// BAD: Inheritance - trying to extend widgets
class DashboardAppBar extends AppBar {  // Don't extend AppBar
  DashboardAppBar() : super(title: Text('Dashboard'));
}
```

### Rule 2: Extract Reusable Widgets

When you see repeated widget patterns, extract them into reusable components.

```dart
// BEFORE: Repeated pattern
class ProductList extends StatelessWidget {
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Image.network(products[index].imageUrl, width: 80, height: 80),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        products[index].name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '\$${products[index].price}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// AFTER: Extracted reusable widget
class ProductList extends StatelessWidget {
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) => ProductListItem(
        product: products[index],
      ),
    );
  }
}

class ProductListItem extends StatelessWidget {
  final Product product;

  const ProductListItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ProductThumbnail(imageUrl: product.imageUrl),
            const SizedBox(width: 16),
            Expanded(
              child: _ProductInfo(
                name: product.name,
                price: product.price,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Rule 3: Builder Pattern for Complex Widgets

Use builder methods to break down complex build methods into manageable pieces.

```dart
// GOOD: Builder methods for organization
class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(product.name),
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _handleShare(context),
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () => _handleFavorite(context),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageGallery(context),
          _buildProductInfo(context),
          _buildDescription(context),
          _buildReviews(context),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _addToCart(context),
                child: const Text('Add to Cart'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FilledButton(
                onPressed: () => _buyNow(context),
                child: const Text('Buy Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ... more builder methods
}
```

### Rule 4: Use Widget Methods for Conditional Rendering

Keep the build method clean by extracting conditional logic.

```dart
// GOOD: Extracted conditional rendering
class UserStatusBadge extends StatelessWidget {
  final UserStatus status;

  const UserStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _labelText(),
        style: TextStyle(color: _textColor(context)),
      ),
    );
  }

  Color _backgroundColor(BuildContext context) {
    switch (status) {
      case UserStatus.active:
        return Colors.green.withOpacity(0.2);
      case UserStatus.inactive:
        return Colors.grey.withOpacity(0.2);
      case UserStatus.suspended:
        return Colors.red.withOpacity(0.2);
    }
  }

  Color _textColor(BuildContext context) {
    switch (status) {
      case UserStatus.active:
        return Colors.green;
      case UserStatus.inactive:
        return Colors.grey;
      case UserStatus.suspended:
        return Colors.red;
    }
  }

  String _labelText() {
    switch (status) {
      case UserStatus.active:
        return 'Active';
      case UserStatus.inactive:
        return 'Inactive';
      case UserStatus.suspended:
        return 'Suspended';
    }
  }
}
```

---

## Const Constructors Usage

### Rule: Always Use const When Possible

`const` constructors enable compile-time constant creation, which significantly improves Flutter's performance by widget reuse.

### Making Widgets Const-Ready

```dart
// GOOD: Widget with const constructor
class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;

  const LoadingIndicator({
    super.key,
    this.size = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

// Usage with const
const LoadingIndicator()  // Creates compile-time constant
const LoadingIndicator(size: 32.0)  // Also const if all params are const
```

### When const Works

```dart
// All these create compile-time constants
const Text('Hello')
const Icon(Icons.star)
const SizedBox(height: 16)
const Padding(
  padding: EdgeInsets.all(16),
  child: Text('Nested const'),
)

// This creates a compile-time constant widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('All const!'),
        ),
      ),
    );
  }
}
```

### When const Doesn't Work

```dart
// NOT const: Using runtime values
final String name = getName();  // Runtime value
Text(name)  // Cannot be const

// NOT const: Using Theme.of(context) in parameters
Container(
  color: Theme.of(context).primaryColor,  // Runtime lookup
  child: const Text('Hello'),  // Only child is const
)

// Solution: Use Builder pattern for runtime values
class ThemedText extends StatelessWidget {
  final String text;

  const ThemedText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge,  // OK in build()
    );
  }
}
```

### Const Performance Example

```dart
// GOOD: Maximizing const usage
class Constants {
  static const loadingIndicator = LoadingIndicator();
  static const defaultPadding = EdgeInsets.all(16.0);
  static const defaultBorderRadius = BorderRadius.all(Radius.circular(8.0));
}

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          Constants.loadingIndicator,  // Reuses same instance
          SizedBox(height: 16),
          Text('Loading...'),
        ],
      ),
    );
  }
}
```

---

## Performance Considerations

### 1. Use const Constructors

Already covered above - this is the #1 performance optimization in Flutter.

### 2. Avoid Rebuilding Unchanged Widgets

Use `const` and proper widget boundaries to minimize rebuilds.

```dart
// BAD: Entire list rebuilds on any state change
class ProductList extends StatelessWidget {
  final List<Product> products;
  final String searchTerm;  // When this changes, everything rebuilds

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Searching: $searchTerm'),  // Needs rebuild
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);  // Unnecessary rebuild
            },
          ),
        ),
      ],
    );
  }
}

// GOOD: Isolate parts that need rebuilding
class ProductList extends StatelessWidget {
  final List<Product> products;
  final String searchTerm;

  const ProductList({
    super.key,
    required this.products,
    required this.searchTerm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SearchTermDisplay(searchTerm: searchTerm),  // Only this rebuilds
        Expanded(
          child: _ProductListView(products: products),  // This stays stable
        ),
      ],
    );
  }
}

class _SearchTermDisplay extends StatelessWidget {
  final String searchTerm;

  const _SearchTermDisplay({required this.searchTerm});

  @override
  Widget build(BuildContext context) {
    return Text('Searching: $searchTerm');
  }
}

class _ProductListView extends StatelessWidget {
  final List<Product> products;

  const _ProductListView({required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}
```

### 3. Use ListView.builder for Long Lists

```dart
// BAD: Loads all items at once
Column(
  children: items.map((item) => ItemWidget(item: item)).toList(),
)

// GOOD: Lazy loading with builder
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(item: items[index]),
)
```

### 4. Use const in Lists

```dart
// BAD: Creates new list instance on each rebuild
final children = [
  const Text('A'),
  const Text('B'),
];

// GOOD: const list
const children = [
  Text('A'),
  Text('B'),
];
```

### 5. Avoid Expensive Operations in build()

```dart
// BAD: Expensive calculation in build
class ProductTotal extends StatelessWidget {
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    // This runs on every rebuild!
    final total = products.fold<double>(
      0,
      (sum, product) => sum + product.price * product.quantity,
    );
    return Text('Total: \$${total.toStringAsFixed(2)}');
  }
}

// GOOD: Pre-calculate or use provider
class ProductTotal extends StatelessWidget {
  final double total;

  const ProductTotal({
    super.key,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Text('Total: \$${total.toStringAsFixed(2)}');
  }
}

// Even better: Calculate in provider
@riverpod
double productTotal(ProductTotalRef ref, List<Product> products) {
  return products.fold<double>(
    0,
    (sum, product) => sum + product.price * product.quantity,
  );
}
```

### 6. Use RepaintBoundary for Complex Animations

```dart
// GOOD: Isolate expensive paint operations
AnimatedBuilder(
  animation: _controller,
  builder: (context, child) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: ComplexPainter(_controller.value),
      ),
    );
  },
)
```

---

## Anti-Patterns

### Anti-Pattern 1: God Widgets

**Problem**: A single widget that does too much (handles state, business logic, UI, navigation).

```dart
// BAD: God widget with 500+ lines
class UserDashboard extends StatefulWidget {
  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  // 50+ state variables
  User? _user;
  List<Order>? _orders;
  List<Notification>? _notifications;
  bool _isLoading = false;
  bool _isLoadingOrders = false;
  // ... many more

  // Business logic mixed with UI
  Future<void> _fetchUserData() async { /* ... */ }
  Future<void> _fetchOrders() async { /* ... */ }
  Future<void> _updateProfile() async { /* ... */ }
  void _handleOrderClick(Order order) { /* ... */ }
  // ... many more methods

  @override
  Widget build(BuildContext context) {
    // 300+ lines of widget tree
    return Scaffold(
      body: Column(
        children: [
          // Profile section - 50 lines
          // Orders section - 100 lines
          // Notifications section - 80 lines
          // Stats section - 70 lines
        ],
      ),
    );
  }
}
```

**Solution**: Break into smaller, focused widgets with clear responsibilities.

```dart
// GOOD: Composed from smaller widgets
class UserDashboard extends ConsumerWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            UserProfileHeader(),
            UserStatsSection(),
            UserOrdersList(),
            UserNotificationsList(),
          ],
        ),
      ),
    );
  }
}

// Each section is its own focused widget
class UserProfileHeader extends ConsumerWidget {
  const UserProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    // Focused on just the profile header
  }
}
```

### Anti-Pattern 2: Deep Widget Trees

**Problem**: Excessively nested widget trees make code hard to read and maintain.

```dart
// BAD: Deeply nested tree
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            child: Text('Title'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
```

**Solution**: Extract widgets and remove unnecessary containers.

```dart
// GOOD: Clean, extracted widgets
Widget build(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: const [
          _HeaderSection(),
          _ContentSection(),
        ],
      ),
    ),
  );
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: const [
          _TitleText(),
        ],
      ),
    );
  }
}
```

### Anti-Pattern 3: Business Logic in Widgets

**Problem**: Widgets should focus on presentation, not business logic.

```dart
// BAD: Business logic in widget
class ProductPrice extends StatelessWidget {
  final Product product;

  const ProductPrice({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Business logic in widget!
    double price = product.basePrice;
    if (product.isOnSale) {
      price = price * 0.8;  // 20% off
    }
    if (product.isPremium) {
      price = price * 1.1;  // 10% premium
    }
    final tax = price * 0.08;
    final total = price + tax;

    return Text('\$${total.toStringAsFixed(2)}');
  }
}
```

**Solution**: Move logic to domain layer or provider.

```dart
// GOOD: Logic in domain
class ProductPrice extends StatelessWidget {
  final Product product;

  const ProductPrice({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final displayPrice = product.calculateDisplayPrice();  // Domain logic

    return Text('\$${displayPrice.toStringAsFixed(2)}');
  }
}

// In domain entity
class Product {
  // ... other properties

  double calculateDisplayPrice() {
    var price = basePrice;
    if (isOnSale) price *= 0.8;
    if (isPremium) price *= 1.1;
    return price + (price * taxRate);
  }
}
```

### Anti-Pattern 4: Passing Data Through Multiple Layers

**Problem**: Passing data through widgets that don't use it (prop drilling).

```dart
// BAD: Prop drilling
class Grandparent extends StatelessWidget {
  final User user;

  @override
  Widget build(BuildContext context) {
    return Parent(user: user);  // Parent doesn't use user
  }
}

class Parent extends StatelessWidget {
  final User user;

  @override
  Widget build(BuildContext context) {
    return Child(user: user);  // Child doesn't use user
  }
}

class Child extends StatelessWidget {
  final User user;

  @override
  Widget build(BuildContext context) {
    return Grandchild(user: user);  // Finally uses user
  }
}

class Grandchild extends StatelessWidget {
  final User user;

  @override
  Widget build(BuildContext context) {
    return Text(user.name);  // Only here is user used
  }
}
```

**Solution**: Use providers or InheritedWidget.

```dart
// GOOD: Provider-based data access
class Grandparent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Parent();
  }
}

class Parent extends StatelessWidget {
  const Parent();

  @override
  Widget build(BuildContext context) {
    return const Child();
  }
}

class Child extends StatelessWidget {
  const Child();

  @override
  Widget build(BuildContext context) {
    return const Grandchild();
  }
}

class Grandchild extends ConsumerWidget {
  const Grandchild();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);  // Direct access
    return Text(user.name);
  }
}
```

### Anti-Pattern 5: Ignoring dispose()

**Problem**: Not disposing controllers and resources causes memory leaks.

```dart
// BAD: Missing dispose
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  // Missing dispose! Memory leak!
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        controller: _scrollController,
        children: [TextField(controller: _controller)],
      ),
    );
  }
}
```

**Solution**: Always dispose resources in StatefulWidget.

```dart
// GOOD: Proper dispose
class _MyScreenState extends State<MyScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  late final ScrollController _scrollController;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        controller: _scrollController,
        children: [TextField(controller: _controller)],
      ),
    );
  }
}
```

---

## Quick Reference Checklist

### Before Creating a Widget

- [ ] Is it `StatelessWidget` or `StatefulWidget`? Choose correctly.
- [ ] Does it have a `const` constructor?
- [ ] Are all parameters named?
- [ ] Are required parameters marked with `required`?
- [ ] Do optional parameters have sensible defaults?
- [ ] Is the name descriptive and follows conventions?
- [ ] Can it be composed from smaller widgets?

### Before Committing Widget Code

- [ ] No business logic in build method
- [ ] No prop drilling (use providers instead)
- [ ] Controllers are disposed (in StatefulWidget)
- [ ] No deeply nested widget trees (extract widgets)
- [ ] `const` used wherever possible
- [ ] No god widgets (split if > 200 lines)
- [ ] Callbacks used for events, not direct navigation

---

## Summary

Following these component guidelines ensures:

- **Performance**: Optimal use of Flutter's rendering pipeline
- **Maintainability**: Clear, readable widget structure
- **Testability**: Separated concerns enable easy testing
- **Consistency**: Uniform code style across the team
- **Scalability**: Patterns that work for small and large apps

**Core Philosophy**: Widgets are for presentation. Keep them dumb, pure, and composable.
