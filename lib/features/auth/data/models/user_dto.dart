/// User DTO for data transfer.
///
/// This file contains the data transfer object for user data.
library;

import 'package:flutter_project_template/features/auth/domain/entities/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

/// User data transfer object.
///
/// Used for serializing/deserializing user data from API.
@JsonSerializable()
class UserDto {
  /// Creates a user DTO.
  const UserDto({
    required this.id,
    required this.email,
    required this.username,
    this.displayName,
    this.avatarUrl,
    this.phoneNumber,
    this.bio,
    this.token,
  });

  /// Creates a user DTO from JSON.
  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  /// The unique identifier of the user.
  final String id;

  /// The user's email address.
  final String email;

  /// The user's username.
  final String username;

  /// The user's display name (optional).
  final String? displayName;

  /// The user's avatar URL (optional).
  final String? avatarUrl;

  /// The user's phone number (optional).
  final String? phoneNumber;

  /// The user's bio/description (optional).
  final String? bio;

  /// Authentication token (optional, only on login/register).
  final String? token;

  /// Converts this DTO to JSON.
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  /// Converts this DTO to a domain entity.
  User toEntity() => User(
    id: id,
    email: email,
    username: username,
    displayName: displayName,
    avatarUrl: avatarUrl,
    phoneNumber: phoneNumber,
    bio: bio,
  );

  @override
  String toString() {
    return 'UserDto(id: $id, email: $email, username: $username, '
        'displayName: $displayName, avatarUrl: $avatarUrl)';
  }
}
