/// User preferences entity.
library;

import 'package:flutter/foundation.dart';

/// User preferences entity.
@immutable
class UserPreferences {
  /// Creates user preferences.
  const UserPreferences({
    this.displayName,
    this.avatarUrl,
    this.bio,
    this.phoneNumber,
    this.email,
  });

  /// The user's display name.
  final String? displayName;

  /// The user's avatar URL.
  final String? avatarUrl;

  /// The user's bio/description.
  final String? bio;

  /// The user's phone number.
  final String? phoneNumber;

  /// The user's email.
  final String? email;

  /// Creates a copy with optionally overridden fields.
  UserPreferences copyWith({
    String? displayName,
    String? avatarUrl,
    String? bio,
    String? phoneNumber,
    String? email,
  }) => UserPreferences(
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
    );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserPreferences &&
        other.displayName == displayName &&
        other.avatarUrl == avatarUrl &&
        other.bio == bio &&
        other.phoneNumber == phoneNumber &&
        other.email == email;
  }

  @override
  int get hashCode => Object.hash(displayName, avatarUrl, bio, phoneNumber, email);

  @override
  String toString() => 'UserPreferences(displayName: $displayName, avatarUrl: $avatarUrl, '
        'bio: $bio, phoneNumber: $phoneNumber, email: $email)';
}
