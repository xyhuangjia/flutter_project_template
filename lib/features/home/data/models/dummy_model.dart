/// Dummy model for demonstrating DTO pattern.
///
/// This model shows the pattern for creating serializable DTOs.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_project_template/features/home/domain/entities/home_entity.dart';

/// Dummy model demonstrating DTO pattern.
@immutable
class DummyModel {
  /// Creates a dummy model.
  const DummyModel({
    required this.id,
    required this.title,
    required this.welcomeMessage,
    required this.createdAt,
    required this.updatedAt,
    this.userName,
    this.avatarUrl,
  });

  /// Creates a DummyModel from JSON map.
  factory DummyModel.fromJson(Map<String, dynamic> json) => DummyModel(
        id: json['id'] as String,
        title: json['title'] as String,
        welcomeMessage: json['welcome_message'] as String,
        userName: json['user_name'] as String?,
        avatarUrl: json['avatar_url'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  /// Unique identifier.
  final String id;

  /// The title.
  final String title;

  /// The welcome message.
  final String welcomeMessage;

  /// Optional user name.
  final String? userName;

  /// Optional avatar URL.
  final String? avatarUrl;

  /// When the record was created.
  final DateTime createdAt;

  /// When the record was last updated.
  final DateTime updatedAt;

  /// Converts DummyModel to JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'welcome_message': welcomeMessage,
        'user_name': userName,
        'avatar_url': avatarUrl,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  /// Creates a copy of this DummyModel with optionally overridden fields.
  DummyModel copyWith({
    String? id,
    String? title,
    String? welcomeMessage,
    String? userName,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      DummyModel(
        id: id ?? this.id,
        title: title ?? this.title,
        welcomeMessage: welcomeMessage ?? this.welcomeMessage,
        userName: userName ?? this.userName,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  /// Converts the model to a domain entity.
  HomeEntity toEntity() => HomeEntity(
        title: title,
        welcomeMessage: welcomeMessage,
        userName: userName,
        avatarUrl: avatarUrl,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DummyModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          welcomeMessage == other.welcomeMessage &&
          userName == other.userName &&
          avatarUrl == other.avatarUrl &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(
        id,
        title,
        welcomeMessage,
        userName,
        avatarUrl,
        createdAt,
        updatedAt,
      );

  @override
  String toString() =>
      'DummyModel(id: $id, title: $title, welcomeMessage: $welcomeMessage, '
      'userName: $userName, avatarUrl: $avatarUrl, createdAt: $createdAt, '
      'updatedAt: $updatedAt)';
}
