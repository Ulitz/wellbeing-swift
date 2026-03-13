import Foundation

final class SettingsStore: Sendable {
    private let storage: StorageManager

    init(storage: StorageManager = StorageManager()) {
        self.storage = storage
    }

    func get() -> Settings {
        storage.load(Settings.self, forKey: StorageKey.settings) ?? .default
    }

    func save(_ settings: Settings) {
        storage.save(settings, forKey: StorageKey.settings)
    }

    func update(_ modify: (inout Settings) -> Void) {
        var settings = get()
        modify(&settings)
        save(settings)
    }

    func getAllContacts() -> [SpiritualContact] {
        let userContacts = get().spiritualContacts
        return DefaultContacts.all + userContacts
    }

    func addContact(name: String, role: String, phone: String) -> SpiritualContact {
        let contact = SpiritualContact(
            id: UUID().uuidString,
            name: name,
            role: role,
            phone: phone,
            isDefault: false
        )
        update { $0.spiritualContacts.append(contact) }
        return contact
    }

    func removeContact(id: String) {
        update { settings in
            settings.spiritualContacts.removeAll { $0.id == id }
        }
    }

    func clearAll() {
        storage.remove(forKey: StorageKey.settings)
    }
}

enum DefaultContacts {
    static let all: [SpiritualContact] = [
        SpiritualContact(
            id: "default-spiritual-1",
            name: "נירית אוליצור",
            role: "מתאמת ליווי רוחני",
            phone: "050-662-2791",
            isDefault: true
        ),
        SpiritualContact(
            id: "default-psych-1",
            name: "ליאת אריאל",
            role: "מענה פסיכולוגי",
            phone: "050-206-4049",
            isDefault: true
        ),
    ]
}
