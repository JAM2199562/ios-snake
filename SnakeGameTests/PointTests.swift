import XCTest
@testable import SnakeGame

final class PointTests: XCTestCase {
    func test_pointEquality() {
        let point1 = Point(x: 5, y: 10)
        let point2 = Point(x: 5, y: 10)
        let point3 = Point(x: 3, y: 10)

        XCTAssertEqual(point1, point2)
        XCTAssertNotEqual(point1, point3)
    }

    func test_pointHashable() {
        let point1 = Point(x: 5, y: 10)
        let point2 = Point(x: 5, y: 10)

        let set: Set<Point> = [point1, point2]
        XCTAssertEqual(set.count, 1) // 相同的点应该只存储一次
    }

    func test_movedUp() {
        let point = Point(x: 5, y: 10)
        let moved = point.moved(in: .up)

        XCTAssertEqual(moved, Point(x: 5, y: 9))
    }

    func test_movedDown() {
        let point = Point(x: 5, y: 10)
        let moved = point.moved(in: .down)

        XCTAssertEqual(moved, Point(x: 5, y: 11))
    }

    func test_movedLeft() {
        let point = Point(x: 5, y: 10)
        let moved = point.moved(in: .left)

        XCTAssertEqual(moved, Point(x: 4, y: 10))
    }

    func test_movedRight() {
        let point = Point(x: 5, y: 10)
        let moved = point.moved(in: .right)

        XCTAssertEqual(moved, Point(x: 6, y: 10))
    }
}
