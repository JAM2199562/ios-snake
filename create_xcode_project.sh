#!/bin/bash

# SnakeGame Xcode 项目创建脚本
# 使用方法: ./create_xcode_project.sh

set -e

PROJECT_DIR="/Users/drew/test/ios-snake"
PROJECT_NAME="SnakeGame"

echo "🎮 开始创建 SnakeGame Xcode 项目..."

# 检查是否安装了 Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ 错误: 未检测到 Xcode"
    echo "请按照 SETUP_INSTRUCTIONS.md 中的手动步骤操作"
    exit 1
fi

cd "$PROJECT_DIR"

# 使用 xcodegen 或手动创建项目
echo "📋 请在 Xcode 中执行以下操作："
echo ""
echo "1. 打开 Xcode"
echo "2. File → New → Project"
echo "3. 选择 iOS → App"
echo "4. 配置:"
echo "   - Product Name: SnakeGame"
echo "   - Interface: SwiftUI"
echo "   - Language: Swift"
echo "   - 取消勾选 Include Tests"
echo "5. 保存到: /Users/drew/test/ios-snake"
echo ""
echo "然后运行: ./add_files_to_project.sh"
echo ""
echo "✅ 所有源文件已准备就绪！"

