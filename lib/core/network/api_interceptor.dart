/// API interceptor for Dio.
///
/// This file defines interceptors for handling authentication,
/// token refresh, and error handling in API requests.
library;

import 'package:dio/dio.dart';
import 'package:flutter_project_template/core/errors/exceptions.dart';

/// API interceptor for authentication and error handling.
///
/// Adds authentication tokens to requests and handles
/// common error scenarios.
class ApiInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // Add authentication token if available
    // This would typically get the token from secure storage
    // final token = await _tokenStorage.getToken();
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }

    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    final statusCode = err.response?.statusCode;

    // Handle specific error codes
    if (statusCode == 401) {
      // Token expired or invalid
      // Could trigger token refresh or logout
      handler.next(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          type: DioExceptionType.badResponse,
          error: const AuthException(
            message: 'Session expired. Please login again.',
          ),
        ),
      );
      return;
    }

    if (statusCode == 403) {
      handler.next(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          type: DioExceptionType.badResponse,
          error: const AuthException(
            message: 'Access denied.',
          ),
        ),
      );
      return;
    }

    handler.next(err);
  }
}

/// Retry interceptor for failed requests.
///
/// Automatically retries failed requests with exponential backoff.
class RetryInterceptor extends Interceptor {
  /// Creates a retry interceptor.
  RetryInterceptor({
    required Dio dio,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  }) : _dio = dio;

  /// The Dio instance to use for retry requests.
  final Dio _dio;

  /// Maximum number of retry attempts.
  final int maxRetries;

  /// Initial delay between retries.
  final Duration retryDelay;

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Only retry on network errors
    if (err.type != DioExceptionType.connectionError &&
        err.type != DioExceptionType.connectionTimeout) {
      handler.next(err);
      return;
    }

    final extra = err.requestOptions.extra;
    final retryCount = extra['retryCount'] as int? ?? 0;

    if (retryCount >= maxRetries) {
      handler.next(err);
      return;
    }

    // Exponential backoff
    final delay = Duration(
      milliseconds: retryDelay.inMilliseconds * (1 << retryCount),
    );

    await Future<void>.delayed(delay);

    err.requestOptions.extra['retryCount'] = retryCount + 1;

    try {
      final response = await _dio.fetch<dynamic>(err.requestOptions);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    } on Exception catch (e) {
      handler.next(
        DioException(
          requestOptions: err.requestOptions,
          error: e,
        ),
      );
    }
  }
}
