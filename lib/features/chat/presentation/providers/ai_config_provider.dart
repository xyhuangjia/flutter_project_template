/// AI configuration provider using Riverpod code generation.
library;

import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_project_template/core/storage/database.dart';
import 'package:flutter_project_template/features/chat/data/services/ai_service.dart';
import 'package:flutter_project_template/features/chat/data/services/claude_service.dart';
import 'package:flutter_project_template/features/chat/data/services/openai_service.dart';
import 'package:flutter_project_template/features/chat/presentation/providers/chat_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_config_provider.g.dart';

/// AI configuration entity for domain layer.
class AIConfigEntity {
  /// Creates an AI config entity.
  const AIConfigEntity({
    required this.id,
    required this.name,
    required this.provider,
    required this.model,
    required this.apiKeyEncrypted,
    this.isDefault = false,
    this.configJson,
    this.createdAt,
    this.updatedAt,
  });

  /// Unique identifier.
  final String id;

  /// Display name.
  final String name;

  /// Provider name (openai, claude).
  final String provider;

  /// Model identifier.
  final String model;

  /// Encrypted API key reference.
  final String apiKeyEncrypted;

  /// Whether this is the default config.
  final bool isDefault;

  /// Additional configuration JSON.
  final String? configJson;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Last update timestamp.
  final DateTime? updatedAt;

  /// Creates a copy with updated fields.
  AIConfigEntity copyWith({
    String? id,
    String? name,
    String? provider,
    String? model,
    String? apiKeyEncrypted,
    bool? isDefault,
    String? configJson,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AIConfigEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      provider: provider ?? this.provider,
      model: model ?? this.model,
      apiKeyEncrypted: apiKeyEncrypted ?? this.apiKeyEncrypted,
      isDefault: isDefault ?? this.isDefault,
      configJson: configJson ?? this.configJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Provider for secure storage.
@riverpod
FlutterSecureStorage secureStorage(SecureStorageRef ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
}

/// AI configuration state.
class AIConfigState {
  /// Creates an AI config state.
  const AIConfigState({
    this.configs = const [],
    this.defaultConfig,
    this.isLoading = false,
    this.error,
  });

  /// All AI configurations.
  final List<AIConfigEntity> configs;

  /// Default configuration.
  final AIConfigEntity? defaultConfig;

  /// Loading state.
  final bool isLoading;

  /// Error message.
  final String? error;

  /// Creates a copy with updated fields.
  AIConfigState copyWith({
    List<AIConfigEntity>? configs,
    AIConfigEntity? defaultConfig,
    bool? isLoading,
    String? error,
  }) {
    return AIConfigState(
      configs: configs ?? this.configs,
      defaultConfig: defaultConfig ?? this.defaultConfig,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Provider for AI configuration management.
@riverpod
class AIConfigNotifier extends _$AIConfigNotifier {
  @override
  Future<AIConfigState> build() async {
    final localDataSource = ref.read(chatLocalDataSourceProvider);
    final configs = await localDataSource.getAllAIConfigs();
    final defaultConfig = configs.where((c) => c.isDefault).firstOrNull;

    return AIConfigState(
      configs: _toEntities(configs),
      defaultConfig: defaultConfig != null
          ? _toEntity(defaultConfig)
          : null,
    );
  }

  /// Adds a new AI configuration.
  Future<AIConfigEntity?> addConfig({
    required String name,
    required String provider,
    required String model,
    required String apiKey,
    bool isDefault = false,
  }) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return null;

    state = AsyncValue.data(currentState.copyWith(isLoading: true));

    try {
      // Validate API key first
      final isValid = await _validateApiKey(provider, apiKey);
      if (!isValid) {
        state = AsyncValue.data(currentState.copyWith(
          error: 'Invalid API key',
          isLoading: false,
        ));
        return null;
      }

      final localDataSource = ref.read(chatLocalDataSourceProvider);
      final secureStorage = ref.read(secureStorageProvider);

      // Generate ID
      final id = DateTime.now().millisecondsSinceEpoch.toString();

      // Store API key securely
      await secureStorage.write(key: 'ai_api_key_$id', value: apiKey);

      // Save config to database (without the actual API key)
      final config = AIConfigsCompanion(
        id: Value(id),
        name: Value(name),
        provider: Value(provider),
        model: Value(model),
        apiKeyEncrypted: Value(id), // Store ID reference
        isDefault: Value(isDefault),
        updatedAt: Value(DateTime.now()),
      );

      await localDataSource.upsertAIConfig(config);

      if (isDefault) {
        await localDataSource.setDefaultAIConfig(id);
      }

      // Refresh state
      ref.invalidateSelf();
      final newConfig = await localDataSource.getAIConfigById(id);
      return newConfig != null ? _toEntity(newConfig) : null;
    } catch (e) {
      state = AsyncValue.data(currentState.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
      return null;
    }
  }

  /// Updates an existing configuration.
  Future<void> updateConfig(AIConfigEntity config) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(isLoading: true));

    try {
      final localDataSource = ref.read(chatLocalDataSourceProvider);

      await localDataSource.upsertAIConfig(
        AIConfigsCompanion(
          id: Value(config.id),
          name: Value(config.name),
          provider: Value(config.provider),
          model: Value(config.model),
          apiKeyEncrypted: Value(config.apiKeyEncrypted),
          isDefault: Value(config.isDefault),
          updatedAt: Value(DateTime.now()),
        ),
      );

      if (config.isDefault) {
        await localDataSource.setDefaultAIConfig(config.id);
      }

      ref.invalidateSelf();
    } catch (e) {
      state = AsyncValue.data(currentState.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  /// Deletes a configuration.
  Future<void> deleteConfig(String id) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(isLoading: true));

    try {
      final localDataSource = ref.read(chatLocalDataSourceProvider);
      final secureStorage = ref.read(secureStorageProvider);

      // Delete from secure storage
      await secureStorage.delete(key: 'ai_api_key_$id');

      // Delete from database
      await localDataSource.deleteAIConfig(id);

      ref.invalidateSelf();
    } catch (e) {
      state = AsyncValue.data(currentState.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  /// Sets a configuration as default.
  Future<void> setDefault(String id) async {
    final localDataSource = ref.read(chatLocalDataSourceProvider);
    await localDataSource.setDefaultAIConfig(id);
    ref.invalidateSelf();
  }

  /// Gets the decrypted API key for a configuration.
  Future<String?> getDecryptedApiKey(String configId) async {
    final secureStorage = ref.read(secureStorageProvider);
    return secureStorage.read(key: 'ai_api_key_$configId');
  }

  Future<bool> _validateApiKey(String provider, String apiKey) async {
    final AIService service;
    switch (provider) {
      case 'openai':
        service = OpenAIService();
      case 'claude':
        service = ClaudeService();
      default:
        return false;
    }
    try {
      return service.validateApiKey(apiKey);
    } finally {
      service.dispose();
    }
  }

  List<AIConfigEntity> _toEntities(List<AIConfig> configs) {
    return configs.map(_toEntity).toList();
  }

  AIConfigEntity _toEntity(AIConfig config) {
    return AIConfigEntity(
      id: config.id,
      name: config.name,
      provider: config.provider,
      model: config.model,
      apiKeyEncrypted: config.apiKeyEncrypted,
      isDefault: config.isDefault,
      configJson: config.configJson,
      createdAt: config.createdAt,
      updatedAt: config.updatedAt,
    );
  }
}

/// Provider for available AI models.
@riverpod
List<AIModelInfo> availableModels(AvailableModelsRef ref) {
  return [
    AIModelInfo(
      provider: 'openai',
      providerDisplayName: 'OpenAI',
      models: [
        ModelInfo(id: 'gpt-4o', name: 'GPT-4o', description: 'Most capable model'),
        ModelInfo(id: 'gpt-4o-mini', name: 'GPT-4o Mini', description: 'Fast and affordable'),
        ModelInfo(id: 'gpt-4-turbo', name: 'GPT-4 Turbo', description: 'Previous flagship'),
      ],
    ),
    AIModelInfo(
      provider: 'claude',
      providerDisplayName: 'Claude (Anthropic)',
      models: [
        ModelInfo(
          id: 'claude-3-5-sonnet-20241022',
          name: 'Claude 3.5 Sonnet',
          description: 'Best balance of intelligence and speed',
        ),
        ModelInfo(
          id: 'claude-3-5-haiku-20241022',
          name: 'Claude 3.5 Haiku',
          description: 'Fastest and most compact',
        ),
      ],
    ),
  ];
}

/// AI model information.
class AIModelInfo {
  /// Creates AI model info.
  const AIModelInfo({
    required this.provider,
    required this.providerDisplayName,
    required this.models,
  });

  /// Provider identifier.
  final String provider;

  /// Display name for the provider.
  final String providerDisplayName;

  /// Available models.
  final List<ModelInfo> models;
}

/// Individual model information.
class ModelInfo {
  /// Creates model info.
  const ModelInfo({
    required this.id,
    required this.name,
    this.description,
  });

  /// Model identifier.
  final String id;

  /// Display name.
  final String name;

  /// Model description.
  final String? description;
}
