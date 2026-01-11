#!/bin/bash

# SnakeGame - 自动生成 Xcode 项目脚本
# 使用 xcodeproj gem 生成项目文件

set -e

echo "🎮 自动生成 SnakeGame Xcode 项目..."

PROJECT_DIR="/Users/drew/test/ios-snake"
cd "$PROJECT_DIR"

# 检查是否安装了 xcodeproj
if ! gem list xcodeproj -i > /dev/null 2>&1; then
    echo "📦 正在安装 xcodeproj gem..."
    gem install xcodeproj
fi

# 创建项目生成脚本
cat > generate_project.rb << 'EOF'
require 'xcodeproj'

project = Xcodeproj::Project.new('SnakeGame.xcodeproj')

# 设置项目属性
project.root_object.build_configuration_list.set_setting('IPHONEOS_DEPLOYMENT_TARGET', '15.0')

# 创建主 target
main_target = project.new_target(:application, 'SnakeGame', :ios, '15.0')

# 创建测试 target
test_target = project.new_target(:unit_test_bundle, 'SnakeGameTests', :ios, '15.0')
test_target.add_dependency(main_target)

# 创建组结构
main_group = project.main_group
app_group = main_group.new_group('SnakeGame')
test_group = main_group.new_group('SnakeGameTests')

# 添加源文件夹
['App', 'Models', 'ViewModels', 'Views', 'Utilities'].each do |folder|
  folder_group = app_group.new_group(folder)
  Dir.glob("SnakeGame/#{folder}/**/*.swift").each do |file|
    file_ref = folder_group.new_file(file)
    main_target.add_file_references([file_ref])
  end
end

# 添加 Views/Components 子文件夹
components_group = app_group['Views'].new_group('Components')

# 添加测试文件
Dir.glob("SnakeGameTests/**/*.swift").each do |file|
  file_ref = test_group.new_file(file)
  test_target.add_file_references([file_ref])
end

# 设置构建配置
main_target.build_configurations.each do |config|
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'com.example.SnakeGame'
  config.build_settings['INFOPLIST_FILE'] = 'SnakeGame/Info.plist'
  config.build_settings['SWIFT_VERSION'] = '5.0'
  config.build_settings['TARGETED_DEVICE_FAMILY'] = '1,2'
  config.build_settings['CODE_SIGN_STYLE'] = 'Automatic'
end

test_target.build_configurations.each do |config|
  config.build_settings['BUNDLE_LOADER'] = '$(TEST_HOST)'
  config.build_settings['TEST_HOST'] = "$(BUILT_PRODUCTS_DIR)/SnakeGame.app/SnakeGame"
  config.build_settings['SWIFT_VERSION'] = '5.0'
end

# 保存项目
project.save

puts "✅ Xcode 项目已生成！"
EOF

# 运行生成脚本
ruby generate_project.rb

# 创建 Info.plist
cat > SnakeGame/Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>UIApplicationSceneManifest</key>
	<dict>
		<key>UIApplicationSupportsMultipleScenes</key>
		<false/>
		<key>UISceneConfigurations</key>
		<dict>
			<key>UIWindowSceneSessionRoleApplication</key>
			<array>
				<dict>
					<key>UISceneConfigurationName</key>
					<string>Default Configuration</string>
					<key>UISceneDelegateClassName</key>
					<string>$(PRODUCT_MODULE_NAME).SceneDelegate</string>
				</dict>
			</array>
		</dict>
	</dict>
</dict>
</plist>
EOF

# 清理
rm -f generate_project.rb

echo ""
echo "✅ 完成！现在可以："
echo "1. 在 Xcode 中打开: open SnakeGame.xcodeproj"
echo "2. 或直接运行: xcodebuild -scheme SnakeGame -destination 'platform=iOS Simulator,name=iPhone 15' build"
echo ""
echo "🎮 准备开始玩贪吃蛇了！"
