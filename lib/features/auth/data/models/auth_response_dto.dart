/// Auth response DTO for data transfer.
library;

import 'package:flutter_project_template/features/auth/data/models/user_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_response_dto.g.dart';

/// Auth response data transfer object.
///
/// Used for serializing authentication response data from API.
@JsonSerializable()
class AuthResponseDto {
  /// Creates an auth response DTO.
  const AuthResponseDto({
    required this.success,
    required this.user,
    required this.token,
    this.message,
    this.refreshToken,
    this.expiresIn,
  });

  /// Creates an auth response DTO from JSON.
  factory AuthResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseDtoFromJson(json);

  /// Whether the authentication was successful.
  final bool success;

  /// The authenticated user data.
  final UserDto user;

  /// The authentication token.
  final String token;

  /// Optional message (e.g., error message).
  final String? message;

  /// Optional refresh token.
  final String? refreshToken;

  /// Token expiration time in seconds.
  final int? expiresIn;

  /// Converts this DTO to JSON.
  Map<String, dynamic> toJson() => _$AuthResponseDtoToJson(this);
}

/// Token refresh response DTO.
@JsonSerializable()
class TokenRefreshResponseDto {
  /// Creates a token refresh response DTO.
  const TokenRefreshResponseDto({
    required this.success,
    required this.token,
    this.refreshToken,
    this.expiresIn,
  });

  /// Creates a token refresh response DTO from JSON.
  factory TokenRefreshResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TokenRefreshResponseDtoFromJson(json);

  /// Whether the refresh was successful.
  final bool success;

  /// The new authentication token.
  final String token;

  /// Optional new refresh token.
  final String? refreshToken;

  /// Token expiration time in seconds.
  final int? expiresIn;

  /// Converts this DTO to JSON.
  Map<String, dynamic> toJson() => _$TokenRefreshResponseDtoToJson(this);
}
