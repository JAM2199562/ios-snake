# SnakeGame 快速启动指南

## 🎯 当前状态

✅ **所有代码已完成** - Phase 1 核心游戏逻辑 100% 实现
⏳ **需要 Xcode GUI 创建项目文件**

## 📦 已完成的文件

### 核心代码 (9 个文件)
- ✅ SnakeGame/App/SnakeGameApp.swift
- ✅ SnakeGame/Models/Point.swift
- ✅ SnakeGame/Models/Direction.swift
- ✅ SnakeGame/Models/GameState.swift
- ✅ SnakeGame/ViewModels/GameViewModel.swift
- ✅ SnakeGame/Views/GameView.swift
- ✅ SnakeGame/Views/GridView.swift
- ✅ SnakeGame/Utilities/Color+Hex.swift

### 测试文件 (3 个文件)
- ✅ SnakeGameTests/PointTests.swift
- ✅ SnakeGameTests/DirectionTests.swift
- ✅ SnakeGameTests/GameViewModelTests.swift

## 🚀 下一步操作（2 选 1）

### 方案 A: 在 Xcode 中创建完整项目（推荐）

**步骤**:
1. 打开 Xcode
2. File → New → Project
3. 选择 **iOS → App**
4. 配置:
   ```
   Product Name: SnakeGame
   Interface: SwiftUI
   Language: Swift
   ```
5. 保存到: `/Users/drew/test/ios-snake`
6. 删除自动生成的 `ContentView.swift`
7. 将 `SnakeGame/` 和 `SnakeGameTests/` 文件夹拖入项目
8. 按 **Cmd+R** 运行游戏

**预期效果**: 黑屏显示 "TAP TO START"，点击后开始游戏

---

### 方案 B: 使用 Swift Package 测试逻辑（快速验证）

**如果只想验证代码逻辑**:

```bash
cd /Users/drew/test/ios-snake
swift test
```

**限制**: 无法运行 iOS 应用 UI，只能运行单元测试

---

## 📋 验证清单

在 Xcode 中运行后，请验证:

- [ ] 应用启动显示黑色背景
- [ ] 显示绿色文字 "TAP TO START"
- [ ] 点击后蛇（荧光绿）从中央开始移动
- [ ] 红色圆形食物随机出现
- [ ] 滑动屏幕可以改变蛇的方向（上下左右）
- [ ] 吃到食物后蛇身变长，分数增加
- [ ] 撞墙或撞到自己后显示 "GAME OVER"
- [ ] 点击屏幕可以重新开始游戏

## 🎮 游戏操作说明

- **开始游戏**: 点击屏幕
- **控制方向**: 滑动屏幕（上/下/左/右）
- **目标**: 吃食物（红色圆点）让蛇变长
- **规则**: 不能撞墙或撞到自己
- **得分**: 每吃一个食物 +10 分

## 📚 详细文档

- **完整设置指南**: `SETUP_INSTRUCTIONS.md`
- **项目状态报告**: `PROJECT_STATUS.md`
- **实现计划**: `docs/plans/2026-01-12-phase1-implementation.md`
- **设计文档**: `docs/plans/2026-01-12-ios-snake-design.md`

## 🆘 遇到问题？

### Xcode 未安装
如果 Xcode 正在下载，等待下载完成后再创建项目。

### 编译错误
确保所有文件都添加到正确的 target:
- SnakeGame 源文件 → SnakeGame target
- 测试文件 → SnakeGameTests target

### UI 显示异常
检查 `SnakeGameApp.swift` 是否正确引用 `GameView()`

---

**所有代码已就绪，只需 3 分钟在 Xcode 中创建项目即可运行！**
