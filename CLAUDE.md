# iOS 贪吃蛇项目 - AI 指令文档

## 项目概述

使用 SwiftUI 开发的复古像素风贪吃蛇游戏，采用 MVVM 架构。

**核心特色**: 复古像素风 + 双控制模式（滑动 + 虚拟十字键）
**技术栈**: SwiftUI + Combine + MVVM
**目标**: 业余工程师学习 vibe coding

---

## 核心原则

- **KISS**: 最简单直接的实现方式，代码可读性优先
- **YAGNI**: 严格按 Phase 分阶段开发，不提前实现未来功能
- **DRY**: 主题配置统一管理，公共组件复用
- **SOLID**: ViewModel 管逻辑，View 管渲染，严格分离

---

## 项目结构

```
SnakeGame/
├── Models/          # Point, Direction, GameState
├── ViewModels/      # GameViewModel (核心逻辑)
├── Views/           # GameView, GridView, ControlPadView
├── Utilities/       # Theme, Color+Hex, Managers
└── App/             # SnakeGameApp
```

---

## 设计规范速查

**色彩（绿屏终端主题）**:
- 背景: `#000000` (纯黑)
- 蛇身: `#00FF00` (荧光绿，圆角 3px)
- 食物: `#FF0000` (红色圆形)

**游戏配置**:
- 网格: 20x30
- 速度: 0.2 秒/格
- 初始长度: 3

**布局**:
- 顶部栏: 44pt（分数 + 设置）
- 虚拟十字键: 右下角，60pt 圆心，透明度 0.6

---

## 开发流程（当前 Phase 1）

### 任务清单
1. ✅ 设计文档和计划（已完成）
2. ⏳ 创建 Xcode 项目结构
3. ⏳ 实现 Models 层（Point/Direction/GameState）
4. ⏳ 实现 GameViewModel 核心逻辑
5. ⏳ 实现基础 GridView 渲染
6. ⏳ 实现滑动手势控制
7. ⏳ 测试完整游戏流程

**验收标准**: 能用滑动手势玩完整游戏

---

## 推荐 Agents

**Phase 1 核心**:
- `multi-platform-apps:ios-developer` - 所有 Swift/SwiftUI 代码实现
- `multi-platform-apps:ui-ux-designer` - UI/UX 设计验证和优化

**测试和审查**:
- `superpowers:test-driven-development` - 先写测试
- `superpowers:verification-before-completion` - 验证功能
- `superpowers:requesting-code-review` - 代码审查

**Git 操作**:
- `zcf:git-commit` - 规范 commit message

---

## 相关文档

- 完整设计: `docs/plans/2026-01-12-ios-snake-design.md`
- 实现计划: `docs/plans/2026-01-12-phase1-implementation.md`
- 全局偏好: `~/.claude/CLAUDE.md`
