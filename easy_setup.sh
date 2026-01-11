#!/bin/bash

# SnakeGame - 最简单的项目创建方法
# 3 步搞定！

echo "🎮 SnakeGame - 超简单 3 步设置法"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "第 1 步: 在桌面创建临时 Xcode 项目"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "请在 Xcode 中操作："
echo "1. File → New → Project"
echo "2. iOS → App → Next"
echo "3. 配置："
echo "   Product Name: SnakeGame"
echo "   Interface: SwiftUI"
echo "   Language: Swift"
echo "   取消勾选 Include Tests"
echo "4. 保存到桌面: ~/Desktop/SnakeGameTemp"
echo ""
echo "完成后按 Enter 继续..."
read

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "第 2 步: 复制我们的源代码"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

TEMP_DIR="$HOME/Desktop/SnakeGameTemp"
SOURCE_DIR="/Users/drew/test/ios-snake"

if [ ! -d "$TEMP_DIR" ]; then
    echo "❌ 错误: 未找到 $TEMP_DIR"
    echo "请确保在桌面创建了项目"
    exit 1
fi

echo "✓ 删除默认文件..."
rm -f "$TEMP_DIR/SnakeGame/ContentView.swift"

echo "✓ 复制源代码..."
cp -r "$SOURCE_DIR/SnakeGame/"* "$TEMP_DIR/SnakeGame/"

echo "✓ 复制测试代码..."
if [ -d "$TEMP_DIR/SnakeGameTests" ]; then
    cp -r "$SOURCE_DIR/SnakeGameTests/"* "$TEMP_DIR/SnakeGameTests/"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "第 3 步: 在 Xcode 中添加文件"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "在 Xcode 中操作："
echo "1. 在左侧删除 SnakeGame 文件夹（只删除引用，不删除文件）"
echo "2. 右键项目 → Add Files to \"SnakeGame\"..."
echo "3. 选择这些文件夹（Cmd+点击多选）："
echo "   ☑️ SnakeGame/App"
echo "   ☑️ SnakeGame/Models"
echo "   ☑️ SnakeGame/ViewModels"
echo "   ☑️ SnakeGame/Views"
echo "   ☑️ SnakeGame/Utilities"
echo "4. ☑️ 勾选 \"Create groups\""
echo "5. Target: ☑️ SnakeGame"
echo "6. 点击 Add"
echo ""
echo "7. 重复步骤 1-6 添加测试文件（如果有 SnakeGameTests 文件夹）"
echo ""
echo "8. 按 Cmd+R 运行！"
echo ""
echo "✅ 完成！你应该看到黑屏显示 \"TAP TO START\""
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🎮 项目位置: $TEMP_DIR"
echo "📱 点击屏幕开始游戏！"
