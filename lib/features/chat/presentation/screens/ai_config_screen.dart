/// AI configuration screen for managing AI models and API keys.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/features/chat/presentation/providers/ai_config_provider.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_project_template/shared/widgets/settings_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// AI configuration screen.
class AIConfigScreen extends ConsumerWidget {
  /// Creates the AI configuration screen.
  const AIConfigScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final configsAsync = ref.watch(aIConfigNotifierProvider);

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text(localizations.aiConfiguration),
      ),
      body: configsAsync.when(
        data: (state) => _buildContent(
          context,
          ref,
          localizations,
          colorScheme,
          state.configs,
          state.defaultConfig,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('${localizations.error}: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddConfigDialog(context, ref, localizations),
        backgroundColor: AppIconColors.aiColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
    ColorScheme colorScheme,
    List<AIConfigEntity> configs,
    AIConfigEntity? defaultConfig,
  ) {
    if (configs.isEmpty) {
      return _buildEmptyState(context, localizations, colorScheme);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: configs.length,
      itemBuilder: (context, index) {
        final config = configs[index];
        final isDefault = config.id == defaultConfig?.id;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildConfigCard(
            context,
            ref,
            localizations,
            colorScheme,
            config,
            isDefault,
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    AppLocalizations localizations,
    ColorScheme colorScheme,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppIconColors.aiBgColor,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.smart_toy_outlined,
              size: 40,
              color: AppIconColors.aiColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            localizations.noAIConfig,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            localizations.addAIConfigHint,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConfigCard(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
    ColorScheme colorScheme,
    AIConfigEntity config,
    bool isDefault,
  ) {
    return SettingsCard(
      colorScheme: colorScheme,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppIconColors.aiColor.withValues(alpha: 0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppIconColors.aiBgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getProviderIcon(config.provider),
                    size: 22,
                    color: AppIconColors.aiColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        config.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        _getModelDisplayName(config.provider, config.model),
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isDefault)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppIconColors.aiColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      localizations.defaultLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Actions
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isDefault)
                  TextButton.icon(
                    onPressed: () => _setDefault(ref, config.id),
                    icon: const Icon(Icons.star_outline, size: 18),
                    label: Text(localizations.setAsDefault),
                    style: TextButton.styleFrom(
                      foregroundColor: AppIconColors.aiColor,
                    ),
                  ),
                TextButton.icon(
                  onPressed: () => _showDeleteConfirmDialog(
                    context,
                    ref,
                    localizations,
                    config,
                  ),
                  icon: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: colorScheme.error,
                  ),
                  label: Text(
                    localizations.delete,
                    style: TextStyle(
                      color: colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getProviderIcon(String provider) {
    switch (provider) {
      case 'openai':
        return Icons.auto_awesome;
      case 'claude':
        return Icons.psychology;
      default:
        return Icons.smart_toy;
    }
  }

  String _getModelDisplayName(String provider, String model) {
    final models = {
      'openai': {
        'gpt-4o': 'GPT-4o',
        'gpt-4o-mini': 'GPT-4o Mini',
        'gpt-4-turbo': 'GPT-4 Turbo',
      },
      'claude': {
        'claude-3-5-sonnet-20241022': 'Claude 3.5 Sonnet',
        'claude-3-5-haiku-20241022': 'Claude 3.5 Haiku',
      },
    };
    return models[provider]?[model] ?? model;
  }

  Future<void> _setDefault(WidgetRef ref, String configId) async {
    await ref.read(aIConfigNotifierProvider.notifier).setDefault(configId);
  }

  void _showAddConfigDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _AddConfigSheet(
        localizations: localizations,
      ),
    );
  }

  void _showDeleteConfirmDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
    AIConfigEntity config,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(localizations.deleteConfig),
        content: Text(localizations.deleteConfigConfirm(config.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(localizations.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ref
                  .read(aIConfigNotifierProvider.notifier)
                  .deleteConfig(config.id);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(localizations.delete),
          ),
        ],
      ),
    );
  }
}

/// Add configuration bottom sheet.
class _AddConfigSheet extends ConsumerStatefulWidget {
  /// Creates the add config sheet.
  const _AddConfigSheet({
    required this.localizations,
  });

  final AppLocalizations localizations;

  @override
  ConsumerState<_AddConfigSheet> createState() => _AddConfigSheetState();
}

class _AddConfigSheetState extends ConsumerState<_AddConfigSheet> {
  final _nameController = TextEditingController();
  final _apiKeyController = TextEditingController();
  String _selectedProvider = 'openai';
  String _selectedModel = 'gpt-4o';
  bool _isLoading = false;
  String? _error;
  bool _obscureApiKey = true;

  @override
  void dispose() {
    _nameController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final models = ref.watch(availableModelsProvider);
    final selectedProviderInfo = models.firstWhere(
      (m) => m.provider == _selectedProvider,
      orElse: () => models.first,
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              widget.localizations.addAIConfig,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            // Provider selection
            Text(
              widget.localizations.provider,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            _buildProviderSelector(models, colorScheme),
            const SizedBox(height: 16),
            // Model selection
            Text(
              widget.localizations.model,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            _buildModelSelector(selectedProviderInfo, colorScheme),
            const SizedBox(height: 16),
            // Name input
            Text(
              widget.localizations.configName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: widget.localizations.configNameHint,
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // API Key input
            Text(
              widget.localizations.apiKey,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _apiKeyController,
              obscureText: _obscureApiKey,
              decoration: InputDecoration(
                hintText: widget.localizations.apiKeyHint,
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureApiKey ? Icons.visibility_off : Icons.visibility,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureApiKey = !_obscureApiKey;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            // API Key help text
            Text(
              _selectedProvider == 'openai'
                  ? widget.localizations.openAIKeyHelp
                  : widget.localizations.claudeKeyHelp,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            // Error message
            if (_error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline,
                        color: colorScheme.error, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style:
                            TextStyle(color: colorScheme.error, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            // Save button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _isLoading ? null : _saveConfig,
                style: FilledButton.styleFrom(
                  backgroundColor: AppIconColors.aiColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(widget.localizations.save),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderSelector(
      List<AIModelInfo> models, ColorScheme colorScheme) {
    return Wrap(
      spacing: 8,
      children: models.map((provider) {
        final isSelected = provider.provider == _selectedProvider;
        return ChoiceChip(
          label: Text(provider.providerDisplayName),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedProvider = provider.provider;
                _selectedModel = provider.models.first.id;
              });
            }
          },
          selectedColor: AppIconColors.aiColor.withValues(alpha: 0.2),
          backgroundColor: colorScheme.surfaceContainerHighest,
          labelStyle: TextStyle(
            color: isSelected ? AppIconColors.aiColor : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          side: BorderSide(
            color: isSelected ? AppIconColors.aiColor : colorScheme.outline,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildModelSelector(
      AIModelInfo providerInfo, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedModel,
          isExpanded: true,
          items: providerInfo.models.map((model) {
            return DropdownMenuItem(
              value: model.id,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    model.name,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (model.description != null)
                    Text(
                      model.description!,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedModel = value;
              });
            }
          },
        ),
      ),
    );
  }

  Future<void> _saveConfig() async {
    final name = _nameController.text.trim();
    final apiKey = _apiKeyController.text.trim();

    if (name.isEmpty) {
      setState(() => _error = widget.localizations.nameRequired);
      return;
    }

    if (apiKey.isEmpty) {
      setState(() => _error = widget.localizations.apiKeyRequired);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final config =
          await ref.read(aIConfigNotifierProvider.notifier).addConfig(
                name: name,
                provider: _selectedProvider,
                model: _selectedModel,
                apiKey: apiKey,
                isDefault: true,
              );

      if (config != null) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.localizations.configSaved),
              backgroundColor: AppIconColors.aiColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        setState(() {
          _error = widget.localizations.invalidApiKey;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
