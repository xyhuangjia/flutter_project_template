/// 图片消息渲染器。
///
/// 渲染图片消息，支持单图和多图显示。
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/features/chat/domain/entities/message.dart';
import 'package:flutter_project_template/features/chat/domain/plugins/message_renderer.dart';
import 'package:intl/intl.dart';

/// 图片消息渲染器。
///
/// 渲染 [ImageMessage] 类型的消息，支持：
/// - 单图显示
/// - 多图网格显示
/// - 缩略图加载
/// - 图片预览
/// - 图片说明
///
/// ## 使用示例
///
/// ```dart
/// final renderer = ImageMessageRenderer(
///   onImageTap: (urls, initialIndex) {
///     // 打开图片预览
///     showImageViewer(urls, initialIndex: initialIndex);
///   },
/// );
///
/// if (renderer.canRender(message)) {
///   return renderer.render(message, context);
/// }
/// ```
class ImageMessageRenderer extends MessageRenderer {
  /// 创建图片消息渲染器。
  ImageMessageRenderer({
    this.onImageTap,
    this.showTimestamp = true,
    this.maxGridColumns = 3,
  });

  /// 图片点击回调。
  ///
  /// 参数为图片 URL 列表和初始显示索引。
  final void Function(List<String> urls, int initialIndex)? onImageTap;

  /// 是否显示时间戳。
  final bool showTimestamp;

  /// 多图网格最大列数。
  final int maxGridColumns;

  @override
  String get id => 'image_message';

  @override
  String get name => 'Image Message Renderer';

  @override
  int get priority => 90;

  @override
  bool canRender(Message message) => message is ImageMessage;

  @override
  Widget render(Message message, BuildContext context) {
    if (message is! ImageMessage) {
      return const SizedBox.shrink();
    }

    return _ImageMessageBubble(
      message: message,
      onImageTap: onImageTap,
      showTimestamp: showTimestamp,
      maxGridColumns: maxGridColumns,
    );
  }
}

/// 图片消息气泡 Widget。
class _ImageMessageBubble extends StatelessWidget {
  const _ImageMessageBubble({
    required this.message,
    required this.onImageTap,
    required this.showTimestamp,
    required this.maxGridColumns,
  });

  final ImageMessage message;
  final void Function(List<String> urls, int initialIndex)? onImageTap;
  final bool showTimestamp;
  final int maxGridColumns;

  bool get _isFromAI => message.sender == MessageSender.assistant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment:
            _isFromAI ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isFromAI) ...[
            _buildAvatar(colorScheme),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: _isFromAI
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: _buildImageContent(context),
                ),
                if (message.caption != null && message.caption!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message.caption!,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
                if (showTimestamp) ...[
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 11,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!_isFromAI) ...[
            const SizedBox(width: 8),
            _buildAvatar(colorScheme),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(ColorScheme colorScheme) => Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: _isFromAI ? colorScheme.tertiary : colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          _isFromAI ? Icons.smart_toy_outlined : Icons.person_outline,
          size: 18,
          color: Colors.white,
        ),
      );

  Widget _buildImageContent(BuildContext context) {
    final imageCount = message.imageCount;

    if (imageCount == 1) {
      return _buildSingleImage(context, 0);
    } else {
      return _buildImageGrid(context);
    }
  }

  Widget _buildSingleImage(BuildContext context, int index) {
    final imageUrl = message.imageUrls[index];
    final thumbnailUrl = message.getThumbnailUrl(index);
    final dimensions = message.getDimensions(index);

    return GestureDetector(
      onTap: () => onImageTap?.call(message.imageUrls, index),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Hero(
          tag: imageUrl,
          child: Image.network(
            thumbnailUrl ?? imageUrl,
            fit: BoxFit.cover,
            width: dimensions?.width?.toDouble() ?? 200,
            height: dimensions?.height?.toDouble() ?? 200,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 200,
                height: 200,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => Container(
              width: 200,
              height: 200,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.broken_image, size: 48),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageGrid(BuildContext context) {
    final imageCount = message.imageCount;
    final columns = imageCount <= 2
        ? 2
        : imageCount <= 4
            ? 2
            : maxGridColumns;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: imageCount.clamp(0, 9), // 最多显示 9 张
        itemBuilder: (context, index) => _buildGridImage(context, index),
      ),
    );
  }

  Widget _buildGridImage(BuildContext context, int index) {
    final imageUrl = message.imageUrls[index];
    final thumbnailUrl = message.getThumbnailUrl(index);

    return GestureDetector(
      onTap: () => onImageTap?.call(message.imageUrls, index),
      child: Image.network(
        thumbnailUrl ?? imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return ColoredBox(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Icon(Icons.broken_image, size: 24),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) => DateFormat.jm().format(time);
}