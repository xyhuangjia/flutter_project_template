/// Input validation utilities.
///
/// This file provides validation functions for common input types.
library;

/// Input validation class.
///
/// Provides static methods for validating user input.
abstract final class Validators {
  /// Email regex pattern.
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  /// Phone number regex pattern (supports various formats).
  static final RegExp _phoneRegex = RegExp(
    r'^\+?[\d\s-]{10,15}$',
  );

  /// Password regex pattern (at least 8 chars, 1 uppercase, 1 lowercase,
  /// 1 number).
  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$',
  );

  /// URL regex pattern.
  static final RegExp _urlRegex = RegExp(
    r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
  );

  /// Validates an email address.
  ///
  /// Returns null if valid, otherwise returns an error message.
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!_emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates a password.
  ///
  /// Returns null if valid, otherwise returns an error message.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!_passwordRegex.hasMatch(value)) {
      return 'Password must contain uppercase, lowercase, and number';
    }
    return null;
  }

  /// Validates a required field.
  ///
  /// Returns null if valid, otherwise returns an error message.
  static String? validateRequired(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Field'} is required';
    }
    return null;
  }

  /// Validates a phone number.
  ///
  /// Returns null if valid, otherwise returns an error message.
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!_phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Validates a URL.
  ///
  /// Returns null if valid, otherwise returns an error message.
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }
    if (!_urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  /// Validates a minimum length.
  ///
  /// Returns null if valid, otherwise returns an error message.
  static String? validateMinLength(
    String? value,
    int minLength, [
    String? fieldName,
  ]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Field'} is required';
    }
    if (value.length < minLength) {
      return '${fieldName ?? 'Field'} must be at least $minLength characters';
    }
    return null;
  }

  /// Validates a maximum length.
  ///
  /// Returns null if valid, otherwise returns an error message.
  static String? validateMaxLength(
    String? value,
    int maxLength, [
    String? fieldName,
  ]) {
    if (value != null && value.length > maxLength) {
      return '${fieldName ?? 'Field'} must not exceed $maxLength characters';
    }
    return null;
  }

  /// Validates that two values match.
  ///
  /// Returns null if valid, otherwise returns an error message.
  static String? validateMatch(
    String? value1,
    String? value2, [
    String? fieldName,
  ]) {
    if (value1 != value2) {
      return '${fieldName ?? 'Values'} do not match';
    }
    return null;
  }

  /// Validates a number is within a range.
  ///
  /// Returns null if valid, otherwise returns an error message.
  static String? validateRange(
    num? value,
    num min,
    num max, [
    String? fieldName,
  ]) {
    if (value == null) {
      return '${fieldName ?? 'Value'} is required';
    }
    if (value < min || value > max) {
      return '${fieldName ?? 'Value'} must be between $min and $max';
    }
    return null;
  }

  /// Combines multiple validators.
  ///
  /// Returns the first error message found, or null if all pass.
  static String? combine(List<String? Function()> validators) {
    for (final validator in validators) {
      final error = validator();
      if (error != null) {
        return error;
      }
    }
    return null;
  }
}
