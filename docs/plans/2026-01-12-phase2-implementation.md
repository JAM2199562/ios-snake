# Phase 2: UI/UX 完善 - 实现计划

**Goal**: 实现完整的像素风界面和双控制模式（滑动 + 虚拟十字键）

**Architecture**: 继续使用 MVVM 架构，添加主题管理系统

**Scope**:
- 虚拟十字键控制（右下角）
- 游戏状态动画（倒数 3-2-1-GO）
- 双主题支持（绿屏终端 + GameBoy）
- 设置页面（主题切换）

---

## Task 1: 创建主题系统

**Files:**
- Create: `SnakeGame/Utilities/Theme.swift`

**目标**: 统一管理颜色配置，支持多主题切换

**实现步骤**:

**Step 1: 定义主题枚举和配置**

Create: `SnakeGame/Utilities/Theme.swift`

```swift
import SwiftUI

/// 游戏主题枚举
enum Theme: String, CaseIterable, Identifiable {
    case greenTerminal = "绿屏终端"
    case gameBoy = "GameBoy"

    var id: String { self.rawValue }

    /// 背景色
    var backgroundColor: Color {
        switch self {
        case .greenTerminal:
            return Color(hex: "000000") // 纯黑
        case .gameBoy:
            return Color(hex: "0F380F") // 暗绿
        }
    }

    /// 蛇身颜色
    var snakeColor: Color {
        switch self {
        case .greenTerminal:
            return Color(hex: "00FF00") // 荧光绿
        case .gameBoy:
            return Color(hex: "8BAC0F") // 亮绿
        }
    }

    /// 食物颜色
    var foodColor: Color {
        switch self {
        case .greenTerminal:
            return Color(hex: "FF0000") // 红色
        case .gameBoy:
            return Color(hex: "306230") // 中绿
        }
    }

    /// UI 文字颜色
    var textColor: Color {
        switch self {
        case .greenTerminal:
            return Color(hex: "00FF00") // 荧光绿
        case .gameBoy:
            return Color(hex: "8BAC0F") // 亮绿
        }
    }
}

/// 主题管理器
class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme = .greenTerminal

    init() {
        // 从 UserDefaults 读取保存的主题
        if let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme"),
           let theme = Theme(rawValue: savedTheme) {
            currentTheme = theme
        }
    }

    func setTheme(_ theme: Theme) {
        currentTheme = theme
        // 保存到 UserDefaults
        UserDefaults.standard.set(theme.rawValue, forKey: "selectedTheme")
    }
}
```

**Step 2: 验证编译**

Run: `Command+B` 构建项目
Expected: 构建成功，无错误

---

## Task 2: 更新 Views 使用主题系统

**Files:**
- Modify: `SnakeGame/Views/GameView.swift`
- Modify: `SnakeGame/Views/GridView.swift`
- Modify: `SnakeGame/App/SnakeGameApp.swift`

**Step 1: 在 App 入口注入 ThemeManager**

Modify: `SnakeGame/App/SnakeGameApp.swift`

```swift
import SwiftUI

@main
struct SnakeGameApp: App {
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            GameView()
                .environmentObject(themeManager)
        }
    }
}
```

**Step 2: 更新 GameView 使用主题**

Modify: `SnakeGame/Views/GameView.swift`

在 `GameView` 添加：
```swift
@EnvironmentObject var themeManager: ThemeManager
```

替换所有硬编码颜色：
- `Color(hex: "00FF00")` → `themeManager.currentTheme.textColor`
- `Color(hex: "000000")` → `themeManager.currentTheme.backgroundColor`

**Step 3: 更新 GridView 使用主题**

Modify: `SnakeGame/Views/GridView.swift`

添加：
```swift
@EnvironmentObject var themeManager: ThemeManager
```

替换：
- 背景 → `themeManager.currentTheme.backgroundColor`
- 蛇身 → `themeManager.currentTheme.snakeColor`
- 食物 → `themeManager.currentTheme.foodColor`

**Step 4: 验证运行**

Run: `Command+R` 在模拟器中运行
Expected: 游戏正常运行，使用绿屏终端主题

---

## Task 3: 实现虚拟十字键控制

**Files:**
- Create: `SnakeGame/Views/Components/ControlPadView.swift`
- Modify: `SnakeGame/Views/GameView.swift`

**Step 1: 创建虚拟十字键组件**

Create: `SnakeGame/Views/Components/ControlPadView.swift`

```swift
import SwiftUI

/// 虚拟十字键控制组件
struct ControlPadView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let onDirectionChange: (Direction) -> Void

    @State private var pressedDirection: Direction?

    var body: some View {
        ZStack {
            // 中心圆底座
            Circle()
                .fill(themeManager.currentTheme.textColor.opacity(0.3))
                .frame(width: 60, height: 60)

            // 上方向键
            DirectionButton(direction: .up, isPressed: pressedDirection == .up)
                .offset(y: -50)

            // 下方向键
            DirectionButton(direction: .down, isPressed: pressedDirection == .down)
                .offset(y: 50)

            // 左方向键
            DirectionButton(direction: .left, isPressed: pressedDirection == .left)
                .offset(x: -50)

            // 右方向键
            DirectionButton(direction: .right, isPressed: pressedDirection == .right)
                .offset(x: 50)
        }
        .opacity(0.6)
    }

    @ViewBuilder
    private func DirectionButton(direction: Direction, isPressed: Bool) -> some View {
        Button(action: {
            onDirectionChange(direction)
            pressedDirection = direction
            // 0.1秒后重置按压状态
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                pressedDirection = nil
            }
        }) {
            Image(systemName: arrowName(for: direction))
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(themeManager.currentTheme.textColor)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(themeManager.currentTheme.textColor.opacity(isPressed ? 0.8 : 0.4))
                )
        }
    }

    private func arrowName(for direction: Direction) -> String {
        switch direction {
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        case .left: return "arrow.left"
        case .right: return "arrow.right"
        }
    }
}
```

**Step 2: 将虚拟十字键添加到 GameView**

Modify: `SnakeGame/Views/GameView.swift`

在 `GeometryReader` 内的 `ZStack` 底部添加：

```swift
// 虚拟十字键（仅在游戏进行中显示）
if viewModel.gameState == .running {
    VStack {
        Spacer()
        HStack {
            Spacer()
            ControlPadView { direction in
                viewModel.changeDirection(direction)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 80)
        }
    }
}
```

**Step 3: 验证运行**

Run: `Command+R`
Expected:
- 游戏开始后右下角出现半透明虚拟十字键
- 点击方向键可以控制蛇的移动
- 按压时按钮高亮显示

---

## Task 4: 实现游戏开始倒数动画

**Files:**
- Modify: `SnakeGame/ViewModels/GameViewModel.swift`
- Modify: `SnakeGame/Views/GameView.swift`

**Step 1: 在 GameViewModel 添加倒数状态**

Modify: `SnakeGame/ViewModels/GameViewModel.swift`

添加新的状态：
```swift
@Published var countdownNumber: Int? = nil
```

修改 `startGame()` 方法：
```swift
func startGame() {
    // 初始化蛇的位置
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
    gameState = .ready

    // 生成第一个食物
    spawnFood()

    // 开始倒数动画
    startCountdown()
}

private func startCountdown() {
    countdownNumber = 3

    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
        guard let self = self else {
            timer.invalidate()
            return
        }

        if let count = self.countdownNumber {
            if count > 1 {
                self.countdownNumber = count - 1
            } else {
                // 倒数结束，开始游戏
                self.countdownNumber = nil
                self.gameState = .running
                self.startTimer()
                timer.invalidate()
            }
        }
    }
}
```

**Step 2: 在 GameView 添加倒数动画 UI**

Modify: `SnakeGame/Views/GameView.swift`

在 `GeometryReader` 内的 `ZStack` 添加：

```swift
// 倒数动画
if let countdown = viewModel.countdownNumber {
    ZStack {
        Color.black.opacity(0.7)

        Text(countdown == 0 ? "GO!" : "\(countdown)")
            .font(.system(size: 80, weight: .bold, design: .monospaced))
            .foregroundColor(themeManager.currentTheme.textColor)
            .transition(.scale.combined(with: .opacity))
    }
    .ignoresSafeArea()
}
```

**Step 3: 验证运行**

Run: `Command+R`
Expected:
- 点击开始后显示 "3" → "2" → "1" → "GO!"
- 每个数字显示 0.5 秒
- GO! 后游戏开始

---

## Task 5: 实现设置页面

**Files:**
- Create: `SnakeGame/Views/SettingsView.swift`
- Modify: `SnakeGame/Views/GameView.swift`

**Step 1: 创建设置页面**

Create: `SnakeGame/Views/SettingsView.swift`

```swift
import SwiftUI

/// 设置页面
struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("主题")) {
                    ForEach(Theme.allCases) { theme in
                        HStack {
                            Text(theme.rawValue)
                                .foregroundColor(theme.textColor)

                            Spacer()

                            if themeManager.currentTheme == theme {
                                Image(systemName: "checkmark")
                                    .foregroundColor(theme.textColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            themeManager.setTheme(theme)
                        }
                    }
                }

                Section(header: Text("关于")) {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0 - Phase 2")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ThemeManager())
    }
}
#endif
```

**Step 2: 在 GameView 添加设置按钮**

Modify: `SnakeGame/Views/GameView.swift`

添加状态：
```swift
@State private var showSettings = false
```

在顶部分数栏添加设置按钮：
```swift
HStack {
    Text("分数: \(viewModel.score)")
        .font(.system(.title2, design: .monospaced))
        .foregroundColor(themeManager.currentTheme.textColor)

    Spacer()

    // 设置按钮
    Button(action: {
        showSettings = true
    }) {
        Image(systemName: "gearshape.fill")
            .font(.title2)
            .foregroundColor(themeManager.currentTheme.textColor)
    }
}
.padding()
.frame(height: 44)
.background(themeManager.currentTheme.backgroundColor)
```

在 `VStack` 后添加 sheet：
```swift
.sheet(isPresented: $showSettings) {
    SettingsView()
        .environmentObject(themeManager)
}
```

**Step 3: 验证运行**

Run: `Command+R`
Expected:
- 顶部右侧显示齿轮图标
- 点击后弹出设置页面
- 可以切换主题（绿屏终端 ↔ GameBoy）
- 切换后颜色立即更新

---

## Task 6: 移除临时调试元素

**Files:**
- Modify: `SnakeGame/Views/GameView.swift`

**Step 1: 移除调试按钮和日志**

在 `GameView.swift` 中删除：
- 临时的 "START" 按钮
- 所有 `print()` 调试语句
- "或点击右上角 START" 提示文字

**Step 2: 验证运行**

Run: `Command+R`
Expected: 界面清爽，无调试元素

---

## Task 7: 最终测试和验证

**验收清单**:

**功能测试**:
- [ ] 主题系统工作正常（绿屏 + GameBoy）
- [ ] 虚拟十字键可以控制蛇的移动
- [ ] 开始倒数动画流畅（3-2-1-GO）
- [ ] 设置页面可以切换主题
- [ ] 主题切换后立即生效
- [ ] 主题选择会被保存（重启 App 后保持）

**双控制模式测试**:
- [ ] 滑动手势依然工作正常
- [ ] 虚拟十字键依然工作正常
- [ ] 两种控制方式可以混合使用

**UI 测试**:
- [ ] GameBoy 主题颜色正确（暗绿背景+亮绿蛇+中绿食物）
- [ ] 绿屏终端主题颜色正确（黑背景+荧光绿蛇+红食物）
- [ ] 虚拟十字键位置正确（右下角）
- [ ] 虚拟十字键透明度正确（0.6）
- [ ] 按压反馈工作正常

**不同设备测试**:
- [ ] iPhone 15 Pro Max（大屏）
- [ ] iPhone SE（小屏）

---

## Phase 2 完成标准

- ✅ 虚拟十字键控制实现
- ✅ 游戏开始倒数动画（3-2-1-GO）
- ✅ 双主题支持（绿屏终端 + GameBoy）
- ✅ 设置页面（主题切换 + 版本信息）
- ✅ 主题持久化（UserDefaults）
- ✅ 双控制模式（滑动 + 虚拟键）无缝切换
- ✅ 所有现有功能继续正常工作

**预计总时间**: 2-3 小时

---

**文档版本**: v1.0
**最后更新**: 2026-01-12
