/// Error handler utilities.
///
/// This file provides utilities for handling and converting
/// exceptions to failures and user-friendly messages.
library;

import 'package:dio/dio.dart';
import 'package:flutter_project_template/core/constants/app_strings.dart';
import 'package:flutter_project_template/core/errors/exceptions.dart';
import 'package:flutter_project_template/core/errors/failures.dart';

/// Utility class for handling errors.
///
/// Provides methods to convert exceptions to failures
/// and extract user-friendly error messages.
abstract final class ErrorHandler {
  /// Converts an exception to a Failure.
  ///
  /// This method maps different exception types to
  /// appropriate failure types.
  static Failure handleException(Exception exception) => switch (exception) {
        NetworkException e => NetworkFailure(
            message: e.message,
            code: e.statusCode?.toString(),
          ),
        ServerException e => ServerFailure(
            message: e.message,
            code: e.errorCode,
            statusCode: e.statusCode,
          ),
        AuthException e => AuthFailure(
            message: e.message,
            code: e.code,
          ),
        ValidationException e => ValidationFailure(
            message: e.message,
            errors: e.errors,
          ),
        CacheException e => CacheFailure(
            message: e.message,
          ),
        NotFoundException e => ServerFailure(
            message: e.message,
            code: '${e.resourceType}_${e.resourceId}',
          ),
        DioException e => _handleDioException(e),
        _ => UnknownFailure(message: exception.toString()),
      };

  /// Handles Dio-specific exceptions.
  static Failure _handleDioException(DioException exception) =>
      switch (exception.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout =>
          NetworkFailure(
            message: 'Connection timeout. Please try again.',
          ),
        DioExceptionType.connectionError => NetworkFailure(
            message: AppStrings.networkError,
          ),
        DioExceptionType.badResponse => _handleResponseError(exception),
        DioExceptionType.cancel => NetworkFailure(
            message: 'Request was cancelled.',
          ),
        _ => ServerFailure(
            message: exception.message ?? AppStrings.serverError,
          ),
      };

  /// Handles HTTP response errors.
  static Failure _handleResponseError(DioException exception) {
    final statusCode = exception.response?.statusCode;

    return switch (statusCode) {
      400 => ValidationFailure(message: 'Bad request'),
      401 => AuthFailure(message: AppStrings.unauthorizedError),
      403 => AuthFailure(message: 'Access denied'),
      404 => ServerFailure(
          message: 'Resource not found',
          statusCode: statusCode,
        ),
      500 || 502 || 503 => ServerFailure(
          message: AppStrings.serverError,
          statusCode: statusCode,
        ),
      _ => ServerFailure(
          message: exception.message ?? AppStrings.serverError,
          statusCode: statusCode,
        ),
    };
  }

  /// Gets a user-friendly error message from a failure.
  static String getErrorMessage(Failure failure) {
    return failure.message;
  }

  /// Gets a user-friendly error message from an exception.
  static String getExceptionMessage(Exception exception) {
    final failure = handleException(exception);
    return getErrorMessage(failure);
  }
}
