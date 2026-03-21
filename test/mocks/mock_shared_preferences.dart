/// Mock SharedPreferences for testing.
library;

import 'package:shared_preferences/shared_preferences.dart';

/// Creates a mock SharedPreferences instance with the given initial values.
///
/// Usage:
/// ```dart
/// final prefs = await createMockSharedPreferences({
///   'auth_token': 'test-token',
///   'user_id': 'user-123',
/// });
/// ```
Future<SharedPreferences> createMockSharedPreferences(
  Map<String, Object> initialValues,
) async {
  SharedPreferences.setMockInitialValues(initialValues);
  return await SharedPreferences.getInstance();
}

/// Creates an empty mock SharedPreferences instance.
Future<SharedPreferences> createEmptyMockSharedPreferences() async {
  SharedPreferences.setMockInitialValues({});
  return await SharedPreferences.getInstance();
}

/// Creates a mock SharedPreferences with auth data pre-populated.
Future<SharedPreferences> createMockSharedPreferencesWithAuth({
  String? token,
  String? userId,
  String? email,
  String? username,
  String? displayName,
  String? avatarUrl,
}) async {
  final values = <String, Object>{};

  if (token != null) values['auth_token'] = token;
  if (userId != null) values['user_id'] = userId;
  if (email != null) values['user_email'] = email;
  if (username != null) values['username'] = username;
  if (displayName != null) values['display_name'] = displayName;
  if (avatarUrl != null) values['avatar_url'] = avatarUrl;

  return createMockSharedPreferences(values);
}
