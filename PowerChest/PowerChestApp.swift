import SwiftUI

@main
struct PowerChestApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            MainContentView()
                .environment(appState)
        }
        .defaultSize(width: 920, height: 680)
        .windowToolbarStyle(.unified)
    }
}
