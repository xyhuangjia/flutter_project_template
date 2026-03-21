/// Route definitions and path constants.
///
/// This file defines all route paths used in the application.
library;

/// Route path constants.
///
/// Contains all route paths as static constants for
/// type-safe navigation.
abstract final class Routes {
  /// Root route.
  static const String root = '/';

  /// Home route.
  static const String home = '/home';

  /// Settings route.
  static const String settings = '/settings';

  /// Profile route.
  static const String profile = '/profile';

  /// Login route.
  static const String login = '/login';

  /// Register route.
  static const String register = '/register';

  /// Splash route.
  static const String splash = '/splash';

  /// Error route.
  static const String error = '/error';

  /// About route.
  static const String about = '/about';

  /// WebView route.
  static const String webView = '/webview';

  /// Chat list route.
  static const String chat = '/chat';

  /// Chat detail route (requires :id parameter).
  static const String chatDetail = '/chat/:id';

  /// Privacy consent route.
  static const String privacyConsent = '/privacy/consent';

  /// Privacy settings route.
  static const String privacySettings = '/privacy/settings';

  /// Permission rationale route.
  static const String permissionRationale = '/permission/rationale';

  /// Account deletion route.
  static const String accountDeletion = '/account/deletion';

  /// Forgot password route.
  static const String forgotPassword = '/forgot-password';

  /// AI configuration route.
  static const String aiConfig = '/settings/ai-config';
}

/// Route names for named navigation.
///
/// Contains all route names as static constants.
abstract final class RouteNames {
  /// Home route name.
  static const String home = 'home';

  /// Settings route name.
  static const String settings = 'settings';

  /// Profile route name.
  static const String profile = 'profile';

  /// Login route name.
  static const String login = 'login';

  /// Register route name.
  static const String register = 'register';

  /// Splash route name.
  static const String splash = 'splash';

  /// Error route name.
  static const String error = 'error';

  /// About route name.
  static const String about = 'about';

  /// WebView route name.
  static const String webView = 'webview';

  /// Chat list route name.
  static const String chat = 'chat';

  /// Chat detail route name.
  static const String chatDetail = 'chatDetail';

  /// Privacy consent route name.
  static const String privacyConsent = 'privacyConsent';

  /// Privacy settings route name.
  static const String privacySettings = 'privacySettings';

  /// Permission rationale route name.
  static const String permissionRationale = 'permissionRationale';

  /// Account deletion route name.
  static const String accountDeletion = 'accountDeletion';

  /// Forgot password route name.
  static const String forgotPassword = 'forgotPassword';

  /// AI configuration route name.
  static const String aiConfig = 'aiConfig';
}
