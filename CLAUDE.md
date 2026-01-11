# iOS 贪吃蛇项目 - Claude Code 指令文档

## 项目概述

这是一个使用 SwiftUI 开发的复古像素风贪吃蛇游戏，采用 MVVM 架构模式。

**目标用户**: 业余工程师学习 vibe coding
**核心特色**: 复古像素风 + 现代 SwiftUI + 双控制模式
**技术栈**: SwiftUI + Combine + MVVM

---

## 架构约束

### 核心原则

**KISS 原则（极致简洁）**:
- 选择最简单直接的实现方式
- 代码可读性优先于聪明技巧
- 避免过度抽象和复杂设计

**YAGNI 原则（只做当前需要的）**:
- 严格按照设计文档的 Phase 分阶段开发
- 不提前实现未来功能
- 不添加"可能用得上"的代码

**DRY 原则（杜绝重复）**:
- 主题配置统一在 `Theme.swift` 管理
- 公共 UI 组件（如像素文字）必须复用
- 相似逻辑抽取为扩展方法

**SOLID 原则**:
- **单一职责**: ViewModel 只管逻辑，View 只管渲染
- **开闭原则**: 新增主题不修改现有代码，只添加配置
- **依赖倒置**: 音效/触觉通过 Manager 抽象，不直接调用系统 API

### 技术约束

**必须遵守**:
- 使用 SwiftUI，禁止 UIKit
- MVVM 架构，Model/ViewModel/View 严格分离
- 所有状态用 `@Published` 管理
- 游戏循环使用 `Timer.publish + Combine`
- 坐标系统使用自定义 `Point` 结构体
- 渲染使用 `GeometryReader + ForEach`

**禁止使用**:
- SpriteKit 或其他游戏引擎
- 第三方 UI 框架
- 复杂状态管理库（如 TCA）
- 过度的动画库

---

## 项目结构规范

```
SnakeGame/
├── App/
│   └── SnakeGameApp.swift          # App 入口点
├── Models/
│   ├── Point.swift                 # 坐标结构体（Hashable）
│   ├── Direction.swift             # 方向枚举（含 opposite 属性）
│   └── GameState.swift             # 游戏状态枚举
├── ViewModels/
│   └── GameViewModel.swift         # 游戏逻辑核心（ObservableObject）
├── Views/
│   ├── GameView.swift              # 主游戏界面
│   ├── GridView.swift              # 网格渲染
│   ├── ControlPadView.swift        # 虚拟十字键
│   ├── SettingsView.swift          # 设置页面
│   └── Components/
│       └── PixelText.swift         # 像素风文字组件
├── Utilities/
│   ├── Theme.swift                 # 主题配置枚举
│   ├── SoundManager.swift          # 音效管理器
│   └── HapticManager.swift         # 触觉反馈管理器
└── Resources/
    └── Sounds/                     # 8-bit 音效资源
```

**文件组织原则**:
- 按功能分层，不按模块分组
- 每个文件单一职责
- 文件名清晰描述内容

---

## UI/UX 设计规范

### 视觉风格

**复古像素风 - 柔和现代融合**:
- 无网格线，纯色背景
- 蛇身方块带 2-3px 圆角
- 食物为圆形
- 字体使用 SF Mono（等宽字体）

### 色彩方案

**主题 1: 绿屏终端（TerminalGreen）**:
```swift
背景: Color(hex: "000000")  // 纯黑
蛇身: Color(hex: "00FF00")  // 荧光绿
食物: Color(hex: "FF0000")  // 亮红
文字: Color(hex: "00FF00")  // 荧光绿
```

**主题 2: GameBoy 风格**:
```swift
背景: Color(hex: "0F380F")  // 暗绿
蛇身: Color(hex: "8BAC0F")  // 亮绿
食物: Color(hex: "306230")  // 中绿
文字: Color(hex: "8BAC0F")  // 亮绿
```

### 布局规范

**界面布局**:
```
┌─────────────────────────┐
│ 分数: 150          ⚙️   │ ← 高度 44pt
├─────────────────────────┤
│                         │
│     游戏网格区域          │ ← 自适应剩余空间
│     (20 x 30 格子)       │
│                         │
│                    [🎮] │ ← 右下角，距边缘 20pt
└─────────────────────────┘
```

**虚拟十字键规格**:
- 位置: 右下角（trailing: 20, bottom: 80）
- 中心圆: 直径 60pt
- 方向键: 40x40pt
- 透明度: 0.6（按下时 1.0）

### 动画规范

**状态过渡时长**:
- 倒数文字淡入淡出: 0.5 秒
- 游戏结束淡出: 1.0 秒
- 按钮按压: 0.1 秒
- 主题切换: 0.3 秒

**使用 SwiftUI 内置动画**:
```swift
.animation(.easeInOut(duration: 0.5), value: gameState)
```

---

## 代码规范

### 命名约定

**变量和属性**:
- 使用小驼峰: `gameState`, `gridWidth`
- 布尔值用 `is/has` 前缀: `isRunning`, `hasFood`
- 避免缩写: `direction` 而非 `dir`

**方法**:
- 动词开头: `startGame()`, `updateGame()`, `spawnFood()`
- 状态检查: `checkCollision()`, `validateMove()`

**类型**:
- 大驼峰: `GameViewModel`, `ControlPadView`
- 枚举 case 小驼峰: `.running`, `.gameOver`

### 注释规范

**代码注释语言**: 简体中文（与全局偏好一致）

**必须注释**:
- 复杂算法（如碰撞检测）
- 非直观的计算（如坐标转换）
- 临时解决方案（标注 TODO）

**注释示例**:
```swift
// 防止蛇 180 度反向转弯
guard newDirection != direction.opposite else { return }

// 计算每个格子的像素大小
let cellSize = min(
    size.width / CGFloat(gridWidth),
    size.height / CGFloat(gridHeight)
)
```

### 代码组织

**类内部组织顺序**:
```swift
class GameViewModel: ObservableObject {
    // 1. 常量配置
    let gridWidth = 20

    // 2. @Published 状态
    @Published var snake: [Point] = []

    // 3. 私有属性
    private var timer: AnyCancellable?

    // 4. 初始化方法
    init() { ... }

    // 5. 公开方法
    func startGame() { ... }

    // 6. 私有方法
    private func updateGame() { ... }
}
```

---

## 开发流程指导

### Phase 1: 核心游戏逻辑（当前优先）

**任务列表**:
1. 创建 Xcode 项目（iOS App, SwiftUI）
2. 实现 `Models/` 下的三个文件
3. 实现 `GameViewModel` 核心逻辑
4. 实现基础 `GridView` 渲染（仅绿屏主题）
5. 实现滑动手势控制
6. 测试完整游戏流程

**验收标准**: 能用滑动手势玩完整游戏

### Phase 2: UI/UX 完善

**任务列表**:
1. 实现 `ControlPadView` 虚拟十字键
2. 实现顶部分数栏
3. 实现游戏状态动画（倒数/暂停/Game Over）
4. 添加 GameBoy 主题到 `Theme.swift`
5. 实现 `SettingsView` 设置页面

**验收标准**: 完整像素风界面 + 双控制模式

### Phase 3: 音效与反馈

**任务列表**:
1. 集成 8-bit 音效文件
2. 实现 `SoundManager`
3. 实现 `HapticManager`
4. 在设置页添加开关
5. 使用 UserDefaults 保存最高分

**验收标准**: 完整感官反馈系统

---

## Agent 使用指南

### ⭐ 核心开发 Agents（claude-code-workflows 官方）

#### 1. `ios-developer` - iOS 开发专家 🎯
**描述**: Native iOS development with Swift/SwiftUI
- **优先级**: ⭐⭐⭐⭐⭐ (最高优先级，所有 iOS 代码实现必用)
- **适用场景**:
  - Phase 1-3 的所有 Swift/SwiftUI 代码编写
  - MVVM 架构实现和最佳实践
  - Combine 框架使用（Timer、@Published 等）
  - SwiftUI 视图开发和状态管理
  - Xcode 项目配置和构建问题
- **使用方式**: 通过 Task tool 调用 `ios-developer` agent
- **示例**: "使用 ios-developer 实现 GameViewModel 的核心逻辑"

#### 2. `ui-ux-designer` - UI/UX 设计专家 🎨
**描述**: Interface design, wireframes, design systems
- **优先级**: ⭐⭐⭐⭐⭐ (你最关心的部分)
- **适用场景**:
  - 验证复古像素风设计方案
  - 优化虚拟十字键布局和交互
  - 设计游戏界面动画过渡
  - 主题系统的视觉一致性检查
  - 响应式布局适配不同屏幕
- **使用方式**: 通过 Task tool 调用 `ui-ux-designer` agent
- **示例**: "使用 ui-ux-designer 优化虚拟十字键的视觉设计和交互反馈"

### 🔧 辅助开发 Agents

#### 3. `frontend-developer` - 前端开发专家
**描述**: React components, responsive layouts, client-side state management
- **优先级**: ⭐⭐⭐
- **适用场景**:
  - 响应式布局设计思路（虽然是 React，但概念通用）
  - 组件化和状态管理最佳实践
  - 客户端状态流转设计
- **使用方式**: 通过 Task tool 调用 `frontend-developer` agent
- **示例**: "使用 frontend-developer 设计 SwiftUI 组件的状态管理方案"

#### 4. `unity-developer` - 游戏开发专家
**描述**: Unity game development and optimization
- **优先级**: ⭐⭐
- **适用场景**:
  - 游戏循环优化建议
  - 碰撞检测算法设计
  - 游戏性能优化技巧
  - 帧率和渲染优化
- **使用方式**: 通过 Task tool 调用 `unity-developer` agent
- **示例**: "使用 unity-developer 优化游戏循环的性能"

### 🛠️ Superpowers 通用 Agents

#### 5. `superpowers:writing-plans`
- **时机**: 开始每个 Phase 之前
- **用途**: 将设计文档中的 Phase 转化为详细实现计划
- **示例**: "请根据设计文档的 Phase 1，生成详细的实现计划"

#### 6. `superpowers:using-git-worktrees`
- **时机**: 开始新功能开发前
- **用途**: 创建隔离的开发环境
- **示例**: "为 Phase 1 核心游戏逻辑创建 worktree"

#### 7. `superpowers:test-driven-development`
- **时机**: 实现任何核心逻辑前（如碰撞检测、食物生成）
- **用途**: 先写测试，确保逻辑正确
- **示例**: "为 GameViewModel 的碰撞检测方法编写测试"

#### 8. `superpowers:requesting-code-review`
- **时机**: 完成每个 Phase 后
- **用途**: 验证代码符合设计规范和编程原则
- **示例**: "审查 Phase 1 的实现，检查是否符合 KISS/YAGNI 原则"

#### 9. `superpowers:code-reviewer`
- **时机**: 重大功能完成后
- **用途**: 深度代码审查，发现潜在问题
- **示例**: "审查 GameViewModel 的完整实现"

#### 10. `superpowers:systematic-debugging`
- **时机**: 遇到 bug 或测试失败时
- **用途**: 系统化调试流程
- **示例**: "碰撞检测在边界时失效，帮我调试"

#### 11. `incident-response:devops-troubleshooter`
- **时机**: 性能问题或复杂技术问题
- **用途**: 深度技术分析
- **示例**: "游戏在 iPhone SE 上帧率低，帮我分析"

#### 12. `superpowers:verification-before-completion`
- **时机**: 声称完成任何功能前
- **用途**: 验证功能真正可用
- **示例**: "验证 Phase 1 所有功能可正常运行"

#### 13. `code-simplifier:code-simplifier`
- **时机**: 代码变复杂时
- **用途**: 重构简化代码
- **示例**: "简化 GridView 的渲染逻辑"

#### 14. `zcf:git-commit`
- **时机**: 需要提交代码时
- **用途**: 自动生成规范的 commit message
- **示例**: "提交 Phase 1 完成的代码"

#### 15. `zcf:git-cleanBranches`
- **时机**: 开发分支过多时
- **用途**: 清理已合并的分支
- **示例**: "清理已完成的 feature 分支"

---

## 推荐工作流程

### 🎯 标准开发流程（针对每个 Phase）

```
1. 计划阶段
   → 使用 superpowers:writing-plans 生成详细计划
   → 使用 superpowers:using-git-worktrees 创建隔离环境

2. 实现阶段（核心）
   → 使用 superpowers:test-driven-development 先写测试
   → 使用 ios-developer 实现 Swift/SwiftUI 代码 ⭐
   → 使用 ui-ux-designer 优化界面设计和交互 ⭐
   → 使用 unity-developer 优化游戏逻辑（如需要）

3. 验证阶段
   → 使用 superpowers:verification-before-completion 验证功能
   → 使用 superpowers:systematic-debugging 修复问题
   → 使用 incident-response:devops-troubleshooter 解决性能问题

4. 审查阶段
   → 使用 superpowers:requesting-code-review 自审
   → 使用 code-simplifier:code-simplifier 简化代码

5. 提交阶段
   → 使用 zcf:git-commit 提交代码
   → 使用 superpowers:finishing-a-development-branch 完成分支
```

### 📱 具体场景推荐

#### Phase 1: 核心游戏逻辑
```
1. 项目搭建
   → ios-developer: 创建 Xcode 项目结构

2. 数据模型
   → ios-developer: 实现 Point/Direction/GameState
   → superpowers:test-driven-development: 为模型编写测试

3. ViewModel 逻辑
   → ios-developer: 实现 GameViewModel 核心逻辑
   → unity-developer: 优化碰撞检测和游戏循环

4. 基础渲染
   → ios-developer: 实现 GridView
   → ui-ux-designer: 验证绿屏主题视觉效果

5. 手势控制
   → ios-developer: 实现滑动手势
   → ui-ux-designer: 优化手势响应体验
```

#### Phase 2: UI/UX 完善
```
1. 虚拟十字键
   → ui-ux-designer: 设计十字键布局和交互 ⭐
   → ios-developer: 实现 ControlPadView

2. 界面布局
   → ui-ux-designer: 优化分数栏和整体布局
   → ios-developer: 实现响应式适配

3. 动画效果
   → ui-ux-designer: 设计状态过渡动画
   → ios-developer: 实现 SwiftUI 动画

4. 主题系统
   → ui-ux-designer: 验证双主题视觉一致性
   → ios-developer: 实现 Theme.swift 和切换逻辑
```

#### Phase 3: 音效与反馈
```
1. 音效集成
   → ios-developer: 实现 SoundManager

2. 触觉反馈
   → ios-developer: 实现 HapticManager
   → ui-ux-designer: 验证反馈时机和强度

3. 设置页面
   → ui-ux-designer: 设计设置页面布局
   → ios-developer: 实现 SettingsView 和 UserDefaults
```

---

## 快速参考

### 关键数值

```swift
// 游戏配置
gridWidth: 20
gridHeight: 30
gameSpeed: 0.2 秒
initialSnakeLength: 3

// UI 尺寸
topBarHeight: 44pt
controlPadSize: 60pt (中心圆)
controlPadOpacity: 0.6
cornerPadding: 20pt
bottomPadding: 80pt

// 动画时长
countdownDuration: 0.5秒
gameOverFadeDuration: 1.0秒
buttonPressDuration: 0.1秒
```

### 常用 SwiftUI 模式

**状态管理**:
```swift
@StateObject private var viewModel = GameViewModel()
@Published var snake: [Point] = []
```

**手势识别**:
```swift
DragGesture(minimumDistance: 20)
    .onEnded { value in ... }
```

**定时器**:
```swift
Timer.publish(every: 0.2, on: .main, in: .common)
    .autoconnect()
    .sink { [weak self] _ in ... }
```

---

## 注意事项

### 必须遵守

- **不要提前优化**: 先实现功能，再考虑性能
- **不要过度抽象**: 只有重复 3 次以上才抽取
- **不要猜测**: 不确定时参考设计文档
- **不要跳 Phase**: 严格按顺序开发

### 调试提示

- 使用 `print()` 调试游戏循环
- 使用 SwiftUI Previews 快速验证 UI
- 在 Simulator 中测试触摸手势
- 在真机上测试触觉反馈和音效

### 性能考虑

- `ForEach` 遍历蛇身时使用 `id: \.self`（Point 是 Hashable）
- 避免在 `updateGame()` 中做复杂计算
- 主题切换使用 `@Environment` 而非重建 View

---

## 相关文档

- **完整设计文档**: `docs/plans/2026-01-12-ios-snake-design.md`
- **全局偏好**: `~/.claude/CLAUDE.md`
- **SwiftUI 官方文档**: https://developer.apple.com/documentation/swiftui

---

**文档版本**: v1.0
**最后更新**: 2026-01-12
