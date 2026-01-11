import SwiftUI

/// 游戏主界面
struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showSettings = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // 顶部分数栏
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

                        // 倒数动画
                        if let countdown = viewModel.countdownNumber {
                            ZStack {
                                Color.black.opacity(0.7)

                                Text("\(countdown)")
                                    .font(.system(size: 80, weight: .bold, design: .monospaced))
                                    .foregroundColor(themeManager.currentTheme.textColor)
                                    .transition(.scale.combined(with: .opacity))
                            }
                            .ignoresSafeArea()
                        }

                        // 虚拟十字键（仅在游戏进行中或暂停时显示）
                        if viewModel.gameState == .running || viewModel.gameState == .paused {
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    ControlPadView(
                                        onDirectionChange: { direction in
                                            viewModel.changeDirection(direction)
                                        },
                                        onPauseToggle: {
                                            viewModel.togglePause()
                                        }
                                    )
                                    .padding(.trailing, 80)
                                    .padding(.bottom, 80)
                                }
                            }
                        }
                    }
                    .gesture(swipeGesture)
                    .onTapGesture {
                        handleTap()
                    }
                }
            }
            .background(themeManager.currentTheme.backgroundColor)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(themeManager)
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
        if viewModel.gameState == .ready || viewModel.gameState == .gameOver {
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
