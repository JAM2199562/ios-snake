# SnakeGame Xcode 项目设置指南

## 当前状态

✅ 所有 Swift 源文件已创建完成：
- ✅ Models: Point.swift, Direction.swift, GameState.swift
- ✅ ViewModels: GameViewModel.swift
- ✅ Views: GameView.swift, GridView.swift
- ✅ Utilities: Color+Hex.swift
- ✅ App: SnakeGameApp.swift
- ✅ Tests: PointTests.swift, DirectionTests.swift, GameViewModelTests.swift

## 方法 1: 使用 Xcode GUI 创建项目（推荐）

### 步骤 1: 创建 Xcode 项目

1. 打开 Xcode
2. 选择 **File → New → Project** (Shift+Cmd+N)
3. 选择 **iOS → App**，点击 Next
4. 配置项目：
   - Product Name: `SnakeGame`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - 取消勾选 "Include Tests"（我们已有测试文件）
   - 点击 Next
5. 保存位置：选择 `/Users/drew/test/ios-snake` 的**父目录**（即 `/Users/drew/test`）
6. **重要**: 在保存对话框中，将项目名改为现有的 `ios-snake` 文件夹
   - Xcode 会检测到已存在的文件并询问是否合并
   - 选择 **Merge**

### 步骤 2: 添加现有文件到项目

1. 删除 Xcode 自动生成的文件：
   - 右键点击 `ContentView.swift` → Delete → Move to Trash
   - 右键点击 `SnakeGameApp.swift`（如果在根目录）→ Delete → Move to Trash

2. 在项目导航器中创建 Group 结构：
   - 右键 SnakeGame 文件夹 → New Group，命名为 `App`
   - 同样创建：`Models`, `ViewModels`, `Views`, `Utilities`
   - 在 Views 下创建子 Group：`Components`

3. 添加现有文件：
   - 右键点击 `App` Group → Add Files to "SnakeGame"
   - 选择 `SnakeGame/App/SnakeGameApp.swift`
   - 确保勾选 "Copy items if needed" 和 "Add to targets: SnakeGame"
   
4. 重复添加所有文件：
   - Models: 添加 Point.swift, Direction.swift, GameState.swift
   - ViewModels: 添加 GameViewModel.swift
   - Views: 添加 GameView.swift, GridView.swift
   - Utilities: 添加 Color+Hex.swift

5. 添加测试文件：
   - 右键点击 `SnakeGameTests` 文件夹
   - Add Files to "SnakeGame"
   - 选择 SnakeGameTests 目录下的所有测试文件
   - 确保 "Add to targets: SnakeGameTests" 被勾选

### 步骤 3: 配置项目设置

1. 选择项目根节点（蓝色图标）
2. 在 TARGETS → SnakeGame → General 中：
   - **Minimum Deployments**: 设置为 iOS 15.0
   - **Display Name**: SnakeGame
   - **Bundle Identifier**: com.yourname.SnakeGame

3. 在 Info 标签页中（如果需要）：
   - 无需额外配置

### 步骤 4: 验证项目

1. 按 **Cmd+B** 构建项目
   - 应该没有编译错误
2. 按 **Cmd+U** 运行测试
   - 所有测试应该通过
3. 按 **Cmd+R** 运行应用
   - 应该看到黑色背景的贪吃蛇游戏

## 方法 2: 使用现有文件快速设置

如果 Xcode 无法直接合并，使用以下步骤：

1. 重命名现有目录：
   ```bash
   cd /Users/drew/test
   mv ios-snake ios-snake-backup
   ```

2. 在 Xcode 中创建新项目（保存到 `/Users/drew/test/ios-snake`）

3. 复制现有文件：
   ```bash
   cp -r ios-snake-backup/SnakeGame/* ios-snake/SnakeGame/
   cp -r ios-snake-backup/SnakeGameTests/* ios-snake/SnakeGameTests/
   cp ios-snake-backup/CLAUDE.md ios-snake/
   cp -r ios-snake-backup/docs ios-snake/
   ```

4. 在 Xcode 中按方法 1 的步骤 2-4 添加文件

## 方法 3: 在终端中打开 Package.swift（临时方案）

如果您只想快速测试代码：

```bash
cd /Users/drew/test/ios-snake
open Package.swift
```

这将在 Xcode 中打开 Swift Package，但无法运行 iOS 应用（只能运行测试）。

## 验证清单

完成设置后，确认以下内容：

- [ ] 项目在 Xcode 中打开无错误
- [ ] 目录结构正确（App/, Models/, ViewModels/, Views/, Utilities/）
- [ ] 所有 Swift 文件都在正确的 Group 中
- [ ] 按 Cmd+B 构建成功
- [ ] 按 Cmd+U 所有测试通过
- [ ] 按 Cmd+R 可以运行应用
- [ ] 应用显示 "TAP TO START" 提示
- [ ] 点击后蛇开始移动
- [ ] 滑动手势可以控制方向

## 遇到问题？

### 问题：无法找到 GameView
**解决方案**：确保 GameView.swift 已添加到 SnakeGame target

### 问题：测试无法运行
**解决方案**：确保测试文件添加到 SnakeGameTests target

### 问题：模拟器显示空白
**解决方案**：检查 SnakeGameApp.swift 是否正确引用 GameView

---

## 下一步

项目设置完成后，您可以：

1. 运行游戏，体验 Phase 1 的核心功能
2. 查看 `docs/plans/2026-01-12-phase1-implementation.md` 了解实现细节
3. 准备开始 Phase 2: UI/UX 完善（虚拟十字键、主题切换等）

如需帮助，请参考 CLAUDE.md 中的项目文档。
