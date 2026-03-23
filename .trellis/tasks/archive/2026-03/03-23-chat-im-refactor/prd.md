# Chat 模块重构为通用 IM 架构

## 目标
将现有的 AI Chat 模块重构为通用 IM 模块，提供扩展能力，支持：
- AI 客服场景
- GPT 应用场景
- 其他 IM 扩展

## 现有架构分析

### 目录结构
```
lib/features/chat/
├── domain/entities/      # ChatMessage, ChatConversation
├── data/
│   ├── datasources/      # 本地数据源
│   └── services/         # AI 服务 (OpenAI, Claude, Universal)
└── presentation/
    ├── providers/        # ChatNotifier, AIConfigNotifier
    ├── screens/          # 会话列表、聊天详情、AI配置
    └── widgets/          # MessageBubble, ChatInputField 等
```

### 现有问题
1. AI 逻辑与 IM 逻辑耦合
2. 缺少 Repository 层
3. 消息类型单一（仅文本）
4. 不支持多模态（图片、文件等）
5. 扩展能力有限

## 已确认需求

### 重构方式
- ✅ **渐进式重构**：保留现有功能，逐步抽象核心层，添加扩展点，新旧兼容

### 消息类型
- ✅ **文本 + 图片**：支持 AI 多模态能力

### 扩展机制
- ✅ **插件化架构**：消息处理器、UI组件、响应逻辑均可注册替换

### 应用场景
- ✅ **AI 聊天助手**：保留现有功能，支持 OpenAI/Claude/自定义端点
- ✅ **AI 客服**：客服机器人，支持自动回复、转人工等
- ✅ **GPT 应用**：基于 GPT 的应用，如翻译、写作助手等
- ✅ **用户聊天**：用户之间的实时聊天

### 实现优先级
- ✅ **核心架构优先**：先完成核心抽象层和插件接口，确保架构正确

## 技术方案

### 架构设计

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────────┐ │
│  │ConversationList│ │ChatDetailScreen│ │ MessageBubble (可扩展) │ │
│  └─────────────┘ └─────────────┘ └─────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                    Application Layer                         │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │              IMPluginRegistry (插件注册中心)               │ │
│  │  - MessageHandler (消息处理器)                             │ │
│  │  - MessageRenderer (消息渲染器)                            │ │
│  │  - ResponseGenerator (响应生成器)                          │ │
│  └─────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                      Domain Layer                            │
│  ┌─────────────┐ ┌─────────────┐ ┌───────────────────────┐  │
│  │ Message     │ │Conversation │ │ MessageAttachment     │  │
│  │ (多类型)    │ │ (会话)      │ │ (图片等附件)           │  │
│  └─────────────┘ └─────────────┘ └───────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                       Data Layer                             │
│  ┌─────────────┐ ┌─────────────┐ ┌───────────────────────┐  │
│  │Repository   │ │DataSource   │ │ AI/Chat Service       │  │
│  │ (抽象)      │ │ (本地/远程) │ │ (可替换实现)            │  │
│  └─────────────┘ └─────────────┘ └───────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### 核心抽象

#### 1. 消息类型系统
```dart
/// 消息基类
sealed class Message {
  String get id;
  String get conversationId;
  MessageSender get sender;
  DateTime get timestamp;
  MessageStatus get status;
}

/// 文本消息
class TextMessage implements Message { ... }

/// 图片消息
class ImageMessage implements Message { ... }

/// 消息附件
class MessageAttachment {
  final String id;
  final AttachmentType type; // image, file, voice
  final String url;
  final String? thumbnailUrl;
  final Map<String, dynamic> metadata;
}
```

#### 2. 插件接口
```dart
/// 消息处理器插件
abstract class MessageHandler {
  /// 能否处理该消息
  bool canHandle(Message message);

  /// 处理消息，返回响应
  Future<Message?> handle(Message message, ConversationContext context);
}

/// 消息渲染器插件
abstract class MessageRenderer {
  /// 能否渲染该消息
  bool canRender(Message message);

  /// 渲染消息 UI
  Widget render(Message message, BuildContext context);
}

/// 响应生成器插件
abstract class ResponseGenerator {
  /// 插件标识
  String get id;
  String get name;

  /// 生成响应（流式）
  Stream<ResponseChunk> generate(MessageContext context);
}
```

#### 3. 插件注册中心
```dart
class IMPluginRegistry {
  /// 注册消息处理器
  void registerHandler(MessageHandler handler);

  /// 注册消息渲染器
  void registerRenderer(MessageRenderer renderer);

  /// 注册响应生成器
  void registerGenerator(ResponseGenerator generator);

  /// 获取处理器
  MessageHandler? getHandler(Message message);

  /// 获取渲染器
  MessageRenderer? getRenderer(Message message);
}
```

### 预置插件

| 插件 | 功能 | 对应场景 |
|------|------|----------|
| AIChatHandler | AI 聊天响应 | AI 聊天助手 |
| CustomerServiceHandler | 客服自动回复 | AI 客服 |
| GPTAppHandler | 特定任务处理 | GPT 应用 |
| UserChatHandler | 用户消息转发 | 用户聊天 |

### 实现阶段

#### Phase 1: 核心抽象层
- [ ] 定义消息类型系统 (Message, TextMessage, ImageMessage)
- [ ] 定义插件接口 (MessageHandler, MessageRenderer, ResponseGenerator)
- [ ] 实现 IMPluginRegistry

#### Phase 2: 数据层重构
- [ ] 添加 Repository 层
- [ ] 更新数据库 schema 支持多类型消息
- [ ] 实现消息附件存储

#### Phase 3: 插件实现
- [ ] 实现 AIChatPlugin (现有功能迁移)
- [ ] 实现 CustomerServicePlugin
- [ ] 实现 GPTAppPlugin

#### Phase 4: UI 适配
- [ ] MessageBubble 支持多类型渲染
- [ ] ChatInputField 支持图片选择
- [ ] 会话列表适配

## 验收标准
- [x] 现有 AI 聊天功能正常工作
- [x] 可通过插件扩展新的消息类型
- [x] 可通过插件扩展新的响应逻辑
- [x] 支持文本和图片消息
- [x] 代码符合项目规范（lint 通过）