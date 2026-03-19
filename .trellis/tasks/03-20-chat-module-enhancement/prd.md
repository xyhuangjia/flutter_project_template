# 完善 Chat 模块：持久化 + AI API + UI 增强

## Goal

将现有的 Chat 模块从内存 mock 数据升级为完整的 AI 聊天功能，包括本地持久化存储、真实 AI API 集成和增强的 UI 交互体验。

## What I already know

### 项目技术栈
- **数据库**: Drift (SQLite)，已有 `Users` 表在 `lib/core/storage/database.dart`
- **网络**: Dio，通过 `DioClient` 封装
- **架构**: Clean Architecture (domain/data/presentation)
- **状态管理**: Riverpod + code generation (`@riverpod`)

### Chat 模块现有结构
```
lib/features/chat/
├── chat.dart                          # 导出文件
├── domain/
│   └── entities/
│       └── chat_message.dart          # ChatMessage, ChatConversation
├── presentation/
│   ├── providers/
│   │   └── chat_provider.dart         # ChatNotifier (内存 mock 数据)
│   ├── screens/
│   │   ├── chat_detail_screen.dart    # 聊天详情页
│   │   └── conversation_list_screen.dart  # 会话列表
│   └── widgets/
│       ├── chat_input_field.dart      # 输入框
│       ├── conversation_list_item.dart # 会话列表项
│       ├── message_bubble.dart        # 消息气泡
│       └── typing_indicator.dart      # 打字指示器
└── utils/
    └── chat_colors.dart               # 颜色常量
```

### 现有功能
- 会话列表展示、创建、删除
- 聊天详情页消息展示
- 发送消息（mock AI 响应）
- 消息状态显示 (sending/sent/read/error)
- 深色模式支持

## Decisions

### AI API 架构
**Decision**: 采用可配置多模型架构
- 定义统一的 `ChatService` 抽象接口
- 实现 OpenAI、Claude 等具体适配器
- 用户可在设置中切换模型和配置 API Key

**Consequences**:
- 需要设计良好的抽象层
- 增加初始开发复杂度，但提高灵活性
- 需要统一的错误处理机制

## Assumptions (temporary)

- 需要保存 API Key 在本地（安全存储）
- 消息只支持文本格式（暂不支持多媒体）
- 默认提供 OpenAI 和 Claude 两种适配器

## Open Questions

(All resolved)

## Requirements (evolving)

### 数据持久化
- [ ] 添加 Drift 表定义 (Conversations, Messages)
- [ ] 实现 ChatLocalDataSource
- [ ] 数据库迁移策略
- [ ] 数据访问层方法 (CRUD)

### AI API 集成
- [ ] 设计 ChatService 抽象接口
- [ ] 实现 OpenAI 适配器
- [ ] 实现 Claude 适配器
- [ ] 流式响应支持 (SSE)
- [ ] API Key 安全存储 (flutter_secure_storage)
- [ ] 模型配置 UI（设置页）

### UI 增强
- [x] 消息长按菜单（复制、删除）✓ 用户选择
- [x] 会话搜索 ✓ 用户选择
- [x] 会话重命名 ✓ 用户选择
- [x] 网络错误重试 ✓ 用户选择

### 完整功能集
- [ ] Token 使用统计
- [ ] 聊天记录导出
- [ ] 流式响应显示优化
- [ ] API Key 配置 UI

## Acceptance Criteria (evolving)

- [ ] 应用重启后聊天记录保留
- [ ] AI 响应真实有效
- [ ] 流式输出体验流畅
- [ ] 基本交互功能完整

## Definition of Done

- [ ] 单元测试覆盖关键逻辑
- [ ] Lint / typecheck 通过
- [ ] 国际化字符串已提取
- [ ] 手动测试通过

## Out of Scope (explicit)

- 多媒体消息（图片、语音）
- 多用户账户系统
- 消息加密
- 云端同步

## Implementation Plan (Phased)

### Phase 1: 数据层基础 (PR1)
1. 添加 Drift 表定义 (Conversations, Messages, AIConfigs)
2. 实现 ChatLocalDataSource
3. 数据库迁移
4. 单元测试

### Phase 2: AI 服务集成 (PR2)
1. 设计 ChatService 抽象接口
2. 实现 OpenAI 适配器（流式响应）
3. 实现 Claude 适配器（流式响应）
4. API Key 安全存储
5. ChatRepository 实现

### Phase 3: 状态层重构 (PR3)
1. 重构 ChatProvider 使用 Repository
2. 添加 AIConfigProvider
3. 流式消息更新机制
4. 错误处理和重试逻辑

### Phase 4: UI 增强 (PR4)
1. 消息长按菜单
2. 会话搜索功能
3. 会话重命名
4. 网络状态提示
5. Token 统计显示

### Phase 5: 完整功能 (PR5)
1. 聊天记录导出
2. AI 模型配置 UI
3. 流式响应动画优化
4. 集成测试

## Technical Notes

### 架构设计

```
lib/features/chat/
├── data/
│   ├── datasources/
│   │   ├── chat_local_data_source.dart    # Drift 数据库操作
│   │   └── chat_remote_data_source.dart   # API 抽象接口
│   ├── models/
│   │   ├── chat_message_dto.dart          # 数据传输对象
│   │   └── ai_config_dto.dart             # AI 配置模型
│   ├── services/
│   │   ├── chat_service.dart              # 抽象接口
│   │   ├── openai_service.dart            # OpenAI 实现
│   │   └── claude_service.dart            # Claude 实现
│   └── repositories/
│       └── chat_repository_impl.dart      # 仓库实现
├── domain/
│   ├── entities/
│   │   ├── chat_message.dart              # 现有
│   │   └── ai_config.dart                 # AI 配置实体
│   ├── repositories/
│   │   └── chat_repository.dart           # 仓库接口
│   └── usecases/
│       ├── get_conversations.dart
│       ├── send_message.dart
│       └── export_chat.dart
└── presentation/
    ├── providers/
    │   ├── chat_provider.dart             # 现有，需重构
    │   └── ai_config_provider.dart        # AI 配置状态
    ├── screens/
    │   └── ... (现有 + AI 设置页)
    └── widgets/
        └── ... (现有 + 消息菜单等)
```

### Drift 表设计
```dart
// conversations 表
class Conversations extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get lastMessage => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get unreadCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// messages 表
class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get conversationId => text()();
  TextColumn get content => text()();
  IntColumn get sender => integer()(); // 0=user, 1=ai
  IntColumn get status => integer().withDefault(const Constant(1))();
  DateTimeColumn get timestamp => dateTime()();
}
```

### API 服务对比
| 服务 | 优点 | 缺点 |
|------|------|------|
| OpenAI | 文档完善，社区活跃 | 需要国际信用卡 |
| Claude | 响应质量高 | API 相对较新 |
| 国内大模型 | 支付方便 | 需要备案 |

### 文件参考
- 数据库模式: `lib/core/storage/database.dart`
- 网络请求: `lib/core/network/dio_client.dart`
- Provider 模式: `lib/features/auth/presentation/providers/auth_provider.dart`
