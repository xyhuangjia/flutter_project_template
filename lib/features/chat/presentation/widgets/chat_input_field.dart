/// Chat input field widget.
library;

import 'package:flutter/material.dart';

/// Chat input field with send button.
class ChatInputField extends StatefulWidget {
  /// Creates a chat input field.
  const ChatInputField({
    required this.onSend,
    super.key,
    this.hintText = 'Type a message...',
    this.enabled = true,
  });

  /// Callback when send button is pressed.
  final ValueChanged<String> onSend;

  /// Placeholder text.
  final String hintText;

  /// Whether the input is enabled.
  final bool enabled;

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color:
                    isDark ? const Color(0xFF334155) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                enabled: widget.enabled,
                maxLines: null,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.send,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _handleSend(),
                onTap: () {
                  // Ensure focus is requested on tap
                  if (widget.enabled) {
                    _focusNode.requestFocus();
                  }
                },
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF94A3B8),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _buildSendButton(isDark),
        ],
      ),
    );
  }

  Widget _buildSendButton(bool isDark) => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final hasText = _controller.text.trim().isNotEmpty;
          return GestureDetector(
            onTap: widget.enabled && hasText ? _handleSend : null,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: hasText
                    ? const Color(0xFF2563EB)
                    : (isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(
                Icons.send_rounded,
                size: 20,
                color: hasText
                    ? Colors.white
                    : (isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF94A3B8)),
              ),
            ),
          );
        },
      );
}
