import SwiftUI

@Observable
final class AppState {
    var selectedSidebarItem: SidebarItem? = .home
    var userMode: UserMode = .powerUser
    var spotlightSettingID: String?
    var spotlightPresetID: String?
    var toast: AppToast?
    var pendingRestartRequests: [RestartRequirement] = []

    var settingStates: [String: SettingState] = [:]
    var isLoading = false
    var isApplying = false
    var lastApplyResult: ApplyResult?
    var applyProgress: ApplyProgress?

    let catalogService: SettingsCatalogService
    let compatibilityService: CompatibilityService
    let readService: SettingsReadService
    let snapshotService: SnapshotService
    let changeLogService: ChangeLogService
    let applyEngine: ApplyEngineService
    let restartService: RestartService
    let persistenceController: PersistenceController

    var customPresets: [PresetDefinition] = []

    /// All presets: custom first, then built-in.
    var allPresets: [PresetDefinition] {
        customPresets + catalogService.presets
    }

    init() {
        let catalog = SettingsCatalogService()
        let compat = CompatibilityService()
        let persistence: PersistenceController
        do {
            persistence = try PersistenceController()
        } catch {
            fatalError("PowerChest: Failed to initialize persistence — \(error.localizedDescription)")
        }
        let read = SettingsReadService(compatibility: compat)
        let snapshot = SnapshotService(persistence: persistence, readService: read, catalogService: catalog)
        let changeLog = ChangeLogService(persistence: persistence)
        let restart = RestartService()
        let apply = ApplyEngineService(
            catalogService: catalog,
            readService: read,
            snapshotService: snapshot,
            changeLogService: changeLog,
            restartService: restart,
            compatibility: compat
        )

        self.catalogService = catalog
        self.compatibilityService = compat
        self.readService = read
        self.snapshotService = snapshot
        self.changeLogService = changeLog
        self.restartService = restart
        self.applyEngine = apply
        self.persistenceController = persistence

        self.customPresets = persistence.loadCustomPresets()
        loadAllStates()
    }

    func loadAllStates() {
        isLoading = true
        let defs = catalogService.shippingDefinitions()
        settingStates = readService.readAllStates(for: defs)
        isLoading = false
    }

    func refreshStates(for category: SettingCategory) {
        let defs = catalogService.shippingDefinitions(for: category)
        let states = readService.readAllStates(for: defs)
        for (id, state) in states {
            settingStates[id] = state
        }
    }

    func refreshAllStates() {
        loadAllStates()
    }

    func state(for settingID: String) -> SettingState? {
        settingStates[settingID]
    }

    func presentToast(title: String, subtitle: String? = nil, icon: String = "sparkles") {
        toast = AppToast(title: title, subtitle: subtitle, icon: icon)
    }

    func enqueueRestartRequests(_ requirements: [RestartRequirement]) {
        guard !requirements.isEmpty else { return }
        for requirement in requirements {
            if !pendingRestartRequests.contains(requirement) {
                pendingRestartRequests.append(requirement)
            }
        }
    }

    // MARK: - Custom Presets

    func saveCustomPreset(_ preset: PresetDefinition) {
        customPresets.insert(preset, at: 0)
        do {
            try persistenceController.saveCustomPresets(customPresets)
        } catch {
            presentToast(title: "Failed to save preset", subtitle: error.localizedDescription, icon: "exclamationmark.triangle")
        }
    }

    func deleteCustomPreset(id: String) {
        customPresets.removeAll { $0.id == id }
        do {
            try persistenceController.saveCustomPresets(customPresets)
        } catch {
            presentToast(title: "Failed to update presets", subtitle: error.localizedDescription, icon: "exclamationmark.triangle")
        }
    }

    var customPresetIDs: Set<String> {
        Set(customPresets.map(\.id))
    }

    // MARK: - Undo

    func undoLastChange() -> Bool {
        guard let last = changeLogService.recentRecords(limit: 1).first,
              let oldValue = last.oldValue,
              let def = catalogService.definition(for: last.settingID) else {
            return false
        }

        let item = ApplyItem(
            settingID: last.settingID,
            targetState: .explicitValue(oldValue),
            mechanism: def.mechanism,
            domain: def.domain,
            keyPath: def.keyPath,
            restartRequirement: def.restartRequirement
        )
        let request = ApplyRequest(source: .powerUser, items: [item])
        let result = applyEngine.apply(request)
        refreshAllStates()
        enqueueRestartRequests(result.pendingRestarts)
        return result.outcomes.contains { if case .applied = $0.result { return true }; return false }
    }

    /// The display name of the most recent change, for the Undo menu item.
    var lastChangeDescription: String? {
        changeLogService.recentRecords(limit: 1).first?.displayName
    }

    // MARK: - Update Check

    let updateService = UpdateService()
    var availableUpdate: AppUpdate?

    func checkForUpdate() {
        Task {
            let update = await updateService.checkForUpdate()
            await MainActor.run {
                self.availableUpdate = update
            }
        }
    }

    func dequeueRestart(_ requirement: RestartRequirement) {
        pendingRestartRequests.removeAll { $0 == requirement }
    }

    func performRestart(_ requirement: RestartRequirement) -> RestartAction? {
        restartService.executeRestarts([requirement]).first
    }
}

struct AppToast: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String?
    let icon: String
}
