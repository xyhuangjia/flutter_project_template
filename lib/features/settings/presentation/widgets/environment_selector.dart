/// Environment selector widget.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/core/config/environment.dart';
import 'package:flutter_project_template/core/config/environment_provider.dart'
    as env;
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Environment option for the selector.
class EnvironmentOption {
  /// Creates an environment option.
  const EnvironmentOption({
    required this.type,
    required this.name,
    this.description,
  });

  /// The environment type.
  final EnvironmentType type;

  /// The display name.
  final String name;

  /// Optional description.
  final String? description;
}

/// Environment selector widget.
class EnvironmentSelector extends ConsumerWidget {
  /// Creates an environment selector.
  const EnvironmentSelector({
    required this.onEnvironmentChanged,
    super.key,
    this.currentEnvironment,
    this.environments = const [
      EnvironmentOption(
        type: EnvironmentType.development,
        name: 'Development',
        description: 'Development environment with debug features',
      ),
      EnvironmentOption(
        type: EnvironmentType.staging,
        name: 'Staging',
        description: 'Staging environment for testing',
      ),
      EnvironmentOption(
        type: EnvironmentType.production,
        name: 'Production',
        description: 'Production environment',
      ),
    ],
  });

  /// Callback when environment is changed.
  final ValueChanged<EnvironmentType> onEnvironmentChanged;

  /// The currently selected environment type.
  final EnvironmentType? currentEnvironment;

  /// List of available environments.
  final List<EnvironmentOption> environments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currentEnv = ref.watch(env.environmentProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Current environment display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _getEnvironmentColor(currentEnv.type).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  _getEnvironmentColor(currentEnv.type).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                _getEnvironmentIcon(currentEnv.type),
                color: _getEnvironmentColor(currentEnv.type),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.currentEnvironment,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getEnvironmentName(currentEnv.type, localizations),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getEnvironmentColor(currentEnv.type),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getEnvironmentColor(currentEnv.type),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  currentEnv.baseUrl,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Environment options
        Text(
          localizations.selectEnvironment,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        ...environments.map(
          (e) => _EnvironmentOptionTile(
            option: e,
            isSelected: currentEnv.type == e.type,
            onTap: () => onEnvironmentChanged(e.type),
          ),
        ),
      ],
    );
  }

  String _getEnvironmentName(
    EnvironmentType type,
    AppLocalizations localizations,
  ) =>
      switch (type) {
        EnvironmentType.development => localizations.environmentDevelopment,
        EnvironmentType.staging => localizations.environmentStaging,
        EnvironmentType.production => localizations.environmentProduction,
      };

  Color _getEnvironmentColor(EnvironmentType type) => switch (type) {
        EnvironmentType.development => Colors.green,
        EnvironmentType.staging => Colors.orange,
        EnvironmentType.production => Colors.blue,
      };

  IconData _getEnvironmentIcon(EnvironmentType type) => switch (type) {
        EnvironmentType.development => Icons.code,
        EnvironmentType.staging => Icons.bug_report,
        EnvironmentType.production => Icons.cloud,
      };
}

class _EnvironmentOptionTile extends StatelessWidget {
  const _EnvironmentOptionTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final EnvironmentOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getName(option.type, localizations),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : null,
                    ),
                  ),
                  if (option.description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      option.description!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getName(EnvironmentType type, AppLocalizations localizations) =>
      switch (type) {
        EnvironmentType.development => localizations.environmentDevelopment,
        EnvironmentType.staging => localizations.environmentStaging,
        EnvironmentType.production => localizations.environmentProduction,
      };
}
