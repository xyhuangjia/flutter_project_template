/// 消息渲染器插件接口。
///
/// 定义消息渲染器的标准接口，用于自定义消息的 UI 显示。
library;

import 'package:flutter/material.dart';
import 'package:flutter_project_template/features/chat/domain/entities/message.dart';

/// 消息渲染器插件接口。
///
/// 实现此接口以自定义消息的 UI 渲染。
/// 渲染器可以根据消息类型提供不同的显示效果。
///
/// ## 使用示例
///
/// ```dart
/// class TextMessageRenderer implements MessageRenderer {
///   @override
///   bool canRender(Message message) => message is TextMessage;
///
///   @override
///   Widget render(Message message, BuildContext context) {
///     final textMessage = message as TextMessage;
///     return Text(textMessage.content);
///   }
/// }
///
/// class ImageMessageRenderer implements MessageRenderer {
///   @override
///   bool canRender(Message message) => message is ImageMessage;
///
///   @override
///   Widget render(Message message, BuildContext context) {
///     final imageMessage = message as ImageMessage;
///     return Image.network(imageMessage.imageUrl);
///   }
/// }
/// ```
abstract class MessageRenderer {
  /// 渲染器唯一标识符。
  ///
  /// 用于在注册中心查找和管理渲染器。
  String get id;

  /// 渲染器名称（用于显示）。
  ///
  /// 如果未提供，默认使用 [id]。
  String get name => id;

  /// 判断是否能渲染该消息。
  ///
  /// 返回 `true` 表示该渲染器可以渲染此消息。
  /// 注册中心会调用此方法来确定使用哪个渲染器。
  bool canRender(Message message);

  /// 渲染消息 UI。
  ///
  /// 根据消息内容返回对应的 Widget。
  ///
  /// - [message] 要渲染的消息。
  /// - [context] Build 上下文，用于获取主题、本地化等。
  ///
  /// 返回消息的 UI 组件。
  Widget render(Message message, BuildContext context);

  /// 渲染器优先级。
  ///
  /// 数值越大优先级越高。当多个渲染器都能渲染同一消息时，
  /// 优先级高的渲染器会被优先选择。
  /// 默认为 0。
  int get priority => 0;
}
