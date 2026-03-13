import Foundation

final class CheckinStore: Sendable {
    private let storage: StorageManager

    init(storage: StorageManager = StorageManager()) {
        self.storage = storage
    }

    func getAll() -> [DailyCheckin] {
        let items = storage.load([DailyCheckin].self, forKey: StorageKey.checkins) ?? []
        return items.sorted { $0.date > $1.date }
    }

    func getToday() -> DailyCheckin? {
        getAll().first { Calendar.current.isDateInToday($0.date) }
    }

    func save(_ checkin: DailyCheckin) {
        var items = storage.load([DailyCheckin].self, forKey: StorageKey.checkins) ?? []
        items.removeAll { $0.id == checkin.id }
        items.insert(checkin, at: 0)
        storage.save(items, forKey: StorageKey.checkins)
    }

    func getRecent(days: Int) -> [DailyCheckin] {
        let cutoff = DateFormatting.daysAgo(days)
        return getAll().filter { $0.date >= cutoff }
    }

    func clearAll() {
        storage.remove(forKey: StorageKey.checkins)
    }
}
