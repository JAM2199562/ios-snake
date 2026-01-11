import SwiftUI

/// 游戏主界面
struct GameView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // 顶部分数栏
            HStack {
                Text("分数: \(viewModel.score)")
                    .font(.system(.title2, design: .monospaced))
                    .foregroundColor(Color(hex: "00FF00"))

                Spacer()
            }
            .padding()
            .frame(height: 44)
            .background(Color(hex: "000000"))

            // 游戏网格区域
            GeometryReader { geometry in
                GridView(viewModel: viewModel, size: geometry.size)
                    .gesture(swipeGesture)
                    .onTapGesture {
                        handleTap()
                    }

                // 游戏结束遮罩
                if viewModel.gameState == .gameOver {
                    ZStack {
                        Color.black.opacity(0.7)

                        VStack(spacing: 20) {
                            Text("GAME OVER")
                                .font(.system(size: 40, weight: .bold, design: .monospaced))
                                .foregroundColor(Color(hex: "00FF00"))

                            Text("分数: \(viewModel.score)")
                                .font(.system(size: 24, design: .monospaced))
                                .foregroundColor(Color(hex: "00FF00"))

                            Text("TAP TO RESTART")
                                .font(.system(size: 16, design: .monospaced))
                                .foregroundColor(Color(hex: "00FF00"))
                                .opacity(0.7)
                        }
                    }
                    .ignoresSafeArea()
                }

                // 开始提示
                if viewModel.gameState == .ready {
                    ZStack {
                        Color.black.opacity(0.5)

                        Text("TAP TO START")
                            .font(.system(size: 24, design: .monospaced))
                            .foregroundColor(Color(hex: "00FF00"))
                    }
                    .ignoresSafeArea()
                }
            }
        }
        .background(Color(hex: "000000"))
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
