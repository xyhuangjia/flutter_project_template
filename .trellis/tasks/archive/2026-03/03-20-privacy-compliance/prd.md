# APP 隐私合规流程和业务

## Goal
实现 APP 的隐私合规流程，支持中国和国际双市场的不同合规要求，确保应用符合各地区的法律法规。

## What I already know
- 目标市场：中国 + 国际（双市场）
- 需要根据不同地区采用不同的合规策略

## Decisions
- **目标市场**: 中国 + 国际双市场
- **合规功能范围**: 全部功能
- **地区判断策略**: 自动检测（设备语言/地区）+ 用户可手动更改
- **后端支持**: 暂时纯前端，后端接口 mock 实现

## Requirements

### 1. 首次启动隐私弹窗
- [ ] APP 首次启动时展示隐私政策和用户协议
- [ ] 必须用户点击"同意"才能继续使用
- [ ] 不同地区展示不同内容（中文/英文版）
- [ ] 记录用户同意状态到本地存储
- [ ] 支持查看完整协议内容

### 2. 权限申请说明
- [ ] 申请相机权限前展示用途说明
- [ ] 申请相册权限前展示用途说明
- [ ] 申请定位权限前展示用途说明
- [ ] 申请通知权限前展示用途说明
- [ ] 用户拒绝后可跳转设置页重新授权

### 3. 账号注销流程
- [ ] 设置页提供"注销账号"入口
- [ ] 注销前展示警告提示（数据将被删除）
- [ ] 需要二次确认（输入密码或其他验证）
- [ ] 调用 mock API 提交注销请求
- [ ] 注销成功后清除本地数据并退出登录

### 4. 隐私设置页
- [ ] 展示隐私政策链接
- [ ] 展示用户协议链接
- [ ] 数据收集偏好设置（可开关）
- [ ] 查看已授权的权限列表
- [ ] 地区/市场切换功能

### 5. 市场差异化
- [ ] 中国市场: 符合 PIPL 要求的隐私文案
- [ ] 国际市场: 符合 GDPR 要求的隐私文案
- [ ] 根据地区自动选择对应文案

## Technical Notes

### 架构设计
```
lib/features/privacy/
├── data/
│   ├── datasources/
│   │   └── privacy_local_data_source.dart  # 本地存储
│   ├── models/
│   │   ├── privacy_consent.dart            # 同意记录
│   │   └── region_config.dart              # 地区配置
│   ├── services/
│   │   └── account_service_mock.dart       # Mock 注销 API
│   └── repositories/
│       └── privacy_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── privacy_state.dart
│   ├── repositories/
│   │   └── privacy_repository.dart
│   └── usecases/
│       ├── check_consent.dart
│       ├── save_consent.dart
│       └── delete_account.dart
└── presentation/
    ├── providers/
    │   ├── privacy_provider.dart           # 隐私状态管理
    │   └── region_provider.dart            # 地区管理
    ├── screens/
    │   ├── privacy_consent_screen.dart     # 首次启动弹窗
    │   ├── permission_rationale_screen.dart # 权限说明
    │   ├── account_deletion_screen.dart    # 注销流程
    │   └── privacy_settings_screen.dart    # 隐私设置
    └── widgets/
        ├── privacy_dialog.dart
        └── permission_card.dart
```

### 关键实现
- **地区检测**: 使用 `WidgetsBinding.instance.platformDispatcher.locale`
- **存储**: 使用 `shared_preferences` 或 Drift 存储同意状态
- **权限**: 使用 `permission_handler` 包
- **弹窗**: 使用 `showDialog` 或底部弹窗

## Acceptance Criteria
- [ ] APP 首次启动必须显示隐私弹窗
- [ ] 用户不同意则无法使用 APP
- [ ] 所有权限申请前都有说明
- [ ] 用户可以完成账号注销流程
- [ ] 隐私设置页功能完整
- [ ] 中英文文案切换正确

## Definition of Done
- [ ] Lint / typecheck 通过
- [ ] 国际化字符串已提取
- [ ] 深色模式适配
- [ ] 手动测试通过

## Out of Scope
- 真实的后端 API 对接
- 实际的法律文档（使用占位文案）
- 未成年人保护专项（后续迭代）
