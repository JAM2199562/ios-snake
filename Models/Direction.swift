import Foundation

/// 蛇移动的方向
enum Direction {
    case up
    case down
    case left
    case right

    /// 返回当前方向的相反方向（用于防止 180 度转弯）
    var opposite: Direction {
        switch self {
        case .up:
            return .down
        case .down:
            return .up
        case .left:
            return .right
        case .right:
            return .left
        }
    }
}
