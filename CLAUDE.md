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
- 顶部栏: 60pt（当前分数 + 最高分 + 设置）
- 游戏网格: 20x25（为虚拟十字键留出空间）
- 虚拟十字键: 右下角，60pt 圆心，透明度 0.6

---

## 开发流程（当前已完成 Phase 1-3）

### Phase 1: 核心游戏逻辑 ✅
1. ✅ 设计文档和计划
2. ✅ 创建 Xcode 项目结构
3. ✅ 实现 Models 层（Point/Direction/GameState）
4. ✅ 实现 GameViewModel 核心逻辑
5. ✅ 实现基础 GridView 渲染
6. ✅ 实现滑动手势控制
7. ✅ 测试完整游戏流程

**验收标准**: ✅ 能用滑动手势玩完整游戏

### Phase 2: UI/UX 完善 ✅
1. ✅ 虚拟十字键控制（带暂停功能）
2. ✅ 双主题系统（绿屏终端 + GameBoy）
3. ✅ 游戏状态动画（倒数 3-2-1）
4. ✅ 设置页面（主题切换）
5. ✅ 主题持久化（UserDefaults）

**验收标准**: ✅ 完整的像素风界面和双控制模式

### Phase 3: 音效与反馈 ✅
1. ✅ 音效系统（吃食物 + 游戏结束）
2. ✅ 触觉反馈系统（轻触觉 + 重触觉）
3. ✅ 最高分记录（UserDefaults 持久化）
4. ✅ 音效/震动开关（设置页面）

**验收标准**: ✅ 完整的感官反馈系统

### 已实现的核心功能
- 双控制模式：滑动手势 + 虚拟十字键
- 暂停/恢复：虚拟十字键中央按钮
- 双主题切换：绿屏终端 + GameBoy
- 音效与触觉反馈（可配置开关）
- 最高分记录与显示
- 游戏区域优化（避开虚拟十字键）

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
- Phase 1 实现计划: `docs/plans/2026-01-12-phase1-implementation.md`
- Phase 2 完成报告: `docs/PHASE2_COMPLETION_REPORT.md`
- Phase 3 实现计划: `docs/plans/2026-01-12-phase3-implementation.md`
- 全局偏好: `~/.claude/CLAUDE.md`
- 代码审查报告: 由 superpowers:code-reviewer 生成

## 项目状态

**当前版本**: 1.0.0 - Phase 3 完成
**测试状态**: 15/15 单元测试通过
**运行状态**: 可在 iOS 模拟器运行
**代码质量**: ⭐⭐⭐⭐☆ (4.6/5)

## 下一步（可选）

Phase 4 优化与扩展功能可根据需要实现。
