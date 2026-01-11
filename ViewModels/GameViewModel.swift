import Foundation
import Combine

/// 游戏逻辑和状态管理的核心 ViewModel
class GameViewModel: ObservableObject {
    // MARK: - 游戏配置常量
    let gridWidth = 20
    let gridHeight = 30

    // MARK: - Published 状态（自动触发 UI 更新）
    @Published var snake: [Point] = []
    @Published var food: Point?
    @Published var direction: Direction = .right
    @Published var gameState: GameState = .ready
    @Published var score: Int = 0
    @Published var countdownNumber: Int? = nil

    // MARK: - 私有属性
    private var timer: AnyCancellable?
    private let gameSpeed: TimeInterval = 0.2

    // MARK: - 初始化
    init() {
        // 初始化时不启动游戏，等待用户触发
    }

    // MARK: - 公开方法

    /// 开始新游戏
    func startGame() {
        // 初始化蛇的位置（网格中央，长度 3，向右延伸）
        let centerX = gridWidth / 2
        let centerY = gridHeight / 2

        snake = [
            Point(x: centerX, y: centerY),
            Point(x: centerX - 1, y: centerY),
            Point(x: centerX - 2, y: centerY)
        ]

        // 重置游戏状态
        direction = .right
        score = 0
        gameState = .ready

        // 生成第一个食物
        spawnFood()

        // 开始倒数动画
        startCountdown()
    }

    /// 开始倒数动画
    private func startCountdown() {
        countdownNumber = 3

        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }

            if let count = self.countdownNumber {
                if count > 1 {
                    self.countdownNumber = count - 1
                } else {
                    // 倒数结束，开始游戏
                    self.countdownNumber = nil
                    self.gameState = .running
                    self.startTimer()
                    timer.invalidate()
                }
            }
        }
    }

    /// 改变蛇的移动方向（防止 180 度反向转弯）
    func changeDirection(_ newDirection: Direction) {
        // 防止蛇反向移动（撞到自己）
        guard newDirection != direction.opposite else { return }

        direction = newDirection
    }

    // MARK: - 私有辅助方法

    /// 在随机位置生成食物（确保不与蛇身重叠）
    private func spawnFood() {
        var newFood: Point
        repeat {
            newFood = Point(
                x: Int.random(in: 0..<gridWidth),
                y: Int.random(in: 0..<gridHeight)
            )
        } while snake.contains(newFood)

        food = newFood
    }

    /// 启动游戏循环定时器
    private func startTimer() {
        // 停止现有定时器（如果有）
        timer?.cancel()

        // 创建新的定时器
        timer = Timer.publish(every: gameSpeed, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateGame()
            }
    }

    /// 停止游戏循环定时器
    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }

    /// 游戏循环每帧调用，处理蛇移动和碰撞检测
    private func updateGame() {
        // 只在运行状态下更新
        guard gameState == .running else { return }

        // 计算蛇头新位置
        let newHead = snake[0].moved(in: direction)

        // 碰撞检测
        if checkCollision(at: newHead) {
            gameState = .gameOver
            stopTimer()
            return
        }

        // 移动蛇：在头部插入新位置
        snake.insert(newHead, at: 0)

        // 检查是否吃到食物
        if newHead == food {
            // 吃到食物：增加分数，生成新食物，蛇身保持增长
            score += 10
            spawnFood()
            // TODO: 触发音效和触觉反馈（Phase 3）
        } else {
            // 没吃到食物：移除尾巴（保持蛇身长度不变）
            snake.removeLast()
        }
    }

    /// 检查指定位置是否发生碰撞（撞墙或撞自己）
    private func checkCollision(at point: Point) -> Bool {
        // 撞墙检测
        if point.x < 0 || point.x >= gridWidth ||
           point.y < 0 || point.y >= gridHeight {
            return true
        }

        // 撞自己检测（检查新位置是否在当前蛇身中）
        return snake.contains(point)
    }

    #if DEBUG
    // MARK: - 测试辅助方法
    func stopTimer() {
        timer?.cancel()
        timer = nil
    }

    func updateGameManually() {
        updateGame()
    }

    func setFoodForTesting(at point: Point) {
        food = point
    }

    func setSnakeForTesting(at headPosition: Point) {
        snake = [
            headPosition,
            Point(x: headPosition.x - 1, y: headPosition.y),
            Point(x: headPosition.x - 2, y: headPosition.y)
        ]
    }
    #endif
}
