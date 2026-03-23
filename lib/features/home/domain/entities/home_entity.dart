/// Home entity representing home screen data.
///
/// This is a domain entity with no external dependencies.
library;

import 'package:flutter/foundation.dart';

/// Home entity representing the home screen state.
///
/// Contains all data needed for the home screen display.
@immutable
class HomeEntity {
  /// Creates a home entity.
  const HomeEntity({
    required this.title,
    required this.welcomeMessage,
    this.userName,
    this.avatarUrl,
  });

  /// The title of the home screen.
  final String title;

  /// The welcome message to display.
  final String welcomeMessage;

  /// The user's name (optional).
  final String? userName;

  /// The user's avatar URL (optional).
  final String? avatarUrl;

  /// Creates a copy of this entity with optionally overridden fields.
  HomeEntity copyWith({
    String? title,
    String? welcomeMessage,
    String? userName,
    String? avatarUrl,
  }) => HomeEntity(
      title: title ?? this.title,
      welcomeMessage: welcomeMessage ?? this.welcomeMessage,
      userName: userName ?? this.userName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HomeEntity &&
        other.title == title &&
        other.welcomeMessage == welcomeMessage &&
        other.userName == userName &&
        other.avatarUrl == avatarUrl;
  }

  @override
  int get hashCode => Object.hash(title, welcomeMessage, userName, avatarUrl);

  @override
  String toString() => 'HomeEntity(title: $title, welcomeMessage: $welcomeMessage, '
        'userName: $userName, avatarUrl: $avatarUrl)';
}
