import Foundation

final class AssessmentStore: Sendable {
    private let storage: StorageManager

    init(storage: StorageManager = StorageManager()) {
        self.storage = storage
    }

    func getAll() -> [Assessment] {
        let items = storage.load([Assessment].self, forKey: StorageKey.assessments) ?? []
        return items.sorted { $0.date > $1.date }
    }

    func getById(_ id: String) -> Assessment? {
        getAll().first { $0.id == id }
    }

    func getLatest() -> Assessment? {
        getAll().first
    }

    func save(_ assessment: Assessment) {
        var items = storage.load([Assessment].self, forKey: StorageKey.assessments) ?? []
        items.removeAll { $0.id == assessment.id }
        items.insert(assessment, at: 0)
        storage.save(items, forKey: StorageKey.assessments)
    }

    func getRecent(weeks: Int) -> [Assessment] {
        let cutoff = DateFormatting.weeksAgo(weeks)
        return getAll().filter { $0.date >= cutoff }
    }

    func clearAll() {
        storage.remove(forKey: StorageKey.assessments)
    }
}
