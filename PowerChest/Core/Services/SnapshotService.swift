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
            name: name ?? autoSnapshotName(trigger: trigger),
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

    private func autoSnapshotName(trigger: SnapshotTrigger) -> String {
        switch trigger {
        case .beforeApply: return "Before changes"
        case .beforePreset: return "Before preset"
        case .beforeRestore: return "Before restore"
        case .manualCapture: return "Manual snapshot"
        case .profileImport: return "Before import"
        }
    }

    private func osVersionString() -> String {
        let v = ProcessInfo.processInfo.operatingSystemVersion
        return "macOS \(v.majorVersion).\(v.minorVersion).\(v.patchVersion)"
    }

}
