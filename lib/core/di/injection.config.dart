// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/auth/data/datasources/auth_local_data_source.dart'
    as _i852;
import '../../features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/chat/data/datasources/chat_local_data_source.dart'
    as _i94;
import '../../features/chat/data/repositories/chat_repository_impl.dart'
    as _i504;
import '../../features/chat/domain/repositories/chat_repository.dart' as _i420;
import '../../features/home/data/datasources/home_local_data_source.dart'
    as _i299;
import '../../features/home/data/datasources/home_remote_data_source.dart'
    as _i362;
import '../../features/home/data/repositories/home_repository_impl.dart'
    as _i76;
import '../../features/home/domain/repositories/home_repository.dart' as _i0;
import '../../features/privacy/data/datasources/privacy_local_data_source.dart'
    as _i56;
import '../../features/privacy/data/repositories/privacy_repository_impl.dart'
    as _i40;
import '../../features/privacy/data/services/account_service_mock.dart'
    as _i495;
import '../../features/privacy/domain/repositories/privacy_repository.dart'
    as _i1058;
import '../../features/settings/data/datasources/developer_options_local_data_source.dart'
    as _i174;
import '../../features/settings/data/datasources/settings_local_data_source.dart'
    as _i599;
import '../../features/settings/data/repositories/developer_options_repository_impl.dart'
    as _i282;
import '../../features/settings/data/repositories/settings_repository_impl.dart'
    as _i955;
import '../../features/settings/domain/repositories/developer_options_repository.dart'
    as _i29;
import '../../features/settings/domain/repositories/settings_repository.dart'
    as _i674;
import '../../features/webview/data/datasources/webview_cookie_data_source.dart'
    as _i537;
import '../../features/webview/data/datasources/webview_file_data_source.dart'
    as _i118;
import '../../features/webview/data/datasources/webview_local_storage_data_source.dart'
    as _i529;
import '../../features/webview/data/repositories/webview_repository_impl.dart'
    as _i342;
import '../../features/webview/domain/repositories/webview_repository.dart'
    as _i838;
import '../network/dio_client.dart' as _i667;
import '../storage/database.dart' as _i47;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i667.DioClient>(() => _i667.DioClient());
    gh.lazySingleton<_i47.AppDatabase>(() => _i47.AppDatabase());
    gh.lazySingleton<_i495.AccountServiceMock>(
        () => _i495.AccountServiceMock());
    gh.lazySingleton<_i107.AuthRemoteDataSource>(
        () => _i107.AuthRemoteDataSource());
    gh.lazySingleton<_i537.WebViewCookieDataSource>(
        () => _i537.WebViewCookieDataSource());
    gh.lazySingleton<_i118.WebViewFileDataSource>(
        () => _i118.WebViewFileDataSource());
    gh.lazySingleton<_i299.HomeLocalDataSource>(
        () => _i299.HomeLocalDataSourceImpl());
    gh.lazySingleton<_i94.ChatLocalDataSource>(
        () => _i94.ChatLocalDataSourceImpl(gh<_i47.AppDatabase>()));
    gh.lazySingleton<_i362.HomeRemoteDataSource>(
        () => _i362.HomeRemoteDataSourceImpl());
    gh.lazySingleton<_i420.ChatRepository>(
        () => _i504.ChatRepositoryImpl(gh<_i94.ChatLocalDataSource>()));
    gh.lazySingleton<_i599.SettingsLocalDataSource>(() =>
        _i599.SettingsLocalDataSource(
            sharedPreferences: gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i174.DeveloperOptionsLocalDataSource>(() =>
        _i174.DeveloperOptionsLocalDataSource(
            sharedPreferences: gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i56.PrivacyLocalDataSource>(() =>
        _i56.PrivacyLocalDataSource(
            sharedPreferences: gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i852.AuthLocalDataSource>(() => _i852.AuthLocalDataSource(
        sharedPreferences: gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i529.WebViewLocalStorageDataSource>(() =>
        _i529.WebViewLocalStorageDataSource(
            sharedPreferences: gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i787.AuthRepository>(() => _i153.AuthRepositoryImpl(
          remoteDataSource: gh<_i107.AuthRemoteDataSource>(),
          localDataSource: gh<_i852.AuthLocalDataSource>(),
        ));
    gh.lazySingleton<_i29.DeveloperOptionsRepository>(
        () => _i282.DeveloperOptionsRepositoryImpl(
              localDataSource: gh<_i174.DeveloperOptionsLocalDataSource>(),
              database: gh<_i47.AppDatabase>(),
            ));
    gh.lazySingleton<_i1058.PrivacyRepository>(() => _i40.PrivacyRepositoryImpl(
          localDataSource: gh<_i56.PrivacyLocalDataSource>(),
          accountService: gh<_i495.AccountServiceMock>(),
        ));
    gh.lazySingleton<_i674.SettingsRepository>(() =>
        _i955.SettingsRepositoryImpl(
            localDataSource: gh<_i599.SettingsLocalDataSource>()));
    gh.lazySingleton<_i0.HomeRepository>(() => _i76.HomeRepositoryImpl(
          remoteDataSource: gh<_i362.HomeRemoteDataSource>(),
          localDataSource: gh<_i299.HomeLocalDataSource>(),
        ));
    gh.lazySingleton<_i838.WebViewRepository>(() => _i342.WebViewRepositoryImpl(
          cookieDataSource: gh<_i537.WebViewCookieDataSource>(),
          fileDataSource: gh<_i118.WebViewFileDataSource>(),
          localStorageDataSource: gh<_i529.WebViewLocalStorageDataSource>(),
        ));
    return this;
  }
}
