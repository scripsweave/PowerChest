import Foundation

final class ApplyEngineService {
    private let catalogService: SettingsCatalogService
    private let readService: SettingsReadService
    private let snapshotService: SnapshotService
    private let changeLogService: ChangeLogService
    private let restartService: RestartService
    private let defaultsAdapter: DefaultsAdapter
    private let commandAdapter: CommandAdapter
    private let privilegedAdapter: PrivilegedAdapter
    private let compatibility: CompatibilityService

    init(
        catalogService: SettingsCatalogService,
        readService: SettingsReadService,
        snapshotService: SnapshotService,
        changeLogService: ChangeLogService,
        restartService: RestartService,
        compatibility: CompatibilityService
    ) {
        self.catalogService = catalogService
        self.readService = readService
        self.snapshotService = snapshotService
        self.changeLogService = changeLogService
        self.restartService = restartService
        self.defaultsAdapter = readService.defaultsAdapter
        self.commandAdapter = readService.commandAdapter
        self.privilegedAdapter = readService.privilegedAdapter
        self.compatibility = compatibility
    }

    func apply(_ request: ApplyRequest, onProgress: ((ApplyProgress) -> Void)? = nil) -> ApplyResult {
        // Step 2: Validate
        var outcomes: [ApplyOutcome] = []
        var effectiveItems: [(ApplyItem, CodableValue?)] = [] // item + old value

        for item in request.items {
            // Check support
            if let def = catalogService.definition(for: item.settingID),
               !compatibility.isSupported(def) {
                outcomes.append(ApplyOutcome(
                    settingID: item.settingID,
                    result: .skippedUnsupported(reason: "Not supported on macOS \(compatibility.currentOSMajorVersion)"),
                    verifiedValue: nil
                ))
                continue
            }

            // Step 3: Filter idempotent — read current value via appropriate adapter
            let def = catalogService.definition(for: item.settingID)
            guard let resolvedValueType = def?.valueType else {
                outcomes.append(ApplyOutcome(
                    settingID: item.settingID,
                    result: .failed(error: "Unknown setting: \(item.settingID)"),
                    verifiedValue: nil
                ))
                continue
            }
            let currentValue: CodableValue?
            let currentExists: Bool

            switch item.mechanism {
            case .defaults:
                guard let domain = item.domain, let key = item.keyPath else {
                    outcomes.append(ApplyOutcome(
                        settingID: item.settingID,
                        result: .failed(error: "Missing domain or key path"),
                        verifiedValue: nil
                    ))
                    continue
                }
                currentValue = defaultsAdapter.readParsed(domain: domain, key: key, valueType: resolvedValueType)
                currentExists = defaultsAdapter.keyExists(domain: domain, key: key)
            case .command:
                currentValue = commandAdapter.read(settingID: item.settingID)
                currentExists = commandAdapter.keyExists(settingID: item.settingID)
            case .privilegedDefaults:
                guard let domain = item.domain, let key = item.keyPath else {
                    outcomes.append(ApplyOutcome(
                        settingID: item.settingID,
                        result: .failed(error: "Missing domain or key path"),
                        verifiedValue: nil
                    ))
                    continue
                }
                currentValue = privilegedAdapter.readParsed(domain: domain, key: key, valueType: resolvedValueType)
                currentExists = privilegedAdapter.keyExists(domain: domain, key: key)
            case .privilegedCommand:
                currentValue = privilegedAdapter.read(settingID: item.settingID)
                currentExists = privilegedAdapter.commandKeyExists(settingID: item.settingID)
            }

            let isIdempotent: Bool
            switch item.targetState {
            case .systemDefault:
                isIdempotent = !currentExists
            case .explicitValue(let target):
                isIdempotent = (currentValue == target)
            }

            if isIdempotent {
                outcomes.append(ApplyOutcome(
                    settingID: item.settingID,
                    result: .skippedIdempotent,
                    verifiedValue: currentValue
                ))
                continue
            }

            effectiveItems.append((item, currentValue))
        }

        // Step 4: Nothing to apply
        if effectiveItems.isEmpty {
            return ApplyResult(
                requestID: request.requestID,
                snapshotID: nil,
                outcomes: outcomes,
                restartActions: [],
                status: outcomes.allSatisfy({ outcome in
                    switch outcome.result {
                    case .skippedIdempotent, .skippedUnsupported: return true
                    default: return false
                    }
                }) ? .nothingToApply : .allFailed,
                pendingRestarts: []
            )
        }

        // Step 5: Snapshot
        var snapshotID: UUID?
        switch request.snapshotBehavior {
        case .automatic:
            let touchedIDs = effectiveItems.map { $0.0.settingID }
            let trigger: SnapshotTrigger = {
                switch request.source {
                case .preset: return .beforePreset
                case .restore: return .beforeRestore
                case .profileImport: return .profileImport
                default: return .beforeApply
                }
            }()
            do {
                snapshotID = try snapshotService.createAutomaticSnapshot(
                    for: touchedIDs, trigger: trigger
                )
            } catch {
                // Step 6: Abort if snapshot fails
                for (item, _) in effectiveItems {
                    outcomes.append(ApplyOutcome(
                        settingID: item.settingID,
                        result: .failed(error: "Snapshot failed: \(error.localizedDescription)"),
                        verifiedValue: nil
                    ))
                }
                return ApplyResult(
                    requestID: request.requestID,
                    snapshotID: nil,
                    outcomes: outcomes,
                    restartActions: [],
                    status: .allFailed,
                    pendingRestarts: []
                )
            }
        case .useExisting(let id):
            snapshotID = id
        case .skip:
            break
        }

        // Step 7-8: Execute and verify
        var changeRecords: [ChangeRecord] = []
        var restartRequirements: [RestartRequirement] = []

        // Batch all privileged commands into a single auth prompt
        let hasPrivileged = effectiveItems.contains { item, _ in
            item.mechanism == .privilegedDefaults || item.mechanism == .privilegedCommand
        }
        if hasPrivileged {
            privilegedAdapter.beginBatch()
        }

        for (index, (item, oldValue)) in effectiveItems.enumerated() {
            do {
                let def = catalogService.definition(for: item.settingID)
                let vType = def?.valueType ?? .string

                // Report progress
                onProgress?(ApplyProgress(
                    total: effectiveItems.count,
                    completed: index,
                    currentSettingName: def?.displayName ?? item.settingID
                ))

                switch item.mechanism {
                case .defaults:
                    guard let domain = item.domain, let key = item.keyPath else { continue }
                    switch item.targetState {
                    case .explicitValue(let value):
                        try defaultsAdapter.write(domain: domain, key: key, value: value, valueType: vType)
                    case .systemDefault:
                        try defaultsAdapter.delete(domain: domain, key: key)
                    }
                case .command:
                    switch item.targetState {
                    case .explicitValue(let value):
                        try commandAdapter.write(settingID: item.settingID, value: value)
                    case .systemDefault:
                        try commandAdapter.reset(settingID: item.settingID)
                    }
                case .privilegedDefaults:
                    guard let domain = item.domain, let key = item.keyPath else { continue }
                    switch item.targetState {
                    case .explicitValue(let value):
                        try privilegedAdapter.writeDefaults(domain: domain, key: key, value: value, valueType: vType)
                    case .systemDefault:
                        try privilegedAdapter.deleteDefaults(domain: domain, key: key)
                    }
                case .privilegedCommand:
                    switch item.targetState {
                    case .explicitValue(let value):
                        try privilegedAdapter.writeCommand(settingID: item.settingID, value: value)
                    case .systemDefault:
                        try privilegedAdapter.resetCommand(settingID: item.settingID)
                    }
                }

                // Readback
                let verified: CodableValue?
                switch item.mechanism {
                case .defaults:
                    verified = defaultsAdapter.readParsed(domain: item.domain!, key: item.keyPath!, valueType: vType)
                case .command:
                    verified = commandAdapter.read(settingID: item.settingID)
                case .privilegedDefaults:
                    verified = privilegedAdapter.readParsed(domain: item.domain!, key: item.keyPath!, valueType: vType)
                case .privilegedCommand:
                    verified = privilegedAdapter.read(settingID: item.settingID)
                }

                outcomes.append(ApplyOutcome(
                    settingID: item.settingID,
                    result: .applied,
                    verifiedValue: verified
                ))

                // Step 9: Log
                let newValue: CodableValue?
                if case .explicitValue(let v) = item.targetState { newValue = v } else { newValue = nil }
                changeRecords.append(ChangeRecord(
                    settingID: item.settingID,
                    displayName: def?.displayName ?? item.settingID,
                    oldValue: oldValue,
                    newValue: newValue,
                    source: request.source,
                    snapshotID: snapshotID
                ))

                if item.restartRequirement.isRequired {
                    restartRequirements.append(item.restartRequirement)
                }
            } catch {
                outcomes.append(ApplyOutcome(
                    settingID: item.settingID,
                    result: .failed(error: error.localizedDescription),
                    verifiedValue: nil
                ))
            }
        }

        // Execute batched privileged commands in one auth prompt
        if hasPrivileged {
            do {
                try privilegedAdapter.executeBatch()
            } catch {
                // If batch fails, mark remaining privileged items as failed
                for (item, _) in effectiveItems where
                    (item.mechanism == .privilegedDefaults || item.mechanism == .privilegedCommand) {
                    if !outcomes.contains(where: { $0.settingID == item.settingID }) {
                        outcomes.append(ApplyOutcome(
                            settingID: item.settingID,
                            result: .failed(error: error.localizedDescription),
                            verifiedValue: nil
                        ))
                    }
                }
            }
        }

        // Final progress
        onProgress?(ApplyProgress(
            total: effectiveItems.count,
            completed: effectiveItems.count,
            currentSettingName: "Done"
        ))

        // Save change log
        if !changeRecords.isEmpty {
            changeLogService.log(changeRecords)
        }

        // Step 10-11: Restart
        let (promptable, auto) = partitionRestartRequirements(restartRequirements)
        let promptActions = promptable.map { requirement in
            RestartAction(
                target: requirement,
                result: .deferred(reason: "userConfirmation"),
                userMessage: restartPromptMessage(for: requirement)
            )
        }
        let restartActions = promptActions + restartService.executeRestarts(auto)

        // Step 12: Result
        let applied = outcomes.filter { if case .applied = $0.result { return true }; return false }
        let failed = outcomes.filter { if case .failed = $0.result { return true }; return false }

        let status: ApplyStatus
        if failed.isEmpty {
            status = .allSucceeded
        } else if applied.isEmpty {
            status = .allFailed
        } else {
            status = .partialFailure
        }

        return ApplyResult(
            requestID: request.requestID,
            snapshotID: snapshotID,
            outcomes: outcomes,
            restartActions: restartActions,
            status: status,
            pendingRestarts: promptable
        )
    }

    func previewRestarts(for request: ApplyRequest) -> [RestartRequirement] {
        let unique = Set(request.items.map { $0.restartRequirement }.filter { $0.isRequired })
        return Array(unique)
    }

    private func partitionRestartRequirements(_ requirements: [RestartRequirement]) -> ([RestartRequirement], [RestartRequirement]) {
        var prompt: [RestartRequirement] = []
        var auto: [RestartRequirement] = []
        var seenPrompt = Set<RestartRequirement>()
        var seenAuto = Set<RestartRequirement>()

        for requirement in requirements {
            if shouldPromptForRestart(requirement) {
                if seenPrompt.insert(requirement).inserted {
                    prompt.append(requirement)
                }
            } else {
                if seenAuto.insert(requirement).inserted {
                    auto.append(requirement)
                }
            }
        }

        return (prompt, auto)
    }

    private func shouldPromptForRestart(_ requirement: RestartRequirement) -> Bool {
        switch requirement {
        case .dock, .finder:
            return true
        default:
            return false
        }
    }

    private func restartPromptMessage(for requirement: RestartRequirement) -> String {
        switch requirement {
        case .dock:
            return "Dock restart available — we’ll ask before bouncing it."
        case .finder:
            return "Finder restart available — restart when you’re ready."
        default:
            return requirement.displayName
        }
    }
}
