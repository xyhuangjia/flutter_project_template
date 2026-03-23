# Chinese App Style Design Guidelines

> 中国App风格设计指南，确保整个项目UI风格一致性。

---

## Overview

本文档定义了项目中采用的中国App风格设计规范，包括布局、颜色、组件等核心要素。所有新页面开发都应遵循此规范。

---

## Core Design Principles

### 1. 页面头部样式选择 (Header Style Selection)

根据页面类型选择合适的头部样式：

#### 1.1 标准 AppBar（推荐）

**适用场景**：大多数普通页面（设置、详情、列表等）

```dart
Scaffold(
  backgroundColor: colorScheme.surfaceContainerLow,
  appBar: AppBar(
    title: Text(localizations.pageTitle),
  ),
  body: // Content
)
```

**特点**：
- 使用 Material 3 标准 AppBar
- 自动处理返回按钮、标题居中等
- 支持深色模式
- 简洁、统一

#### 1.2 沉浸式渐变头部

**适用场景**：首页、特殊展示页面

```dart
CustomScrollView(
  slivers: [
    SliverToBoxAdapter(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary,
              colorScheme.primaryContainer,
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: // Header content
          ),
        ),
      ),
    ),
    // Content...
  ],
)
```

**特点**：
- 使用 `primary` 到 `primaryContainer` 的渐变
- `SafeArea` 只处理顶部，底部延伸到内容区
- 左上角到右下角对角线渐变
- 白色/亮色文字在渐变背景上
- **仅用于首页等特殊展示页面**

#### 选择规则

| 页面类型 | 推荐头部样式 |
|---------|------------|
| 首页 | 沉浸式渐变头部 |
| 设置页、详情页、列表页 | 标准 AppBar |
| 表单页、编辑页 | 标准 AppBar |
| 关于页、帮助页 | 标准 AppBar |

### 2. 卡片式分组 (Card Grouping)

```dart
Container(
  decoration: BoxDecoration(
    color: colorScheme.surface,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: colorScheme.shadow.withValues(alpha: 0.05),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: children,
  ),
)
```

**特点**：
- 16px 圆角
- 轻微阴影 (5% 透明度, 10px 模糊, 2px Y偏移)
- 白色背景（或 surface 颜色）
- 垂直排列子元素

### 3. 分段标题 (Section Title)

```dart
Row(
  children: [
    Container(
      width: 4,
      height: 18,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
    const SizedBox(width: 8),
    Text(
      title,
      style: textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
)
```

**特点**：
- 左侧带颜色的竖条 (4px 宽, 18px 高)
- 标题字体加粗
- 使用主题色

### 4. 图标带背景色 (Icon with Background)

```dart
Container(
  padding: const EdgeInsets.all(8),
  decoration: BoxDecoration(
    color: iconBgColor, // 图标背景色
    borderRadius: BorderRadius.circular(10),
  ),
  child: Icon(
    icon,
    size: 22,
    color: iconColor, // 图标颜色
  ),
)
```

**特点**：
- 10px 圆角
- 8px 内边距
- 图标大小 22px
- 背景色为图标颜色的 10% 透明度

---

## Color Palette

### Icon Colors

| 用途 | 颜色代码 | 背景色 |
|------|---------|--------|
| 主题/通用 | `primary` (#1677FF) | `primaryContainer` (#E6F4FF) |
| 语言/国际化 | `#1677FF` (蓝) | `#E6F4FF` |
| 主题切换 | `#FA8C16` (橙) | `#FFF7E6` |
| 通知 | `#EB2F96` (洋红) | `#FFF0F6` |
| AI助手 | `#1677FF` (蓝) | `#E6F4FF` |
| 关于/信息 | `#13C2C2` (青) | `#E6FFFB` |
| 隐私/安全 | `#52C41A` (绿) | `#F6FFED` |
| 开发者选项 | `#595959` (灰) | `#F5F5F5` |
| 退出/危险 | `error` (#FF4D4F) | `errorContainer` (#FFF2F0) |

### Pre-defined Color Pairs

```dart
// 预定义图标颜色组合 (基于 Ant Design 色板)
const iconColorPairs = {
  'language': (color: Color(0xFF1677FF), bg: Color(0xFFE6F4FF)),
  'theme': (color: Color(0xFFFA8C16), bg: Color(0xFFFFF7E6)),
  'notification': (color: Color(0xFFEB2F96), bg: Color(0xFFFFF0F6)),
  'ai': (color: Color(0xFF1677FF), bg: Color(0xFFE6F4FF)),
  'info': (color: Color(0xFF13C2C2), bg: Color(0xFFE6FFFB)),
  'privacy': (color: Color(0xFF52C41A), bg: Color(0xFFF6FFED)),
  'developer': (color: Color(0xFF595959), bg: Color(0xFFF5F5F5)),
};
```

---

## Layout Patterns

### Page Background

```dart
Scaffold(
  backgroundColor: colorScheme.surfaceContainerLow,
  body: // Content
)
```

- 使用 `surfaceContainerLow` 作为页面背景色
- 比纯白色更有层次感

### Content Padding

```dart
SliverPadding(
  padding: const EdgeInsets.all(16),
  sliver: // Content
)
```

- 统一使用 16px 外边距
- 卡片间距 16px

### Card Internal Spacing

```dart
// 卡片内部分隔线
Padding(
  padding: const EdgeInsets.only(left: 60), // 对齐图标后的内容
  child: Divider(
    height: 1,
    color: colorScheme.surfaceContainerHighest,
  ),
)
```

---

## Component Specifications

### SettingsTile

```dart
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.iconBgColor,
    this.trailing,
    this.onTap,
    this.showChevron = true,
    this.titleColor,
  });
}
```

**内部布局**：
- 水平内边距: 16px
- 垂直内边距: 12px
- 图标与标题间距: 12px
- 标题字重: w500

### Grid Module (首页风格)

```dart
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    mainAxisSpacing: 16,
    crossAxisSpacing: 16,
  ),
)
```

**特点**：
- 3列网格
- 16px 间距
- 图标容器 12px 内边距, 12px 圆角

---

## Typography

### Title Styles

| 类型 | 样式 |
|------|------|
| 页面标题 | `headlineSmall` + `bold` |
| 分段标题 | `titleMedium` + `bold` |
| 列表项标题 | `bodyLarge` + `w500` |
| 副标题 | `bodySmall` + `onSurfaceVariant` |
| 当前值显示 | `bodyMedium` + `onSurfaceVariant` |

---

## Scroll Behavior

```dart
CustomScrollView(
  physics: const AlwaysScrollableScrollPhysics(),
  slivers: [
    // Header (SliverToBoxAdapter)
    // Content (SliverPadding + SliverList)
  ],
)
```

**特点**：
- 使用 `CustomScrollView` + Sliver 实现联动滚动
- 始终可滚动，即使内容不足

---

## Dark Mode Support

所有颜色都应通过 `ColorScheme` 或预定义的深色模式适配颜色来支持深色模式：

```dart
// 正确：使用 ColorScheme
color: colorScheme.primary,
bgColor: colorScheme.primaryContainer,

// 正确：深色模式适配
final theme = Theme.of(context);
pickerStyle: theme.brightness == Brightness.dark
    ? DefaultPickerStyle.dark()
    : DefaultPickerStyle(),
```

---

## Common Patterns

### 带选择器的列表项

```dart
InkWell(
  onTap: () {
    // 显示选择器
  },
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        Container(/* Icon with bg */),
        const SizedBox(width: 12),
        Expanded(child: Text(title)),
        Text(currentValue),
        Icon(Icons.chevron_right_rounded, size: 20),
      ],
    ),
  ),
)
```

### 带开关的列表项

```dart
SettingsTile(
  title: localizations.notifications,
  icon: Icons.notifications_outlined,
  iconColor: const Color(0xFFEC4899),
  iconBgColor: const Color(0xFFFDF2F8),
  trailing: Switch(
    value: settings.notificationsEnabled,
    onChanged: (value) {
      // 更新状态
    },
  ),
  showChevron: false,
)
```

---

## Responsive Design & Tablet Adaptation

> 响应式设计与平板适配规范

### 设计稿基准

**基准宽度**: 375pt (iPhone 标准)

| 设计稿类型 | 基准宽度 | 转换规则 |
|-----------|---------|---------|
| iOS 设计稿 | 375pt | **直接使用** - 与 Flutter 逻辑像素 1:1 对应 |
| Android 设计稿 | 360dp | 乘以 375/360 ≈ 1.04 |
| 2x 标注稿 | 750px | 除以 2 转换为逻辑像素 |
| 3x 标注稿 | 1125px | 除以 3 转换为逻辑像素 |

**转换示例**:
```dart
// 375pt 基准设计稿 → Flutter 代码 (直接使用)
设计稿: 16px  → 代码: 16.0
设计稿: 20px  → 代码: 20.0
设计稿: 375px → 代码: 375.0 (满屏宽度)
```

### 设备断点

使用 `Breakpoints` 类定义的断点:

```dart
import 'package:flutter_project_template/core/theme/theme.dart';

LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth >= Breakpoints.mobile) {
      // 平板布局
    }
    return MobileLayout();
  },
)
```

| 断点 | 宽度范围 | 设备类型 |
|------|---------|---------|
| `< 600px` | 手机 | Phone |
| `600px - 840px` | 平板竖屏 | Tablet Portrait |
| `840px - 1200px` | 平板横屏 | Tablet Landscape |
| `≥ 1200px` | 桌面 | Desktop |

### 固定尺寸 vs 弹性尺寸

#### 固定尺寸 (不随设备变化)

| 元素类型 | 处理方式 | 示例 |
|---------|---------|------|
| 字体大小 | 固定值 | `fontSize: 16` |
| 图标大小 | 固定值 | `Icon(size: 24)` |
| 按钮高度 | 固定值 | `height: 48` |
| 圆角 | 固定值 | `BorderRadius.circular(16)` |
| 小间距 | 固定值 | `SizedBox(height: 8)` |

#### 弹性尺寸 (响应式调整)

| 元素类型 | 手机 | 平板 | 获取方式 |
|---------|------|------|---------|
| 页面内边距 | 16px | 24px | `context.spacing.pagePadding` |
| 卡片内边距 | 16px | 20px | `context.spacing.cardPadding` |
| 卡片间距 | 16px | 20px | `context.spacing.cardSpacing` |
| 列表项高度 | 56px | 64px | `context.spacing.listItemHeight` |

### 平板布局策略

#### 方式 1: 完全独立布局 (推荐用于差异大的页面)

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _MobileLayout(),
      tablet: _TabletLayout(),
      desktop: _DesktopLayout(),
    );
  }

  Widget _MobileLayout() {
    // 手机专用布局
    return Scaffold(
      appBar: AppBar(title: Text('Title')),
      body: ListView(children: [...]),
    );
  }

  Widget _TabletLayout() {
    // 平板专用布局
    return Scaffold(
      body: Row(
        children: [
          SizedBox(width: 280, child: _NavigationRail()),
          Expanded(child: _Content()),
        ],
      ),
    );
  }
}
```

#### 方式 2: 内容约束 (用于表单、卡片等内容)

```dart
ConstrainedContent(
  maxWidth: ContentConstraints.form,  // 400px
  child: LoginForm(),
)
```

#### 方式 3: 响应式数值选择

```dart
final columns = context.selectValue(
  mobile: 3,
  tablet: 4,
  desktop: 6,
);

return GridView.count(
  crossAxisCount: columns,
  children: items,
);
```

### 平板专属设计要点

| 设计元素 | 手机布局 | 平板布局 |
|---------|---------|---------|
| 导航 | 底部导航栏 | 侧边导航栏 / 底部导航+侧边详情 |
| 列表 | 单列列表 | 双栏 Master-Detail 或多列 Grid |
| 表单 | 单列垂直表单 | 双列表单或卡片式分组 |
| 详情页 | 全屏页面 | 右侧面板或 Modal |
| 内边距 | 16px | 24-32px |
| 网格列数 | 3 | 4-6 |

### 内容最大宽度约束

使用 `ContentConstraints` 类:

```dart
ConstrainedBox(
  constraints: BoxConstraints(
    maxWidth: ContentConstraints.form,  // 400px
  ),
  child: MyForm(),
)
```

| 内容类型 | 最大宽度 | 用途 |
|---------|---------|------|
| `form` | 400px | 登录、注册等表单 |
| `card` | 600px | 卡片内容 |
| `text` | 680px | 正文、文章 |
| `list` | 840px | 列表页面 |
| `masterDetail` | 1200px | 双栏布局 |

---

## Checklist for New Pages

开发新页面时，确保：

- [ ] 页面背景使用 `surfaceContainerLow`
- [ ] 头部样式正确选择：普通页面用 AppBar，首页等特殊页面用沉浸式头部
- [ ] 内容分组使用卡片式布局
- [ ] 分段标题带竖条装饰
- [ ] 图标使用带背景色的样式
- [ ] 圆角统一使用 16px (卡片) / 10-12px (图标容器)
- [ ] 支持深色模式
- [ ] 使用 `CustomScrollView` 或 `SingleChildScrollView` 实现滚动
- [ ] **平板适配**: 使用 `ResponsiveLayout` 或 `ConstrainedContent`
- [ ] **响应式间距**: 使用 `context.spacing` 获取响应式数值

---

## Reference Files

| 文件 | 说明 |
|------|------|
| `lib/core/theme/breakpoints.dart` | 断点定义、响应式间距 |
| `lib/shared/widgets/responsive_layout.dart` | 响应式布局组件 |
| `home_screen.dart` | 首页示例（沉浸式头部） |
| `settings_screen.dart` | 设置页面示例（标准 AppBar + 卡片式布局） |
| `login_screen.dart` | 登录页面示例（平板独立布局） |
| `about_screen.dart` | 关于页面示例（标准 AppBar） |
| `profile_screen.dart` | 个人资料页面示例（标准 AppBar + 卡片式布局） |
| `change_password_screen.dart` | 修改密码页面示例（表单卡片） |
| `settings_tile.dart` | 列表项组件 |
| `theme_selector.dart` | 选择器组件 |

---

**Note**: 本文档应与 `.trellis/spec/frontend/component-guidelines.md` 配合使用，本文件专注于中国App风格的设计规范。