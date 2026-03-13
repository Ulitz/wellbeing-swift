import Foundation

final class StorageManager: Sendable {
    // UserDefaults is documented as thread-safe by Apple
    nonisolated(unsafe) let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            return try decoder.decode(type, from: data)
        } catch {
            assertionFailure("Failed to decode \(T.self) for key \(key): \(error)")
            return nil
        }
    }

    func save<T: Encodable>(_ value: T, forKey key: String) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let data = try encoder.encode(value)
            defaults.set(data, forKey: key)
        } catch {
            assertionFailure("Failed to encode \(T.self) for key \(key): \(error)")
        }
    }

    func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
}

enum StorageKey {
    static let assessments = "wellbeing_assessments"
    static let checkins = "wellbeing_checkins"
    static let practices = "wellbeing_practices"
    static let settings = "wellbeing_settings"
    static let favorites = "wellbeing_favorites"
    static let meaning = "wellbeing_meaning"
}
