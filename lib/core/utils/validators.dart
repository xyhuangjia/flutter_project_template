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
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  /// Chinese phone number regex pattern (starts with 1, 11 digits).
  static final RegExp _chinesePhoneRegex = RegExp(
    r'^1[3-9]\d{9}$',
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

  /// Checks if password meets minimum length requirement.
  ///
  /// Returns true if password length is at least [minLength].
  static bool isPasswordMinLengthMet(String? password, {int minLength = 8}) {
    return password != null && password.length >= minLength;
  }

  /// Checks if password meets complexity requirement.
  ///
  /// Returns true if password contains both letters and numbers.
  static bool isPasswordComplexityMet(String? password) {
    if (password == null || password.isEmpty) return false;
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(password);
    final hasDigit = RegExp(r'\d').hasMatch(password);
    return hasLetter && hasDigit;
  }

  /// Checks if email format is valid.
  ///
  /// Returns true if email matches valid format.
  static bool isEmailValid(String? email) {
    if (email == null || email.isEmpty) return false;
    return _emailRegex.hasMatch(email);
  }

  /// Checks if Chinese phone number format is valid.
  ///
  /// Returns true if phone matches Chinese phone format (starts with 1, 11 digits).
  static bool isChinesePhoneValid(String? phone) {
    if (phone == null || phone.isEmpty) return false;
    return _chinesePhoneRegex.hasMatch(phone);
  }

  /// Checks if phone number format is valid (international format).
  ///
  /// Returns true if phone matches international phone format.
  static bool isPhoneValid(String? phone) {
    if (phone == null || phone.isEmpty) return false;
    return _phoneRegex.hasMatch(phone);
  }

  /// Checks if verification code length is valid.
  ///
  /// Returns true if code has exactly [length] digits.
  static bool isVerificationCodeValid(String? code, {int length = 6}) {
    if (code == null || code.isEmpty) return false;
    return code.length == length && RegExp(r'^\d+$').hasMatch(code);
  }

  /// Validates a Chinese phone number.
  ///
  /// Returns null if valid, otherwise returns an error message.
  static String? validateChinesePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!_chinesePhoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Validates a verification code.
  ///
  /// Returns null if valid, otherwise returns an error message.
  static String? validateVerificationCode(String? value, {int length = 6}) {
    if (value == null || value.isEmpty) {
      return 'Verification code is required';
    }
    if (value.length != length) {
      return 'Verification code must be $length digits';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Verification code must contain only digits';
    }
    return null;
  }

  /// Validates password match.
  ///
  /// Returns null if passwords match, otherwise returns an error message.
  static String? validatePasswordMatch(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validates a simple password (letters and numbers, at least 8 chars).
  ///
  /// Returns null if valid, otherwise returns an error message.
  static String? validateSimplePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!isPasswordComplexityMet(value)) {
      return 'Password must contain letters and numbers';
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
