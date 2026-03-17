/// Database provider for dependency injection.
///
/// This file provides Riverpod providers for database access.
library;

import 'package:flutter_project_template/core/storage/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the application database.
///
/// Use this provider to access the database instance.
final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();

  ref.onDispose(database.close);

  return database;
});

/// Provider for user-related database operations.
///
/// Use this provider to access user data.
final userDaoProvider = Provider<UserDao>((ref) {
  final database = ref.watch(databaseProvider);
  return UserDao(database);
});

/// Data access object for user operations.
///
/// Provides high-level database operations for users.
class UserDao {
  /// Creates a user DAO.
  UserDao(this._database);

  final AppDatabase _database;

  /// Fetches all users.
  Future<List<User>> getAllUsers() => _database.getAllUsers();

  /// Fetches a user by ID.
  Future<User?> getUserById(String id) => _database.getUserById(id);

  /// Fetches a user by email.
  Future<User?> getUserByEmail(String email) => _database.getUserByEmail(email);

  /// Watches all users for changes.
  Stream<List<User>> watchAllUsers() => _database.watchAllUsers();

  /// Inserts or updates a user.
  Future<void> upsertUser(UsersCompanion user) => _database.upsertUser(user);

  /// Deletes a user by ID.
  Future<int> deleteUser(String id) => _database.deleteUser(id);

  /// Clears all users.
  Future<int> clearAllUsers() => _database.clearAllUsers();
}
