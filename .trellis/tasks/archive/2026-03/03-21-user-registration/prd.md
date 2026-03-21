# 用户注册功能

## Goal
增强现有注册功能，添加验证码验证和头像上传功能。

## Current State
**已有功能** (register_screen.dart):
- Email、Username、Password、ConfirmPassword 字段
- 基本表单验证
- 注册 API 调用
- 路由已配置

**缺少功能**:
- 验证码验证流程
- 头像上传
- 地区自动判断（手机号/邮箱）

## Requirements
- 添加验证码验证流程（国内手机号/国外邮箱）
- 系统自动判断地区
- 添加头像上传功能（可选）
- Mock API 实现

## User Flow (Enhanced)
1. 用户在登录页面点击"注册"（已有）
2. 系统自动判断地区，显示对应的输入框（手机号/邮箱）
3. 用户输入账号，点击"获取验证码"
4. 验证码输入框出现，用户输入验证码
5. 用户填写密码、昵称
6. （可选）用户上传头像
7. 验证通过后，完成注册
8. 注册成功，自动登录

## Acceptance Criteria
- [ ] 系统能自动判断地区并显示对应输入方式
- [ ] 验证码发送/输入流程完整
- [ ] 验证码倒计时（60秒）
- [ ] 头像上传功能（可选）
- [ ] Mock API 实现（发送验证码、验证验证码）
- [ ] UI 支持国际化

## Technical Notes
- 地区判断：优先使用设备 locale，fallback 到 IP 判断
- 验证码有效期：5 分钟
- 验证码倒计时：60 秒
- 密码要求：至少 8 位，包含字母和数字
- 昵称：2-20 个字符
- 头像：支持相册选择，压缩后上传（Mock 阶段本地存储）
- Mock 延迟：1-2 秒模拟网络请求

## Files to Modify
- `lib/features/auth/presentation/screens/register_screen.dart` (modify - 添加验证码和头像)
- `lib/features/auth/presentation/providers/auth_provider.dart` (modify - 添加验证码方法)
- `lib/features/auth/domain/repositories/auth_repository.dart` (modify - 添加接口)
- `lib/features/auth/data/repositories/auth_repository_impl.dart` (modify - Mock 实现)
- `lib/l10n/app_zh.arb` (modify - 添加翻译)
- `lib/l10n/app_en.arb` (modify - 添加翻译)
