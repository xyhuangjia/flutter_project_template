/// Auth provider using Riverpod code generation.
library;

import 'package:flutter_project_template/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_project_template/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_project_template/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_project_template/features/auth/domain/entities/auth_state.dart';
import 'package:flutter_project_template/features/auth/domain/entities/user.dart';
import 'package:flutter_project_template/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_provider.g.dart';

/// Provider for SharedPreferences.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  throw UnimplementedError('Override with SharedPreferences instance');
}

/// Provider for AuthLocalDataSource.
@Riverpod(keepAlive: true)
AuthLocalDataSource authLocalDataSource(AuthLocalDataSourceRef ref) {
  return AuthLocalDataSource(
    sharedPreferences: ref.watch(sharedPreferencesProvider),
  );
}

/// Provider for AuthRemoteDataSource.
@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(AuthRemoteDataSourceRef ref) {
  return AuthRemoteDataSource();
}

/// Provider for AuthRepository.
@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
}

/// Auth state notifier provider.
///
/// Manages the authentication state.
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<AuthState> build() async {
    // Check if user is already authenticated
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.getCurrentUser();

    return result.when(
      failure: (failure) => const AuthState.unauthenticated(),
      success: (user) {
        if (user != null) {
          final token = ref.read(authLocalDataSourceProvider).getToken();
          return AuthState.authenticated(user: user, token: token ?? '');
        }
        return const AuthState.unauthenticated();
      },
    );
  }

  /// Logs in with email and password.
  Future<bool> loginWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.loginWithEmail(
      email: email,
      password: password,
    );

    state = result.when(
      failure: (failure) => AsyncValue.error(failure, StackTrace.current),
      success: (user) => AsyncValue.data(
        AuthState.authenticated(
          user: user,
          token: ref.read(authLocalDataSourceProvider).getToken() ?? '',
        ),
      ),
    );

    return !state.hasError;
  }

  /// Logs in with username and password.
  Future<bool> loginWithUsername({
    required String username,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.loginWithUsername(
      username: username,
      password: password,
    );

    state = result.when(
      failure: (failure) => AsyncValue.error(failure, StackTrace.current),
      success: (user) => AsyncValue.data(
        AuthState.authenticated(
          user: user,
          token: ref.read(authLocalDataSourceProvider).getToken() ?? '',
        ),
      ),
    );

    return !state.hasError;
  }

  /// Logs in with WeChat.
  Future<bool> loginWithWeChat() async {
    state = const AsyncValue.loading();

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.loginWithWeChat();

    state = result.when(
      failure: (failure) => AsyncValue.error(failure, StackTrace.current),
      success: (user) => AsyncValue.data(
        AuthState.authenticated(
          user: user,
          token: ref.read(authLocalDataSourceProvider).getToken() ?? '',
        ),
      ),
    );

    return !state.hasError;
  }

  /// Logs in with Apple.
  Future<bool> loginWithApple() async {
    state = const AsyncValue.loading();

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.loginWithApple();

    state = result.when(
      failure: (failure) => AsyncValue.error(failure, StackTrace.current),
      success: (user) => AsyncValue.data(
        AuthState.authenticated(
          user: user,
          token: ref.read(authLocalDataSourceProvider).getToken() ?? '',
        ),
      ),
    );

    return !state.hasError;
  }

  /// Logs in with Google.
  Future<bool> loginWithGoogle() async {
    state = const AsyncValue.loading();

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.loginWithGoogle();

    state = result.when(
      failure: (failure) => AsyncValue.error(failure, StackTrace.current),
      success: (user) => AsyncValue.data(
        AuthState.authenticated(
          user: user,
          token: ref.read(authLocalDataSourceProvider).getToken() ?? '',
        ),
      ),
    );

    return !state.hasError;
  }

  /// Registers a new user.
  Future<bool> register({
    required String email,
    required String username,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.register(
      email: email,
      username: username,
      password: password,
    );

    state = result.when(
      failure: (failure) => AsyncValue.error(failure, StackTrace.current),
      success: (user) => AsyncValue.data(
        AuthState.authenticated(
          user: user,
          token: ref.read(authLocalDataSourceProvider).getToken() ?? '',
        ),
      ),
    );

    return !state.hasError;
  }

  /// Logs out the current user.
  Future<bool> logout() async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.logout();

    result.when<void>(
      failure: (failure) => null,
      success: (_) {
        state = const AsyncValue.data(AuthState.unauthenticated());
      },
    );

    return !result.isFailure;
  }

  /// Gets the current user.
  User? get currentUser => state.valueOrNull?.user;

  /// Checks if the user is authenticated.
  bool get isAuthenticated => state.valueOrNull?.isAuthenticated ?? false;
}
