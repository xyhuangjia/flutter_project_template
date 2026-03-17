/// Application string constants.
///
/// This file defines all user-facing strings used in the application.
/// Centralizing strings makes localization easier.
library;

/// Application strings class.
///
/// Contains all string constants used in the application.
abstract final class AppStrings {
  /// Application name.
  static const String appName = 'Flutter Project Template';

  // Common
  /// Loading text.
  static const String loading = 'Loading...';

  /// Error text.
  static const String error = 'Error';

  /// Success text.
  static const String success = 'Success';

  /// Cancel text.
  static const String cancel = 'Cancel';

  /// Confirm text.
  static const String confirm = 'Confirm';

  /// Save text.
  static const String save = 'Save';

  /// Delete text.
  static const String delete = 'Delete';

  /// Retry text.
  static const String retry = 'Retry';

  /// Close text.
  static const String close = 'Close';

  /// OK text.
  static const String ok = 'OK';

  // Navigation
  /// Home navigation label.
  static const String home = 'Home';

  /// Settings navigation label.
  static const String settings = 'Settings';

  /// Profile navigation label.
  static const String profile = 'Profile';

  /// Back navigation label.
  static const String back = 'Back';

  /// Next navigation label.
  static const String next = 'Next';

  // Authentication
  /// Login text.
  static const String login = 'Login';

  /// Logout text.
  static const String logout = 'Logout';

  /// Register text.
  static const String register = 'Register';

  /// Email label.
  static const String email = 'Email';

  /// Password label.
  static const String password = 'Password';

  /// Forgot password text.
  static const String forgotPassword = 'Forgot Password?';

  // Error messages
  /// Generic error message.
  static const String genericError = 'Something went wrong. Please try again.';

  /// Network error message.
  static const String networkError = 'Network error. Please check your connection.';

  /// Server error message.
  static const String serverError = 'Server error. Please try again later.';

  /// Unauthorized error message.
  static const String unauthorizedError = 'Unauthorized. Please login again.';

  /// Session expired message.
  static const String sessionExpired = 'Session expired. Please login again.';

  /// Validation error message.
  static const String validationError = 'Please check your input.';

  /// Empty list message.
  static const String emptyList = 'No items found.';

  // Success messages
  /// Operation success message.
  static const String operationSuccess = 'Operation completed successfully.';

  /// Save success message.
  static const String saveSuccess = 'Saved successfully.';

  /// Delete success message.
  static const String deleteSuccess = 'Deleted successfully.';
}
