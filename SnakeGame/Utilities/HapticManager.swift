import UIKit

/// 触觉反馈管理器
class HapticManager: ObservableObject {
    static let shared = HapticManager()

    @Published var isHapticEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isHapticEnabled, forKey: "hapticEnabled")
        }
    }

    private init() {
        // 从 UserDefaults 读取触觉反馈开关状态
        isHapticEnabled = UserDefaults.standard.bool(forKey: "hapticEnabled")

        // 如果是首次启动，默认开启触觉反馈
        if UserDefaults.standard.object(forKey: "hapticEnabled") == nil {
            isHapticEnabled = true
        }
    }

    /// 播放轻触觉反馈（吃食物时）
    func playLightImpact() {
        guard isHapticEnabled else { return }

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    /// 播放重触觉反馈（游戏结束时）
    func playHeavyImpact() {
        guard isHapticEnabled else { return }

        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
}
