# Phase 3: 音效与反馈 - 实现计划

**Goal**: 实现完整的感官反馈系统，提升游戏沉浸感

**Architecture**: 添加音效管理器和触觉反馈管理器

**Scope**:
- 8-bit 音效系统（吃食物 + 游戏结束）
- 触觉反馈系统（轻触觉 + 重触觉）
- 最高分记录（UserDefaults 持久化）
- 音效/震动开关（设置页面）

---

## Task 1: 创建音效管理器

**Files:**
- Create: `SnakeGame/Utilities/SoundManager.swift`

**目标**: 统一管理游戏音效播放

**实现步骤**:

**Step 1: 创建 SoundManager**

Create: `SnakeGame/Utilities/SoundManager.swift`

```swift
import AVFoundation

/// 音效管理器
class SoundManager: ObservableObject {
    static let shared = SoundManager()

    @Published var isSoundEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isSoundEnabled, forKey: "soundEnabled")
        }
    }

    private var eatPlayer: AVAudioPlayer?
    private var gameOverPlayer: AVAudioPlayer?

    private init() {
        // 从 UserDefaults 读取音效开关状态
        isSoundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")

        // 如果是首次启动，默认开启音效
        if UserDefaults.standard.object(forKey: "soundEnabled") == nil {
            isSoundEnabled = true
        }

        setupSounds()
    }

    private func setupSounds() {
        // 使用系统音效代替自定义音效文件（简化实现）
        // 实际项目中可以替换为自定义 8-bit 音效文件
    }

    /// 播放吃食物音效
    func playEatSound() {
        guard isSoundEnabled else { return }

        // 使用系统音效 ID 1103（Pop 音效）
        AudioServicesPlaySystemSound(1103)
    }

    /// 播放游戏结束音效
    func playGameOverSound() {
        guard isSoundEnabled else { return }

        // 使用系统音效 ID 1053（短促震动音）
        AudioServicesPlaySystemSound(1053)
    }
}
```

**注**: 使用系统音效是最简单的方式，符合 KISS 原则。如果后续需要自定义 8-bit 音效，可以替换为 AVAudioPlayer + 音频文件。

---

## Task 2: 创建触觉反馈管理器

**Files:**
- Create: `SnakeGame/Utilities/HapticManager.swift`

**实现步骤**:

**Step 1: 创建 HapticManager**

Create: `SnakeGame/Utilities/HapticManager.swift`

```swift
import UIKit

/// 触觉反馈管理器
class HapticManager: ObservableObject {
    static let shared = HapticManager()

    @Published var isHapticEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isHapticEnabled, forKey: "hapticEnabled")
        }
    }

    private init() {
        // 从 UserDefaults 读取触觉反馈开关状态
        isHapticEnabled = UserDefaults.standard.bool(forKey: "hapticEnabled")

        // 如果是首次启动，默认开启触觉反馈
        if UserDefaults.standard.object(forKey: "hapticEnabled") == nil {
            isHapticEnabled = true
        }
    }

    /// 播放轻触觉反馈（吃食物时）
    func playLightImpact() {
        guard isHapticEnabled else { return }

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    /// 播放重触觉反馈（游戏结束时）
    func playHeavyImpact() {
        guard isHapticEnabled else { return }

        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
}
```

---

## Task 3: 实现最高分记录系统

**Files:**
- Modify: `SnakeGame/ViewModels/GameViewModel.swift`

**实现步骤**:

**Step 1: 在 GameViewModel 添加最高分逻辑**

Add to `GameViewModel.swift`:

```swift
// MARK: - Published 状态
@Published var highScore: Int = 0

// MARK: - 初始化
init() {
    // 从 UserDefaults 读取最高分
    highScore = UserDefaults.standard.integer(forKey: "highScore")
}

// 在 updateGame() 中更新最高分
if newHead == food {
    score += 10

    // 更新最高分
    if score > highScore {
        highScore = score
        UserDefaults.standard.set(highScore, forKey: "highScore")
    }

    spawnFood()

    // 播放音效和触觉反馈
    SoundManager.shared.playEatSound()
    HapticManager.shared.playLightImpact()
} else {
    snake.removeLast()
}

// 在 checkCollision 后游戏结束时
if checkCollision(at: newHead) {
    gameState = .gameOver
    stopTimer()

    // 播放游戏结束音效和触觉反馈
    SoundManager.shared.playGameOverSound()
    HapticManager.shared.playHeavyImpact()

    return
}
```

---

## Task 4: 更新设置页面添加开关

**Files:**
- Modify: `SnakeGame/Views/SettingsView.swift`

**实现步骤**:

**Step 1: 添加音效和触觉反馈开关**

Update `SettingsView.swift`:

```swift
struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var soundManager = SoundManager.shared
    @ObservedObject var hapticManager = HapticManager.shared
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

                Section(header: Text("反馈设置")) {
                    Toggle("音效", isOn: $soundManager.isSoundEnabled)
                    Toggle("触觉反馈", isOn: $hapticManager.isHapticEnabled)
                }

                Section(header: Text("关于")) {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0 - Phase 3")
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
```

---

## Task 5: 在 GameView 显示最高分

**Files:**
- Modify: `SnakeGame/Views/GameView.swift`

**实现步骤**:

**Step 1: 在顶部栏显示最高分**

Update `GameView.swift` 顶部栏:

```swift
// 顶部分数栏
HStack {
    VStack(alignment: .leading, spacing: 4) {
        Text("分数: \(viewModel.score)")
            .font(.system(.title2, design: .monospaced))
            .foregroundColor(themeManager.currentTheme.textColor)

        Text("最高: \(viewModel.highScore)")
            .font(.system(.caption, design: .monospaced))
            .foregroundColor(themeManager.currentTheme.textColor)
            .opacity(0.7)
    }

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
.frame(height: 60)
.background(themeManager.currentTheme.backgroundColor)
```

---

## Task 6: 最终验证和测试

**验收清单**:

**音效系统**:
- [ ] 吃到食物时播放音效
- [ ] 游戏结束时播放音效
- [ ] 音效开关工作正常
- [ ] 关闭音效后不播放声音

**触觉反馈**:
- [ ] 吃到食物时轻触觉反馈
- [ ] 游戏结束时重触觉反馈
- [ ] 触觉反馈开关工作正常
- [ ] 关闭后不产生震动

**最高分记录**:
- [ ] 游戏中实时更新最高分
- [ ] 最高分持久化保存
- [ ] 重启 App 后最高分保持
- [ ] 顶部栏显示当前分数和最高分

**设置页面**:
- [ ] 音效开关可切换
- [ ] 触觉反馈开关可切换
- [ ] 版本信息更新为 "1.0.0 - Phase 3"

**整体体验**:
- [ ] 所有 Phase 1、2、3 功能正常工作
- [ ] 无性能问题
- [ ] 无崩溃或错误

---

## Phase 3 完成标准

- ✅ 音效系统（吃食物 + 游戏结束）
- ✅ 触觉反馈系统（轻触觉 + 重触觉）
- ✅ 最高分记录（UserDefaults 持久化）
- ✅ 音效/触觉反馈开关（设置页面）
- ✅ 顶部栏显示最高分
- ✅ 所有现有功能继续正常工作

**预计总时间**: 1-2 小时

---

**文档版本**: v1.0
**最后更新**: 2026-01-12
