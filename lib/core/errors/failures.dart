/// Failure classes for error handling.
///
/// This file defines failure types that represent different
/// types of errors in the domain layer and are
/// returned from repository methods.
library;

import 'package:flutter_project_template/core/constants/app_strings.dart';

/// Base failure class for all failures.
///
/// Failures represent errors in the domain layer and are
/// returned from repository methods.
abstract class Failure {
  /// Creates a failure.
  const Failure({
    required this.message,
    this.code,
  });

  /// Type of error message.
  final String message;

  /// An optional error code.
  final String? code;
}

/// Server failure represents errors from the server.
class ServerFailure extends Failure {
  /// Creates a server failure.
  const ServerFailure({
    super.message = AppStrings.serverError,
    super.code,
    this.statusCode,
  });

  /// The HTTP status code.
  final int? statusCode;
}

/// Network failure represents connectivity errors.
class NetworkFailure extends Failure {
  /// Creates a network failure.
  const NetworkFailure({
    super.message = AppStrings.networkError,
    super.code,
  });
}

/// Cache failure represents local storage errors.
class CacheFailure extends Failure {
  /// Creates a cache failure.
  const CacheFailure({
    super.message = 'Cache error occurred',
    super.code,
  });
}

/// Validation failure represents input validation errors.
class ValidationFailure extends Failure {
  /// Creates a validation failure.
  const ValidationFailure({
    super.message = AppStrings.validationError,
    super.code,
    this.errors,
  });

  /// Map of field names to error messages.
  final Map<String, String>? errors;
}

/// Auth failure represents authentication errors.
class AuthFailure extends Failure {
  /// Creates an auth failure.
  const AuthFailure({
    super.message = AppStrings.unauthorizedError,
    super.code,
  });
}

/// Unknown failure represents unexpected errors.
class UnknownFailure extends Failure {
  /// Creates an unknown failure.
  const UnknownFailure({
    super.message = AppStrings.genericError,
    super.code,
  });
}

/// Result type for type-safe error handling.
///
/// Use this for type-safe error handling in async operations.
sealed class Result<T> {
  /// Creates a result.
  const Result();

  /// Returns true if this is a success result.
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a failure result.
  bool get isFailure => this is FailureResult<T>;

  /// Gets the data if success, throws if failure.
  T get data => switch (this) {
      Success<T>(:final data) => data,
      FailureResult<T>(:final failure) =>
        throw StateError('No data in failure: $failure'),
    };

  /// Gets the data if success, null otherwise.
  T? get dataOrNull => switch (this) {
        Success<T>(:final data) => data,
        FailureResult<T>() => null,
      };

  /// Gets the failure if failure, null otherwise.
  Failure? get failureOrNull => switch (this) {
        Success<T>() => null,
        FailureResult<T>(:final failure) => failure,
      };

  /// Maps the data to a new type.
  Result<R> map<R>(R Function(T) mapper) => switch (this) {
        Success<T>(:final data) => Success(mapper(data)),
        FailureResult<T>(:final failure) => FailureResult(failure),
      };

  /// Executes callbacks based on result state.
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) =>
      switch (this) {
        Success<T>(:final data) => success(data),
        FailureResult<T>(failure: final err) => failure(err),
      };
}

/// Success result with data.
final class Success<T> extends Result<T> {
  /// Creates a success result.
  const Success(this.data);

  /// The success data.
  @override
  final T data;
}

/// Failure result with error.
final class FailureResult<T> extends Result<T> {
  /// Creates a failure result.
  const FailureResult(this.failure);

  /// The failure.
  final Failure failure;
}
