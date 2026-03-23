/// 聊天仓库 Provider。
///
/// 提供 ChatRepository 的依赖注入配置。
library;

import 'package:flutter_project_template/core/storage/database_provider.dart';
import 'package:flutter_project_template/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:flutter_project_template/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:flutter_project_template/features/chat/domain/repositories/chat_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_repository_provider.g.dart';

/// 聊天本地数据源 Provider。
@riverpod
ChatLocalDataSource chatLocalDataSource(Ref ref) {
  final database = ref.watch(databaseProvider);
  return ChatLocalDataSourceImpl(database);
}

/// 聊天仓库 Provider。
@riverpod
ChatRepository chatRepository(Ref ref) {
  final localDataSource = ref.watch(chatLocalDataSourceProvider);
  return ChatRepositoryImpl(localDataSource);
}