/// 聊天仓库接口。
///
/// 定义聊天数据操作的标准接口，遵循 Repository 模式。
/// 数据层通过实现此接口提供具体的数据访问能力。
library;

import 'package:flutter_project_template/features/chat/domain/entities/message.dart';

/// 会话实体。
///
/// 表示一个聊天会话，包含会话的基本信息。
class Conversation {
  /// 创建会话实体。
  const Conversation({
    required this.id,
    required this.title,
    required this.updatedAt, this.lastMessage,
    this.unreadCount = 0,
    this.type = 'ai',
    this.aiModelId,
    this.totalTokens = 0,
    this.createdAt,
  });

  /// 会话唯一标识符。
  final String id;

  /// 会话标题。
  final String title;

  /// 最后一条消息预览。
  final String? lastMessage;

  /// 会话最后更新时间。
  final DateTime updatedAt;

  /// 未读消息数量。
  final int unreadCount;

  /// 会话类型：'ai', 'customer_service', 'user'。
  final String type;

  /// 关联的 AI 模型 ID（可选）。
  final String? aiModelId;

  /// 会话使用的总 token 数。
  final int totalTokens;

  /// 会话创建时间。
  final DateTime? createdAt;

  /// 创建会话副本。
  Conversation copyWith({
    String? id,
    String? title,
    String? lastMessage,
    DateTime? updatedAt,
    int? unreadCount,
    String? type,
    String? aiModelId,
    int? totalTokens,
    DateTime? createdAt,
  }) => Conversation(
      id: id ?? this.id,
      title: title ?? this.title,
      lastMessage: lastMessage ?? this.lastMessage,
      updatedAt: updatedAt ?? this.updatedAt,
      unreadCount: unreadCount ?? this.unreadCount,
      type: type ?? this.type,
      aiModelId: aiModelId ?? this.aiModelId,
      totalTokens: totalTokens ?? this.totalTokens,
      createdAt: createdAt ?? this.createdAt,
    );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Conversation &&
          other.id == id &&
          other.title == title &&
          other.lastMessage == lastMessage &&
          other.updatedAt == updatedAt;

  @override
  int get hashCode => Object.hash(id, title, lastMessage, updatedAt);
}

/// 聊天仓库接口。
///
/// 提供会话和消息的 CRUD 操作。
///
/// ## 使用示例
///
/// ```dart
/// final repository = ref.watch(chatRepositoryProvider);
///
/// // 获取所有会话
/// final conversations = await repository.getConversations();
///
/// // 创建新会话
/// final conversation = await repository.createConversation(title: 'New Chat');
///
/// // 发送消息
/// final message = TextMessage(
///   id: 'msg_1',
///   conversationId: conversation.id,
///   sender: MessageSender.user,
///   timestamp: DateTime.now(),
///   content: 'Hello!',
/// );
/// await repository.addMessage(message);
/// ```
abstract class ChatRepository {
  /// 获取所有会话。
  ///
  /// 返回按更新时间降序排列的会话列表。
  Future<List<Conversation>> getConversations();

  /// 监听所有会话的变化。
  ///
  /// 返回会话列表的流，当会话发生变化时发出新数据。
  Stream<List<Conversation>> watchConversations();

  /// 获取单个会话。
  ///
  /// 返回指定 ID 的会话，如果不存在则返回 `null`。
  Future<Conversation?> getConversation(String id);

  /// 监听单个会话的变化。
  ///
  /// 返回会话的流，当会话发生变化时发出新数据。
  Stream<Conversation?> watchConversation(String id);

  /// 创建新会话。
  ///
  /// - [title] 会话标题。
  /// - [type] 会话类型，默认为 'ai'。
  /// - [aiModelId] 关联的 AI 模型 ID（可选）。
  ///
  /// 返回创建的会话。
  Future<Conversation> createConversation({
    required String title,
    String type = 'ai',
    String? aiModelId,
  });

  /// 更新会话。
  ///
  /// 更新会话的信息，如标题、最后消息等。
  Future<void> updateConversation(Conversation conversation);

  /// 删除会话。
  ///
  /// 同时删除会话下的所有消息。
  Future<void> deleteConversation(String id);

  /// 获取会话的所有消息。
  ///
  /// 返回按时间升序排列的消息列表。
  Future<List<Message>> getMessages(String conversationId);

  /// 监听会话消息的变化。
  ///
  /// 返回消息列表的流，当消息发生变化时发出新数据。
  Stream<List<Message>> watchMessages(String conversationId);

  /// 添加消息。
  ///
  /// 将消息持久化到存储中。
  /// 返回添加后的消息（可能包含服务器分配的 ID）。
  Future<Message> addMessage(Message message);

  /// 更新消息。
  ///
  /// 更新消息的内容或状态。
  Future<void> updateMessage(Message message);

  /// 更新消息状态。
  ///
  /// 仅更新消息的状态字段。
  Future<void> updateMessageStatus(String id, MessageStatus status);

  /// 删除消息。
  ///
  /// 从存储中删除指定消息。
  Future<void> deleteMessage(String id);

  /// 更新会话的最后消息。
  ///
  /// 同时更新会话的 updatedAt 时间戳。
  Future<void> updateConversationLastMessage(
    String conversationId, {
    required String lastMessage,
    required DateTime updatedAt,
    int? tokenCount,
  });
}