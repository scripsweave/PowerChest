import Foundation

struct ChangeRecord: Identifiable, Codable, Sendable {
    let id: UUID
    let settingID: String
    let displayName: String
    let oldValue: CodableValue?
    let newValue: CodableValue?
    let appliedAt: Date
    let source: ApplySource
    let snapshotID: UUID?

    init(settingID: String, displayName: String, oldValue: CodableValue?, newValue: CodableValue?, source: ApplySource, snapshotID: UUID?) {
        self.id = UUID()
        self.settingID = settingID
        self.displayName = displayName
        self.oldValue = oldValue
        self.newValue = newValue
        self.appliedAt = Date()
        self.source = source
        self.snapshotID = snapshotID
    }
}
