import Foundation

struct SnapshotRecord: Identifiable, Codable, Sendable {
    let id: UUID
    var name: String
    let kind: SnapshotKind
    let createdAt: Date
    let trigger: SnapshotTrigger
    var notes: String?
    let osVersion: String
    let appVersion: String
    let settingRecords: [SnapshotSettingRecord]
    let sourceTransactionID: UUID?
}

struct SnapshotSettingRecord: Codable, Sendable {
    let settingID: String
    let capturedValue: CodableValue?
    let keyExistence: KeyExistence
    let captureStatus: CaptureStatus
}

enum SnapshotKind: String, Codable, Sendable {
    case automatic
    case manual
    case milestone
    case imported
}

enum SnapshotTrigger: String, Codable, Sendable {
    case beforeApply
    case beforePreset
    case beforeRestore
    case manualCapture
    case profileImport
}

enum KeyExistence: String, Codable, Sendable {
    case exists
    case absent
    case unknown
}

enum CaptureStatus: String, Codable, Sendable {
    case captured
    case unavailable
    case unsupported
    case readFailed
}

// MARK: - Diff

struct SnapshotDiffItem: Identifiable, Sendable {
    let id: UUID
    let settingID: String
    let displayName: String
    let category: SettingCategory
    let snapshotValue: CodableValue?
    let currentValue: CodableValue?
    let classification: DiffClassification
    let restartRequirement: RestartRequirement
}

enum DiffClassification: String, Sendable {
    case unchanged
    case changed
    case unsupportedOnCurrentMachine
    case unavailableInSnapshot
    case missingFromCurrentCatalog
}

// MARK: - Restore

struct RestorePlan: Sendable {
    let snapshotID: UUID
    let items: [SnapshotDiffItem]
    let applyRequest: ApplyRequest
}
