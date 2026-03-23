# Chat 模块对接与扩展文档

> 本文档介绍如何使用和扩展重构后的 Chat 模块。

---

## 目录

1. [架构概述](#架构概述)
2. [快速开始](#快速开始)
3. [核心概念](#核心概念)
4. [消息类型系统](#消息类型系统)
5. [插件系统](#插件系统)
6. [扩展指南](#扩展指南)
7. [API 参考](#api-参考)
8. [最佳实践](#最佳实践)

---

## 架构概述

### 整体架构

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────────┐ │
│  │ConversationList│ │ChatDetailScreen│ │ MessageBubble (插件)   │ │
│  └─────────────┘ └─────────────┘ └─────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                    Plugin Layer                              │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │              IMPluginRegistry (插件注册中心)              │ │
│  │  - MessageHandler (消息处理器)                            │ │
│  │  - MessageRenderer (消息渲染器)                           │ │
│  │  - ResponseGenerator (响应生成器)                         │ │
│  └─────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                      Domain Layer                            │
│  ┌─────────────┐ ┌─────────────┐ ┌───────────────────────┐  │
│  │ Message     │ │ ChatRepository │ │ MessageAttachment  │  │
│  │ (sealed)    │ │ (接口)        │ │ (附件)              │  │
│  └─────────────┘ └─────────────┘ └───────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                       Data Layer                             │
│  ┌─────────────┐ ┌─────────────┐ ┌───────────────────────┐  │
│  │RepositoryImpl│ │DataSource   │ │ MessageConverter     │  │
│  └─────────────┘ └─────────────┘ └───────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### 目录结构

```
lib/features/chat/
├── chat.dart                          # 模块导出文件
├── domain/
│   ├── entities/
│   │   ├── chat_message.dart          # 旧版消息模型（兼容）
│   │   ├── message.dart               # 新消息类型系统
│   │   └── entities.dart              # 实体导出
│   ├── plugins/
│   │   ├── message_handler.dart       # 消息处理器接口
│   │   ├── message_renderer.dart      # 消息渲染器接口
│   │   ├── response_generator.dart    # 响应生成器接口
│   │   ├── plugin_registry.dart       # 插件注册中心
│   │   ├── plugins.dart               # 插件导出
│   │   └── impl/                      # 插件实现
│   │       ├── ai_chat_handler.dart
│   │       ├── ai_message_renderer.dart
│   │       ├── ai_response_generator.dart
│   │       ├── image_message_renderer.dart
│   │       └── echo_handler.dart
│   └── repositories/
│       └── chat_repository.dart       # 仓库接口
├── data/
│   ├── datasources/
│   │   └── chat_local_data_source.dart
│   ├── repositories/
│   │   └── chat_repository_impl.dart
│   ├── converters/
│   │   └── message_converter.dart     # 消息转换器
│   └── services/
│       ├── ai_service.dart
│       ├── openai_service.dart
│       ├── claude_service.dart
│       └── universal_ai_service.dart
└── presentation/
    ├── providers/
    │   ├── chat_provider.dart
    │   ├── ai_config_provider.dart
    │   ├── plugin_registry_provider.dart
    │   └── response_generator_provider.dart
    ├── screens/
    │   ├── conversation_list_screen.dart
    │   ├── chat_detail_screen.dart
    │   └── ai_config_screen.dart
    └── widgets/
        ├── message_bubble.dart
        ├── chat_input_field.dart
        ├── conversation_list_item.dart
        ├── message_type_indicator.dart
        └── typing_indicator.dart
```

---

## 快速开始

### 基本使用

```dart
import 'package:flutter_project_template/features/chat/chat.dart';

// 1. 在页面中使用聊天详情
class MyChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChatDetailScreen(
      conversationId: 'conversation-id',
    );
  }
}

// 2. 使用会话列表
class MyConversationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const ConversationListScreen();
  }
}
```

### 发送消息

```dart
// 使用 Provider 发送消息
final chatNotifier = ref.read(chatProvider.notifier);

// 发送文本消息
await chatNotifier.sendMessageStream(
  conversationId: 'conversation-id',
  content: '你好！',
);

// 发送图片消息（需要先上传图片获取 URL）
// 详见后续章节
```

---

## 核心概念

### 1. 消息类型系统

Chat 模块使用 `sealed class` 实现类型安全的消息系统：

```dart
/// 消息基类
sealed class Message {
  String get id;
  String get conversationId;
  MessageSender get sender;
  DateTime get timestamp;
  MessageStatus get status;
  String? get text;
}

/// 文本消息
class TextMessage implements Message {
  @override
  final String id;
  @override
  final String conversationId;
  @override
  final MessageSender sender;
  @override
  final DateTime timestamp;
  @override
  final MessageStatus status;
  @override
  final String? text;
}

/// 图片消息
class ImageMessage implements Message {
  // ... 基础字段

  final List<String> imageUrls;      // 图片 URL 列表
  final List<String>? thumbnailUrls; // 缩略图 URL 列表
  final String? caption;             // 图片说明
}
```

### 2. 消息发送者

```dart
enum MessageSender {
  user,      // 用户消息
  assistant, // AI/助手消息
  system,    // 系统消息
}
```

### 3. 消息状态

```dart
enum MessageStatus {
  sending, // 发送中
  sent,    // 已发送
  read,    // 已读
  error,   // 发送失败
}
```

### 4. 插件系统

插件系统由三部分组成：

| 组件 | 职责 | 示例 |
|------|------|------|
| `MessageHandler` | 处理用户消息，生成响应 | AI 聊天、客服机器人 |
| `MessageRenderer` | 渲染消息 UI | 文本气泡、图片网格 |
| `ResponseGenerator` | 生成流式响应 | OpenAI API 调用 |

---

## 消息类型系统

### 内置消息类型

#### TextMessage - 文本消息

```dart
final textMessage = TextMessage(
  id: 'msg-001',
  conversationId: 'conv-001',
  sender: MessageSender.user,
  text: '你好，请帮我翻译这段文字',
  timestamp: DateTime.now(),
  status: MessageStatus.sent,
);
```

#### ImageMessage - 图片消息

```dart
final imageMessage = ImageMessage(
  id: 'msg-002',
  conversationId: 'conv-001',
  sender: MessageSender.user,
  imageUrls: ['https://example.com/image1.jpg'],
  thumbnailUrls: ['https://example.com/thumb1.jpg'],
  caption: '请描述这张图片',
  timestamp: DateTime.now(),
  status: MessageStatus.sent,
);
```

### 消息转换

```dart
// 从数据库 DTO 转换为 Message
final message = MessageConverter.fromDto(chatMessageDto);

// 从 Message 转换为数据库 DTO
final dto = MessageConverter.toDto(message);

// 从旧版 ChatMessage 转换（向后兼容）
final message = MessageConverter.fromLegacy(chatMessage);
```

---

## 插件系统

### IMPluginRegistry

插件注册中心管理所有插件：

```dart
// 获取插件注册中心
final registry = ref.read(pluginRegistryProvider);

// 注册消息处理器
registry.registerHandler(MyCustomHandler());

// 注册消息渲染器
registry.registerRenderer(MyCustomRenderer());

// 注册响应生成器
registry.registerGenerator(MyCustomGenerator());

// 查找合适的处理器
final handler = registry.getHandler(message);

// 查找合适的渲染器
final renderer = registry.getRenderer(message);

// 获取生成器
final generator = registry.getGenerator('my-generator');
```

### MessageHandler - 消息处理器

处理用户消息并生成响应：

```dart
abstract class MessageHandler {
  /// 插件标识
  String get id;

  /// 能否处理该消息
  bool canHandle(Message message);

  /// 处理消息（返回响应消息）
  Future<Message?> handle(Message message, MessageContext context);
}
```

**示例：自动回复处理器**

```dart
class AutoReplyHandler extends MessageHandler {
  @override
  String get id => 'auto_reply';

  @override
  bool canHandle(Message message) {
    // 只处理用户消息
    return message.sender == MessageSender.user;
  }

  @override
  Future<Message?> handle(Message message, MessageContext context) async {
    // 检查是否包含关键词
    final text = message.text?.toLowerCase() ?? '';

    if (text.contains('帮助')) {
      return TextMessage(
        id: uuid.v4(),
        conversationId: message.conversationId,
        sender: MessageSender.assistant,
        text: '我可以帮您：\n1. 翻译文字\n2. 总结文章\n3. 回答问题',
        timestamp: DateTime.now(),
        status: MessageStatus.sent,
      );
    }

    return null; // 不处理，交给下一个处理器
  }
}
```

### MessageRenderer - 消息渲染器

渲染消息的 UI 组件：

```dart
abstract class MessageRenderer {
  /// 能否渲染该消息
  bool canRender(Message message);

  /// 渲染消息 UI
  Widget render(Message message, BuildContext context);
}
```

**示例：链接预览渲染器**

```dart
class LinkPreviewRenderer extends MessageRenderer {
  @override
  bool canRender(Message message) {
    final text = message.text ?? '';
    // 检测是否包含 URL
    return text.contains('http://') || text.contains('https://');
  }

  @override
  Widget render(Message message, BuildContext context) {
    final text = message.text ?? '';
    final urls = _extractUrls(text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text),
        if (urls.isNotEmpty)
          LinkPreviewCard(url: urls.first),
      ],
    );
  }

  List<String> _extractUrls(String text) {
    final regex = RegExp(r'https?://[^\s]+');
    return regex.allMatches(text).map((m) => m.group(0)!).toList();
  }
}
```

### ResponseGenerator - 响应生成器

生成流式 AI 响应：

```dart
abstract class ResponseGenerator {
  /// 插件标识
  String get id;
  String get name;

  /// 生成响应（流式）
  Stream<ResponseChunk> generate(MessageContext context);

  /// 停止生成
  void stop();
}
```

**ResponseChunk 结构**：

```dart
class ResponseChunk {
  final String content;    // 内容增量
  final bool isDone;       // 是否完成
  final String? error;     // 错误信息
  final int? totalTokens;  // 总 Token 数
}
```

**示例：翻译生成器**

```dart
class TranslationGenerator extends ResponseGenerator {
  final AIService _aiService;

  @override
  String get id => 'translation';

  @override
  String get name => '翻译助手';

  @override
  Stream<ResponseChunk> generate(MessageContext context) async* {
    final lastMessage = context.history.last;
    final text = lastMessage.text ?? '';

    // 构建翻译提示
    final prompt = '请将以下内容翻译成英文：\n\n$text';

    // 调用 AI 服务
    await for (final chunk in _aiService.streamMessage(
      messages: [AIMessage(role: 'user', content: prompt)],
      config: AIRequestConfig(model: 'gpt-4'),
    )) {
      yield ResponseChunk(
        content: chunk.content,
        isDone: chunk.isDone,
      );
    }
  }
}
```

---

## 扩展指南

### 场景一：添加新的消息类型

**步骤 1：定义消息类**

```dart
// lib/features/chat/domain/entities/message.dart

/// 文件消息
class FileMessage implements Message {
  @override
  final String id;
  @override
  final String conversationId;
  @override
  final MessageSender sender;
  @override
  final DateTime timestamp;
  @override
  final MessageStatus status;

  final String fileUrl;
  final String fileName;
  final int fileSize;
  final String fileType; // 'pdf', 'doc', 'excel', etc.
}
```

**步骤 2：创建渲染器**

```dart
// lib/features/chat/domain/plugins/impl/file_message_renderer.dart

class FileMessageRenderer extends MessageRenderer {
  @override
  bool canRender(Message message) => message is FileMessage;

  @override
  Widget render(Message message, BuildContext context) {
    final fileMessage = message as FileMessage;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(_getFileIcon(fileMessage.fileType)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileMessage.fileName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  _formatFileSize(fileMessage.fileSize),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _downloadFile(fileMessage.fileUrl),
          ),
        ],
      ),
    );
  }
}
```

**步骤 3：注册渲染器**

```dart
// 在 Provider 中注册
@riverpod
IMPluginRegistry pluginRegistry(Ref ref) {
  final registry = IMPluginRegistry();

  // 注册文件渲染器
  registry.registerRenderer(FileMessageRenderer());

  return registry;
}
```

### 场景二：创建 AI 客服机器人

**步骤 1：创建处理器**

```dart
class CustomerServiceHandler extends MessageHandler {
  @override
  String get id => 'customer_service';

  @override
  bool canHandle(Message message) {
    return message.sender == MessageSender.user;
  }

  @override
  Future<Message?> handle(Message message, MessageContext context) async {
    final text = message.text?.toLowerCase() ?? '';

    // 1. 检查关键词匹配
    final quickReply = _getQuickReply(text);
    if (quickReply != null) {
      return _createReply(message.conversationId, quickReply);
    }

    // 2. 检查是否需要转人工
    if (text.contains('人工') || text.contains('客服')) {
      return _createReply(
        message.conversationId,
        '正在为您转接人工客服，请稍候...',
      );
    }

    // 3. 使用 AI 生成回复
    return null; // 让 AI 处理
  }

  String? _getQuickReply(String text) {
    final replies = {
      '退货': '退货政策：购买7天内可无理由退货，请联系客服处理。',
      '退款': '退款将在1-3个工作日内原路返回。',
      '发货': '订单一般24小时内发货，可在我订单中查看物流信息。',
      '价格': '商品价格以页面显示为准，如有疑问请联系客服。',
    };

    for (final entry in replies.entries) {
      if (text.contains(entry.key)) {
        return entry.value;
      }
    }
    return null;
  }

  Message _createReply(String conversationId, String text) {
    return TextMessage(
      id: uuid.v4(),
      conversationId: conversationId,
      sender: MessageSender.assistant,
      text: text,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );
  }
}
```

**步骤 2：注册处理器**

```dart
registry.registerHandler(CustomerServiceHandler());
```

### 场景三：创建 GPT 应用（如翻译助手）

**步骤 1：创建专用的生成器**

```dart
class TranslationAppGenerator extends ResponseGenerator {
  final AIService _aiService;
  final String targetLanguage;

  @override
  String get id => 'translation_${targetLanguage.toLowerCase()}';

  @override
  String get name => '翻译到${targetLanguage}';

  TranslationAppGenerator({
    required AIService aiService,
    required this.targetLanguage,
  }) : _aiService = aiService;

  @override
  Stream<ResponseChunk> generate(MessageContext context) async* {
    final text = context.history.last.text ?? '';

    yield ResponseChunk(content: '正在翻译...\n\n');

    final prompt = '''请将以下内容翻译成$targetLanguage。
只需要输出翻译结果，不要添加任何解释。

原文：
$text''';

    await for (final chunk in _aiService.streamMessage(
      messages: [AIMessage(role: 'user', content: prompt)],
      config: AIRequestConfig(model: 'gpt-4'),
    )) {
      yield ResponseChunk(
        content: chunk.content,
        isDone: chunk.isDone,
      );
    }
  }
}
```

**步骤 2：创建应用入口**

```dart
class TranslationAppScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 初始化翻译生成器
    final registry = ref.read(pluginRegistryProvider);
    registry.registerGenerator(
      TranslationAppGenerator(
        aiService: ref.read(aiServicesProvider)['openai']!,
        targetLanguage: '英语',
      ),
    );

    return ChatDetailScreen(
      conversationId: 'translation-app',
      title: '翻译助手',
    );
  }
}
```

---

## API 参考

### Provider

#### chatProvider

管理聊天状态：

```dart
// 获取状态
final state = ref.watch(chatProvider);

// 获取方法
final notifier = ref.read(chatProvider.notifier);

// 创建会话
final conversation = await notifier.createConversation(title: '新对话');

// 发送消息（流式）
await for (final event in notifier.sendMessageStream(
  conversationId: 'conv-id',
  content: '你好',
)) {
  if (event is ChatAIResponseChunk) {
    print(event.content);
  }
}

// 删除会话
await notifier.deleteConversation('conv-id');

// 导出会话
final markdown = await notifier.exportConversation('conv-id');
```

#### pluginRegistryProvider

插件注册中心：

```dart
final registry = ref.read(pluginRegistryProvider);

// 注册
registry.registerHandler(handler);
registry.registerRenderer(renderer);
registry.registerGenerator(generator);

// 查找
final handler = registry.getHandler(message);
final renderer = registry.getRenderer(message);
final generator = registry.getGenerator(id);
```

#### aiConfigProvider

AI 配置管理：

```dart
final notifier = ref.read(aiConfigProvider.notifier);

// 添加配置
await notifier.addConfig(
  name: 'My GPT-4',
  provider: AIProvider.openai,
  apiKey: 'sk-...',
  models: ['gpt-4', 'gpt-4-turbo'],
  defaultModel: 'gpt-4',
);

// 设置默认配置
await notifier.setDefault('config-id');

// 删除配置
await notifier.deleteConfig('config-id');
```

### 数据模型

#### Message

```dart
sealed class Message {
  String get id;
  String get conversationId;
  MessageSender get sender;
  DateTime get timestamp;
  MessageStatus get status;
  String? get text;
}
```

#### TextMessage

```dart
class TextMessage implements Message {
  const TextMessage({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.timestamp,
    required this.status,
    this.text,
  });

  final String id;
  final String conversationId;
  final MessageSender sender;
  final DateTime timestamp;
  final MessageStatus status;
  final String? text;

  // copyWith, toJson, fromJson
}
```

#### ImageMessage

```dart
class ImageMessage implements Message {
  const ImageMessage({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.timestamp,
    required this.status,
    required this.imageUrls,
    this.thumbnailUrls,
    this.caption,
  });

  final String id;
  final String conversationId;
  final MessageSender sender;
  final DateTime timestamp;
  final MessageStatus status;
  final List<String> imageUrls;
  final List<String>? thumbnailUrls;
  final String? caption;
}
```

---

## 最佳实践

### 1. 处理器优先级

```dart
// 高优先级处理器先处理
registry.registerHandler(QuickReplyHandler());   // 快速回复
registry.registerHandler(AIChatHandler());       // AI 聊天
```

### 2. 渲染器优先级

```dart
// 渲染器按注册顺序匹配
// 更具体的渲染器应该先注册
registry.registerRenderer(ImageMessageRenderer());  // 图片
registry.registerRenderer(LinkPreviewRenderer());   // 链接预览
registry.registerRenderer(AIMessageRenderer());     // 通用文本
```

### 3. 错误处理

```dart
class SafeHandler extends MessageHandler {
  @override
  Future<Message?> handle(Message message, MessageContext context) async {
    try {
      return await _doHandle(message, context);
    } catch (e) {
      // 返回错误消息
      return TextMessage(
        id: uuid.v4(),
        conversationId: message.conversationId,
        sender: MessageSender.system,
        text: '处理消息时出错：$e',
        timestamp: DateTime.now(),
        status: MessageStatus.error,
      );
    }
  }
}
```

### 4. 流式响应取消

```dart
// 使用 Riverpod 的 dispose 回调清理资源
@riverpod
class MyGenerator extends _$MyGenerator {
  ResponseGenerator? _generator;

  @override
  ResponseGenerator build() {
    ref.onDispose(() {
      _generator?.stop();
    });
    return _generator = _createGenerator();
  }
}
```

### 5. 测试插件

```dart
void main() {
  test('EchoHandler returns same text', () async {
    final handler = EchoHandler();
    final message = TextMessage(
      id: '1',
      conversationId: 'c1',
      sender: MessageSender.user,
      text: 'Hello',
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );

    expect(handler.canHandle(message), isTrue);

    final response = await handler.handle(message, MessageContext.empty());
    expect(response?.text, contains('Hello'));
  });
}
```

---

## 常见问题

### Q: 如何支持语音消息？

1. 创建 `VoiceMessage` 类型
2. 创建 `VoiceMessageRenderer` 渲染器
3. 创建 `VoiceRecorder` 录音组件
4. 集成到 `ChatInputField`

### Q: 如何实现消息撤回？

```dart
// 在 ChatRepository 中添加
Future<void> recallMessage(String id);

// UI 中调用
await ref.read(chatProvider.notifier).recallMessage(messageId);
```

### Q: 如何实现消息已读回执？

```dart
// 扩展 MessageStatus
enum MessageStatus {
  sending,
  sent,
  delivered, // 已送达
  read,      // 已读
  error,
}

// 在对方查看时更新状态
await ref.read(chatProvider.notifier).markAsRead(messageIds);
```

---

## 更新日志

### v2.0.0 (2024-03-23)

- 重构为插件化架构
- 新增 `Message` sealed class 类型系统
- 新增 `IMPluginRegistry` 插件注册中心
- 支持文本和图片消息
- 新增 `ChatRepository` 数据层抽象
- 向后兼容旧版 `ChatMessage`

---

## 联系方式

如有问题，请联系开发团队或在项目 Issue 中提问。