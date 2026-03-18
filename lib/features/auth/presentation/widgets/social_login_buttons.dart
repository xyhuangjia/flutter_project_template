/// Social login buttons widget.
library;

import 'package:flutter/material.dart';

/// Social login buttons widget.
///
/// Provides buttons for third-party login (WeChat, Apple, Google).
class SocialLoginButtons extends StatelessWidget {
  /// Creates social login buttons.
  const SocialLoginButtons({
    super.key,
    required this.onWeChatLogin,
    required this.onAppleLogin,
    required this.onGoogleLogin,
    this.isLoading = false,
  });

  /// Callback when WeChat login is tapped.
  final VoidCallback onWeChatLogin;

  /// Callback when Apple login is tapped.
  final VoidCallback onAppleLogin;

  /// Callback when Google login is tapped.
  final VoidCallback onGoogleLogin;

  /// Whether buttons are in loading state.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SocialButton(
          icon: Icons.chat,
          label: 'Continue with WeChat',
          onPressed: isLoading ? null : onWeChatLogin,
          backgroundColor: const Color(0xFF07C160),
        ),
        const SizedBox(height: 12),
        _SocialButton(
          icon: Icons.apple,
          label: 'Continue with Apple',
          onPressed: isLoading ? null : onAppleLogin,
          backgroundColor: Colors.black,
        ),
        const SizedBox(height: 12),
        _SocialButton(
          icon: Icons.g_mobiledata,
          label: 'Continue with Google',
          onPressed: isLoading ? null : onGoogleLogin,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          borderColor: Colors.grey.shade300,
        ),
      ],
    );
  }
}

/// Social login button widget.
class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.borderColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        side: borderColor != null ? BorderSide(color: borderColor!) : null,
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      icon: Icon(icon, size: 24),
      label: Text(label),
    );
  }
}

/// Divider with "OR" text.
class OrDivider extends StatelessWidget {
  /// Creates an OR divider.
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
