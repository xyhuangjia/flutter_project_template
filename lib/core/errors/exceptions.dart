/// Application exception classes.
///
/// This file defines custom exception types used throughout
/// the application for error handling.
library;

import 'package:flutter_project_template/core/constants/app_strings.dart';

/// Base exception class for all application exceptions.
///
/// All custom exceptions should extend this class.
abstract class AppException implements Exception {
  /// Creates an app exception.
  const AppException({
    required this.message,
    this.stackTrace,
  });

  /// The error message.
  final String message;

  /// The stack trace when the exception occurred.
  final StackTrace? stackTrace;

  @override
  String toString() => 'AppException: $message';
}

/// Exception thrown when a network error occurs.
class NetworkException extends AppException {
  /// Creates a network exception.
  const NetworkException({
    super.message = AppStrings.networkError,
    super.stackTrace,
    this.statusCode,
  });

  /// The HTTP status code if available.
  final int? statusCode;

  @override
  String toString() => 'NetworkException: $message (statusCode: $statusCode)';
}

/// Exception thrown when a server error occurs.
class ServerException extends AppException {
  /// Creates a server exception.
  const ServerException({
    super.message = AppStrings.serverError,
    super.stackTrace,
    this.statusCode,
    this.errorCode,
  });

  /// The HTTP status code.
  final int? statusCode;

  /// The server-specific error code.
  final String? errorCode;

  @override
  String toString() =>
      'ServerException: $message (statusCode: $statusCode, errorCode: $errorCode)';
}

/// Exception thrown when authentication fails.
class AuthException extends AppException {
  /// Creates an auth exception.
  const AuthException({
    super.message = AppStrings.unauthorizedError,
    super.stackTrace,
    this.code,
  });

  /// The authentication error code.
  final String? code;

  @override
  String toString() => 'AuthException: $message (code: $code)';
}

/// Exception thrown when validation fails.
class ValidationException extends AppException {
  /// Creates a validation exception.
  const ValidationException({
    super.message = AppStrings.validationError,
    super.stackTrace,
    this.errors,
  });

  /// Map of field names to error messages.
  final Map<String, String>? errors;

  @override
  String toString() => 'ValidationException: $message (errors: $errors)';
}

/// Exception thrown when a resource is not found.
class NotFoundException extends AppException {
  /// Creates a not found exception.
  const NotFoundException({
    super.message = 'Resource not found',
    super.stackTrace,
    this.resourceType,
    this.resourceId,
  });

  /// The type of resource that was not found.
  final String? resourceType;

  /// The ID of the resource that was not found.
  final String? resourceId;

  @override
  String toString() =>
      'NotFoundException: $message (resourceType: $resourceType, resourceId: $resourceId)';
}

/// Exception thrown when a cache error occurs.
class CacheException extends AppException {
  /// Creates a cache exception.
  const CacheException({
    super.message = 'Cache error occurred',
    super.stackTrace,
  });

  @override
  String toString() => 'CacheException: $message';
}

/// Exception thrown when parsing JSON fails.
class JsonParseException extends AppException {
  /// Creates a JSON parse exception.
  const JsonParseException({
    required super.message,
    super.stackTrace,
  });

  @override
  String toString() => 'JsonParseException: $message';
}
