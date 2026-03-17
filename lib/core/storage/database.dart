/// Database configuration using Drift.
///
/// This file defines the database schema and provides
/// database access methods.
library;

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

/// Users table definition.
///
/// Stores user profile information.
class Users extends Table {
  /// Unique identifier.
  TextColumn get id => text()();

  /// User's email address.
  TextColumn get email => text().withLength(min: 5, max: 254)();

  /// Display name.
  TextColumn get name => text().withLength(min: 1, max: 100)();

  /// Optional avatar URL.
  TextColumn get avatarUrl => text().nullable()();

  /// When the user account was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// When the user account was last updated.
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>>? get uniqueKeys => [
        {email},
      ];
}

/// Application database.
///
/// Defines all tables and provides database access methods.
@DriftDatabase(tables: [Users])
class AppDatabase extends _$AppDatabase {
  /// Creates the application database.
  AppDatabase() : super(_openConnection());

  /// Creates the application database with a specified executor.
  AppDatabase.connect(super.connection) : super();

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async => m.createAll(),
        onUpgrade: (m, from, to) async {
          // Add migration code here when schema changes
          // if (from < 2) {
          //   await m.addColumn(users, users.newColumn);
          // }
        },
        beforeOpen: (details) async =>
            customStatement('PRAGMA foreign_keys = ON'),
      );

  /// Fetches all users.
  Future<List<User>> getAllUsers() => select(users).get();

  /// Fetches a user by ID.
  Future<User?> getUserById(String id) =>
      (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();

  /// Fetches a user by email.
  Future<User?> getUserByEmail(String email) =>
      (select(users)..where((u) => u.email.equals(email))).getSingleOrNull();

  /// Watches users for changes.
  Stream<List<User>> watchAllUsers() => select(users).watch();

  /// Inserts or updates a user.
  Future<void> upsertUser(UsersCompanion user) =>
      into(users).insertOnConflictUpdate(user);

  /// Deletes a user by ID.
  Future<int> deleteUser(String id) =>
      (delete(users)..where((u) => u.id.equals(id))).go();

  /// Clears all users.
  Future<int> clearAllUsers() => delete(users).go();
}

/// Opens the database connection.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
