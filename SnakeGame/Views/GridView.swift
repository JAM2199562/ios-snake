import SwiftUI

/// 游戏网格渲染视图
struct GridView: View {
    @ObservedObject var viewModel: GameViewModel
    @EnvironmentObject var themeManager: ThemeManager
    let size: CGSize

    // 计算每个格子的像素大小
    private var cellSize: CGFloat {
        min(
            size.width / CGFloat(viewModel.gridWidth),
            size.height / CGFloat(viewModel.gridHeight)
        )
    }

    var body: some View {
        ZStack {
            // 背景：纯黑色（绿屏终端主题）
            Color(hex: "000000")
                .ignoresSafeArea()

            // 蛇身：荧光绿色方块
            ForEach(viewModel.snake, id: \.self) { point in
                Rectangle()
                    .fill(Color(hex: "00FF00"))
                    .cornerRadius(3) // 轻微圆角
                    .frame(width: cellSize, height: cellSize)
                    .position(
                        x: CGFloat(point.x) * cellSize + cellSize / 2,
                        y: CGFloat(point.y) * cellSize + cellSize / 2
                    )
            }

            // 食物：红色圆形
            if let food = viewModel.food {
                Circle()
                    .fill(Color(hex: "FF0000"))
                    .frame(width: cellSize, height: cellSize)
                    .position(
                        x: CGFloat(food.x) * cellSize + cellSize / 2,
                        y: CGFloat(food.y) * cellSize + cellSize / 2
                    )
            }
        }
    }
}
