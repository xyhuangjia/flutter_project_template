/// Profile screen for user information management.
library;

import 'dart:io';

import 'package:flutter/material.dart';
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
  final _nicknameController = TextEditingController();
  bool _isEditing = false;
  bool _isSaving = false;
  String? _avatarPath;

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

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
    }
  }

  void _showAvatarOptions() {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.photo_camera_outlined,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
              title: Text(
                localizations.takePhoto,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo_library_outlined,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
              title: Text(
                localizations.chooseFromGallery,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
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

  Future<void> _saveProfile() async {
    if (_nicknameController.text.trim().isEmpty) {
      return;
    }

    setState(() => _isSaving = true);

    // Simulate save delay (in real app, this would call an API)
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      _isEditing = false;
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.saveSuccess),
        backgroundColor: const Color(0xFF8B5CF6),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      appBar: AppBar(
        title: Text(
          localizations.profile,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
          ),
          onPressed: context.pop,
        ),
        actions: [
          if (!_isEditing)
            TextButton(
              onPressed: () {
                final user = authState.valueOrNull?.user;
                if (user != null) {
                  _nicknameController.text = user.displayName ?? user.username;
                }
                setState(() => _isEditing = true);
              },
              child: Text(localizations.edit),
            ),
        ],
      ),
      body: authState.when(
        data: (state) => _buildContent(
          context,
          localizations,
          isDark,
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
    bool isDark,
    AuthState authState,
  ) {
    final user = authState.user;

    if (user == null) {
      return _buildNotLoggedInState(context, localizations, isDark);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          // Avatar
          _buildAvatarSection(user, localizations, isDark),
          const SizedBox(height: 32),
          // User info
          if (_isEditing)
            _buildEditForm(localizations, isDark)
          else
            _buildInfoList(user, localizations, isDark),
          const SizedBox(height: 32),
          // Stats
          _buildStatsSection(localizations, isDark),
        ],
      ),
    );
  }

  Widget _buildNotLoggedInState(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
  ) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 64,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            ),
            const SizedBox(height: 16),
            Text(
              localizations.noAccount,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
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

  Widget _buildAvatarSection(
    User user,
    AppLocalizations localizations,
    bool isDark,
  ) =>
      GestureDetector(
        onTap: _isEditing ? _showAvatarOptions : null,
        child: Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF8B5CF6),
                    const Color(0xFF6366F1),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: _avatarPath != null
                  ? ClipOval(
                      child: Image.file(
                        File(_avatarPath!),
                        fit: BoxFit.cover,
                      ),
                    )
                  : user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            user.avatarUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        ),
            ),
            if (_isEditing)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      width: 3,
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      );

  Widget _buildEditForm(AppLocalizations localizations, bool isDark) => Column(
        children: [
          TextField(
            controller: _nicknameController,
            decoration: InputDecoration(
              labelText: localizations.nickname,
              prefixIcon: const Icon(Icons.badge_outlined),
              filled: true,
              fillColor: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _isEditing = false),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(
                      color: isDark
                          ? const Color(0xFF334155)
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(localizations.cancel),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(localizations.save),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildInfoList(
    User user,
    AppLocalizations localizations,
    bool isDark,
  ) =>
      Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            _InfoTile(
              icon: Icons.person_outline,
              label: localizations.nickname,
              value: user.displayName ?? user.username,
              isDark: isDark,
            ),
            _Divider(isDark: isDark),
            _InfoTile(
              icon: Icons.email_outlined,
              label: localizations.email,
              value: user.email,
              isDark: isDark,
            ),
          ],
        ),
      );

  Widget _buildStatsSection(AppLocalizations localizations, bool isDark) =>
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.quickActions,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.chat_bubble_outline,
                    label: localizations.chats,
                    value: '0',
                    isDark: isDark,
                    onTap: () => context.push('/chat'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.settings_outlined,
                    label: localizations.settings,
                    value: '',
                    isDark: isDark,
                    onTap: () => context.push('/settings'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

/// Info tile widget.
class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: const Color(0xFF8B5CF6),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? const Color(0xFF64748B)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

/// Divider widget.
class _Divider extends StatelessWidget {
  const _Divider({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Divider(
          color: isDark ? const Color(0xFF334155) : Colors.grey.shade200,
          height: 1,
        ),
      );
}

/// Stat card widget.
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: const Color(0xFF8B5CF6),
              ),
              if (value.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? const Color(0xFF64748B)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      );
}
