import SwiftUI

@Observable
final class AppState {
    var selectedSidebarItem: SidebarItem? = .home
    var userMode: UserMode = .powerUser

    var settingStates: [String: SettingState] = [:]
    var isLoading = false
    var lastApplyResult: ApplyResult?

    let catalogService: SettingsCatalogService
    let compatibilityService: CompatibilityService
    let readService: SettingsReadService
    let snapshotService: SnapshotService
    let changeLogService: ChangeLogService
    let applyEngine: ApplyEngineService
    let restartService: RestartService

    init() {
        let catalog = SettingsCatalogService()
        let compat = CompatibilityService()
        let persistence = PersistenceController()
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
}
