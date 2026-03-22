/// Auth provider using Riverpod code generation.
library;

import 'package:flutter_project_template/core/config/environment_provider.dart';
import 'package:flutter_project_template/core/errors/failures.dart';
import 'package:flutter_project_template/core/logging/talker_config.dart';
import 'package:flutter_project_template/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_project_template/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_project_template/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_project_template/features/auth/domain/entities/auth_state.dart';
import 'package:flutter_project_template/features/auth/domain/entities/user.dart';
import 'package:flutter_project_template/features/auth/domain/repositories/auth_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

/// Provider for AuthLocalDataSource.
@riverpod
AuthLocalDataSource authLocalDataSource(Ref ref) {
  // Use the same sharedPreferencesProvider that is overridden in main.dart
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthLocalDataSource(sharedPreferences: prefs);
}

/// Provider for AuthRemoteDataSource.
@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSource();
}

/// Provider for AuthRepository.
@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
}

/// Auth state notifier provider.
///
/// Manages the authentication state.
/// Uses keepAlive to prevent auto-dispose during navigation.
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<AuthState> build() async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.getCurrentUser();

    talker.log('[认证状态] build() 已调用');
    return result.when(
      failure: (_) {
        talker.log('[认证状态] build() 失败，返回未认证状态');
        return const AuthState.unauthenticated();
      },
      success: (user) {
        if (user != null) {
          final token = ref.read(authLocalDataSourceProvider).getToken();
          talker.log(
            '[认证状态] build() 成功，用户: ${user.username}',
          );
          return AuthState.authenticated(user: user, token: token ?? '');
        }
        talker.log('[认证状态] build() 无用户，返回未认证状态');
        return const AuthState.unauthenticated();
      },
    );
  }

  /// Logs in with email and password.
  Future<bool> loginWithEmail({
    required String email,
    required String password,
  }) async {
    talker.log('[认证状态] loginWithEmail() 已调用: $email');
    state = const AsyncValue.loading();

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.loginWithEmail(
      email: email,
      password: password,
    );

    state = result.when(
      failure: (f) {
        talker.error('[认证状态] loginWithEmail() 失败: ${f.message}');
        return AsyncValue.error(f, StackTrace.current);
      },
      success: (user) {
        talker.log('[认证状态] loginWithEmail() 成功: ${user.username}');
        return AsyncValue.data(
          AuthState.authenticated(
            user: user,
            token: ref.read(authLocalDataSourceProvider).getToken() ?? '',
          ),
        );
      },
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

    state = result.when<AsyncValue<AuthState>>(
      failure: (Failure f) =>
          AsyncValue<AuthState>.error(f, StackTrace.current),
      success: (User user) => AsyncValue<AuthState>.data(
        AuthState.authenticated(
          user: user,
          token: ref.read(authLocalDataSourceProvider).getToken() ?? '',
        ),
      ),
    );

    return !state.hasError;
  }

  /// Logs in with WeChat.
  Future<bool> loginWithWeChat() async => _performLogin(
        () => ref.read(authRepositoryProvider).loginWithWeChat(),
      );

  /// Logs in with Apple.
  Future<bool> loginWithApple() async => _performLogin(
        () => ref.read(authRepositoryProvider).loginWithApple(),
      );

  /// Logs in with Google.
  Future<bool> loginWithGoogle() async => _performLogin(
        () => ref.read(authRepositoryProvider).loginWithGoogle(),
      );

  /// Registers a new user.
  Future<bool> register({
    required String email,
    required String username,
    required String password,
  }) async =>
      _performLogin(
        () => ref.read(authRepositoryProvider).register(
              email: email,
              username: username,
              password: password,
            ),
      );

  /// Logs out the current user.
  Future<bool> logout() async {
    talker.log('[认证状态] logout() 已调用');
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.logout();

    result.when<void>(
      failure: (f) {
        talker.error('[认证状态] logout() 失败: ${f.message}');
      },
      success: (_) {
        talker.log('[认证状态] logout() 成功');
        state = const AsyncValue.data(AuthState.unauthenticated());
      },
    );

    return !result.isFailure;
  }

  /// Gets the current user.
  User? get currentUser => state.value?.user;

  /// Checks if the user is authenticated.
  bool get isAuthenticated => state.value?.isAuthenticated ?? false;

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
  }) async =>
      _performLogin(
        () => ref.read(authRepositoryProvider).registerWithPhone(
              phoneNumber: phoneNumber,
              username: username,
              password: password,
              verificationCode: verificationCode,
              avatarUrl: avatarUrl,
            ),
      );

  /// Registers with email verification.
  Future<bool> registerWithEmail({
    required String email,
    required String username,
    required String password,
    required String verificationCode,
    String? avatarUrl,
  }) async =>
      _performLogin(
        () => ref.read(authRepositoryProvider).registerWithEmail(
              email: email,
              username: username,
              password: password,
              verificationCode: verificationCode,
              avatarUrl: avatarUrl,
            ),
      );

  /// Updates user profile.
  Future<bool> updateUserProfile({
    String? displayName,
    String? avatarUrl,
    String? phoneNumber,
    UserGender? gender,
  }) async {
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.updateUserProfile(
      displayName: displayName,
      avatarUrl: avatarUrl,
      phoneNumber: phoneNumber,
      gender: gender,
    );

    return result.when(
      failure: (_) => false,
      success: (user) {
        final token = ref.read(authLocalDataSourceProvider).getToken() ?? '';
        state = AsyncValue.data(
          AuthState.authenticated(user: user, token: token),
        );
        return true;
      },
    );
  }

  /// Helper method to perform login operations with consistent state handling.
  Future<bool> _performLogin(
    Future<Result<User>> Function() loginAction,
  ) async {
    state = const AsyncValue.loading();

    final result = await loginAction();

    state = result.when<AsyncValue<AuthState>>(
      failure: (Failure f) =>
          AsyncValue<AuthState>.error(f, StackTrace.current),
      success: (User user) => AsyncValue<AuthState>.data(
        AuthState.authenticated(
          user: user,
          token: ref.read(authLocalDataSourceProvider).getToken() ?? '',
        ),
      ),
    );

    return !state.hasError;
  }
}
