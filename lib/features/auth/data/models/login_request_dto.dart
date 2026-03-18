/// Login request DTO for data transfer.
library;

import 'package:json_annotation/json_annotation.dart';

part 'login_request_dto.g.dart';

/// Login request data transfer object.
///
/// Used for serializing login request data.
@JsonSerializable()
class LoginRequestDto {
  /// Creates a login request DTO.
  const LoginRequestDto({
    required this.email,
    required this.password,
    this.username,
  });

  /// Creates a login request DTO from JSON.
  factory LoginRequestDto.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestDtoFromJson(json);

  /// The email address (for email login).
  final String email;

  /// The password.
  final String password;

  /// The username (optional, for username login).
  final String? username;

  /// Converts this DTO to JSON.
  Map<String, dynamic> toJson() => _$LoginRequestDtoToJson(this);
}

/// Login request DTO for username login.
@JsonSerializable()
class UsernameLoginRequestDto {
  /// Creates a username login request DTO.
  const UsernameLoginRequestDto({
    required this.username,
    required this.password,
  });

  /// Creates a username login request DTO from JSON.
  factory UsernameLoginRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UsernameLoginRequestDtoFromJson(json);

  /// The username.
  final String username;

  /// The password.
  final String password;

  /// Converts this DTO to JSON.
  Map<String, dynamic> toJson() => _$UsernameLoginRequestDtoToJson(this);
}
