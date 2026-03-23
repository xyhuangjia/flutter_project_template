/// 聊天输入框组件。
///
/// 支持文本输入和图片选择，提供统一的输入交互体验。
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// 输入内容类型。
enum InputContentType {
  /// 纯文本内容。
  text,

  /// 图片内容（可能附带文本说明）。
  image,
}

/// 输入内容。
class InputContent {
  /// 创建输入内容。
  const InputContent({
    required this.type,
    this.text,
    this.imagePaths = const [],
  });

  /// 纯文本内容。
  const InputContent.text(String text)
      : type = InputContentType.text,
        this.text = text,
        imagePaths = const [];

  /// 图片内容。
  const InputContent.image({
    required List<String> paths,
    String? caption,
  })  : type = InputContentType.image,
        text = caption,
        imagePaths = paths;

  /// 内容类型。
  final InputContentType type;

  /// 文本内容。
  final String? text;

  /// 图片路径列表。
  final List<String> imagePaths;

  /// 是否为空。
  bool get isEmpty {
    if (type == InputContentType.text) {
      return text == null || text!.trim().isEmpty;
    }
    return imagePaths.isEmpty;
  }

  /// 是否有文本。
  bool get hasText => text != null && text!.trim().isNotEmpty;

  /// 是否有图片。
  bool get hasImages => imagePaths.isNotEmpty;
}

/// 聊天输入框。
///
/// 支持以下功能：
/// - 文本输入
/// - 多图选择
/// - 图片预览
/// - 发送文本和图片消息
class ChatInputField extends StatefulWidget {
  /// 创建聊天输入框。
  const ChatInputField({
    required this.onSend,
    super.key,
    this.hintText = 'Type a message...',
    this.enabled = true,
    this.maxImages = 9,
    this.showImageButton = true,
  });

  /// 发送回调。
  ///
  /// 当用户点击发送按钮时调用，参数为输入内容。
  final ValueChanged<InputContent> onSend;

  /// 占位文本。
  final String hintText;

  /// 是否启用。
  final bool enabled;

  /// 最大图片数量。
  final int maxImages;

  /// 是否显示图片按钮。
  final bool showImageButton;

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _imagePicker = ImagePicker();
  final List<String> _selectedImages = [];

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    final hasImages = _selectedImages.isNotEmpty;

    if (!hasImages && text.isEmpty) {
      return;
    }

    if (hasImages) {
      // 发送图片消息（可能附带文本）
      widget.onSend(InputContent.image(
        paths: List.from(_selectedImages),
        caption: text.isNotEmpty ? text : null,
      ));
      _controller.clear();
      setState(() {
        _selectedImages.clear();
      });
    } else {
      // 发送纯文本消息
      widget.onSend(InputContent.text(text));
      _controller.clear();
    }
  }

  Future<void> _pickImages() async {
    try {
      final remainingSlots = widget.maxImages - _selectedImages.length;
      if (remainingSlots <= 0) {
        _showMaxImagesReached();
        return;
      }

      final images = await _imagePicker.pickMultiImage();

      if (images.isNotEmpty) {
        setState(() {
          // 只添加不超过最大数量的图片
          final newImages = images.take(remainingSlots).map((x) => x.path).toList();
          _selectedImages.addAll(newImages);
        });
      }
    } catch (e) {
      // 忽略取消选择的情况
    }
  }

  Future<void> _takePhoto() async {
    try {
      if (_selectedImages.length >= widget.maxImages) {
        _showMaxImagesReached();
        return;
      }

      final image = await _imagePicker.pickImage(source: ImageSource.camera);

      if (image != null) {
        setState(() {
          _selectedImages.add(image.path);
        });
      }
    } catch (e) {
      // 忽略取消选择的情况
    }
  }

  void _showMaxImagesReached() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('最多选择 ${widget.maxImages} 张图片'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 图片预览区域
          if (_selectedImages.isNotEmpty) _buildImagePreview(isDark),

          // 输入区域
          Row(
            children: [
              // 图片按钮
              if (widget.showImageButton) _buildImageButton(isDark),

              // 文本输入框
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 120),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFF8FAFC),
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
                      if (widget.enabled) {
                        _focusNode.requestFocus();
                      }
                    },
                    style: TextStyle(
                      fontSize: 15,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                    decoration: InputDecoration(
                      hintText: _selectedImages.isNotEmpty
                          ? '添加说明（可选）...'
                          : widget.hintText,
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
        ],
      ),
    );
  }

  /// 构建图片按钮。
  Widget _buildImageButton(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: widget.enabled ? _showImageSourceDialog : null,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.add_photo_alternate_outlined,
            size: 22,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  /// 显示图片来源选择对话框。
  void _showImageSourceDialog() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('从相册选择'),
              onTap: () {
                Navigator.pop(context);
                _pickImages();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('拍照'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 构建发送按钮。
  Widget _buildSendButton(bool isDark) => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final hasText = _controller.text.trim().isNotEmpty;
          final hasImages = _selectedImages.isNotEmpty;
          final canSend = hasText || hasImages;

          return GestureDetector(
            onTap: widget.enabled && canSend ? _handleSend : null,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: canSend
                    ? const Color(0xFF2563EB)
                    : (isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(
                _selectedImages.isNotEmpty
                    ? Icons.send_rounded
                    : Icons.send_rounded,
                size: 20,
                color: canSend
                    ? Colors.white
                    : (isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF94A3B8)),
              ),
            ),
          );
        },
      );

  /// 构建图片预览区域。
  Widget _buildImagePreview(bool isDark) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 100),
      margin: const EdgeInsets.only(bottom: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < _selectedImages.length; i++)
              _buildImageItem(i, isDark),
          ],
        ),
      ),
    );
  }

  /// 构建单个图片预览项。
  Widget _buildImageItem(int index, bool isDark) {
    final imagePath = _selectedImages[index];

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          // 图片缩略图
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(imagePath),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80,
                height: 80,
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                child: const Icon(Icons.broken_image, size: 32),
              ),
            ),
          ),
          // 删除按钮
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.close,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // 图片序号
          if (_selectedImages.length > 1)
            Positioned(
              bottom: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
