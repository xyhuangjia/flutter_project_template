/// Application-wide constants.
///
/// This file defines constants used throughout the application
/// such as API endpoints, timeouts, and configuration values.
library;

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application constants class.
///
/// Contains all application-wide constant values.
abstract final class AppConstants {
  /// Application name.
  static const String appName = 'Flutter Project Template';

  /// Application version.
  static const String appVersion = '1.0.0';

  /// API base URL loaded from environment.
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.example.com';

  /// Connection timeout in seconds.
  static const int connectionTimeoutSeconds = 30;

  /// Receive timeout in seconds.
  static const int receiveTimeoutSeconds = 30;

  /// Default page size for pagination.
  static const int defaultPageSize = 20;

  /// Maximum retry attempts for network requests.
  static const int maxRetryAttempts = 3;

  /// Token refresh threshold in seconds before expiration.
  static const int tokenRefreshThresholdSeconds = 300;
}
