import SwiftUI

/// 虚拟十字键控制组件
struct ControlPadView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let onDirectionChange: (Direction) -> Void
    let onPauseToggle: () -> Void

    @State private var pressedDirection: Direction?
    @State private var isPausePressing = false

    var body: some View {
        ZStack {
            // 中心暂停按钮
            Button(action: {
                onPauseToggle()
                isPausePressing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPausePressing = false
                }
            }) {
                ZStack {
                    Circle()
                        .fill(themeManager.currentTheme.textColor.opacity(isPausePressing ? 0.5 : 0.3))
                        .frame(width: 60, height: 60)

                    // 暂停图标（两条竖线）
                    Image(systemName: "pause.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(themeManager.currentTheme.textColor)
                }
            }

            // 上方向键
            DirectionButton(direction: .up, isPressed: pressedDirection == .up)
                .offset(y: -50)

            // 下方向键
            DirectionButton(direction: .down, isPressed: pressedDirection == .down)
                .offset(y: 50)

            // 左方向键
            DirectionButton(direction: .left, isPressed: pressedDirection == .left)
                .offset(x: -50)

            // 右方向键
            DirectionButton(direction: .right, isPressed: pressedDirection == .right)
                .offset(x: 50)
        }
        .opacity(0.6)
    }

    @ViewBuilder
    private func DirectionButton(direction: Direction, isPressed: Bool) -> some View {
        Button(action: {
            onDirectionChange(direction)
            pressedDirection = direction
            // 0.1秒后重置按压状态
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                pressedDirection = nil
            }
        }) {
            Image(systemName: arrowName(for: direction))
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(themeManager.currentTheme.textColor)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(themeManager.currentTheme.textColor.opacity(isPressed ? 0.8 : 0.4))
                )
        }
    }

    private func arrowName(for direction: Direction) -> String {
        switch direction {
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        case .left: return "arrow.left"
        case .right: return "arrow.right"
        }
    }
}
