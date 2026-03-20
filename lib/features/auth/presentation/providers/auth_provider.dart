/// Auth provider using Riverpod code generation.
library;

import 'package:flutter_project_template/core/providers/locale_provider.dart';
import 'package:flutter_project_template/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_project_template/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_project_template/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_project_template/features/auth/domain/entities/auth_state.dart';
import 'package:flutter_project_template/features/auth/domain/entities/user.dart';
import 'package:flutter_project_template/features/auth/domain/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

/// Provider for AuthLocalDataSource.
@riverpod
AuthLocalDataSource authLocalDataSource(AuthLocalDataSourceRef ref) {
  final prefs = ref.watch(sharedPrefsProvider).valueOrNull;
  if (prefs == null) {
    throw StateError('SharedPreferences not initialized');
  }
  return AuthLocalDataSource(sharedPreferences: prefs);
}

/// Provider for AuthRemoteDataSource.
@riverpod
AuthRemoteDataSource authRemoteDataSource(AuthRemoteDataSourceRef ref) {
  return AuthRemoteDataSource();
}

/// Provider for AuthRepository.
@riverpod
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
    await ref.watch(sharedPrefsProvider.future);
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.getCurrentUser();

    return result.when(
      failure: (_) => const AuthState.unauthenticated(),
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
      failure: (f) => AsyncValue.error(f, StackTrace.current),
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
      failure: (f) => AsyncValue.error(f, StackTrace.current),
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
      failure: (f) => AsyncValue.error(f, StackTrace.current),
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
      failure: (f) => AsyncValue.error(f, StackTrace.current),
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
      failure: (f) => AsyncValue.error(f, StackTrace.current),
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
      failure: (f) => AsyncValue.error(f, StackTrace.current),
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
      failure: (_) => null,
      success: (_) =>
          state = const AsyncValue.data(AuthState.unauthenticated()),
    );

    return !result.isFailure;
  }

  /// Gets the current user.
  User? get currentUser => state.valueOrNull?.user;

  /// Checks if the user is authenticated.
  bool get isAuthenticated => state.valueOrNull?.isAuthenticated ?? false;

  /// Sends verification code to phone number.
  Future<bool> sendVerificationCodeToPhone(String phoneNumber) async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.sendVerificationCodeToPhone(phoneNumber);

    return result.when(
      failure: (_) => false,
      success: (_) => true,
    );
  }

  /// Sends verification code to email.
  Future<bool> sendVerificationCodeToEmail(String email) async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.sendVerificationCodeToEmail(email);

    return result.when(
      failure: (_) => false,
      success: (_) => true,
    );
  }

  /// Verifies phone code.
  Future<bool> verifyPhoneCode({
    required String phoneNumber,
    required String code,
  }) async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.verifyPhoneCode(
      phoneNumber: phoneNumber,
      code: code,
    );

    return result.when(
      failure: (_) => false,
      success: (verified) => verified,
    );
  }

  /// Verifies email code.
  Future<bool> verifyEmailCode({
    required String email,
    required String code,
  }) async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.verifyEmailCode(
      email: email,
      code: code,
    );

    return result.when(
      failure: (_) => false,
      success: (verified) => verified,
    );
  }

  /// Registers with phone verification.
  Future<bool> registerWithPhone({
    required String phoneNumber,
    required String username,
    required String password,
    required String verificationCode,
    String? avatarUrl,
  }) async {
    state = const AsyncValue.loading();

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.registerWithPhone(
      phoneNumber: phoneNumber,
      username: username,
      password: password,
      verificationCode: verificationCode,
      avatarUrl: avatarUrl,
    );

    state = result.when(
      failure: (f) => AsyncValue.error(f, StackTrace.current),
      success: (user) => AsyncValue.data(
        AuthState.authenticated(
          user: user,
          token: ref.read(authLocalDataSourceProvider).getToken() ?? '',
        ),
      ),
    );

    return !state.hasError;
  }

  /// Registers with email verification.
  Future<bool> registerWithEmail({
    required String email,
    required String username,
    required String password,
    required String verificationCode,
    String? avatarUrl,
  }) async {
    state = const AsyncValue.loading();

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.registerWithEmail(
      email: email,
      username: username,
      password: password,
      verificationCode: verificationCode,
      avatarUrl: avatarUrl,
    );

    state = result.when(
      failure: (f) => AsyncValue.error(f, StackTrace.current),
      success: (user) => AsyncValue.data(
        AuthState.authenticated(
          user: user,
          token: ref.read(authLocalDataSourceProvider).getToken() ?? '',
        ),
      ),
    );

    return !state.hasError;
  }
}
