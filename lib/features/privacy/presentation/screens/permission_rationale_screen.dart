/// Permission rationale screen for explaining permissions.
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/features/privacy/presentation/widgets/permission_card.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

/// Permission rationale screen for explaining why permissions are needed.
class PermissionRationaleScreen extends StatefulWidget {
  /// Creates a permission rationale screen.
  const PermissionRationaleScreen({
    required this.permissionType, super.key,
    this.onGranted,
    this.onDenied,
  });

  /// The type of permission to explain.
  final PermissionType permissionType;

  /// Callback when permission is granted.
  final VoidCallback? onGranted;

  /// Callback when permission is denied.
  final VoidCallback? onDenied;

  @override
  State<PermissionRationaleScreen> createState() =>
      _PermissionRationaleScreenState();
}

class _PermissionRationaleScreenState extends State<PermissionRationaleScreen> {
  bool _isRequesting = false;

  Future<void> _requestPermission() async {
    setState(() => _isRequesting = true);

    try {
      final status =
          await PermissionHelper.requestWithRationale(widget.permissionType);

      if (!mounted) return;

      if (status.isGranted) {
        widget.onGranted?.call();
        Navigator.of(context).pop(true);
      } else if (status.isPermanentlyDenied) {
        _showPermanentlyDeniedDialog();
      } else {
        widget.onDenied?.call();
        Navigator.of(context).pop(false);
      }
    } finally {
      if (mounted) {
        setState(() => _isRequesting = false);
      }
    }
  }

  void _showPermanentlyDeniedDialog() {
    final localizations = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(localizations.permissionPermanentlyDeniedTitle),
        content: Text(localizations.permissionPermanentlyDeniedMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              widget.onDenied?.call();
              Navigator.of(context).pop(false);
            },
            child: Text(localizations.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await PermissionHelper.openSettings();
            },
            child: Text(localizations.openSettings),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(localizations)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PermissionCard(
                permissionType: widget.permissionType,
                onRequest: _isRequesting ? null : _requestPermission,
                onSkip: widget.onDenied != null
                    ? () {
                        widget.onDenied?.call();
                        Navigator.of(context).pop(false);
                      }
                    : null,
              ),
              if (_isRequesting) ...[
                const SizedBox(height: 24),
                const CircularProgressIndicator(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getTitle(AppLocalizations localizations) {
    switch (widget.permissionType) {
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
}

/// Shows a permission rationale screen as a dialog.
Future<bool> showPermissionRationale(
  BuildContext context, {
  required PermissionType permissionType,
  VoidCallback? onGranted,
  VoidCallback? onDenied,
}) async {
  final result = await Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder: (context) => PermissionRationaleScreen(
        permissionType: permissionType,
        onGranted: onGranted,
        onDenied: onDenied,
      ),
    ),
  );

  return result ?? false;
}
