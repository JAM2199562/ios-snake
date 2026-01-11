import SwiftUI

@main
struct SnakeGameApp: App {
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            GameView()
                .environmentObject(themeManager)
        }
    }
}
