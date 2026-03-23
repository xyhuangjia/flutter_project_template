/// 消息类型指示器组件。
///
/// 显示消息类型图标，用于会话列表等场景中快速识别消息类型。
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/features/chat/domain/entities/message.dart';

/// 消息类型指示器。
///
/// 根据消息类型显示不同的图标：
/// - 文本消息：无图标或文本图标
/// - 图片消息：图片图标
/// - 其他类型：对应图标
class MessageTypeIndicator extends StatelessWidget {
  /// 创建消息类型指示器。
  const MessageTypeIndicator({
    required this.type,
    super.key,
    this.size = 14,
    this.color,
  });

  /// 消息类型。
  final MessageType type;

  /// 图标大小。
  final double size;

  /// 图标颜色。
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final icon = _getIcon();
    if (icon == null) {
      return const SizedBox.shrink();
    }

    return Icon(
      icon,
      size: size,
      color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  IconData? _getIcon() {
    return switch (type) {
      MessageType.text => null, // 文本消息不显示图标
      MessageType.image => Icons.image_outlined,
      MessageType.file => Icons.insert_drive_file_outlined,
      MessageType.voice => Icons.mic_outlined,
      MessageType.video => Icons.videocam_outlined,
      MessageType.custom => Icons.more_horiz,
    };
  }
}

/// 消息类型图标构建工具类。
///
/// 提供静态方法用于根据消息内容生成预览图标。
class MessageTypeIcon {
  MessageTypeIcon._();

  /// 根据消息对象获取消息类型。
  static MessageType getMessageType(Message message) => message.type;

  /// 根据消息内容预览文本获取图标。
  ///
  /// 用于会话列表等场景，根据最后消息的内容生成类型图标。
  static IconData? getIconForPreview(String? preview, {MessageType? type}) {
    // 如果明确知道类型，直接返回对应图标
    if (type != null && type != MessageType.text) {
      return switch (type) {
        MessageType.image => Icons.image_outlined,
        MessageType.file => Icons.insert_drive_file_outlined,
        MessageType.voice => Icons.mic_outlined,
        MessageType.video => Icons.videocam_outlined,
        MessageType.custom => Icons.more_horiz,
        MessageType.text => null,
      };
    }

    // 尝试从预览文本推断类型
    if (preview == null || preview.isEmpty) {
      return null;
    }

    // 常见的图片消息占位符
    if (preview.contains('[图片]') ||
        preview.contains('[image]') ||
        preview.contains('[Photo]')) {
      return Icons.image_outlined;
    }

    // 常见的文件消息占位符
    if (preview.contains('[文件]') ||
        preview.contains('[file]') ||
        preview.contains('[File]')) {
      return Icons.insert_drive_file_outlined;
    }

    // 常见的语音消息占位符
    if (preview.contains('[语音]') ||
        preview.contains('[voice]') ||
        preview.contains('[Voice]')) {
      return Icons.mic_outlined;
    }

    // 常见的视频消息占位符
    if (preview.contains('[视频]') ||
        preview.contains('[video]') ||
        preview.contains('[Video]')) {
      return Icons.videocam_outlined;
    }

    return null;
  }

  /// 获取消息预览文本。
  ///
  /// 根据消息类型生成用于显示的预览文本。
  static String getPreviewText(Message message) {
    return switch (message) {
      TextMessage(:final content) => content,
      ImageMessage(:final caption, :final imageCount) =>
        caption ?? (imageCount > 1 ? '[$imageCount 张图片]' : '[图片]'),
    };
  }
}
