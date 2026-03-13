import Foundation

final class FavoritesStore: Sendable {
    private let storage: StorageManager

    init(storage: StorageManager = StorageManager()) {
        self.storage = storage
    }

    func getAll() -> [ExerciseId] {
        storage.load([ExerciseId].self, forKey: StorageKey.favorites) ?? []
    }

    func isFavorite(_ id: ExerciseId) -> Bool {
        getAll().contains(id)
    }

    func toggle(_ id: ExerciseId) {
        var items = getAll()
        if let index = items.firstIndex(of: id) {
            items.remove(at: index)
        } else {
            items.append(id)
        }
        storage.save(items, forKey: StorageKey.favorites)
    }

    func clearAll() {
        storage.remove(forKey: StorageKey.favorites)
    }
}
