# OMO (Oh My OpenCode) 配置指南

## 📋 概述

本项目已配置 **Alibaba Coding Plan (China)** 作为 OMO 的主要模型提供商，包含 4 个顶级模型：

- **通义千问 Qwen3.5-Plus** - 支持图片理解、多模态
- **智谱 GLM-5** - 编程推理能力强
- **月之暗面 Kimi K2.5** - 支持图片理解
- **MiniMax M2.5** - 专注 Agent 用例

---

## 🔧 配置文件

### OpenCode 全局配置
- **位置**: `~/.config/opencode/opencode.json`
- **作用**: 配置默认模型和主题
- **当前设置**: `alibaba/qwen-plus`（推荐模型）

### Oh My OpenCode 配置
- **位置**: `~/.config/opencode/oh-my-opencode.json`
- **作用**: 多模型管理和 Agent 配置

---

## 🤖 配置的模型

| 模型 ID | 模型名称 | Base URL | 特性 |
|---------|---------|----------|-------|
| `qwen-plus` | 通义千问 Qwen3.5-Plus | https://coding-intl.dashscope.aliyuncs.com/v1 | ✅ 图片理解、多模态 |
| `glm-5` | 智谱 GLM-5 | https://coding-intl.dashscope.aliyuncs.com/v1 | ❌ 纯文本 |
| `kimi-k2.5` | 月之暗面 Kimi K2.5 | https://coding-intl.dashscope.aliyuncs.com/v1 | ✅ 图片理解 |
| `minimax-m2.5` | MiniMax M2.5 | https://coding-intl.dashscope.aliyuncs.com/v1 | ❌ 纯文本 |

---

## 🤖 Agent 模型分配

| Agent | 默认模型 | 温度 | 用途 |
|-------|----------|-------|--------|
| `sisyphus` | qwen-plus | 0.7 | 主编排 |
| `oracle` | glm-5 | 0.3 | 深度推理 |
| `librarian` | qwen-plus | 0.5 | 代码搜索 |
| `explore` | qwen-plus | 0.5 | 代码探索 |
| `multimodal-looker` | kimi-k2.5 | 0.8 | 视觉分析 |
| `prometheus` | qwen-plus | 0.5 | 规划 |
| `metis` | glm-5 | 0.5 | 数据分析 |
| `momus` | qwen-plus | 0.5 | 多模态 |
| `atlas` | glm-5 | 0.5 | 综合分析 |
| `sisyphus-junior` | glm-5 | 0.8 | 辅助 |

---

## 📂 Categories 模型分配

| Category | 推荐模型 | 适用场景 |
|----------|----------|---------|
| `visual-engineering` | sisyphus (qwen-plus) | UI/视觉设计 |
| `ultrabrain` | oracle/prometheus (glm-5/qwen-plus) | 深度推理/规划 |
| `frontend` | frontend-ui-ux-engineer (kimi-k2.5) | 前端开发 |
| `unspecified` | librarian/explore/multimodal-looker (qwen-plus) | 通用任务 |

---

## 🚀 使用方法

### 1. 设置 API Key

```bash
# 编辑 ~/.config/opencode/opencode.json
nano ~/.config/opencode/opencode.json
```

添加 API Key 到 `env` 字段：

```json
{
  "env": {
    "ALIBABA_API_KEY": "sk-sp-xxxxxxxxxxxx"
  }
}
```

### 2. 启动 OMO

```bash
# 直接启动（会使用 oh-my-opencode.json 配置）
opencode

# 或使用 OpenCode（已配置 Oh My OpenCode 插件）
clother
```

### 3. 切换模型

在 OMO 中：

```bash
# 切换到通义千问
clother-alibaba --model qwen-plus

# 切换到智谱
clother-alibaba --model glm-5

# 切换到月之暗面
clother-alibaba --model kimi-k2.5

# 切换到 MiniMax
clother-alibaba --model minimax-m2.5
```

或在 `.opencode/AGENTS.md` 中指定：

```markdown
# @oracle - 深度分析，使用智谱 GLM-5
oracle: model=alibaba/glm-5

# @multimodal-looker - 视觉分析，使用月之暗面
multimodal-looker: model=alibaba/kimi-k2.5
```

### 4. 在 Flutter 项目中使用

在项目根目录创建或更新 `.opencode/AGENTS.md`：

```markdown
# @sisyphus - 主编排，使用 Qwen3.5-Plus
sisyphus: model=alibaba/qwen-plus

# @oracle - 深度推理，使用智谱 GLM-5
oracle: model=alibaba/glm-5

# @frontend-ui-ux-engineer - 前端开发，使用月之暗面
frontend-ui-ux-engineer: model=alibaba/kimi-k2.5
```

---

## ⚙️ 高级配置

### 自动切换策略（可选）

可以根据任务类型自动切换模型：

1. **工作时间**: 使用智谱 GLM-5（性价比高）
2. **复杂推理**: 使用通义千问 Qwen3.5-Plus（能力强）
3. **视觉任务**: 使用月之暗面 Kimi K2.5
4. **简单任务**: 使用 MiniMax M2.5（快速响应）

在 `~/.config/opencode/opencode.json` 中配置 `model` 为 `auto`，然后在 Oh My OpenCode 中实现自动切换逻辑。

### 多模型协作

启用多个 Agent 协作，利用不同模型的优势：

```markdown
# 编排使用通义千问，探索使用智谱，视觉分析使用月之暗面
sisyphus: model=alibaba/qwen-plus
oracle: model=alibaba/glm-5
multimodal-looker: model=alibaba/kimi-k2.5
```

---

## 📊 模型能力对比

### Qwen3.5-Plus (推荐用于通用任务)
- ✅ 128K 上下文
- ✅ 支持图片理解
- ✅ 多模态能力
- ✅ 编程能力强
- 💰 成本：中等

### GLM-5 (推荐用于深度推理)
- ✅ 逻辑推理强
- ✅ 代码生成好
- ❌ 不支持图片
- 💰 成本：低

### Kimi K2.5 (推荐用于视觉任务)
- ✅ 支持图片理解
- ✅ 中文理解好
- ❌ 编程能力一般
- 💰 成本：中等

### MiniMax M2.5 (推荐用于快速响应)
- ✅ 响应速度快
- ✅ Agent 优化
- ❌ 不支持图片
- 💰 成本：低

---

## 🔄 更新配置

当需要更新模型配置时：

1. 编辑 `~/.config/opencode/oh-my-opencode.json`
2. 编辑 `~/.config/opencode/opencode.json`（可选）
3. 重启 OpenCode 或 OMO
4. 运行 `opencode --init` 重新初始化项目

---

## 📖 参考资料

- [Alibaba Coding Plan 官方文档](https://help.aliyun.com/zh/model-studio/coding-plan)
- [Oh My OpenCode GitHub](https://github.com/frankieeW/oh-my-opencode)
- [OpenCode 文档](https://opencode.ai/docs)
- [Flutter 项目模板](.)

---

## ⚠️ 重要提示

1. **API Key 安全**: 不要将 API Key 提交到代码仓库
2. **成本控制**: 注意模型选择，避免超支
3. **上下文管理**: 复杂任务使用 Qwen3.5-Plus（128K 上下文）
4. **模型组合**: 不同 Agent 使用不同模型，发挥各自优势
5. **配置验证**: 配置修改后重启 OMO 生效

---

*最后更新: 2026-03-22*
