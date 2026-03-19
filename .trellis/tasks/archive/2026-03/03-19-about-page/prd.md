# 添加关于页面

## Goal
创建一个独立的"关于"页面，展示APP信息和法律协议入口。

## Requirements
- 显示APP图标（使用应用图标）
- 显示版本号（从pubspec.yaml读取）
- 显示构建日期（编译时生成）
- 显示隐私协议链接（使用内部WebView打开）
- 显示用户协议链接（使用内部WebView打开）
- 显示备案号（支持点击跳转到工信部备案查询页面）
- 从设置页面点击"关于"入口进入

## Acceptance Criteria
- [x] 创建 `AboutScreen` 页面，位于 `lib/features/settings/presentation/screens/`
- [x] 页面显示APP图标、版本号、构建日期
- [x] 隐私协议和用户协议点击后使用内部WebView显示
- [x] 备案号点击跳转到工信部备案查询页面
- [x] 在 `routes.dart` 和 `app_router.dart` 中添加路由
- [x] 在设置页面"关于"部分添加入口，将原有的版本、隐私、条款合并为"关于"入口
- [x] 添加必要的i18n翻译

## Technical Notes
- 版本号使用 `package_info_plus` 包获取
- 构建日期使用 `build_time` 或自定义生成
- WebView使用 `webview_flutter` 包
- 备案查询URL: https://beian.miit.gov.cn/
- 协议URL需要配置（暂用占位符）
