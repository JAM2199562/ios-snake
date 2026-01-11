# iOS 贪吃蛇游戏 - 完整架构设计文档

**项目类型**: iOS 移动游戏
**设计日期**: 2026-01-12
**目标用户**: 业余工程师学习 vibe coding
**核心理念**: 复古像素风 + 现代 SwiftUI

---

## 一、技术架构选型

### 1.1 UI 框架
**选择: SwiftUI**

理由:
- 声明式语法简洁直观，适合快速原型开发
- 状态管理天然契合游戏逻辑
- 适合 vibe coding 的快速反馈循环
- 社区资源丰富，调试友好

### 1.2 架构模式
**选择: MVVM + ObservableObject**

组件职责:
- **Model**: 定义游戏数据结构（Point, Direction, GameState）
- **ViewModel**: 管理游戏逻辑和状态（GameViewModel）
- **View**: 渲染 UI 和处理用户交互（GameView, GridView）

优势:
- 业务逻辑与 UI 分离，易于测试
- `@Published` 自动触发 UI 更新
- 符合 SwiftUI 最佳实践

### 1.3 游戏循环
**选择: Timer.publish + Combine**

```swift
Timer.publish(every: 0.2, on: .main, in: .common)
    .autoconnect()
    .sink { [weak self] _ in
        self?.updateGame()
    }
```

优势:
- 与 SwiftUI 无缝集成
- 可轻松调整速度（难度递增）
- 支持暂停/恢复

### 1.4 坐标系统
**选择: 自定义 Point 结构体**

```swift
struct Point: Hashable, Equatable {
    let x: Int
    let y: Int
}
```

优势:
- 语义清晰，代码可读性高
- `Hashable` 协议支持高效碰撞检测
- 内存占用小（只存储蛇和食物位置）

### 1.5 渲染方式
**选择: GeometryReader + ForEach + Rectangle**

工作原理:
1. `GeometryReader` 获取可用屏幕空间
2. 计算每个格子大小: `cellSize = 屏幕宽度 / 格子数量`
3. `ForEach` 遍历蛇身数组，在对应坐标绘制方块
4. 状态更新时 SwiftUI 自动重绘

优势:
- 纯 SwiftUI 实现，无额外依赖
- 自适应不同屏幕尺寸
- 代码简洁易懂

### 1.6 控制方式
**选择: 滑动手势 + 虚拟十字键（双模式同时存在）**

**滑动手势**:
```swift
DragGesture(minimumDistance: 20)
    .onEnded { value in
        // 判断滑动方向并改变蛇的移动方向
    }
```

**虚拟十字键**:
- 位置: 右下角（右手拇指操作区）
- 样式: 经典十字形 + 圆形底座
- 透明度: 0.6（不遮挡游戏区域）

优势:
- 新手看到按键就知道怎么玩
- 老玩家用滑动更流畅
- 符合移动游戏通用做法

---

## 二、项目文件结构

```
SnakeGame/
├── App/
│   └── SnakeGameApp.swift          # App 入口
├── Models/
│   ├── Point.swift                 # 坐标结构体
│   ├── Direction.swift             # 方向枚举
│   └── GameState.swift             # 游戏状态枚举
├── ViewModels/
│   └── GameViewModel.swift         # 游戏逻辑控制器
├── Views/
│   ├── GameView.swift              # 主游戏界面
│   ├── GridView.swift              # 网格渲染视图
│   ├── ControlPadView.swift        # 虚拟十字键
│   ├── SettingsView.swift          # 设置页面
│   └── Components/
│       └── PixelText.swift         # 像素风格文字组件
├── Utilities/
│   ├── Theme.swift                 # 主题配置（绿屏/GameBoy）
│   ├── SoundManager.swift          # 音效管理
│   └── HapticManager.swift         # 触觉反馈管理
└── Resources/
    └── Sounds/                     # 8-bit 音效文件
```

**设计原则**:
- 按功能分层，清晰的 MVVM 映射
- 易于定位代码和扩展功能
- 符合 SwiftUI 项目常见实践

---

## 三、核心数据模型

### 3.1 Point（坐标）
```swift
struct Point: Hashable, Equatable {
    let x: Int
    let y: Int

    func moved(in direction: Direction) -> Point {
        switch direction {
        case .up:    return Point(x: x, y: y - 1)
        case .down:  return Point(x: x, y: y + 1)
        case .left:  return Point(x: x - 1, y: y)
        case .right: return Point(x: x + 1, y: y)
        }
    }
}
```

### 3.2 Direction（方向）
```swift
enum Direction {
    case up, down, left, right

    var opposite: Direction {
        switch self {
        case .up: return .down
        case .down: return .up
        case .left: return .right
        case .right: return .left
        }
    }
}
```

**防反向逻辑**: 阻止 180 度转弯，避免蛇撞到自己

### 3.3 GameState（游戏状态）
```swift
enum GameState {
    case ready      // 准备开始
    case running    // 进行中
    case paused     // 暂停
    case gameOver   // 游戏结束
}
```

---

## 四、ViewModel 游戏逻辑

### 4.1 GameViewModel 结构
```swift
class GameViewModel: ObservableObject {
    // 游戏配置
    let gridWidth = 20
    let gridHeight = 30

    // 游戏状态
    @Published var snake: [Point] = []
    @Published var food: Point?
    @Published var direction: Direction = .right
    @Published var gameState: GameState = .ready
    @Published var score: Int = 0

    // 定时器
    private var timer: AnyCancellable?
    private let gameSpeed: TimeInterval = 0.2

    // 核心方法
    func startGame() { ... }
    func updateGame() { ... }
    func changeDirection(_ newDirection: Direction) { ... }
    func checkCollision() -> Bool { ... }
    func spawnFood() { ... }
}
```

### 4.2 关键方法说明

**startGame()**:
- 初始化蛇位置（网格中央，长度3）
- 生成第一个食物
- 启动定时器

**updateGame()**:
- 计算蛇头新位置
- 碰撞检测（撞墙/撞自己 → 游戏结束）
- 检测是否吃到食物（增加分数，蛇身变长，生成新食物）
- 更新蛇身数组

**changeDirection()**:
- 防止反向移动: `guard newDirection != direction.opposite`
- 更新方向状态

**spawnFood()**:
- 随机生成坐标
- 确保不与蛇身重叠

---

## 五、UI/UX 设计规范

### 5.1 视觉风格
**复古像素风 - 柔和现代融合**

特征:
- 无网格线，纯色背景
- 蛇身方块带轻微圆角（2-3px）
- 食物为圆形，保持像素感
- 字体使用 SF Mono（等宽，有复古感但易读）

### 5.2 色彩方案（双主题）

**主题 1: 经典绿屏终端**
- 背景: `#000000` (纯黑)
- 蛇身: `#00FF00` (荧光绿)
- 食物: `#FF0000` (亮红)
- UI文字: `#00FF00`

**主题 2: GameBoy 风格**
- 背景: `#0F380F` (暗绿)
- 蛇身: `#8BAC0F` (亮绿)
- 食物: `#306230` (中绿)
- UI文字: `#8BAC0F`

### 5.3 界面布局

```
┌─────────────────────────┐
│ 分数: 150          ⚙️   │ ← 顶部栏（固定）
├─────────────────────────┤
│                         │
│                         │
│     游戏网格区域          │
│     (20 x 30 格子)       │
│                         │
│                         │
│                    [🎮] │ ← 虚拟十字键（右下角）
└─────────────────────────┘
```

**布局原则**:
- 顶部栏: 分数 + 设置图标
- 网格区: 占据最大可用空间
- 虚拟键: 右下角，半透明不遮挡

### 5.4 虚拟十字键设计

**样式**:
```
      ↑
    ← ⊕ →
      ↓
```

**规格**:
- 位置: 距右边缘 20pt，距底边 80pt
- 大小: 中心圆直径 60pt，方向键各 40x40pt
- 颜色: 根据主题变化（绿色或绿色系）
- 透明度: 0.6
- 按压反馈: opacity 变为 1.0

### 5.5 状态过渡动画

**游戏开始**:
- 倒数 "3" → "2" → "1" → "GO!"
- 像素字体，淡入淡出（0.5秒/次）

**暂停状态**:
- 半透明黑色遮罩（opacity 0.5）
- 中央显示 "PAUSED" 像素文字

**游戏结束**:
- 网格淡出（1秒）
- 显示 "GAME OVER"
- 显示最终分数
- 显示 "TAP TO RESTART" 提示

### 5.6 音效与触觉反馈

**音效**:
- 吃到食物: 8-bit "哔" 声（0.1秒）
- 游戏结束: 低沉失败音（0.5秒）
- 移动/转向: 无声音

**触觉反馈**:
- 吃到食物: 轻触觉（light impact）
- 游戏结束: 重触觉（heavy impact）

**控制**:
- 设置页面可开关音效和震动
- 默认全部开启

### 5.7 设置页面功能

**基础设置项**:
- 主题切换（绿屏终端 / GameBoy）
- 音效开关
- 触觉反馈开关
- 历史最高分显示（只读）
- 重置最高分按钮（带二次确认）

**样式**:
- SwiftUI 标准 Sheet 弹出
- 使用 List + Toggle 组件
- 符合像素风配色

### 5.8 首次启动体验

**极简直接开始**:
1. 打开 App 直接显示游戏界面
2. 游戏状态为 `.ready`（蛇静止）
3. 网格中央显示 "TAP TO START" 闪烁提示
4. 点击屏幕任意位置开始倒数 3-2-1
5. 0.5 秒后游戏开始

**无教程**: 贪吃蛇规则人人都懂，直接开玩

---

## 六、技术实现要点

### 6.1 碰撞检测算法
```swift
func checkCollision() -> Bool {
    guard let head = snake.first else { return false }

    // 撞墙检测
    if head.x < 0 || head.x >= gridWidth ||
       head.y < 0 || head.y >= gridHeight {
        return true
    }

    // 撞自己检测（检查蛇头是否在蛇身数组中）
    let body = snake.dropFirst()
    return body.contains(head)
}
```

### 6.2 食物生成逻辑
```swift
func spawnFood() {
    var newFood: Point
    repeat {
        newFood = Point(
            x: Int.random(in: 0..<gridWidth),
            y: Int.random(in: 0..<gridHeight)
        )
    } while snake.contains(newFood)

    food = newFood
}
```

### 6.3 蛇移动更新
```swift
func updateGame() {
    guard gameState == .running else { return }

    let newHead = snake[0].moved(in: direction)

    if checkCollision() {
        gameState = .gameOver
        return
    }

    snake.insert(newHead, at: 0)

    if newHead == food {
        score += 10
        spawnFood()
        // 触发音效和触觉反馈
    } else {
        snake.removeLast() // 不吃食物时移除尾巴
    }
}
```

### 6.4 手势识别实现
```swift
var swipeGesture: some Gesture {
    DragGesture(minimumDistance: 20)
        .onEnded { value in
            let horizontal = value.translation.width
            let vertical = value.translation.height

            if abs(horizontal) > abs(vertical) {
                viewModel.changeDirection(horizontal > 0 ? .right : .left)
            } else {
                viewModel.changeDirection(vertical > 0 ? .down : .up)
            }
        }
}
```

---

## 七、开发优先级与迭代计划

### Phase 1: 核心游戏逻辑（MVP）
- [ ] 搭建项目基础结构
- [ ] 实现 Point, Direction, GameState 模型
- [ ] 实现 GameViewModel 核心逻辑
- [ ] 实现基础 GridView 渲染（绿屏主题）
- [ ] 实现滑动手势控制
- [ ] 基础碰撞检测和游戏循环

**验收标准**: 能用滑动手势玩完整的贪吃蛇游戏

### Phase 2: UI/UX 完善
- [ ] 添加虚拟十字键控制
- [ ] 实现顶部分数显示
- [ ] 实现游戏状态动画（倒数、暂停、Game Over）
- [ ] 添加 GameBoy 主题
- [ ] 实现设置页面（主题切换）

**验收标准**: 完整的像素风界面和双控制模式

### Phase 3: 音效与反馈
- [ ] 集成 8-bit 音效
- [ ] 实现触觉反馈
- [ ] 添加音效/震动开关
- [ ] 实现最高分记录（UserDefaults）

**验收标准**: 完整的感官反馈系统

### Phase 4: 优化与扩展（可选）
- [ ] 难度递增（速度随分数增加）
- [ ] 游戏统计（总游戏次数、平均分等）
- [ ] 更多主题配色
- [ ] 网格大小可调

---

## 八、技术依赖与要求

**最低支持版本**:
- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+

**核心框架**:
- SwiftUI（UI 框架）
- Combine（响应式编程）
- AVFoundation（音效播放）
- CoreHaptics（触觉反馈）

**第三方依赖**: 无

---

## 九、设计原则总结

本项目严格遵循以下原则：

**KISS (Keep It Simple, Stupid)**:
- 选择最简单直接的实现方式
- 避免过度抽象和复杂设计

**YAGNI (You Aren't Gonna Need It)**:
- 只实现当前明确需要的功能
- 分阶段迭代，不提前设计未来特性

**DRY (Don't Repeat Yourself)**:
- 主题配置统一管理
- 公共组件复用（如像素文字）

**SOLID 原则**:
- 单一职责: ViewModel 管理逻辑，View 负责渲染
- 开闭原则: 主题系统易于扩展新配色
- 依赖倒置: 音效和触觉通过 Manager 抽象

**Vibe Coding 友好**:
- 快速看到效果，即时反馈
- 代码简洁易读，适合学习
- 渐进式开发，每个 Phase 都可独立运行

---

## 十、预期效果

**最终产品特征**:
- ✅ 纯 SwiftUI 实现，代码清晰
- ✅ 复古像素风，双主题切换
- ✅ 双控制模式（手势 + 虚拟键）
- ✅ 完整音效和触觉反馈
- ✅ 流畅动画和状态过渡
- ✅ 适配所有 iPhone 屏幕尺寸
- ✅ 代码量 < 1000 行（含注释）

**学习价值**:
- SwiftUI 状态管理实践
- MVVM 架构应用
- Combine 响应式编程
- 游戏循环设计
- 用户体验设计思考

---

**文档版本**: v1.0
**最后更新**: 2026-01-12
