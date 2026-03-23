/// Unit tests for password validation logic.
library;

import 'package:flutter_test/flutter_test.dart';

/// Password validation helper class for testing.
class PasswordValidator {
  /// Minimum password length.
  static const int minLength = 8;

  /// Validates password length.
  static bool hasMinLength(String password) => password.length >= minLength;

  /// Validates password contains at least one letter.
  static bool hasLetter(String password) =>
      RegExp('[a-zA-Z]').hasMatch(password);

  /// Validates password contains at least one number.
  static bool hasNumber(String password) => RegExp('[0-9]').hasMatch(password);

  /// Validates password meets all requirements.
  static bool isValid(String password) {
    if (password.length < minLength) return false;
    if (!hasLetter(password)) return false;
    if (!hasNumber(password)) return false;
    return true;
  }

  /// Returns list of validation errors.
  static List<String> getErrors(String password) {
    final errors = <String>[];
    if (!hasMinLength(password)) {
      errors.add('Password must be at least $minLength characters');
    }
    if (!hasLetter(password)) {
      errors.add('Password must contain at least one letter');
    }
    if (!hasNumber(password)) {
      errors.add('Password must contain at least one number');
    }
    return errors;
  }
}

void main() {
  group('PasswordValidator - hasMinLength', () {
    test('should return false for empty password', () {
      expect(PasswordValidator.hasMinLength(''), isFalse);
    });

    test('should return false for password shorter than 8 characters', () {
      expect(PasswordValidator.hasMinLength('1234567'), isFalse);
    });

    test('should return true for password with exactly 8 characters', () {
      expect(PasswordValidator.hasMinLength('12345678'), isTrue);
    });

    test('should return true for password longer than 8 characters', () {
      expect(PasswordValidator.hasMinLength('123456789'), isTrue);
    });
  });

  group('PasswordValidator - hasLetter', () {
    test('should return false for password without letters', () {
      expect(PasswordValidator.hasLetter('12345678'), isFalse);
    });

    test('should return true for password with lowercase letter', () {
      expect(PasswordValidator.hasLetter('a2345678'), isTrue);
    });

    test('should return true for password with uppercase letter', () {
      expect(PasswordValidator.hasLetter('A2345678'), isTrue);
    });

    test('should return true for password with mixed case letters', () {
      expect(PasswordValidator.hasLetter('Ab345678'), isTrue);
    });
  });

  group('PasswordValidator - hasNumber', () {
    test('should return false for password without numbers', () {
      expect(PasswordValidator.hasNumber('abcdefgh'), isFalse);
    });

    test('should return true for password with one number', () {
      expect(PasswordValidator.hasNumber('abcdefg1'), isTrue);
    });

    test('should return true for password with multiple numbers', () {
      expect(PasswordValidator.hasNumber('abc12345'), isTrue);
    });
  });

  group('PasswordValidator - isValid', () {
    test('should return false for empty password', () {
      expect(PasswordValidator.isValid(''), isFalse);
    });

    test('should return false for password too short', () {
      expect(PasswordValidator.isValid('Ab1'), isFalse);
    });

    test('should return false for password without numbers', () {
      expect(PasswordValidator.isValid('Abcdefgh'), isFalse);
    });

    test('should return false for password without letters', () {
      expect(PasswordValidator.isValid('12345678'), isFalse);
    });

    test('should return true for valid password with letters and numbers', () {
      expect(PasswordValidator.isValid('Abcd1234'), isTrue);
    });

    test('should return true for valid password with special chars', () {
      expect(PasswordValidator.isValid('Abcd1234!@#'), isTrue);
    });

    test('should return true for valid complex password', () {
      expect(PasswordValidator.isValid('MyP@ssw0rd!2024'), isTrue);
    });
  });

  group('PasswordValidator - getErrors', () {
    test('should return all errors for empty password', () {
      final errors = PasswordValidator.getErrors('');
      expect(errors.length, equals(3));
      expect(errors.any((e) => e.contains('8 characters')), isTrue);
      expect(errors.any((e) => e.contains('letter')), isTrue);
      expect(errors.any((e) => e.contains('number')), isTrue);
    });

    test('should return only letter error for numbers-only password', () {
      final errors = PasswordValidator.getErrors('12345678');
      expect(errors.length, equals(1));
      expect(errors.first, contains('letter'));
    });

    test('should return only number error for letters-only password', () {
      final errors = PasswordValidator.getErrors('Abcdefgh');
      expect(errors.length, equals(1));
      expect(errors.first, contains('number'));
    });

    test('should return no errors for valid password', () {
      final errors = PasswordValidator.getErrors('Abcd1234');
      expect(errors, isEmpty);
    });
  });

  group('PasswordValidator - edge cases', () {
    test('should handle spaces', () {
      // Spaces are not letters or numbers
      expect(PasswordValidator.isValid('Abcd 123'), isTrue);
    });

    test('should handle only special characters', () {
      expect(PasswordValidator.hasLetter(r'!@#$%^&*'), isFalse);
      expect(PasswordValidator.hasNumber(r'!@#$%^&*'), isFalse);
    });

    test('should handle very long passwords', () {
      final longPassword = 'A' * 100 + '1';
      expect(PasswordValidator.isValid(longPassword), isTrue);
    });

    test('should not match non-ASCII letters with [a-zA-Z]', () {
      // [a-zA-Z] only matches ASCII letters, not unicode letters
      expect(PasswordValidator.hasLetter('中文1234'), isFalse);
    });
  });
}
