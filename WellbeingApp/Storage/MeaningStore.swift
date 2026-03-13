import Foundation

final class MeaningStore: Sendable {
    private let storage: StorageManager

    init(storage: StorageManager = StorageManager()) {
        self.storage = storage
    }

    func getAll() -> [MeaningMoment] {
        let items = storage.load([MeaningMoment].self, forKey: StorageKey.meaning) ?? []
        return items.sorted { $0.date > $1.date }
    }

    func getToday() -> MeaningMoment? {
        getAll().first { Calendar.current.isDateInToday($0.date) }
    }

    func save(_ moment: MeaningMoment) {
        var items = storage.load([MeaningMoment].self, forKey: StorageKey.meaning) ?? []
        items.removeAll { $0.id == moment.id }
        items.insert(moment, at: 0)
        storage.save(items, forKey: StorageKey.meaning)
    }

    func clearAll() {
        storage.remove(forKey: StorageKey.meaning)
    }
}
