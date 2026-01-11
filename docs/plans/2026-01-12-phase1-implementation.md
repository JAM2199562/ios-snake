# Phase 1: 核心游戏逻辑 - 实现计划

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 实现可玩的贪吃蛇游戏 MVP，支持滑动手势控制，包含完整游戏循环和碰撞检测。

**Architecture:** MVVM 架构，使用 SwiftUI + Combine。Model 层定义数据结构（Point/Direction/GameState），ViewModel 管理游戏逻辑和状态，View 层负责渲染和交互。

**Tech Stack:** SwiftUI, Combine, Swift 5.7+, iOS 15.0+

---

## Task 1: 创建 Xcode 项目结构

**Files:**
- Create: Xcode 项目 `SnakeGame.xcodeproj`
- Create: `SnakeGame/App/SnakeGameApp.swift`
- Create: 目录结构

**Step 1: 创建 Xcode 项目**

使用 Xcode 创建新项目：
- Template: iOS → App
- Product Name: SnakeGame
- Interface: SwiftUI
- Language: Swift
- Minimum Deployment: iOS 15.0

**Step 2: 创建目录结构**

在 Xcode 中创建以下 Group（文件夹）：
```
SnakeGame/
├── App/
├── Models/
├── ViewModels/
├── Views/
│   └── Components/
└── Utilities/
```

**Step 3: 移动 App 入口文件**

将自动生成的 `SnakeGameApp.swift` 移动到 `App/` 目录。

**Step 4: 删除默认文件**

删除自动生成的 `ContentView.swift`（我们会创建自己的 GameView）。

**Step 5: 验证项目运行**

Run: Command+R 在模拟器中运行
Expected: 显示空白白色屏幕（因为删除了 ContentView）

**Step 6: 初始化 Git 仓库（如果还没有）**

```bash
cd /Users/drew/test/ios-snake
git init
git add .
git commit -m "chore: 创建 Xcode 项目基础结构"
```

---

## Task 2: 实现 Point 模型

**Files:**
- Create: `SnakeGame/Models/Point.swift`
- Create: `SnakeGameTests/PointTests.swift`

**Step 1: 编写 Point 测试**

Create: `SnakeGameTests/PointTests.swift`

```swift
import XCTest
@testable import SnakeGame

final class PointTests: XCTestCase {
    func test_pointEquality() {
        let point1 = Point(x: 5, y: 10)
        let point2 = Point(x: 5, y: 10)
        let point3 = Point(x: 3, y: 10)

        XCTAssertEqual(point1, point2)
        XCTAssertNotEqual(point1, point3)
    }

    func test_pointHashable() {
        let point1 = Point(x: 5, y: 10)
        let point2 = Point(x: 5, y: 10)

        let set: Set<Point> = [point1, point2]
        XCTAssertEqual(set.count, 1) // 相同的点应该只存储一次
    }

    func test_movedUp() {
        let point = Point(x: 5, y: 10)
        let moved = point.moved(in: .up)

        XCTAssertEqual(moved, Point(x: 5, y: 9))
    }

    func test_movedDown() {
        let point = Point(x: 5, y: 10)
        let moved = point.moved(in: .down)

        XCTAssertEqual(moved, Point(x: 5, y: 11))
    }

    func test_movedLeft() {
        let point = Point(x: 5, y: 10)
        let moved = point.moved(in: .left)

        XCTAssertEqual(moved, Point(x: 4, y: 10))
    }

    func test_movedRight() {
        let point = Point(x: 5, y: 10)
        let moved = point.moved(in: .right)

        XCTAssertEqual(moved, Point(x: 6, y: 10))
    }
}
```

**Step 2: 运行测试验证失败**

Run: `Command+U` 或 `xcodebuild test -scheme SnakeGame -destination 'platform=iOS Simulator,name=iPhone 15'`
Expected: 编译错误 "Cannot find type 'Point' in scope"

**Step 3: 实现 Point 结构体**

Create: `SnakeGame/Models/Point.swift`

```swift
import Foundation

/// 表示网格上的坐标点
struct Point: Hashable, Equatable {
    let x: Int
    let y: Int

    /// 根据给定方向移动一格，返回新的坐标点
    func moved(in direction: Direction) -> Point {
        switch direction {
        case .up:
            return Point(x: x, y: y - 1)
        case .down:
            return Point(x: x, y: y + 1)
        case .left:
            return Point(x: x - 1, y: y)
        case .right:
            return Point(x: x + 1, y: y)
        }
    }
}
```

**Step 4: 运行测试验证通过**

Run: `Command+U`
Expected: 所有 PointTests 测试通过

**Step 5: 提交代码**

```bash
git add SnakeGame/Models/Point.swift SnakeGameTests/PointTests.swift
git commit -m "feat: 实现 Point 坐标结构体"
```

---

## Task 3: 实现 Direction 模型

**Files:**
- Create: `SnakeGame/Models/Direction.swift`
- Create: `SnakeGameTests/DirectionTests.swift`

**Step 1: 编写 Direction 测试**

Create: `SnakeGameTests/DirectionTests.swift`

```swift
import XCTest
@testable import SnakeGame

final class DirectionTests: XCTestCase {
    func test_oppositeDirections() {
        XCTAssertEqual(Direction.up.opposite, .down)
        XCTAssertEqual(Direction.down.opposite, .up)
        XCTAssertEqual(Direction.left.opposite, .right)
        XCTAssertEqual(Direction.right.opposite, .left)
    }
}
```

**Step 2: 运行测试验证失败**

Run: `Command+U`
Expected: 编译错误 "Cannot find type 'Direction' in scope"

**Step 3: 实现 Direction 枚举**

Create: `SnakeGame/Models/Direction.swift`

```swift
import Foundation

/// 蛇移动的方向
enum Direction {
    case up
    case down
    case left
    case right

    /// 返回当前方向的相反方向（用于防止 180 度转弯）
    var opposite: Direction {
        switch self {
        case .up:
            return .down
        case .down:
            return .up
        case .left:
            return .right
        case .right:
            return .left
        }
    }
}
```

**Step 4: 运行测试验证通过**

Run: `Command+U`
Expected: 所有 DirectionTests 测试通过

**Step 5: 提交代码**

```bash
git add SnakeGame/Models/Direction.swift SnakeGameTests/DirectionTests.swift
git commit -m "feat: 实现 Direction 方向枚举"
```

---

## Task 4: 实现 GameState 模型

**Files:**
- Create: `SnakeGame/Models/GameState.swift`

**Step 1: 实现 GameState 枚举**

Create: `SnakeGame/Models/GameState.swift`

```swift
import Foundation

/// 游戏的当前状态
enum GameState {
    case ready      // 准备开始（初始状态）
    case running    // 游戏进行中
    case paused     // 暂停
    case gameOver   // 游戏结束
}
```

**Step 2: 验证编译**

Run: `Command+B` 构建项目
Expected: 构建成功，无错误

**Step 3: 提交代码**

```bash
git add SnakeGame/Models/GameState.swift
git commit -m "feat: 实现 GameState 游戏状态枚举"
```

---

## Task 5: 实现 GameViewModel 基础结构

**Files:**
- Create: `SnakeGame/ViewModels/GameViewModel.swift`
- Create: `SnakeGameTests/GameViewModelTests.swift`

**Step 1: 编写 GameViewModel 初始化测试**

Create: `SnakeGameTests/GameViewModelTests.swift`

```swift
import XCTest
import Combine
@testable import SnakeGame

final class GameViewModelTests: XCTestCase {
    var viewModel: GameViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        viewModel = GameViewModel()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        viewModel = nil
        super.tearDown()
    }

    func test_initialState() {
        XCTAssertEqual(viewModel.gameState, .ready)
        XCTAssertEqual(viewModel.score, 0)
        XCTAssertEqual(viewModel.direction, .right)
        XCTAssertTrue(viewModel.snake.isEmpty)
        XCTAssertNil(viewModel.food)
    }
}
```

**Step 2: 运行测试验证失败**

Run: `Command+U`
Expected: 编译错误 "Cannot find type 'GameViewModel' in scope"

**Step 3: 实现 GameViewModel 基础结构**

Create: `SnakeGame/ViewModels/GameViewModel.swift`

```swift
import Foundation
import Combine

/// 游戏逻辑和状态管理的核心 ViewModel
class GameViewModel: ObservableObject {
    // MARK: - 游戏配置常量
    let gridWidth = 20
    let gridHeight = 30

    // MARK: - Published 状态（自动触发 UI 更新）
    @Published var snake: [Point] = []
    @Published var food: Point?
    @Published var direction: Direction = .right
    @Published var gameState: GameState = .ready
    @Published var score: Int = 0

    // MARK: - 私有属性
    private var timer: AnyCancellable?
    private let gameSpeed: TimeInterval = 0.2

    // MARK: - 初始化
    init() {
        // 初始化时不启动游戏，等待用户触发
    }
}
```

**Step 4: 运行测试验证通过**

Run: `Command+U`
Expected: test_initialState 测试通过

**Step 5: 提交代码**

```bash
git add SnakeGame/ViewModels/GameViewModel.swift SnakeGameTests/GameViewModelTests.swift
git commit -m "feat: 实现 GameViewModel 基础结构"
```

---

## Task 6: 实现 startGame() 方法

**Files:**
- Modify: `SnakeGame/ViewModels/GameViewModel.swift`
- Modify: `SnakeGameTests/GameViewModelTests.swift`

**Step 1: 编写 startGame 测试**

Add to `SnakeGameTests/GameViewModelTests.swift`:

```swift
func test_startGame_initializesSnake() {
    viewModel.startGame()

    XCTAssertEqual(viewModel.snake.count, 3)
    XCTAssertEqual(viewModel.gameState, .running)
    XCTAssertNotNil(viewModel.food)
}

func test_startGame_snakeStartsInCenter() {
    viewModel.startGame()

    let centerX = viewModel.gridWidth / 2
    let centerY = viewModel.gridHeight / 2

    XCTAssertEqual(viewModel.snake[0], Point(x: centerX, y: centerY))
    XCTAssertEqual(viewModel.snake[1], Point(x: centerX - 1, y: centerY))
    XCTAssertEqual(viewModel.snake[2], Point(x: centerX - 2, y: centerY))
}

func test_startGame_foodNotOnSnake() {
    viewModel.startGame()

    guard let food = viewModel.food else {
        XCTFail("Food should be spawned")
        return
    }

    XCTAssertFalse(viewModel.snake.contains(food))
}
```

**Step 2: 运行测试验证失败**

Run: `Command+U`
Expected: 测试失败，提示 "Value of type 'GameViewModel' has no member 'startGame'"

**Step 3: 实现 startGame() 方法**

Add to `SnakeGame/ViewModels/GameViewModel.swift`:

```swift
// MARK: - 公开方法

/// 开始新游戏
func startGame() {
    // 初始化蛇的位置（网格中央，长度 3，向右延伸）
    let centerX = gridWidth / 2
    let centerY = gridHeight / 2

    snake = [
        Point(x: centerX, y: centerY),
        Point(x: centerX - 1, y: centerY),
        Point(x: centerX - 2, y: centerY)
    ]

    // 重置游戏状态
    direction = .right
    score = 0
    gameState = .running

    // 生成第一个食物
    spawnFood()

    // 启动游戏循环
    startTimer()
}
```

**Step 4: 运行测试验证失败（缺少辅助方法）**

Run: `Command+U`
Expected: 编译错误 "Value of type 'GameViewModel' has no member 'spawnFood'"

**Step 5: 实现 spawnFood() 辅助方法**

Add to `SnakeGame/ViewModels/GameViewModel.swift`:

```swift
// MARK: - 私有辅助方法

/// 在随机位置生成食物（确保不与蛇身重叠）
private func spawnFood() {
    var newFood: Point
    repeat {
        newFood = Point(
            x: Int.random(in: 0..<gridWidth),
            y: Int.random(in: 0..<gridHeight)
        )
    } while snake.contains(newFood)

    food = newFood
}

/// 启动游戏循环定时器
private func startTimer() {
    // 停止现有定时器（如果有）
    timer?.cancel()

    // 创建新的定时器
    timer = Timer.publish(every: gameSpeed, on: .main, in: .common)
        .autoconnect()
        .sink { [weak self] _ in
            self?.updateGame()
        }
}

/// 停止游戏循环定时器
private func stopTimer() {
    timer?.cancel()
    timer = nil
}
```

**Step 6: 运行测试验证失败（缺少 updateGame）**

Run: `Command+U`
Expected: 编译错误 "Value of type 'GameViewModel' has no member 'updateGame'"

**Step 7: 添加临时的 updateGame() 占位方法**

Add to `SnakeGame/ViewModels/GameViewModel.swift`:

```swift
/// 游戏循环每帧调用（暂时为空，下一个任务实现）
private func updateGame() {
    // TODO: 在下一个任务中实现
}
```

**Step 8: 运行测试验证通过**

Run: `Command+U`
Expected: 所有 startGame 相关测试通过

**Step 9: 提交代码**

```bash
git add SnakeGame/ViewModels/GameViewModel.swift SnakeGameTests/GameViewModelTests.swift
git commit -m "feat: 实现 startGame() 和食物生成逻辑"
```

---

## Task 7: 实现 updateGame() 核心游戏循环

**Files:**
- Modify: `SnakeGame/ViewModels/GameViewModel.swift`
- Modify: `SnakeGameTests/GameViewModelTests.swift`

**Step 1: 编写 updateGame 测试**

Add to `SnakeGameTests/GameViewModelTests.swift`:

```swift
func test_updateGame_snakeMoves() {
    viewModel.startGame()
    let initialHead = viewModel.snake[0]

    // 手动调用 updateGame（绕过定时器）
    viewModel.stopTimer() // 先添加这个公开方法
    viewModel.updateGameManually() // 添加测试用的公开方法

    let newHead = viewModel.snake[0]
    XCTAssertEqual(newHead, initialHead.moved(in: .right))
}

func test_updateGame_snakeEatsFood() {
    viewModel.startGame()
    viewModel.stopTimer()

    let initialLength = viewModel.snake.count
    let initialScore = viewModel.score

    // 将食物放在蛇头前方
    viewModel.setFoodForTesting(at: viewModel.snake[0].moved(in: .right))

    viewModel.updateGameManually()

    XCTAssertEqual(viewModel.snake.count, initialLength + 1)
    XCTAssertEqual(viewModel.score, initialScore + 10)
}

func test_updateGame_snakeHitsWall() {
    viewModel.startGame()
    viewModel.stopTimer()

    // 将蛇移到边缘
    viewModel.setSnakeForTesting(at: Point(x: 19, y: 15))
    viewModel.changeDirection(.right)

    viewModel.updateGameManually()

    XCTAssertEqual(viewModel.gameState, .gameOver)
}
```

**Step 2: 添加测试辅助方法**

Add to `SnakeGame/ViewModels/GameViewModel.swift`:

```swift
#if DEBUG
// MARK: - 测试辅助方法
func stopTimer() {
    timer?.cancel()
    timer = nil
}

func updateGameManually() {
    updateGame()
}

func setFoodForTesting(at point: Point) {
    food = point
}

func setSnakeForTesting(at headPosition: Point) {
    snake = [
        headPosition,
        Point(x: headPosition.x - 1, y: headPosition.y),
        Point(x: headPosition.x - 2, y: headPosition.y)
    ]
}
#endif
```

**Step 3: 运行测试验证失败**

Run: `Command+U`
Expected: 测试失败（updateGame 还是空方法）

**Step 4: 实现 updateGame() 方法**

Replace the placeholder `updateGame()` in `SnakeGame/ViewModels/GameViewModel.swift`:

```swift
/// 游戏循环每帧调用，处理蛇移动和碰撞检测
private func updateGame() {
    // 只在运行状态下更新
    guard gameState == .running else { return }

    // 计算蛇头新位置
    let newHead = snake[0].moved(in: direction)

    // 碰撞检测
    if checkCollision(at: newHead) {
        gameState = .gameOver
        stopTimer()
        return
    }

    // 移动蛇：在头部插入新位置
    snake.insert(newHead, at: 0)

    // 检查是否吃到食物
    if newHead == food {
        // 吃到食物：增加分数，生成新食物，蛇身保持增长
        score += 10
        spawnFood()
        // TODO: 触发音效和触觉反馈（Phase 3）
    } else {
        // 没吃到食物：移除尾巴（保持蛇身长度不变）
        snake.removeLast()
    }
}

/// 检查指定位置是否发生碰撞（撞墙或撞自己）
private func checkCollision(at point: Point) -> Bool {
    // 撞墙检测
    if point.x < 0 || point.x >= gridWidth ||
       point.y < 0 || point.y >= gridHeight {
        return true
    }

    // 撞自己检测（检查新位置是否在当前蛇身中）
    return snake.contains(point)
}
```

**Step 5: 运行测试验证通过**

Run: `Command+U`
Expected: 所有 updateGame 相关测试通过

**Step 6: 提交代码**

```bash
git add SnakeGame/ViewModels/GameViewModel.swift SnakeGameTests/GameViewModelTests.swift
git commit -m "feat: 实现 updateGame() 核心游戏循环和碰撞检测"
```

---

## Task 8: 实现 changeDirection() 方法

**Files:**
- Modify: `SnakeGame/ViewModels/GameViewModel.swift`
- Modify: `SnakeGameTests/GameViewModelTests.swift`

**Step 1: 编写 changeDirection 测试**

Add to `SnakeGameTests/GameViewModelTests.swift`:

```swift
func test_changeDirection_allowsValidChange() {
    viewModel.startGame()
    viewModel.changeDirection(.up)

    XCTAssertEqual(viewModel.direction, .up)
}

func test_changeDirection_preventsOppositeDirection() {
    viewModel.startGame() // 初始方向是 .right
    viewModel.changeDirection(.left) // 尝试反向

    XCTAssertEqual(viewModel.direction, .right) // 应该保持原方向
}

func test_changeDirection_allowsPerpendicularChange() {
    viewModel.startGame() // 初始方向是 .right
    viewModel.changeDirection(.up)

    XCTAssertEqual(viewModel.direction, .up)
}
```

**Step 2: 运行测试验证失败**

Run: `Command+U`
Expected: 编译错误 "Value of type 'GameViewModel' has no member 'changeDirection'"

**Step 3: 实现 changeDirection() 方法**

Add to `SnakeGame/ViewModels/GameViewModel.swift`:

```swift
/// 改变蛇的移动方向（防止 180 度反向转弯）
func changeDirection(_ newDirection: Direction) {
    // 防止蛇反向移动（撞到自己）
    guard newDirection != direction.opposite else { return }

    direction = newDirection
}
```

**Step 4: 运行测试验证通过**

Run: `Command+U`
Expected: 所有 changeDirection 测试通过

**Step 5: 提交代码**

```bash
git add SnakeGame/ViewModels/GameViewModel.swift SnakeGameTests/GameViewModelTests.swift
git commit -m "feat: 实现 changeDirection() 防止反向转弯"
```

---

## Task 9: 实现基础 GameView 和 GridView

**Files:**
- Create: `SnakeGame/Views/GameView.swift`
- Create: `SnakeGame/Views/GridView.swift`
- Create: `SnakeGame/Utilities/Color+Hex.swift`

**Step 1: 实现 Color 扩展（支持十六进制颜色）**

Create: `SnakeGame/Utilities/Color+Hex.swift`

```swift
import SwiftUI

extension Color {
    /// 从十六进制字符串创建颜色
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
```

**Step 2: 实现 GridView 渲染**

Create: `SnakeGame/Views/GridView.swift`

```swift
import SwiftUI

/// 游戏网格渲染视图
struct GridView: View {
    @ObservedObject var viewModel: GameViewModel
    let size: CGSize

    // 计算每个格子的像素大小
    private var cellSize: CGFloat {
        min(
            size.width / CGFloat(viewModel.gridWidth),
            size.height / CGFloat(viewModel.gridHeight)
        )
    }

    var body: some View {
        ZStack {
            // 背景：纯黑色（绿屏终端主题）
            Color(hex: "000000")
                .ignoresSafeArea()

            // 蛇身：荧光绿色方块
            ForEach(viewModel.snake, id: \.self) { point in
                Rectangle()
                    .fill(Color(hex: "00FF00"))
                    .cornerRadius(3) // 轻微圆角
                    .frame(width: cellSize, height: cellSize)
                    .position(
                        x: CGFloat(point.x) * cellSize + cellSize / 2,
                        y: CGFloat(point.y) * cellSize + cellSize / 2
                    )
            }

            // 食物：红色圆形
            if let food = viewModel.food {
                Circle()
                    .fill(Color(hex: "FF0000"))
                    .frame(width: cellSize, height: cellSize)
                    .position(
                        x: CGFloat(food.x) * cellSize + cellSize / 2,
                        y: CGFloat(food.y) * cellSize + cellSize / 2
                    )
            }
        }
    }
}
```

**Step 3: 实现 GameView 主界面**

Create: `SnakeGame/Views/GameView.swift`

```swift
import SwiftUI

/// 游戏主界面
struct GameView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // 顶部分数栏
            HStack {
                Text("分数: \(viewModel.score)")
                    .font(.system(.title2, design: .monospaced))
                    .foregroundColor(Color(hex: "00FF00"))

                Spacer()
            }
            .padding()
            .frame(height: 44)
            .background(Color(hex: "000000"))

            // 游戏网格区域
            GeometryReader { geometry in
                GridView(viewModel: viewModel, size: geometry.size)
                    .gesture(swipeGesture)
                    .onTapGesture {
                        handleTap()
                    }
            }
        }
        .background(Color(hex: "000000"))
    }

    // MARK: - 手势处理

    /// 滑动手势识别
    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 20)
            .onEnded { value in
                let horizontal = value.translation.width
                let vertical = value.translation.height

                if abs(horizontal) > abs(vertical) {
                    // 水平滑动
                    viewModel.changeDirection(horizontal > 0 ? .right : .left)
                } else {
                    // 垂直滑动
                    viewModel.changeDirection(vertical > 0 ? .down : .up)
                }
            }
    }

    /// 点击屏幕处理（开始游戏）
    private func handleTap() {
        if viewModel.gameState == .ready {
            viewModel.startGame()
        }
    }
}

// MARK: - Preview

#if DEBUG
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
#endif
```

**Step 4: 更新 App 入口**

Modify: `SnakeGame/App/SnakeGameApp.swift`

```swift
import SwiftUI

@main
struct SnakeGameApp: App {
    var body: some Scene {
        WindowGroup {
            GameView()
        }
    }
}
```

**Step 5: 运行并验证**

Run: `Command+R` 在模拟器中运行

Expected:
- 看到黑色背景
- 点击屏幕后蛇开始移动（荧光绿色）
- 红色圆形食物随机出现
- 可以用滑动手势控制方向
- 分数显示在顶部

**Step 6: 提交代码**

```bash
git add SnakeGame/Views/GameView.swift SnakeGame/Views/GridView.swift SnakeGame/Utilities/Color+Hex.swift SnakeGame/App/SnakeGameApp.swift
git commit -m "feat: 实现基础 UI 渲染和滑动手势控制"
```

---

## Task 10: 添加游戏结束提示

**Files:**
- Modify: `SnakeGame/Views/GameView.swift`

**Step 1: 添加游戏结束 UI**

Add to `GameView.swift` inside `GeometryReader`:

```swift
GeometryReader { geometry in
    GridView(viewModel: viewModel, size: geometry.size)
        .gesture(swipeGesture)
        .onTapGesture {
            handleTap()
        }

    // 游戏结束遮罩
    if viewModel.gameState == .gameOver {
        ZStack {
            Color.black.opacity(0.7)

            VStack(spacing: 20) {
                Text("GAME OVER")
                    .font(.system(size: 40, weight: .bold, design: .monospaced))
                    .foregroundColor(Color(hex: "00FF00"))

                Text("分数: \(viewModel.score)")
                    .font(.system(size: 24, design: .monospaced))
                    .foregroundColor(Color(hex: "00FF00"))

                Text("TAP TO RESTART")
                    .font(.system(size: 16, design: .monospaced))
                    .foregroundColor(Color(hex: "00FF00"))
                    .opacity(0.7)
            }
        }
        .ignoresSafeArea()
    }

    // 开始提示
    if viewModel.gameState == .ready {
        ZStack {
            Color.black.opacity(0.5)

            Text("TAP TO START")
                .font(.system(size: 24, design: .monospaced))
                .foregroundColor(Color(hex: "00FF00"))
        }
        .ignoresSafeArea()
    }
}
```

**Step 2: 更新 handleTap 逻辑**

Update `handleTap()` in `GameView.swift`:

```swift
/// 点击屏幕处理
private func handleTap() {
    if viewModel.gameState == .ready || viewModel.gameState == .gameOver {
        viewModel.startGame()
    }
}
```

**Step 3: 运行并验证**

Run: `Command+R`

Expected:
- 启动时看到 "TAP TO START" 提示
- 点击后游戏开始
- 撞墙或撞自己后显示 "GAME OVER"
- 点击后可以重新开始

**Step 4: 提交代码**

```bash
git add SnakeGame/Views/GameView.swift
git commit -m "feat: 添加游戏开始和结束提示 UI"
```

---

## Task 11: 最终验证和清理

**Step 1: 运行所有测试**

Run: `Command+U`
Expected: 所有测试通过

**Step 2: 在不同设备上测试**

Run on:
- iPhone 15 Pro Max (大屏)
- iPhone SE (小屏)

Expected: 网格自适应屏幕大小

**Step 3: 完整游戏流程测试**

Manual Testing:
1. ✅ 启动显示 "TAP TO START"
2. ✅ 点击后蛇开始移动
3. ✅ 滑动手势可以控制方向
4. ✅ 吃到食物后蛇身变长，分数+10
5. ✅ 撞墙后游戏结束
6. ✅ 撞到自己后游戏结束
7. ✅ 游戏结束后可以重新开始

**Step 4: 代码质量检查**

Check:
- ✅ 所有代码有适当的中文注释
- ✅ 遵循 MVVM 架构
- ✅ 没有编译警告
- ✅ 符合 KISS/DRY/YAGNI 原则

**Step 5: 最终提交**

```bash
git add .
git commit -m "chore: Phase 1 完成 - 核心游戏逻辑 MVP"
git tag -a v0.1.0 -m "Phase 1: 核心游戏逻辑 MVP 完成"
```

---

## Phase 1 验收清单

- ✅ 搭建项目基础结构
- ✅ 实现 Point, Direction, GameState 模型
- ✅ 实现 GameViewModel 核心逻辑
- ✅ 实现基础 GridView 渲染（绿屏主题）
- ✅ 实现滑动手势控制
- ✅ 基础碰撞检测和游戏循环
- ✅ 所有单元测试通过
- ✅ 能用滑动手势玩完整的贪吃蛇游戏

**预计总时间**: 2-3 小时（包括测试和验证）

---

## 下一步

Phase 1 完成后，继续 Phase 2: UI/UX 完善
- 添加虚拟十字键控制
- 实现顶部分数显示优化
- 实现游戏状态动画（倒数、暂停、Game Over）
- 添加 GameBoy 主题
- 实现设置页面

**文档版本**: v1.0
**最后更新**: 2026-01-12
