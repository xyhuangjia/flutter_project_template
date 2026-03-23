# 基于 Talker 的日志上传系统

## 目标
实现一个基于 Talker 的日志系统，支持将本地日志文件上传到自定义服务器。

## 现有代码
- `lib/core/logging/talker_config.dart` - 基础 Talker 配置
- `lib/core/logging/log_config.dart` - 日志配置模型（已定义 LogUploadConfig、LogStorageConfig）

## 需求确认

### 1. 上传触发方式
- ✅ **两者都支持**：自动上传 + 手动上传
- 自动上传：可配置间隔时间
- 手动上传：提供方法供外部调用

### 2. UI 设置界面
- ❌ **不需要 UI**
- 仅通过代码配置（环境变量或配置文件）

### 3. 认证方式
- ✅ **通过 Headers 配置**
- 在 `LogUploadConfig.headers` 中配置 Authorization 等

### 4. 上传数据格式
- ✅ **上传本地日志文件**
- 利用 `talker_persistent` 保存的日志文件
- 以文件形式上传到服务器

## 功能范围

### 核心功能
1. **日志持久化服务** - 基于 TalkerObserver（自定义实现）
2. **日志上传服务** - 支持文件上传
3. **自动上传调度** - 定时上传
4. **手动上传接口** - Provider 暴露上传方法

### 配置项
- 服务器 URL
- 请求 Headers（认证信息）
- 自动上传开关
- 上传间隔
- 批量大小
- 仅 WiFi 上传

## 技术方案

### 文件结构
```
lib/core/logging/
├── talker_config.dart          # Talker 基础配置 (已有，需修改)
├── log_config.dart              # 配置模型 (已有)
├── log_persistence_service.dart # 日志持久化服务 (新增，使用 TalkerObserver)
├── log_upload_service.dart      # 日志上传服务 (新增)
└── log_upload_provider.dart     # Riverpod Provider (新增)
```

### 依赖
- `talker_persistent` - 日志持久化 (已安装)
- `dio` - HTTP 上传 (已安装)
- `flutter_riverpod` - 状态管理 (已安装)

## 验收标准
- [ ] 日志能正常持久化到本地文件
- [ ] 支持配置服务器 URL 和认证 Headers
- [ ] 支持手动触发上传
- [ ] 支持自动定时上传
- [ ] 上传失败有重试机制
- [ ] 代码符合项目规范（lint 通过）