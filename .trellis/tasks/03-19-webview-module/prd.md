# Webview Dynamic Module

## Goal
构建一个完整的 Webview 动态化模块，支持多种使用场景的动态化需求。

## Requirements

### Core Features
1. **URL 动态传入** - 页面路由时传入 URL，一个模块加载任意网页
2. **配置驱动** - 通过配置参数决定加载哪个 URL 及行为
3. **JS 双向通信** - Webview 与 Flutter 之间的双向通信能力

### Use Cases
- **通用浏览器** - 用户输入 URL 访问任意网页
- **内嵌 H5 页面** - 加载指定的 H5 业务页面（活动页、协议页）
- **混合开发** - 部分 UI 用 H5 实现，需要频繁与 Flutter 交互

### Full Feature Set
- **基础导航**：页面加载、前进、后退、刷新
- **Cookie/Session 管理**：保持登录状态、共享 Cookie
- **文件交互**：下载、上传、预览
- **状态展示**：加载进度条、错误页面、重试机制

## Acceptance Criteria
- [ ] Webview 页面组件，支持 URL 动态传入
- [ ] 路由配置支持 Webview 页面
- [ ] JS Bridge 实现双向通信
- [ ] Cookie 管理功能
- [ ] 文件下载/上传功能
- [ ] 加载状态 UI（进度条、错误页、重试）
- [ ] 代码符合 Clean Architecture 规范
- [ ] 单元测试覆盖核心逻辑

## Technical Notes
- 遵循项目现有 Clean Architecture + Riverpod 架构
- 使用 `webview_flutter` 插件
- 支持 iOS 和 Android 平台
- JS Bridge 需定义清晰的通信协议
