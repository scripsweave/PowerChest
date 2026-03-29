import SwiftUI

@Observable
final class CategoryPaneViewModel {
    let category: SettingCategory
    private let appState: AppState

    var stagedChanges: [String: TargetState] = [:]
    var applyResultMessage: String?
    var isApplying = false

    var hasPendingChanges: Bool { !stagedChanges.isEmpty }
    var pendingCount: Int { stagedChanges.count }

    init(category: SettingCategory, appState: AppState) {
        self.category = category
        self.appState = appState
    }

    func stageChange(settingID: String, target: TargetState) {
        stagedChanges[settingID] = target
    }

    func unstageChange(settingID: String) {
        stagedChanges.removeValue(forKey: settingID)
    }

    func discardAll() {
        stagedChanges.removeAll()
        applyResultMessage = nil
    }

    func applyAll() {
        guard !stagedChanges.isEmpty else { return }
        isApplying = true
        applyResultMessage = nil

        let items: [ApplyItem] = stagedChanges.compactMap { (settingID, target) in
            guard let def = appState.catalogService.definition(for: settingID) else { return nil }
            return ApplyItem(
                settingID: settingID,
                targetState: target,
                mechanism: def.mechanism,
                domain: def.domain,
                keyPath: def.keyPath,
                restartRequirement: def.restartRequirement
            )
        }

        let source: ApplySource = appState.userMode == .powerUser ? .powerUser : .propellerhead
        let request = ApplyRequest(source: source, items: items)
        let result = appState.applyEngine.apply(request)

        appState.lastApplyResult = result
        appState.refreshStates(for: category)
        stagedChanges.removeAll()

        // Build user-facing message
        let applied = result.outcomes.filter { if case .applied = $0.result { return true }; return false }.count
        let skipped = result.outcomes.filter { if case .skippedIdempotent = $0.result { return true }; return false }.count
        let failed = result.outcomes.filter { if case .failed = $0.result { return true }; return false }.count

        var msg = ""
        switch result.status {
        case .allSucceeded:
            msg = "Done. \(applied) change\(applied == 1 ? "" : "s") applied."
        case .nothingToApply:
            msg = "Nothing to change — everything already matches."
        case .partialFailure:
            msg = "\(applied) applied, \(failed) failed."
        case .allFailed:
            msg = "All changes failed."
        }

        if skipped > 0 {
            msg += " \(skipped) already matched."
        }

        for action in result.restartActions {
            if case .deferred = action.result {
                msg += " " + action.userMessage
            }
        }

        applyResultMessage = msg
        isApplying = false
    }

    func applyPreset(_ preset: PresetDefinition) {
        isApplying = true
        applyResultMessage = nil

        let items: [ApplyItem] = preset.items.compactMap { presetItem in
            guard let def = appState.catalogService.definition(for: presetItem.settingID) else { return nil }
            return ApplyItem(
                settingID: presetItem.settingID,
                targetState: presetItem.targetState,
                mechanism: def.mechanism,
                domain: def.domain,
                keyPath: def.keyPath,
                restartRequirement: def.restartRequirement
            )
        }

        let request = ApplyRequest(source: .preset, items: items)
        let result = appState.applyEngine.apply(request)

        appState.lastApplyResult = result
        appState.refreshAllStates()

        let applied = result.outcomes.filter { if case .applied = $0.result { return true }; return false }.count
        applyResultMessage = "Preset \"\(preset.name)\" applied. \(applied) change\(applied == 1 ? "" : "s")."

        isApplying = false
    }
}
