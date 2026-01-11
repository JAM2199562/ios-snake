import SwiftUI

/// 游戏主题枚举
enum Theme: String, CaseIterable, Identifiable {
    case greenTerminal = "绿屏终端"
    case gameBoy = "GameBoy"

    var id: String { self.rawValue }

    /// 背景色
    var backgroundColor: Color {
        switch self {
        case .greenTerminal:
            return Color(hex: "000000") // 纯黑
        case .gameBoy:
            return Color(hex: "0F380F") // 暗绿
        }
    }

    /// 蛇身颜色
    var snakeColor: Color {
        switch self {
        case .greenTerminal:
            return Color(hex: "00FF00") // 荧光绿
        case .gameBoy:
            return Color(hex: "8BAC0F") // 亮绿
        }
    }

    /// 食物颜色
    var foodColor: Color {
        switch self {
        case .greenTerminal:
            return Color(hex: "FF0000") // 红色
        case .gameBoy:
            return Color(hex: "306230") // 中绿
        }
    }

    /// UI 文字颜色
    var textColor: Color {
        switch self {
        case .greenTerminal:
            return Color(hex: "00FF00") // 荧光绿
        case .gameBoy:
            return Color(hex: "8BAC0F") // 亮绿
        }
    }
}

/// 主题管理器
class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme = .greenTerminal

    init() {
        // 从 UserDefaults 读取保存的主题
        if let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme"),
           let theme = Theme(rawValue: savedTheme) {
            currentTheme = theme
        }
    }

    func setTheme(_ theme: Theme) {
        currentTheme = theme
        // 保存到 UserDefaults
        UserDefaults.standard.set(theme.rawValue, forKey: "selectedTheme")
    }
}
