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

enum TargetState: Equatable, Hashable, Sendable {
    case explicitValue(CodableValue)
    case systemDefault
}

extension TargetState: Codable {
    private enum CodingKeys: String, CodingKey {
        case type, value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "systemDefault":
            self = .systemDefault
        case "explicitValue":
            let value = try container.decode(CodableValue.self, forKey: .value)
            self = .explicitValue(value)
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown TargetState type: \(type)")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .systemDefault:
            try container.encode("systemDefault", forKey: .type)
        case .explicitValue(let value):
            try container.encode("explicitValue", forKey: .type)
            try container.encode(value, forKey: .value)
        }
    }
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
    let pendingRestarts: [RestartRequirement]
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

// MARK: - Progress

struct ApplyProgress {
    let total: Int
    var completed: Int
    var currentSettingName: String

    var fraction: Double {
        guard total > 0 else { return 0 }
        return Double(completed) / Double(total)
    }
}
