/// Profile screen for user information management.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart' as pickers;
import 'package:flutter_pickers/style/default_style.dart';
import 'package:flutter_project_template/core/router/routes.dart';
import 'package:flutter_project_template/features/auth/domain/entities/auth_state.dart';
import 'package:flutter_project_template/features/auth/domain/entities/user.dart';
import 'package:flutter_project_template/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_project_template/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

/// Profile screen widget.
class ProfileScreen extends ConsumerStatefulWidget {
  /// Creates the profile screen.
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String? _avatarPath;

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() => _avatarPath = image.path);
      await _updateAvatar(image.path);
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() => _avatarPath = image.path);
      await _updateAvatar(image.path);
    }
  }

  void _showAvatarOptions() {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.photo_camera_outlined,
                color: theme.colorScheme.primary,
              ),
              title: Text(localizations.takePhoto),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo_library_outlined,
                color: theme.colorScheme.primary,
              ),
              title: Text(localizations.chooseFromGallery),
              onTap: () {
                Navigator.pop(context);
                _pickAvatar();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateAvatar(String path) async {
    await ref.read(authNotifierProvider.notifier).updateUserProfile(
          avatarUrl: path,
        );
  }

  Future<void> _updateNickname(String value) async {
    if (value.trim().isEmpty) return;
    await _updateProfile(displayName: value.trim());
  }

  Future<void> _updatePhone(String value) async {
    final phone = value.trim().isEmpty ? null : value.trim();
    await _updateProfile(phoneNumber: phone);
  }

  Future<void> _updateGender(UserGender gender) async {
    await _updateProfile(gender: gender);
  }

  Future<void> _updateProfile({
    String? displayName,
    String? avatarUrl,
    String? phoneNumber,
    UserGender? gender,
  }) async {
    final success =
        await ref.read(authNotifierProvider.notifier).updateUserProfile(
              displayName: displayName,
              avatarUrl: avatarUrl,
              phoneNumber: phoneNumber,
              gender: gender,
            );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.saveSuccess),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.operationFailed),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showNicknameDialog(User user) {
    final controller = TextEditingController(
      text: user.displayName ?? user.username,
    );
    final localizations = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.nickname),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: localizations.enterNickname,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _updateNickname(controller.text);
            },
            child: Text(localizations.save),
          ),
        ],
      ),
    );
  }

  void _showPhoneDialog(User user) {
    final controller = TextEditingController(text: user.phoneNumber ?? '');
    final localizations = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.phoneNumber),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: localizations.enterPhoneNumber,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _updatePhone(controller.text);
            },
            child: Text(localizations.save),
          ),
        ],
      ),
    );
  }

  void _showGenderDialog(User user) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final genderOptions = [
      localizations.male,
      localizations.female,
      localizations.unspecified,
    ];

    final genderValues = [
      UserGender.male,
      UserGender.female,
      UserGender.unspecified,
    ];

    final currentLabel = _getGenderLabel(user.gender, localizations);

    pickers.Pickers.showSinglePicker(
      context,
      data: genderOptions,
      selectData: currentLabel,
      pickerStyle: theme.brightness == Brightness.dark
          ? DefaultPickerStyle.dark()
          : DefaultPickerStyle(),
      onConfirm: (data, position) {
        _updateGender(genderValues[position]);
      },
    );
  }

  String _getGenderLabel(UserGender gender, AppLocalizations localizations) =>
      switch (gender) {
        UserGender.male => localizations.male,
        UserGender.female => localizations.female,
        UserGender.unspecified => localizations.unspecified,
      };

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(Routes.settings),
            tooltip: localizations.settings,
          ),
        ],
      ),
      body: authState.when(
        data: (state) => _buildContent(
          context,
          localizations,
          colorScheme,
          state,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('${localizations.error}: $error')),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations localizations,
    ColorScheme colorScheme,
    AuthState authState,
  ) {
    final user = authState.user;

    if (user == null) {
      return _buildNotLoggedInState(context, localizations, colorScheme);
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Avatar section
          GestureDetector(
            onTap: _showAvatarOptions,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: colorScheme.primaryContainer,
                    backgroundImage: _avatarPath != null
                        ? FileImage(File(_avatarPath!))
                        : (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
                            ? NetworkImage(user.avatarUrl!) as ImageProvider
                            : null,
                    child: (_avatarPath == null &&
                            (user.avatarUrl == null || user.avatarUrl!.isEmpty))
                        ? Icon(
                            Icons.person,
                            size: 44,
                            color: colorScheme.onPrimaryContainer,
                          )
                        : null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Info list
          _buildInfoList(user, localizations, colorScheme),
        ],
      ),
    );
  }

  Widget _buildNotLoggedInState(
    BuildContext context,
    AppLocalizations localizations,
    ColorScheme colorScheme,
  ) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 64,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              localizations.noAccount,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.push('/login'),
              icon: const Icon(Icons.login),
              label: Text(localizations.login),
            ),
          ],
        ),
      );

  Widget _buildInfoList(
    User user,
    AppLocalizations localizations,
    ColorScheme colorScheme,
  ) =>
      Column(
        children: [
          _buildEditableTile(
            icon: Icons.person_outline,
            label: localizations.nickname,
            value: user.displayName ?? user.username,
            colorScheme: colorScheme,
            onTap: () => _showNicknameDialog(user),
          ),
          _buildDivider(),
          _buildEditableTile(
            icon: Icons.phone_outlined,
            label: localizations.phoneNumber,
            value: user.phoneNumber ?? localizations.unspecified,
            colorScheme: colorScheme,
            onTap: () => _showPhoneDialog(user),
          ),
          _buildDivider(),
          _buildEditableTile(
            icon: Icons.wc_outlined,
            label: localizations.gender,
            value: _getGenderLabel(user.gender, localizations),
            colorScheme: colorScheme,
            onTap: () => _showGenderDialog(user),
          ),
          _buildDivider(),
          _buildEditableTile(
            icon: Icons.lock_outline,
            label: localizations.changePassword,
            value: '',
            colorScheme: colorScheme,
            onTap: () => context.push('/profile/change-password'),
          ),
          _buildDivider(),
        ],
      );

  Widget _buildEditableTile({
    required IconData icon,
    required String label,
    required String value,
    required ColorScheme colorScheme,
    required VoidCallback onTap,
  }) =>
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          value,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildDivider() => const Divider(height: 1, indent: 54);
}
