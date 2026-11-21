import SwiftUI

@main
struct TurtleBridgeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .defaultSize(width: 680, height: 620)
        .windowResizability(.contentMinSize)
    }
}
