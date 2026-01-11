import AVFoundation

/// 音效管理器
class SoundManager: ObservableObject {
    static let shared = SoundManager()

    @Published var isSoundEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isSoundEnabled, forKey: "soundEnabled")
        }
    }

    private init() {
        // 从 UserDefaults 读取音效开关状态
        isSoundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")

        // 如果是首次启动，默认开启音效
        if UserDefaults.standard.object(forKey: "soundEnabled") == nil {
            isSoundEnabled = true
        }
    }

    /// 播放吃食物音效
    func playEatSound() {
        guard isSoundEnabled else { return }

        // 使用系统音效 ID 1103（Pop 音效）
        AudioServicesPlaySystemSound(1103)
    }

    /// 播放游戏结束音效
    func playGameOverSound() {
        guard isSoundEnabled else { return }

        // 使用系统音效 ID 1053（短促音效）
        AudioServicesPlaySystemSound(1053)
    }
}
