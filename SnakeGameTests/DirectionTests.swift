import XCTest
@testable import SnakeGame

final class DirectionTests: XCTestCase {
    func test_oppositeDirections() {
        XCTAssertEqual(Direction.up.opposite, .down)
        XCTAssertEqual(Direction.down.opposite, .up)
        XCTAssertEqual(Direction.left.opposite, .right)
        XCTAssertEqual(Direction.right.opposite, .left)
    }
}
