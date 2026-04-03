import Foundation

final class SnapshotService {
    private let persistence: PersistenceController
    private let readService: SettingsReadService
    private let catalogService: SettingsCatalogService

    init(persistence: PersistenceController, readService: SettingsReadService, catalogService: SettingsCatalogService) {
        self.persistence = persistence
        self.readService = readService
        self.catalogService = catalogService
    }

    func createAutomaticSnapshot(
        for settingIDs: [String],
        trigger: SnapshotTrigger,
        name: String? = nil
    ) throws -> UUID {
        let definitions = settingIDs.compactMap { catalogService.definition(for: $0) }
        let records = captureRecords(for: definitions)

        let snapshot = SnapshotRecord(
            id: UUID(),
            name: name ?? descriptiveSnapshotName(trigger: trigger, definitions: definitions),
            kind: .automatic,
            createdAt: Date(),
            trigger: trigger,
            notes: nil,
            osVersion: osVersionString(),
            appVersion: "1.0",
            settingRecords: records,
            sourceTransactionID: nil
        )

        try persistence.saveSnapshot(snapshot)
        return snapshot.id
    }

    func createManualSnapshot(name: String?, notes: String?) throws -> UUID {
        let definitions = catalogService.shippingDefinitions()
        let records = captureRecords(for: definitions)

        let snapshot = SnapshotRecord(
            id: UUID(),
            name: name ?? "Manual snapshot — \(Date().formatted(date: .abbreviated, time: .shortened))",
            kind: .manual,
            createdAt: Date(),
            trigger: .manualCapture,
            notes: notes,
            osVersion: osVersionString(),
            appVersion: "1.0",
            settingRecords: records,
            sourceTransactionID: nil
        )

        try persistence.saveSnapshot(snapshot)
        return snapshot.id
    }

    func listSnapshots() -> [SnapshotRecord] {
        persistence.loadAllSnapshots()
    }

    func loadSnapshot(id: UUID) -> SnapshotRecord? {
        try? persistence.loadSnapshot(id: id)
    }

    func deleteSnapshot(id: UUID) {
        persistence.deleteSnapshot(id: id)
    }

    func diffSnapshotToCurrent(snapshot: SnapshotRecord) -> [SnapshotDiffItem] {
        snapshot.settingRecords.compactMap { record in
            guard let def = catalogService.definition(for: record.settingID) else {
                return SnapshotDiffItem(
                    id: UUID(),
                    settingID: record.settingID,
                    displayName: record.settingID,
                    category: .interface,
                    snapshotValue: record.capturedValue,
                    currentValue: nil,
                    classification: .missingFromCurrentCatalog,
                    restartRequirement: .none
                )
            }

            let currentState = readService.readState(for: def)
            let classification: DiffClassification
            if record.capturedValue == currentState.currentValue {
                classification = .unchanged
            } else {
                classification = .changed
            }

            return SnapshotDiffItem(
                id: UUID(),
                settingID: record.settingID,
                displayName: def.displayName,
                category: def.category,
                snapshotValue: record.capturedValue,
                currentValue: currentState.currentValue,
                classification: classification,
                restartRequirement: def.restartRequirement
            )
        }
    }

    func buildRestorePlan(snapshot: SnapshotRecord, selectedSettingIDs: [String]?) -> RestorePlan? {
        let diff = diffSnapshotToCurrent(snapshot: snapshot)
        let changedItems = diff.filter { $0.classification == .changed }
        let selected: [SnapshotDiffItem]
        if let ids = selectedSettingIDs {
            selected = changedItems.filter { ids.contains($0.settingID) }
        } else {
            selected = changedItems
        }

        guard !selected.isEmpty else { return nil }

        let applyItems: [ApplyItem] = selected.compactMap { item in
            guard let def = catalogService.definition(for: item.settingID) else { return nil }
            let snapshotRecord = snapshot.settingRecords.first { $0.settingID == item.settingID }
            let targetState: TargetState
            if let val = snapshotRecord?.capturedValue {
                targetState = .explicitValue(val)
            } else if snapshotRecord?.keyExistence == .absent {
                targetState = .systemDefault
            } else {
                return nil
            }

            return ApplyItem(
                settingID: def.id,
                targetState: targetState,
                mechanism: def.mechanism,
                domain: def.domain,
                keyPath: def.keyPath,
                restartRequirement: def.restartRequirement
            )
        }

        let request = ApplyRequest(
            source: .restore,
            items: applyItems,
            snapshotBehavior: .automatic
        )

        return RestorePlan(snapshotID: snapshot.id, items: selected, applyRequest: request)
    }

    // MARK: - Private

    private func captureRecords(for definitions: [SettingDefinition]) -> [SnapshotSettingRecord] {
        definitions.map { def in
            let state = readService.readState(for: def)
            return SnapshotSettingRecord(
                settingID: def.id,
                capturedValue: state.currentValue,
                keyExistence: state.keyExists ? .exists : .absent,
                captureStatus: state.isSupported ? .captured : .unsupported
            )
        }
    }

    private func descriptiveSnapshotName(trigger: SnapshotTrigger, definitions: [SettingDefinition]) -> String {
        let prefix: String
        switch trigger {
        case .beforeApply: prefix = "Before"
        case .beforePreset: prefix = "Before preset"
        case .beforeRestore: prefix = "Before restore"
        case .manualCapture: return "Manual snapshot"
        case .profileImport: return "Before import"
        }

        // Summarize what's being changed by category
        let categories = Set(definitions.map(\.category))
        if categories.count == 1, let cat = categories.first {
            let catName = categoryDisplayName(cat)
            if definitions.count == 1 {
                return "\(prefix) — \(definitions[0].displayName)"
            }
            return "\(prefix) — \(definitions.count) \(catName) settings"
        } else if categories.count <= 3 {
            let names = categories.map { categoryDisplayName($0) }.sorted().joined(separator: ", ")
            return "\(prefix) — \(names)"
        } else {
            return "\(prefix) — \(definitions.count) settings across \(categories.count) categories"
        }
    }

    private func categoryDisplayName(_ category: SettingCategory) -> String {
        switch category {
        case .interface: return "Dock & Interface"
        case .finder: return "Finder"
        case .keyboardInput: return "Keyboard"
        case .windowsSpaces: return "Windows & Spaces"
        case .screenshots: return "Screenshots"
        case .safariDeveloper: return "Safari"
        case .menuBarStatus: return "Menu Bar"
        case .accessibilityVisual: return "Accessibility"
        case .securityPrivacy: return "Security"
        case .networkConnectivity: return "Network"
        case .internals: return "Internals"
        }
    }

    private func osVersionString() -> String {
        let v = ProcessInfo.processInfo.operatingSystemVersion
        return "macOS \(v.majorVersion).\(v.minorVersion).\(v.patchVersion)"
    }

}
