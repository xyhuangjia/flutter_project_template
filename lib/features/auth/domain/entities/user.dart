/// User entity representing authenticated user.
///
/// This is a domain entity with no external dependencies.
library;

import 'package:flutter/foundation.dart';

/// User gender enum.
enum UserGender {
  /// Male.
  male,

  /// Female.
  female,

  /// Not specified.
  unspecified,
}

/// User entity representing an authenticated user.
@immutable
class User {
  /// Creates a user entity.
  const User({
    required this.id,
    required this.email,
    required this.username,
    this.displayName,
    this.avatarUrl,
    this.phoneNumber,
    this.gender = UserGender.unspecified,
    this.bio,
  });

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

  /// The user's gender.
  final UserGender gender;

  /// The user's bio/description (optional).
  final String? bio;

  /// Creates a copy of this entity with optionally overridden fields.
  User copyWith({
    String? id,
    String? email,
    String? username,
    String? displayName,
    String? avatarUrl,
    String? phoneNumber,
    UserGender? gender,
    String? bio,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      bio: bio ?? this.bio,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.email == email &&
        other.username == username &&
        other.displayName == displayName &&
        other.avatarUrl == avatarUrl &&
        other.phoneNumber == phoneNumber &&
        other.gender == gender &&
        other.bio == bio;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      email,
      username,
      displayName,
      avatarUrl,
      phoneNumber,
      gender,
      bio,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, username: $username, '
        'displayName: $displayName, avatarUrl: $avatarUrl, '
        'phoneNumber: $phoneNumber, gender: $gender, bio: $bio)';
  }
}
