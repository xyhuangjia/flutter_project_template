/// Chat-specific color constants for AI Chatbot UI.
///
/// Defines colors for chat bubbles, AI responses, and chat interactions.
library;

import 'package:flutter/material.dart';

/// Chat-specific colors for the AI Chatbot interface.
abstract final class ChatColors {
  // ========== Light Theme Colors ==========

  /// User message background (light theme).
  static const Color userMessageLight = Color(0xFF2563EB);

  /// User message text (light theme).
  static const Color userMessageTextLight = Colors.white;

  /// AI message background (light theme).
  static const Color aiMessageLight = Color(0xFFF1F5F9);

  /// AI message text (light theme).
  static const Color aiMessageTextLight = Color(0xFF1E293B);

  /// Chat background (light theme).
  static const Color chatBackgroundLight = Colors.white;

  /// Input field background (light theme).
  static const Color inputFieldLight = Color(0xFFF8FAFC);

  /// Typing indicator dot color (light theme).
  static const Color typingDotLight = Color(0xFF94A3B8);

  // ========== Dark Theme Colors ==========

  /// User message background (dark theme).
  static const Color userMessageDark = Color(0xFF3B82F6);

  /// User message text (dark theme).
  static const Color userMessageTextDark = Colors.white;

  /// AI message background (dark theme).
  static const Color aiMessageDark = Color(0xFF1E293B);

  /// AI message text (dark theme).
  static const Color aiMessageTextDark = Color(0xFFE2E8F0);

  /// Chat background (dark theme).
  static const Color chatBackgroundDark = Color(0xFF0F172A);

  /// Input field background (dark theme).
  static const Color inputFieldDark = Color(0xFF1E293B);

  /// Typing indicator dot color (dark theme).
  static const Color typingDotDark = Color(0xFF64748B);

  // ========== Accent Colors ==========

  /// AI avatar accent color.
  static const Color aiAvatarAccent = Color(0xFF8B5CF6);

  /// User avatar accent color.
  static const Color userAvatarAccent = Color(0xFF06B6D4);

  /// Online/active indicator.
  static const Color onlineIndicator = Color(0xFF10B981);

  /// Sent/read indicator.
  static const Color sentIndicator = Color(0xFF3B82F6);

  /// Error state color.
  static const Color errorAccent = Color(0xFFEF4444);
}
