import Foundation
import os.log

private let logger = Logger(subsystem: "janvanrensburg.PowerChest", category: "Persistence")

// @unchecked Sendable: encoder/decoder are configured once at init and never mutated after.
// All file operations use atomic writes for crash safety.
final class PersistenceController: @unchecked Sendable {
    let appSupportURL: URL
    let snapshotsURL: URL
    let changeLogURL: URL

    init() throws {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            .appendingPathComponent("PowerChest", isDirectory: true)
        self.appSupportURL = base
        self.snapshotsURL = base.appendingPathComponent("Snapshots", isDirectory: true)
        self.changeLogURL = base.appendingPathComponent("ChangeLog", isDirectory: true)

        let fm = FileManager.default
        try fm.createDirectory(at: snapshotsURL, withIntermediateDirectories: true)
        try fm.createDirectory(at: changeLogURL, withIntermediateDirectories: true)
    }

    private let encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        e.outputFormatting = [.prettyPrinted, .sortedKeys]
        return e
    }()

    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()

    // MARK: - Snapshots

    func saveSnapshot(_ snapshot: SnapshotRecord) throws {
        let url = snapshotsURL.appendingPathComponent("\(snapshot.id.uuidString).json")
        let data = try encoder.encode(snapshot)
        try data.write(to: url, options: .atomic)
    }

    func loadSnapshot(id: UUID) throws -> SnapshotRecord? {
        let url = snapshotsURL.appendingPathComponent("\(id.uuidString).json")
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        let data = try Data(contentsOf: url)
        return try decoder.decode(SnapshotRecord.self, from: data)
    }

    func loadAllSnapshots() -> [SnapshotRecord] {
        guard let files = try? FileManager.default.contentsOfDirectory(
            at: snapshotsURL, includingPropertiesForKeys: nil
        ) else { return [] }

        return files
            .filter { $0.pathExtension == "json" }
            .compactMap { url in
                do {
                    let data = try Data(contentsOf: url)
                    return try decoder.decode(SnapshotRecord.self, from: data)
                } catch {
                    logger.error("Failed to load snapshot \(url.lastPathComponent): \(error.localizedDescription)")
                    return nil
                }
            }
            .sorted { $0.createdAt > $1.createdAt }
    }

    func deleteSnapshot(id: UUID) {
        let url = snapshotsURL.appendingPathComponent("\(id.uuidString).json")
        try? FileManager.default.removeItem(at: url)
    }

    // MARK: - Change Log

    private var changeLogFileURL: URL {
        changeLogURL.appendingPathComponent("changes.json")
    }

    func saveChangeRecords(_ records: [ChangeRecord]) throws {
        var existing = loadAllChangeRecords()
        existing.append(contentsOf: records)
        let data = try encoder.encode(existing)
        try data.write(to: changeLogFileURL, options: .atomic)
    }

    func loadAllChangeRecords() -> [ChangeRecord] {
        let url = changeLogFileURL
        guard FileManager.default.fileExists(atPath: url.path) else { return [] }
        do {
            let data = try Data(contentsOf: url)
            return try decoder.decode([ChangeRecord].self, from: data)
        } catch {
            logger.error("Failed to load change log: \(error.localizedDescription)")
            return []
        }
    }
}
