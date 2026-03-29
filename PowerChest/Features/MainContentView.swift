import SwiftUI

struct MainContentView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var state = appState

        NavigationSplitView {
            SidebarView(appState: state)
        } detail: {
            detailView
                .navigationTitle(appState.selectedSidebarItem?.displayName ?? "PowerChest")
                .navigationSubtitle(navigationSubtitle)
        }
        .navigationSplitViewColumnWidth(min: 200, ideal: 230, max: 280)
    }

    private var navigationSubtitle: String {
        switch appState.selectedSidebarItem {
        case .home: return ""
        case .appSettings: return ""
        default: return appState.userMode == .powerUser ? "Power User" : "Propellerhead"
        }
    }

    @ViewBuilder
    private var detailView: some View {
        switch appState.selectedSidebarItem {
        case .home, nil:
            HomeView()
        case .snapshots:
            SnapshotsView()
        case .changes:
            ChangesView()
        case .appSettings:
            AppSettingsView()
        case let item? where item.settingCategory != nil:
            CategoryPaneView(category: item.settingCategory!)
        default:
            Text("Select an item")
                .foregroundStyle(.secondary)
        }
    }
}
