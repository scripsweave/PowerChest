import Foundation

// MARK: - Request

struct ApplyRequest: Sendable {
    let requestID: UUID
    let source: ApplySource
    let items: [ApplyItem]
    let snapshotBehavior: SnapshotBehavior

    init(source: ApplySource, items: [ApplyItem], snapshotBehavior: SnapshotBehavior = .automatic) {
        self.requestID = UUID()
        self.source = source
        self.items = items
        self.snapshotBehavior = snapshotBehavior
    }
}

enum ApplySource: String, Codable, Sendable {
    case powerUser
    case propellerhead
    case preset
    case restore
    case profileImport
}

struct ApplyItem: Sendable {
    let settingID: String
    let targetState: TargetState
    let mechanism: SettingMechanism
    let domain: String?
    let keyPath: String?
    let restartRequirement: RestartRequirement
}

enum TargetState: Codable, Equatable, Hashable, Sendable {
    case explicitValue(CodableValue)
    case systemDefault
}

enum SnapshotBehavior: Sendable {
    case automatic
    case useExisting(UUID)
    case skip
}

// MARK: - Result

struct ApplyResult: Sendable {
    let requestID: UUID
    let snapshotID: UUID?
    let outcomes: [ApplyOutcome]
    let restartActions: [RestartAction]
    let status: ApplyStatus
}

struct ApplyOutcome: Sendable {
    let settingID: String
    let result: ApplyItemResult
    let verifiedValue: CodableValue?
}

enum ApplyItemResult: Sendable {
    case applied
    case skippedIdempotent
    case skippedUnsupported(reason: String)
    case failed(error: String)
}

enum ApplyStatus: Sendable {
    case allSucceeded
    case partialFailure
    case allFailed
    case nothingToApply
}

struct RestartAction: Sendable {
    let target: RestartRequirement
    let result: RestartActionResult
    let userMessage: String
}

enum RestartActionResult: Sendable {
    case completed
    case deferred(reason: String)
    case failed(error: String)
}

// MARK: - Validation

struct ApplyValidationIssue: Sendable {
    let settingID: String
    let issue: ValidationIssueKind
    let message: String
}

enum ValidationIssueKind: Sendable {
    case unsupportedOnCurrentOS
    case mechanismUnavailable
    case permissionDenied
    case unknownSetting
}
