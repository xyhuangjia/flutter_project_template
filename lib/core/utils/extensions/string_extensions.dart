/// String extension methods.
///
/// This file provides extension methods for String manipulation.
library;

/// Extension methods for String class.
extension StringExtensions on String {
  /// Returns true if the string is null or empty.
  bool get isNullOrEmpty => isEmpty;

  /// Returns true if the string is not null and not empty.
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Capitalizes the first letter of the string.
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Capitalizes the first letter of each word.
  String get capitalizeWords =>
      isEmpty ? this : split(' ').map((word) => word.capitalize).join(' ');

  /// Truncates the string to a maximum length with ellipsis.
  String truncate(int maxLength, {String ellipsis = '...'}) =>
      length <= maxLength
          ? this
          : '${substring(0, maxLength - ellipsis.length)}$ellipsis';

  /// Removes all whitespace from the string.
  String get removeWhitespace => replaceAll(RegExp(r'\s'), '');

  /// Returns true if the string is a valid email.
  bool get isEmail =>
      RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(this);

  /// Returns true if the string is a valid URL.
  bool get isUrl => RegExp(
        r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      ).hasMatch(this);

  /// Returns true if the string is numeric.
  bool get isNumeric => RegExp(r'^[0-9]+$').hasMatch(this);

  /// Parses the string to an integer, returns null if invalid.
  int? toIntOrNull() => int.tryParse(this);

  /// Parses the string to a double, returns null if invalid.
  double? toDoubleOrNull() => double.tryParse(this);

  /// Returns the string reversed.
  String get reversed => split('').reversed.join();

  /// Returns true if the string contains only alphabetic characters.
  bool get isAlpha => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  /// Returns true if the string contains only alphanumeric characters.
  bool get isAlphanumeric => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
}

/// Extension methods for nullable String.
extension NullableStringExtensions on String? {
  /// Returns the string or a default value if null.
  String orDefault(String defaultValue) => this ?? defaultValue;

  /// Returns true if the string is null or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Returns true if the string is not null and not empty.
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;
}
