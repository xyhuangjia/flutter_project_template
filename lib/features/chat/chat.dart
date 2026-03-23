/// Chat feature exports.
library;

export 'data/datasources/chat_local_data_source.dart';
export 'data/services/ai_service.dart';
export 'data/services/claude_service.dart';
export 'data/services/openai_service.dart';
// 旧的消息实体（保持兼容）
// 注意：hide MessageSender 和 MessageStatus 避免与新的 message.dart 冲突
export 'domain/entities/chat_message.dart'
    hide MessageSender, MessageStatus, ChatMessage;
// 新的 IM 消息实体
export 'domain/entities/entities.dart';
// 插件系统
export 'domain/plugins/plugins.dart';
export 'presentation/providers/ai_config_provider.dart';
export 'presentation/providers/chat_provider.dart';
export 'presentation/providers/plugin_registry_provider.dart';
export 'presentation/providers/response_generator_provider.dart';
export 'presentation/screens/chat_detail_screen.dart';
export 'presentation/screens/conversation_list_screen.dart';
export 'presentation/widgets/chat_input_field.dart';
export 'presentation/widgets/conversation_list_item.dart';
export 'presentation/widgets/message_bubble.dart';
export 'presentation/widgets/typing_indicator.dart';
export 'utils/chat_colors.dart';
