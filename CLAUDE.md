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
├── Views/           # GameView, GridView, ControlPadView, SettingsView
├── Utilities/       # Theme, Color+Hex, SoundManager, HapticManager
└── App/             # SnakeGameApp
```

---

## 设计规范速查

**色彩（绿屏终端主题）**:
- 背景: `#000000` (纯黑)
- 蛇身: `#00FF00` (荧光绿，圆角 3px)
- 食物: `#FF0000` (红色圆形)

**游戏配置**:
- 网格: 20x25（为虚拟十字键留出空间）
- 速度: 0.2 秒/格
- 初始长度: 3

**布局**:
- 顶部栏: 60pt（当前分数 + 最高分 + 设置）
- 游戏网格: 占据剩余空间，底部避开虚拟十字键
- 虚拟十字键: 右下角，60pt 圆心，透明度 0.6

---

## AI 工作流程要求

### 必须使用的 Agents

**开发阶段**:
- `multi-platform-apps:ios-developer` - 所有 Swift/SwiftUI 代码实现
- `multi-platform-apps:ui-ux-designer` - UI/UX 设计验证和优化

**质量保证**:
- `superpowers:test-driven-development` - 先写测试
- `superpowers:verification-before-completion` - 验证功能后才能声称完成
- `superpowers:requesting-code-review` - 完成主要功能后必须审查

**版本控制**:
- `zcf:git-commit` - 规范 commit message
- ⚠️ **关键约束**: 除非用户明确要求，否则绝对不要执行 git commit/push/branch 操作

### 工作流程检查清单

在开始任何工作前，必须检查：
- [ ] 是否有推荐的 Agent 可用？如果有，必须使用 Skill tool 调用
- [ ] 是否需要验证？必须使用 verification-before-completion
- [ ] 是否完成了主要功能？必须使用 requesting-code-review

在声称任何完成状态前：
- [ ] 已运行验证命令并看到输出
- [ ] 已获得用户确认或有实际证据
- [ ] 不使用"应该"、"可能"、"似乎"等词汇

---

## 相关文档

- 完整设计: `docs/plans/2026-01-12-ios-snake-design.md`
- 实现计划: `docs/plans/`
- 项目状态: 查看 git log 或询问用户
- 全局偏好: `~/.claude/CLAUDE.md`

---

## 违规记录与强化机制

**已知违规行为**:
1. ❌ 未使用推荐的 Agents（直接编写代码而非调用 ios-developer agent）
2. ❌ 添加过多表情符号（违反全局 CLAUDE.md 的简洁性要求）
3. ❌ 将 CLAUDE.md 当作 changelog 使用（本次）

**强化措施**:
- 在每次开始工作时，重新阅读本文档的"AI 工作流程要求"部分
- 遇到推荐 Agent 必须使用，无例外
- 验证前不得声称完成
- CLAUDE.md 仅用于 AI 指令，不记录进度

**自检问题**:
1. 我是否应该调用 Agent 而不是直接做？
2. 我是否在没有证据的情况下声称完成？
3. 我是否在修改不应该修改的文档类型？
