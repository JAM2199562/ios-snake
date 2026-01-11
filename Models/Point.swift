import Foundation

/// 表示网格上的坐标点
struct Point: Hashable, Equatable {
    let x: Int
    let y: Int

    /// 根据给定方向移动一格，返回新的坐标点
    func moved(in direction: Direction) -> Point {
        switch direction {
        case .up:
            return Point(x: x, y: y - 1)
        case .down:
            return Point(x: x, y: y + 1)
        case .left:
            return Point(x: x - 1, y: y)
        case .right:
            return Point(x: x + 1, y: y)
        }
    }
}
