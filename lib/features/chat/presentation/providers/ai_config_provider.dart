/// AI configuration provider using Riverpod code generation.
library;

import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_project_template/core/storage/database.dart';
import 'package:flutter_project_template/features/chat/data/services/ai_service.dart';
import 'package:flutter_project_template/features/chat/data/services/claude_service.dart';
import 'package:flutter_project_template/features/chat/data/services/openai_service.dart';
import 'package:flutter_project_template/features/chat/data/services/universal_ai_service.dart';
import 'package:flutter_project_template/features/chat/presentation/providers/chat_repository_provider.dart';
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
    required this.models,
    required this.defaultModel,
    required this.apiKeyEncrypted,
    this.isDefault = false,
    this.baseUrl,
    this.apiFormat = 'openai',
    this.configJson,
    this.createdAt,
    this.updatedAt,
  });

  /// Unique identifier.
  final String id;

  /// Display name.
  final String name;

  /// Provider name (openai, claude, custom).
  final String provider;

  /// Model identifiers list.
  final List<String> models;

  /// Default model identifier.
  final String defaultModel;

  /// Encrypted API key reference.
  final String apiKeyEncrypted;

  /// Whether this is the default config.
  final bool isDefault;

  /// Custom API endpoint URL (for custom providers).
  final String? baseUrl;

  /// API format type: 'openai' or 'claude' (for custom providers).
  final String apiFormat;

  /// Additional configuration JSON.
  final String? configJson;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Last update timestamp.
  final DateTime? updatedAt;

  /// Checks if a model is in the models list.
  bool hasModel(String modelId) => models.contains(modelId);

  /// Gets the default model or first model if default is not set.
  String get currentModel {
    if (models.contains(defaultModel)) return defaultModel;
    return models.isNotEmpty ? models.first : '';
  }

  /// Creates a copy with updated fields.
  AIConfigEntity copyWith({
    String? id,
    String? name,
    String? provider,
    List<String>? models,
    String? defaultModel,
    String? apiKeyEncrypted,
    bool? isDefault,
    String? baseUrl,
    String? apiFormat,
    String? configJson,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AIConfigEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      provider: provider ?? this.provider,
      models: models ?? this.models,
      defaultModel: defaultModel ?? this.defaultModel,
      apiKeyEncrypted: apiKeyEncrypted ?? this.apiKeyEncrypted,
      isDefault: isDefault ?? this.isDefault,
      baseUrl: baseUrl ?? this.baseUrl,
      apiFormat: apiFormat ?? this.apiFormat,
      configJson: configJson ?? this.configJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
}

/// Provider for secure storage.
@riverpod
FlutterSecureStorage secureStorage(Ref ref) => const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

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
  }) => AIConfigState(
      configs: configs ?? this.configs,
      defaultConfig: defaultConfig ?? this.defaultConfig,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
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
      defaultConfig: defaultConfig != null ? _toEntity(defaultConfig) : null,
    );
  }

  /// Adds a new AI configuration.
  Future<AIConfigEntity?> addConfig({
    required String name,
    required String provider,
    required List<String> models,
    required String defaultModel,
    required String apiKey,
    bool isDefault = false,
    String? baseUrl,
    String apiFormat = 'openai',
  }) async {
    final currentState = state.value;
    if (currentState == null) return null;

    state = AsyncValue.data(currentState.copyWith(isLoading: true));

    try {
      // Validate API key first
      final isValid = await _validateApiKey(provider, apiKey,
          baseUrl: baseUrl, apiFormat: apiFormat,);
      if (!isValid) {
        state = AsyncValue.data(currentState.copyWith(
          error: 'Invalid API key',
          isLoading: false,
        ),);
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
        models: Value(jsonEncode(models)),
        defaultModel: Value(defaultModel),
        apiKeyEncrypted: Value(id), // Store ID reference
        isDefault: Value(isDefault),
        baseUrl: Value(baseUrl),
        apiFormat: Value(apiFormat),
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
      ),);
      return null;
    }
  }

  /// Updates an existing configuration.
  Future<void> updateConfig(AIConfigEntity config) async {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(isLoading: true));

    try {
      final localDataSource = ref.read(chatLocalDataSourceProvider);

      await localDataSource.upsertAIConfig(
        AIConfigsCompanion(
          id: Value(config.id),
          name: Value(config.name),
          provider: Value(config.provider),
          models: Value(jsonEncode(config.models)),
          defaultModel: Value(config.defaultModel),
          apiKeyEncrypted: Value(config.apiKeyEncrypted),
          isDefault: Value(config.isDefault),
          baseUrl: Value(config.baseUrl),
          apiFormat: Value(config.apiFormat),
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
      ),);
    }
  }

  /// Deletes a configuration.
  Future<void> deleteConfig(String id) async {
    final currentState = state.value;
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
      ),);
    }
  }

  /// Sets a configuration as default.
  Future<void> setDefault(String id) async {
    final localDataSource = ref.read(chatLocalDataSourceProvider);
    await localDataSource.setDefaultAIConfig(id);
    ref.invalidateSelf();
  }

  /// Adds a model to a configuration.
  Future<void> addModelToConfig(String configId, String modelId) async {
    final currentState = state.value;
    if (currentState == null) return;

    final config =
        currentState.configs.where((c) => c.id == configId).firstOrNull;
    if (config == null) return;

    if (config.models.contains(modelId)) return; // Already exists

    final updatedModels = [...config.models, modelId];
    await updateConfig(config.copyWith(models: updatedModels));
  }

  /// Removes a model from a configuration.
  Future<void> removeModelFromConfig(String configId, String modelId) async {
    final currentState = state.value;
    if (currentState == null) return;

    final config =
        currentState.configs.where((c) => c.id == configId).firstOrNull;
    if (config == null) return;

    if (config.models.length <= 1) return; // Must have at least one model

    final updatedModels = config.models.where((m) => m != modelId).toList();
    final updatedDefaultModel = config.defaultModel == modelId
        ? updatedModels.first
        : config.defaultModel;

    await updateConfig(config.copyWith(
      models: updatedModels,
      defaultModel: updatedDefaultModel,
    ),);
  }

  /// Sets the default model for a configuration.
  Future<void> setDefaultModel(String configId, String modelId) async {
    final currentState = state.value;
    if (currentState == null) return;

    final config =
        currentState.configs.where((c) => c.id == configId).firstOrNull;
    if (config == null) return;

    if (!config.models.contains(modelId)) return;

    await updateConfig(config.copyWith(defaultModel: modelId));
  }

  /// Gets the decrypted API key for a configuration.
  Future<String?> getDecryptedApiKey(String configId) async {
    final secureStorage = ref.read(secureStorageProvider);
    return secureStorage.read(key: 'ai_api_key_$configId');
  }

  Future<bool> _validateApiKey(
    String provider,
    String apiKey, {
    String? baseUrl,
    String apiFormat = 'openai',
  }) async {
    final AIService service;
    switch (provider) {
      case 'openai':
        service = OpenAIService();
      case 'claude':
        service = ClaudeService();
      case 'custom':
        if (baseUrl == null) return false;
        service = UniversalAIService(
          baseUrl: baseUrl,
          apiFormat:
              apiFormat == 'claude' ? APIFormat.claude : APIFormat.openai,
        );
      default:
        return false;
    }
    try {
      return await service.validateApiKey(apiKey);
    } finally {
      service.dispose();
    }
  }

  List<AIConfigEntity> _toEntities(List<AIConfig> configs) => configs.map(_toEntity).toList();

  AIConfigEntity _toEntity(AIConfig config) {
    // Parse models from JSON
    List<String> modelsList;
    try {
      final decoded = jsonDecode(config.models) as List<dynamic>;
      modelsList = decoded.cast<String>();
    } catch (_) {
      // Fallback: treat as single model
      modelsList = [config.models];
    }

    return AIConfigEntity(
      id: config.id,
      name: config.name,
      provider: config.provider,
      models: modelsList,
      defaultModel: config.defaultModel,
      apiKeyEncrypted: config.apiKeyEncrypted,
      isDefault: config.isDefault,
      baseUrl: config.baseUrl,
      apiFormat: config.apiFormat,
      configJson: config.configJson,
      createdAt: config.createdAt,
      updatedAt: config.updatedAt,
    );
  }
}

/// Provider for available AI models.
@riverpod
List<AIModelInfo> availableModels(Ref ref) => [
    const AIModelInfo(
      provider: 'openai',
      providerDisplayName: 'OpenAI',
      models: [
        ModelInfo(
            id: 'gpt-4o', name: 'GPT-4o', description: 'Most capable model',),
        ModelInfo(
            id: 'gpt-4o-mini',
            name: 'GPT-4o Mini',
            description: 'Fast and affordable',),
        ModelInfo(
            id: 'gpt-4-turbo',
            name: 'GPT-4 Turbo',
            description: 'Previous flagship',),
      ],
    ),
    const AIModelInfo(
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
    const AIModelInfo(
      provider: 'custom',
      providerDisplayName: 'Custom',
      models: [], // Custom providers have user-defined models
    ),
  ];

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
