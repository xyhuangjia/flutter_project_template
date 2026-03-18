# 登录模块和设置模块

## Goal
为 Flutter 应用添加用户认证和设置功能，使用 Mock 数据先行开发

## Requirements

### 登录模块
- 支持 **邮箱 + 密码** 登录
- 支持 **用户名 + 密码** 登录
- 支持第三方登录：**微信、Apple、Google**
- 支持用户注册功能
- 登录状态持久化
- 退出登录功能

### 设置模块
- **个人资料**: 头像、昵称、个人简介
- **账号安全**: 修改密码、绑定账号
- **偏好设置**: 主题、语言、通知
- **关于应用**: 版本信息、隐私政策、用户协议

## Acceptance Criteria
- [ ] 登录页面支持多种登录方式
- [ ] 注册页面完整功能
- [ ] 第三方登录流程完整（Mock）
- [ ] 设置页面分组展示
- [ ] 个人资料可编辑
- [ ] 修改密码功能
- [ ] 偏好设置可切换
- [ ] 登录状态持久化
- [ ] 退出登录功能

## Technical Notes
- 使用 Repository 模式隔离数据层，方便后续切换真实 API
- 状态管理使用现有 Riverpod 方案
- 遵循项目现有的目录结构和代码规范

## Architecture

```
lib/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── repositories/
│   │   │   └── models/
│   │   ├── domain/
│   │   │   └── entities/
│   │   └── presentation/
│   │       ├── pages/
│   │       ├── widgets/
│   │       └── providers/
│   └── settings/
│       ├── data/
│       ├── domain/
│       └── presentation/
```
