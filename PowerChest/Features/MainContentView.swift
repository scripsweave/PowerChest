import SwiftUI

struct MainContentView: View {
    @Environment(AppState.self) private var appState
    @State private var toolbarQuery = ""
    @Namespace private var searchNamespace
    @State private var toastDismissTask: DispatchWorkItem?
    @State private var presetSpotlightTask: DispatchWorkItem?
    @State private var settingSpotlightTask: DispatchWorkItem?
    @State private var restartPromptRequirement: RestartRequirement?
    @State private var searchIndex = SearchIndex()

    var body: some View {
        @Bindable var state = appState

        NavigationSplitView {
            SidebarView(appState: state, searchQuery: $toolbarQuery)
        } detail: {
            ZStack(alignment: .top) {
                detailView
                    .textSelection(.enabled)
                    .blur(radius: isShowingSearchResults ? 12 : 0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.85), value: isShowingSearchResults)

                if isShowingSearchResults {
                    SearchResultsOverlay(
                        query: toolbarQuery,
                        results: searchResults,
                        onSelect: handleSearchSelection
                    )
                    .matchedGeometryEffect(id: "searchOverlay", in: searchNamespace)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .navigationTitle(appState.selectedSidebarItem?.displayName ?? "PowerChest")
            .navigationSubtitle(navigationSubtitle)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ModePicker(userMode: $state.userMode)
                }
            }
            .overlay(alignment: .topTrailing) {
                if let toast = appState.toast {
                    ToastView(toast: toast)
                        .padding(.top, 16)
                        .padding(.trailing, 24)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
        }
        .overlay {
            if let progress = appState.applyProgress {
                ApplyProgressOverlay(progress: progress)
            }
        }
        .navigationSplitViewColumnWidth(min: 200, ideal: 230, max: 280)
        .animation(.spring(response: 0.28, dampingFraction: 0.9), value: searchResults.count)
        .onAppear {
            if searchIndex.isEmpty {
                rebuildSearchIndex()
            }
        }
        .onChange(of: appState.toast?.id) { _ in
            scheduleToastDismissal()
        }
        .onChange(of: appState.pendingRestartRequests) { _ in
            restartPromptRequirement = appState.pendingRestartRequests.first
        }
        .onReceive(NotificationCenter.default.publisher(for: .menuCreateSnapshot)) { note in
            guard note.object == nil else { return }
            appState.selectedSidebarItem = .home
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NotificationCenter.default.post(name: .menuCreateSnapshot, object: "forwarded")
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .menuExportConfig)) { note in
            guard note.object == nil else { return }
            appState.selectedSidebarItem = .home
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NotificationCenter.default.post(name: .menuExportConfig, object: "forwarded")
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .menuImportConfig)) { note in
            guard note.object == nil else { return }
            appState.selectedSidebarItem = .home
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NotificationCenter.default.post(name: .menuImportConfig, object: "forwarded")
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .menuSavePreset)) { note in
            guard note.object == nil else { return }
            appState.selectedSidebarItem = .home
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NotificationCenter.default.post(name: .menuSavePreset, object: "forwarded")
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .menuResetToDefaults)) { note in
            guard note.object == nil else { return }
            appState.selectedSidebarItem = .home
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NotificationCenter.default.post(name: .menuResetToDefaults, object: "forwarded")
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .menuRestoreSnapshot)) { _ in
            appState.selectedSidebarItem = .snapshots
        }
        .confirmationDialog("Restart required",
                            isPresented: Binding(
                                get: { restartPromptRequirement != nil },
                                set: { presented in
                                    if !presented { restartPromptRequirement = nil }
                                }),
                            presenting: restartPromptRequirement) { requirement in
            Button(restartConfirmTitle(for: requirement)) {
                performRestart(requirement)
            }
            Button("Later", role: .cancel) {
                appState.dequeueRestart(requirement)
                restartPromptRequirement = appState.pendingRestartRequests.first
            }
        } message: { requirement in
            Text(restartPromptMessage(for: requirement))
        }
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

    private var normalizedQuery: String {
        toolbarQuery.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var searchResults: [SearchResult] {
        let query = normalizedQuery.lowercased()
        guard query.count >= 2 else { return [] }

        var matches: [SearchResult] = []

        let categoryMatches = searchIndex.categoryEntries
            .filter { $0.searchable.contains(query) }
            .prefix(5)
            .map { SearchResult.category($0.item) }
        matches.append(contentsOf: categoryMatches)

        let settingMatches = searchIndex.settingEntries
            .filter { $0.searchable.contains(query) }
            .prefix(15)
            .map { SearchResult.setting($0.definition) }
        matches.append(contentsOf: settingMatches)

        let presetMatches = searchIndex.presetEntries
            .filter { $0.searchable.contains(query) }
            .prefix(8)
            .map { SearchResult.preset($0.preset) }
        matches.append(contentsOf: presetMatches)

        return matches
    }

    private var isShowingSearchResults: Bool {
        !searchResults.isEmpty
    }

    private func handleSearchSelection(_ result: SearchResult) {
        switch result {
        case .category(let item):
            appState.selectedSidebarItem = item
            appState.spotlightSettingID = nil
        case .setting(let definition):
            if let item = SidebarItem.allCases.first(where: { $0.settingCategory == definition.category }) {
                appState.selectedSidebarItem = item
            }
            appState.spotlightSettingID = definition.id
            settingSpotlightTask?.cancel()
            let task = DispatchWorkItem {
                if appState.spotlightSettingID == definition.id {
                    appState.spotlightSettingID = nil
                }
            }
            settingSpotlightTask = task
            DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: task)
        case .preset(let preset):
            appState.selectedSidebarItem = .home
            appState.spotlightSettingID = nil
            appState.spotlightPresetID = preset.id
            schedulePresetSpotlightClear(for: preset.id)
        }

        toolbarQuery = ""
    }

    private func scheduleToastDismissal() {
        toastDismissTask?.cancel()
        guard appState.toast != nil else { return }
        let task = DispatchWorkItem {
            withAnimation {
                appState.toast = nil
            }
        }
        toastDismissTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: task)
    }

    private func schedulePresetSpotlightClear(for presetID: String) {
        presetSpotlightTask?.cancel()
        let task = DispatchWorkItem {
            if appState.spotlightPresetID == presetID {
                appState.spotlightPresetID = nil
            }
        }
        presetSpotlightTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: task)
    }

    private func rebuildSearchIndex() {
        var index = SearchIndex()

        index.categoryEntries = SidebarItem.allCases.map { item in
            let text = [item.displayName, item.categoryDescription ?? ""]
                .joined(separator: " ")
                .lowercased()
            return (item: item, searchable: text)
        }

        let definitions = appState.catalogService.shippingDefinitions()
        index.settingEntries = definitions.map { def in
            let tokens: [String] = [
                def.displayName,
                def.powerUserLabel ?? "",
                def.propellerheadDescription,
                def.category.rawValue
            ] + def.searchAliases
            let searchable = tokens.joined(separator: " ").lowercased()
            return (definition: def, searchable: searchable)
        }

        let presets = appState.allPresets
        index.presetEntries = presets.map { preset in
            let tokens = [preset.name, preset.description]
            let searchable = tokens.joined(separator: " ").lowercased()
            return (preset: preset, searchable: searchable)
        }

        searchIndex = index
    }

    private func performRestart(_ requirement: RestartRequirement) {
        if let action = appState.performRestart(requirement) {
            appState.presentToast(
                title: restartTitle(for: requirement),
                subtitle: action.userMessage.isEmpty ? nil : action.userMessage,
                icon: "arrow.triangle.2.circlepath"
            )
        } else {
            appState.presentToast(title: restartTitle(for: requirement), subtitle: nil, icon: "arrow.triangle.2.circlepath")
        }
        appState.dequeueRestart(requirement)
        restartPromptRequirement = appState.pendingRestartRequests.first
    }

    private func restartTitle(for requirement: RestartRequirement) -> String {
        switch requirement {
        case .dock: return "Dock restarted"
        case .finder: return "Finder restarted"
        case .systemUIServer: return "Menu bar refreshed"
        case .safari: return "Safari restart"
        case .app(let id): return "\(id) restarted"
        case .signOut: return "Sign out pending"
        case .reboot: return "Restart pending"
        case .none: return "No restart"
        }
    }

    private func restartConfirmTitle(for requirement: RestartRequirement) -> String {
        switch requirement {
        case .dock: return "Restart Dock"
        case .finder: return "Restart Finder"
        case .systemUIServer: return "Restart Menu Bar"
        case .safari: return "Relaunch Safari"
        case .app(let id): return "Restart \(id)"
        case .signOut: return "Sign Out Later"
        case .reboot: return "Reminder Later"
        case .none: return "Restart"
        }
    }

    private func restartPromptMessage(for requirement: RestartRequirement) -> String {
        switch requirement {
        case .dock:
            return "Dock relaunch makes animation tweaks stick."
        case .finder:
            return "Finder relaunch applies file browser changes."
        case .systemUIServer:
            return "Refreshing the menu bar applies status-item tweaks."
        case .safari:
            return "Safari needs a relaunch for this setting to take effect."
        case .app(let id):
            return "\(id) needs a restart."
        case .signOut:
            return "This change takes effect the next time you sign out."
        case .reboot:
            return "A full restart is required to finish applying this change."
        case .none:
            return ""
        }
    }
}

// MARK: - Toolbar Helpers

private struct ModePicker: View {
    @Binding var userMode: UserMode

    var body: some View {
        Picker("User Mode", selection: $userMode) {
            Text("Power User").tag(UserMode.powerUser)
            Text("Propellerhead").tag(UserMode.propellerhead)
        }
        .pickerStyle(.segmented)
        .frame(width: 220)
        .help("Switch between the playful grouping view and the raw settings list.")
    }
}

// MARK: - Search Result Overlay

private enum SearchResult: Identifiable {
    case category(SidebarItem)
    case setting(SettingDefinition)
    case preset(PresetDefinition)

    var id: String {
        switch self {
        case .category(let item): return "category-\(item.id)"
        case .setting(let def): return "setting-\(def.id)"
        case .preset(let preset): return "preset-\(preset.id)"
        }
    }
}

private struct SearchResultsOverlay: View {
    let query: String
    let results: [SearchResult]
    let onSelect: (SearchResult) -> Void

    private var categoryResults: [SearchResult] {
        results.filter {
            if case .category = $0 { return true }
            return false
        }
    }

    private var settingResults: [SearchResult] {
        results.filter {
            if case .setting = $0 { return true }
            return false
        }
    }

    private var presetResults: [SearchResult] {
        results.filter {
            if case .preset = $0 { return true }
            return false
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Results for \"\(query)\"")
                    .font(.headline)
                Spacer()
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    if !categoryResults.isEmpty {
                        Text("Categories")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        ForEach(categoryResults) { result in
                            SearchRow(result: result, accent: .accentColor, onSelect: onSelect)
                        }
                    }

                    if !settingResults.isEmpty {
                        Text("Settings")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        ForEach(settingResults) { result in
                            SearchRow(result: result, accent: .mint, onSelect: onSelect)
                        }
                    }

                    if !presetResults.isEmpty {
                        Text("Presets")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        ForEach(presetResults) { result in
                            SearchRow(result: result, accent: .pink, onSelect: onSelect)
                        }
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: 420)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.top, 40)
        .padding(.horizontal, 40)
        .shadow(color: .black.opacity(0.2), radius: 20, y: 12)
    }

    private struct SearchRow: View {
        let result: SearchResult
        let accent: Color
        let onSelect: (SearchResult) -> Void

        var body: some View {
            Button {
                onSelect(result)
            } label: {
                HStack(alignment: .center, spacing: 12) {
                    Image(systemName: icon)
                        .frame(width: 28, height: 28)
                        .background(accent.opacity(0.2), in: RoundedRectangle(cornerRadius: 8))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.headline)
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "arrow.turn.up.right")
                        .foregroundStyle(.secondary)
                }
                .padding(10)
                .background(Color(nsColor: .textBackgroundColor).opacity(0.8), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .buttonStyle(.plain)
        }

        private var title: String {
            switch result {
            case .category(let item): return item.displayName
            case .setting(let def): return def.displayName
            case .preset(let preset): return preset.name
            }
        }

        private var subtitle: String {
            switch result {
            case .category:
                return "Category"
            case .setting(let def):
                return truncated(def.propellerheadDescription)
            case .preset(let preset):
                return "Preset · " + truncated(preset.description)
            }
        }

        private var icon: String {
            switch result {
            case .category(let item):
                return item.systemImage
            case .setting:
                return "slider.horizontal.3"
            case .preset:
                return "wand.and.stars"
            }
        }

        private func truncated(_ text: String) -> String {
            if text.count <= 60 { return text }
            return text.prefix(57) + "…"
        }
    }
}

// MARK: - Toast View

private struct ToastView: View {
    let toast: AppToast

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: toast.icon)
                .font(.callout)
                .foregroundStyle(.white)
            VStack(alignment: .leading, spacing: 2) {
                Text(toast.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                if let subtitle = toast.subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(LinearGradient(colors: [.indigo, .purple], startPoint: .leading, endPoint: .trailing))
        )
        .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
    }
}

private struct RestartPromptView: View {
    let requirement: RestartRequirement
    let onConfirm: () -> Void
    let onSkip: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .foregroundStyle(.white)
                VStack(alignment: .leading, spacing: 2) {
                    Text(promptTitle)
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text(promptDescription)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.85))
                }
            }

            HStack {
                Button("Later", action: onSkip)
                    .buttonStyle(.bordered)
                    .tint(.white)
                Button("Restart now", action: onConfirm)
                    .buttonStyle(.borderedProminent)
                    .tint(.white)
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(LinearGradient(colors: [.purple, .blue], startPoint: .leading, endPoint: .trailing))
        )
        .shadow(color: .black.opacity(0.25), radius: 14, y: 6)
    }

    private var promptTitle: String {
        switch requirement {
        case .dock: return "Restart Dock?"
        case .finder: return "Restart Finder?"
        default: return "Restart now?"
        }
    }

    private var promptDescription: String {
        switch requirement {
        case .dock: return "Dock relaunch makes animation tweaks stick."
        case .finder: return "Finder relaunch applies file browser changes."
        default: return "A restart helps finalize this change."
        }
    }
}

// MARK: - Search Index

// MARK: - Apply Progress Overlay

private struct ApplyProgressOverlay: View {
    let progress: ApplyProgress

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                ProgressView(value: progress.fraction) {
                    Text("Applying changes\u{2026}")
                        .font(.headline)
                } currentValueLabel: {
                    Text("\(progress.completed) of \(progress.total) — \(progress.currentSettingName)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .progressViewStyle(.linear)
            }
            .padding(32)
            .frame(width: 380)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.regularMaterial)
            )
            .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
        }
    }
}

private struct SearchIndex {
    var categoryEntries: [(item: SidebarItem, searchable: String)] = []
    var settingEntries: [(definition: SettingDefinition, searchable: String)] = []
    var presetEntries: [(preset: PresetDefinition, searchable: String)] = []

    var isEmpty: Bool {
        categoryEntries.isEmpty && settingEntries.isEmpty && presetEntries.isEmpty
    }
}
