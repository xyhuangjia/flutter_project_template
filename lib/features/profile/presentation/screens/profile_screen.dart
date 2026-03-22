/// Profile screen with Chinese app style design.
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
import 'package:flutter_project_template/shared/widgets/settings_widgets.dart';
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
      backgroundColor: colorScheme.surfaceContainerLow,
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
        data: (state) => _ProfileContent(
          localizations: localizations,
          colorScheme: colorScheme,
          authState: state,
          avatarPath: _avatarPath,
          onAvatarTap: _showAvatarOptions,
          onNicknameTap: _showNicknameDialog,
          onPhoneTap: _showPhoneDialog,
          onGenderTap: _showGenderDialog,
        ),
        loading: () => _LoadingState(colorScheme: colorScheme),
        error: (error, _) => _ErrorState(
          localizations: localizations,
          colorScheme: colorScheme,
          error: error,
        ),
      ),
    );
  }
}

/// Loading state widget.
class _LoadingState extends StatelessWidget {
  const _LoadingState({
    required this.colorScheme,
  });

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) => Center(
        child: CircularProgressIndicator(color: colorScheme.primary),
      );
}

/// Error state widget.
class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.localizations,
    required this.colorScheme,
    required this.error,
  });

  final AppLocalizations localizations;
  final ColorScheme colorScheme;
  final Object error;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                '${localizations.error}: $error',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}

/// Profile content widget.
class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.localizations,
    required this.colorScheme,
    required this.authState,
    required this.avatarPath,
    required this.onAvatarTap,
    required this.onNicknameTap,
    required this.onPhoneTap,
    required this.onGenderTap,
  });

  final AppLocalizations localizations;
  final ColorScheme colorScheme;
  final AuthState authState;
  final String? avatarPath;
  final VoidCallback onAvatarTap;
  final void Function(User) onNicknameTap;
  final void Function(User) onPhoneTap;
  final void Function(User) onGenderTap;

  @override
  Widget build(BuildContext context) {
    final user = authState.user;

    if (user == null) {
      return _NotLoggedInState(
        localizations: localizations,
        colorScheme: colorScheme,
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Avatar card
          _AvatarCard(
            user: user,
            avatarPath: avatarPath,
            colorScheme: colorScheme,
            onTap: onAvatarTap,
          ),
          const SizedBox(height: 16),

          // Basic info section
          SectionTitle(
            title: localizations.profile,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 12),
          SettingsCard(
            colorScheme: colorScheme,
            children: [
              _ProfileTile(
                title: localizations.nickname,
                value: user.displayName ?? user.username,
                icon: Icons.person_outline,
                iconColor: AppIconColors.languageColor,
                iconBgColor: AppIconColors.languageBgColor,
                onTap: () => onNicknameTap(user),
              ),
              SettingsDivider(colorScheme: colorScheme),
              _ProfileTile(
                title: localizations.phoneNumber,
                value: user.phoneNumber ?? localizations.unspecified,
                icon: Icons.phone_outlined,
                iconColor: AppIconColors.phoneColor,
                iconBgColor: AppIconColors.phoneBgColor,
                onTap: () => onPhoneTap(user),
              ),
              SettingsDivider(colorScheme: colorScheme),
              _ProfileTile(
                title: localizations.gender,
                value: _getGenderLabel(user.gender, localizations),
                icon: Icons.wc_outlined,
                iconColor: AppIconColors.genderColor,
                iconBgColor: AppIconColors.genderBgColor,
                onTap: () => onGenderTap(user),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Security section
          SectionTitle(
            title: localizations.security,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 12),
          SettingsCard(
            colorScheme: colorScheme,
            children: [
              _ProfileTile(
                title: localizations.changePassword,
                value: '',
                icon: Icons.lock_outline,
                iconColor: AppIconColors.passwordColor,
                iconBgColor: AppIconColors.passwordBgColor,
                onTap: () => context.push('/profile/change-password'),
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  String _getGenderLabel(UserGender gender, AppLocalizations loc) =>
      switch (gender) {
        UserGender.male => loc.male,
        UserGender.female => loc.female,
        UserGender.unspecified => loc.unspecified,
      };
}

/// Not logged in state widget.
class _NotLoggedInState extends StatelessWidget {
  const _NotLoggedInState({
    required this.localizations,
    required this.colorScheme,
  });

  final AppLocalizations localizations;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_outline,
                size: 48,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              localizations.noAccount,
              style: Theme.of(context).textTheme.titleLarge,
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
}

/// Avatar card widget.
class _AvatarCard extends StatelessWidget {
  const _AvatarCard({
    required this.user,
    required this.avatarPath,
    required this.colorScheme,
    required this.onTap,
  });

  final User user;
  final String? avatarPath;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              GestureDetector(
                onTap: onTap,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: colorScheme.primaryContainer,
                      backgroundImage: avatarPath != null
                          ? FileImage(File(avatarPath!))
                          : (user.avatarUrl != null &&
                                  user.avatarUrl!.isNotEmpty)
                              ? NetworkImage(user.avatarUrl!) as ImageProvider
                              : null,
                      child: (avatarPath == null &&
                              (user.avatarUrl == null ||
                                  user.avatarUrl!.isEmpty))
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
              const SizedBox(height: 12),
              Text(
                user.displayName ?? user.username,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      );
}

/// Profile tile widget.
class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.onTap,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 22,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
