/// Permission card widget for showing permission rationale.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

/// Permission type enum.
enum PermissionType {
  /// Camera permission.
  camera,

  /// Photo library permission.
  photoLibrary,

  /// Location permission.
  location,

  /// Notification permission.
  notification,
}

/// Permission card widget for showing rationale before requesting permission.
class PermissionCard extends StatelessWidget {
  /// Creates a permission card.
  const PermissionCard({
    required this.permissionType,
    required this.onRequest,
    super.key,
    this.onSkip,
  });

  /// The type of permission.
  final PermissionType permissionType;

  /// Callback when request button is tapped.
  final VoidCallback? onRequest;

  /// Callback when skip button is tapped.
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIcon(),
                    color: theme.colorScheme.onPrimaryContainer,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getTitle(localizations),
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getSubtitle(localizations),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _getDescription(localizations),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onSkip != null) ...[
                  TextButton(
                    onPressed: onSkip,
                    child: Text(localizations.skip),
                  ),
                  const SizedBox(width: 8),
                ],
                FilledButton.icon(
                  onPressed: onRequest,
                  icon: const Icon(Icons.check, size: 18),
                  label: Text(localizations.grantPermission),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (permissionType) {
      case PermissionType.camera:
        return Icons.camera_alt;
      case PermissionType.photoLibrary:
        return Icons.photo_library;
      case PermissionType.location:
        return Icons.location_on;
      case PermissionType.notification:
        return Icons.notifications;
    }
  }

  String _getTitle(AppLocalizations localizations) {
    switch (permissionType) {
      case PermissionType.camera:
        return localizations.cameraPermissionTitle;
      case PermissionType.photoLibrary:
        return localizations.photoLibraryPermissionTitle;
      case PermissionType.location:
        return localizations.locationPermissionTitle;
      case PermissionType.notification:
        return localizations.notificationPermissionTitle;
    }
  }

  String _getSubtitle(AppLocalizations localizations) {
    switch (permissionType) {
      case PermissionType.camera:
        return localizations.cameraPermissionSubtitle;
      case PermissionType.photoLibrary:
        return localizations.photoLibraryPermissionSubtitle;
      case PermissionType.location:
        return localizations.locationPermissionSubtitle;
      case PermissionType.notification:
        return localizations.notificationPermissionSubtitle;
    }
  }

  String _getDescription(AppLocalizations localizations) {
    switch (permissionType) {
      case PermissionType.camera:
        return localizations.cameraPermissionDescription;
      case PermissionType.photoLibrary:
        return localizations.photoLibraryPermissionDescription;
      case PermissionType.location:
        return localizations.locationPermissionDescription;
      case PermissionType.notification:
        return localizations.notificationPermissionDescription;
    }
  }
}

/// Permission helper for handling permission requests.
class PermissionHelper {
  /// Gets the permission object for a permission type.
  static Permission getPermission(PermissionType type) {
    switch (type) {
      case PermissionType.camera:
        return Permission.camera;
      case PermissionType.photoLibrary:
        return Permission.photos;
      case PermissionType.location:
        return Permission.location;
      case PermissionType.notification:
        return Permission.notification;
    }
  }

  /// Requests a permission with rationale.
  static Future<PermissionStatus> requestWithRationale(
    PermissionType type,
  ) async {
    final permission = getPermission(type);
    return permission.request();
  }

  /// Checks if a permission is granted.
  static Future<bool> isGranted(PermissionType type) async {
    final permission = getPermission(type);
    final status = await permission.status;
    return status.isGranted;
  }

  /// Checks if a permission is permanently denied.
  static Future<bool> isPermanentlyDenied(PermissionType type) async {
    final permission = getPermission(type);
    final status = await permission.status;
    return status.isPermanentlyDenied;
  }

  /// Opens app settings.
  static Future<bool> openSettings() {
    return openAppSettings();
  }
}
