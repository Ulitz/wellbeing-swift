import Foundation

final class PracticeStore: Sendable {
    private let storage: StorageManager

    init(storage: StorageManager = StorageManager()) {
        self.storage = storage
    }

    func getAll() -> [PracticeLog] {
        let items = storage.load([PracticeLog].self, forKey: StorageKey.practices) ?? []
        return items.sorted { $0.date > $1.date }
    }

    func log(_ practice: PracticeLog) {
        var items = storage.load([PracticeLog].self, forKey: StorageKey.practices) ?? []
        items.removeAll { $0.id == practice.id }
        items.insert(practice, at: 0)
        storage.save(items, forKey: StorageKey.practices)
    }

    func getRecent(days: Int) -> [PracticeLog] {
        let cutoff = DateFormatting.daysAgo(days)
        return getAll().filter { $0.date >= cutoff }
    }

    func clearAll() {
        storage.remove(forKey: StorageKey.practices)
    }
}
