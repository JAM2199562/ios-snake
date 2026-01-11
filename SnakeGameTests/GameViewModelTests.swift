import XCTest
import Combine
@testable import SnakeGame

final class GameViewModelTests: XCTestCase {
    var viewModel: GameViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        viewModel = GameViewModel()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        viewModel = nil
        super.tearDown()
    }

    func test_initialState() {
        XCTAssertEqual(viewModel.gameState, .ready)
        XCTAssertEqual(viewModel.score, 0)
        XCTAssertEqual(viewModel.direction, .right)
        XCTAssertTrue(viewModel.snake.isEmpty)
        XCTAssertNil(viewModel.food)
    }

    func test_startGame_initializesSnake() {
        viewModel.startGame()

        XCTAssertEqual(viewModel.snake.count, 3)
        XCTAssertEqual(viewModel.gameState, .running)
        XCTAssertNotNil(viewModel.food)
    }

    func test_startGame_snakeStartsInCenter() {
        viewModel.startGame()

        let centerX = viewModel.gridWidth / 2
        let centerY = viewModel.gridHeight / 2

        XCTAssertEqual(viewModel.snake[0], Point(x: centerX, y: centerY))
        XCTAssertEqual(viewModel.snake[1], Point(x: centerX - 1, y: centerY))
        XCTAssertEqual(viewModel.snake[2], Point(x: centerX - 2, y: centerY))
    }

    func test_startGame_foodNotOnSnake() {
        viewModel.startGame()

        guard let food = viewModel.food else {
            XCTFail("Food should be spawned")
            return
        }

        XCTAssertFalse(viewModel.snake.contains(food))
    }

    func test_updateGame_snakeMoves() {
        viewModel.startGame()
        let initialHead = viewModel.snake[0]

        // 手动调用 updateGame（绕过定时器）
        viewModel.stopTimer()
        viewModel.updateGameManually()

        let newHead = viewModel.snake[0]
        XCTAssertEqual(newHead, initialHead.moved(in: .right))
    }

    func test_updateGame_snakeEatsFood() {
        viewModel.startGame()
        viewModel.stopTimer()

        let initialLength = viewModel.snake.count
        let initialScore = viewModel.score

        // 将食物放在蛇头前方
        viewModel.setFoodForTesting(at: viewModel.snake[0].moved(in: .right))

        viewModel.updateGameManually()

        XCTAssertEqual(viewModel.snake.count, initialLength + 1)
        XCTAssertEqual(viewModel.score, initialScore + 10)
    }

    func test_updateGame_snakeHitsWall() {
        viewModel.startGame()
        viewModel.stopTimer()

        // 将蛇移到边缘
        viewModel.setSnakeForTesting(at: Point(x: 19, y: 15))
        viewModel.changeDirection(.right)

        viewModel.updateGameManually()

        XCTAssertEqual(viewModel.gameState, .gameOver)
    }

    func test_changeDirection_allowsValidChange() {
        viewModel.startGame()
        viewModel.changeDirection(.up)

        XCTAssertEqual(viewModel.direction, .up)
    }

    func test_changeDirection_preventsOppositeDirection() {
        viewModel.startGame() // 初始方向是 .right
        viewModel.changeDirection(.left) // 尝试反向

        XCTAssertEqual(viewModel.direction, .right) // 应该保持原方向
    }

    func test_changeDirection_allowsPerpendicularChange() {
        viewModel.startGame() // 初始方向是 .right
        viewModel.changeDirection(.up)

        XCTAssertEqual(viewModel.direction, .up)
    }
}
