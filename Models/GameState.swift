import Foundation

/// 游戏的当前状态
enum GameState {
    case ready      // 准备开始（初始状态）
    case running    // 游戏进行中
    case paused     // 暂停
    case gameOver   // 游戏结束
}
