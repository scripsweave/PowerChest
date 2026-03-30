import Foundation
import os.log

private let logger = Logger(subsystem: "janvanrensburg.PowerChest", category: "ChangeLog")

final class ChangeLogService {
    private let persistence: PersistenceController

    init(persistence: PersistenceController) {
        self.persistence = persistence
    }

    func log(_ records: [ChangeRecord]) {
        do {
            try persistence.saveChangeRecords(records)
        } catch {
            logger.error("Failed to save \(records.count) change record(s): \(error.localizedDescription)")
        }
    }

    func allRecords() -> [ChangeRecord] {
        persistence.loadAllChangeRecords().sorted { $0.appliedAt > $1.appliedAt }
    }

    func recentRecords(limit: Int = 20) -> [ChangeRecord] {
        Array(allRecords().prefix(limit))
    }
}
