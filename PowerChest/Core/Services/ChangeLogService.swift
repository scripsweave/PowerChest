import Foundation

final class ChangeLogService {
    private let persistence: PersistenceController

    init(persistence: PersistenceController) {
        self.persistence = persistence
    }

    func log(_ records: [ChangeRecord]) {
        try? persistence.saveChangeRecords(records)
    }

    func allRecords() -> [ChangeRecord] {
        persistence.loadAllChangeRecords().sorted { $0.appliedAt > $1.appliedAt }
    }

    func recentRecords(limit: Int = 20) -> [ChangeRecord] {
        Array(allRecords().prefix(limit))
    }
}
