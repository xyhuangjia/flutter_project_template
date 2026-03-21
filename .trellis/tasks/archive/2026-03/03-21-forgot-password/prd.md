# 忘记密码功能

## Goal
为用户提供密码找回功能，根据用户所在地区自动选择验证方式（国内手机号/国外邮箱）。

## Requirements
- 系统自动判断用户地区（基于设备 locale 或 IP）
- 国内用户：手机号 + 短信验证码
- 国外用户：邮箱 + 邮箱验证码
- 在登录页面添加"忘记密码"按钮入口
- 先用 Mock 数据开发，后续对接真实 API

## User Flow
1. 用户在登录页面点击"忘记密码"
2. 系统自动判断地区，显示对应的输入框（手机号/邮箱）
3. 用户输入账号，点击获取验证码
4. 用户输入验证码
5. 验证通过后，设置新密码
6. 密码重置成功，跳转登录页

## Acceptance Criteria
- [ ] 登录页面有"忘记密码"按钮
- [ ] 系统能自动判断地区并显示对应输入方式
- [ ] 验证码发送/输入流程完整
- [ ] 新密码设置流程完整
- [ ] Mock API 实现
- [ ] UI 支持国际化

## Technical Notes
- 地区判断：优先使用设备 locale，fallback 到 IP 判断
- 验证码有效期：5 分钟
- 新密码要求：至少 8 位，包含字母和数字
- Mock 延迟：1-2 秒模拟网络请求

## Files to Modify/Create
- `lib/features/auth/presentation/screens/forgot_password_screen.dart` (new)
- `lib/features/auth/presentation/providers/forgot_password_provider.dart` (new)
- `lib/features/auth/domain/usecases/forgot_password_usecase.dart` (new)
- `lib/features/auth/data/repositories/auth_repository_impl.dart` (modify)
- `lib/features/auth/presentation/screens/login_screen.dart` (modify - add button)
- `lib/core/router/app_router.dart` (modify - add route)
