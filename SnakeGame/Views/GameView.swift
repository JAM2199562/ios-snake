import SwiftUI

/// 游戏主界面
struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // 顶部分数栏
                HStack {
                    Text("分数: \(viewModel.score)")
                        .font(.system(.title2, design: .monospaced))
                        .foregroundColor(themeManager.currentTheme.textColor)

                    Spacer()

                    // 临时开始按钮（调试用）
                    Button("START") {
                        print("🔘 按钮点击！")
                        viewModel.startGame()
                    }
                    .foregroundColor(Color(hex: "00FF00"))
                    .font(.system(.body, design: .monospaced))
                }
                .padding()
                .frame(height: 44)
                .background(themeManager.currentTheme.backgroundColor)

                // 游戏网格区域
                GeometryReader { geometry in
                    ZStack {
                        GridView(viewModel: viewModel, size: geometry.size)

                        // 游戏结束遮罩
                        if viewModel.gameState == .gameOver {
                            ZStack {
                                Color.black.opacity(0.7)

                                VStack(spacing: 20) {
                                    Text("GAME OVER")
                                        .font(.system(size: 40, weight: .bold, design: .monospaced))
                                        .foregroundColor(themeManager.currentTheme.textColor)

                                    Text("分数: \(viewModel.score)")
                                        .font(.system(size: 24, design: .monospaced))
                                        .foregroundColor(themeManager.currentTheme.textColor)

                                    Button("重新开始") {
                                        viewModel.startGame()
                                    }
                                    .foregroundColor(themeManager.currentTheme.textColor)
                                    .font(.system(size: 16, design: .monospaced))
                                }
                            }
                        }

                        // 开始提示
                        if viewModel.gameState == .ready {
                            ZStack {
                                Color.black.opacity(0.5)

                                VStack(spacing: 20) {
                                    Text("TAP TO START")
                                        .font(.system(size: 24, design: .monospaced))
                                        .foregroundColor(themeManager.currentTheme.textColor)
                                }
                            }
                        }

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
                    }
                    .gesture(swipeGesture)
                    .onTapGesture {
                        print("🖱️ 屏幕点击！")
                        handleTap()
                    }
                }
            }
            .background(themeManager.currentTheme.backgroundColor)
        }
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

    /// 点击屏幕处理
    private func handleTap() {
        print("🎮 handleTap 被调用！当前状态: \(viewModel.gameState)")
        if viewModel.gameState == .ready || viewModel.gameState == .gameOver {
            print("🎮 启动游戏！")
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
