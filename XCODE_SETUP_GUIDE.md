# 🎮 创建 Xcode 项目的正确方法

## 问题
Xcode 不允许在已有文件的目录中创建新项目。

## ✅ 解决方案（2 种方法）

### 方法 1: 在新位置创建项目，然后移动文件（推荐）

**步骤 1: 在桌面临时创建项目**
```
1. 打开 Xcode
2. File → New → Project
3. iOS → App
4. 配置:
   - Product Name: SnakeGame
   - Interface: SwiftUI
   - Language: Swift
5. 保存到: ~/Desktop/SnakeGameTemp
```

**步骤 2: 替换源文件**
```bash
cd ~/Desktop/SnakeGameTemp

# 删除默认文件
rm -f SnakeGame/ContentView.swift

# 复制我们的源文件
cp -r /Users/drew/test/ios-snake/SnakeGame/* SnakeGame/
cp -r /Users/drew/test/ios-snake/SnakeGameTests/* SnakeGameTests/
```

**步骤 3: 在 Xcode 中刷新**
```
1. 在 Xcode 左侧项目导航器中
2. 删除 SnakeGame 和 SnakeGameTests 文件夹（只删除引用）
3. 右键项目 → Add Files to "SnakeGame"...
4. 选择 SnakeGame 和 SnakeGameTests 文件夹
5. 确保勾选 "Copy items if needed"
6. 点击 Add
```

**步骤 4: 运行**
```
按 Cmd+R 运行项目
```

---

### 方法 2: 清空当前目录重新开始

**步骤 1: 备份源代码**
```bash
cd /Users/drew/test
cp -r ios-snake ios-snake-backup
```

**步骤 2: 清空并重新创建**
```bash
cd ios-snake
# 只保留源代码和文档
mkdir -p temp
mv SnakeGame SnakeGameTests docs *.md temp/
rm -rf *
mv temp/* .
rmdir temp
```

**步骤 3: 在 Xcode 中创建项目**
```
现在目录相对干净，可以创建项目了
```

---

## 🚀 我推荐的最快方式

**直接用命令行生成 Xcode 项目文件！**

运行这个脚本：
```bash
cd /Users/drew/test/ios-snake
./generate_xcode_project.sh
```

（我马上为你创建这个脚本）

---

选择你喜欢的方法，告诉我你想用哪个！
