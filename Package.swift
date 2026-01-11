// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SnakeGame",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SnakeGame",
            targets: ["SnakeGame"])
    ],
    targets: [
        .target(
            name: "SnakeGame",
            path: "SnakeGame"),
        .testTarget(
            name: "SnakeGameTests",
            dependencies: ["SnakeGame"],
            path: "SnakeGameTests")
    ]
)
