# 添加环境配置切换模块

## Goal

创建一个环境配置管理模块，允许开发者通过开发者菜单切换 App 的运行环境（开发/测试/线上），并自动应用相应的配置。

## Requirements

### 功能需求

1. **环境类型**
   - 开发环境 (Development)
   - 测试环境 (Staging)
   - 线上环境 (Production)

2. **配置项**
   - API 基础地址 (baseUrl)
   - 日志级别 (logLevel)
   - 调试开关 (debugMode)
   - 第三方服务配置（如：Analytics, Crashlytics 等的启用/禁用）

3. **切换方式**
   - 在开发者菜单中提供环境切换入口
   - 切换后需要重启 App 才能生效（显示提示）

4. **持久化**
   - 使用 SharedPreferences 保存用户选择的环境
   - App 启动时自动加载保存的环境配置

5. **UI 需求**
   - 提供清晰的环境标识（当前运行环境）
   - 切换时显示确认对话框
   - 显示切换后需要重启的提示

### 技术需求

1. **架构设计**
   - 使用 Riverpod 进行状态管理
   - 环境配置独立模块，位于 `lib/core/environment/`
   - 遵循 Clean Architecture 分层

2. **代码规范**
   - 遵循项目现有的代码风格和规范
   - 使用 json_serializable 进行序列化（如需要）
   - 完善的注释和文档

## Acceptance Criteria

- [ ] 创建环境配置模块，包含三种环境的配置定义
- [ ] 实现 SharedPreferences 持久化存储
- [ ] 在开发者菜单中添加环境切换 UI
- [ ] 切换环境时显示确认对话框和重启提示
- [ ] 提供环境配置的 Provider，供其他模块使用
- [ ] 代码符合项目规范，通过 lint 检查
- [ ] 提供基本的使用文档

## Technical Notes

1. **目录结构建议**
   ```
   lib/core/environment/
   ├── environment.dart           # 环境枚举和配置模型
   ├── environment_provider.dart  # Riverpod Provider
   └── environment_service.dart   # 环境切换服务
   ```

2. **关键实现点**
   - 环境枚举使用 Dart enum
   - 配置使用常量类或配置文件
   - Provider 提供当前环境的配置访问
   - 切换逻辑需要考虑异步存储

3. **注意事项**
   - 生产环境的配置应该安全（不能随意切换到开发环境）
   - 考虑在 Release 模式下隐藏开发者菜单
   - 日志级别配置需要与现有的 Logger 集成
