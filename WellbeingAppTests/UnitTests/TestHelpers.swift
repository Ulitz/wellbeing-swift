import Foundation
@testable import WellbeingApp

/// Creates an isolated UserDefaults instance for testing.
/// Call `cleanUp()` in tearDown to remove the persistent domain.
final class TestStorage {
    let suiteName: String
    let defaults: UserDefaults
    let storageManager: StorageManager

    init() {
        suiteName = "test-\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)!
        storageManager = StorageManager(defaults: defaults)
    }

    func cleanUp() {
        UserDefaults.standard.removePersistentDomain(forName: suiteName)
    }
}
