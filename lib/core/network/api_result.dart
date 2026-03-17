/// API result wrapper for type-safe API responses.
///
/// This file provides a sealed class for handling API responses
/// in a type-safe manner using pattern matching.
library;

/// Sealed class representing API call results.
///
/// Use this for type-safe handling of API responses with
/// pattern matching support.
sealed class ApiResult<T> {
  /// Creates an API result.
  const ApiResult();

  /// Returns true if the result is successful.
  bool get isSuccess => this is ApiSuccess<T>;

  /// Returns true if the result is a failure.
  bool get isFailure => this is ApiFailure<T>;

  /// Returns true if the result is loading.
  bool get isLoading => this is ApiLoading<T>;

  /// Gets the data if successful, null otherwise.
  T? get dataOrNull => switch (this) {
        ApiSuccess<T>(:final data) => data,
        ApiFailure<T>() || ApiLoading<T>() => null,
      };

  /// Gets the error message if failed, null otherwise.
  String? get errorMessageOrNull => switch (this) {
        ApiFailure<T>(:final message) => message,
        ApiSuccess<T>() || ApiLoading<T>() => null,
      };

  /// Maps the data to a different type.
  ApiResult<R> map<R>(R Function(T) mapper) => switch (this) {
        ApiSuccess<T>(:final data, :final message) =>
          ApiSuccess(data: mapper(data), message: message),
        ApiFailure<T>(
          :final message,
          :final statusCode,
          :final errorCode,
          :final details,
        ) =>
          ApiFailure(
            message: message,
            statusCode: statusCode,
            errorCode: errorCode,
            details: details,
          ),
        ApiLoading<T>() => const ApiLoading(),
      };

  /// Executes callbacks based on the result state.
  R when<R>({
    required R Function(T data, String? message) success,
    required R Function(String message, int? statusCode, String? errorCode)
        failure,
    R Function()? loading,
  }) =>
      switch (this) {
        ApiSuccess<T>(:final data, :final message) => success(data, message),
        ApiFailure<T>(
          :final message,
          :final statusCode,
          :final errorCode,
        ) =>
          failure(message, statusCode, errorCode),
        ApiLoading<T>() =>
          loading?.call() ?? (throw StateError('No loading handler provided')),
      };
}

/// Successful API response with data.
final class ApiSuccess<T> extends ApiResult<T> {
  /// Creates a successful API result.
  const ApiSuccess({
    required this.data,
    this.message,
  });

  /// The response data.
  final T data;

  /// Optional success message.
  final String? message;
}

/// Failed API response with error details.
final class ApiFailure<T> extends ApiResult<T> {
  /// Creates a failed API result.
  const ApiFailure({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.details,
  });

  /// The error message.
  final String message;

  /// The HTTP status code.
  final int? statusCode;

  /// The server-specific error code.
  final String? errorCode;

  /// Additional error details.
  final dynamic details;
}

/// Loading state.
final class ApiLoading<T> extends ApiResult<T> {
  /// Creates a loading state.
  const ApiLoading();
}
