#!/bin/bash

# SnakeGame - Xcode 项目文件整理脚本
# 运行此脚本来整理 Xcode 生成的文件

set -e

echo "🎮 整理 SnakeGame Xcode 项目文件..."

PROJECT_DIR="/Users/drew/test/ios-snake"
cd "$PROJECT_DIR"

# 1. 删除 Xcode 自动生成的重复文件
if [ -f "SnakeGame/SnakeGameApp.swift" ]; then
    echo "✓ 检测到 Xcode 生成的 SnakeGameApp.swift，将使用我们的版本"
    rm -f "SnakeGame/SnakeGameApp.swift"
fi

if [ -f "SnakeGame/ContentView.swift" ]; then
    echo "✓ 删除默认的 ContentView.swift"
    rm -f "SnakeGame/ContentView.swift"
fi

# 2. 检查我们的源文件是否存在
echo ""
echo "📁 检查源文件..."
echo "✓ App/SnakeGameApp.swift: $([ -f SnakeGame/App/SnakeGameApp.swift ] && echo '存在' || echo '缺失')"
echo "✓ Models/Point.swift: $([ -f SnakeGame/Models/Point.swift ] && echo '存在' || echo '缺失')"
echo "✓ ViewModels/GameViewModel.swift: $([ -f SnakeGame/ViewModels/GameViewModel.swift ] && echo '存在' || echo '缺失')"
echo "✓ Views/GameView.swift: $([ -f SnakeGame/Views/GameView.swift ] && echo '存在' || echo '缺失')"

echo ""
echo "✅ 文件整理完成！"
echo ""
echo "📋 下一步操作："
echo "1. 在 Xcode 中，右键点击 SnakeGame 文件夹"
echo "2. 选择 'Add Files to SnakeGame...'"
echo "3. 选中以下文件夹（按住 Cmd 多选）："
echo "   - SnakeGame/App"
echo "   - SnakeGame/Models"
echo "   - SnakeGame/ViewModels"
echo "   - SnakeGame/Views"
echo "   - SnakeGame/Utilities"
echo "4. 确保勾选 'Copy items if needed'"
echo "5. 点击 'Add'"
echo ""
echo "6. 对 SnakeGameTests 文件夹重复上述步骤"
echo ""
echo "然后按 Cmd+R 运行项目！🎮"
