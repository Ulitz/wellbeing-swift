import XCTest
@testable import WellbeingApp

final class SettingsStoreTests: XCTestCase {

    private var testStorage: TestStorage!
    private var sut: SettingsStore!

    override func setUp() {
        super.setUp()
        testStorage = TestStorage()
        sut = SettingsStore(storage: testStorage.storageManager)
    }

    override func tearDown() {
        testStorage.cleanUp()
        super.tearDown()
    }

    func testGetReturnsDefaultsWhenEmpty() {
        let settings = sut.get()
        XCTAssertEqual(settings, Settings.default)
    }

    func testSaveAndGet() {
        var settings = Settings.default
        settings.onboarded = true
        settings.dailyPracticeMinutes = 15
        sut.save(settings)

        let loaded = sut.get()
        XCTAssertTrue(loaded.onboarded)
        XCTAssertEqual(loaded.dailyPracticeMinutes, 15)
    }

    func testUpdatePreservesUnmodifiedFields() {
        sut.update { $0.onboarded = true }
        sut.update { $0.dailyPracticeMinutes = 20 }

        let settings = sut.get()
        XCTAssertTrue(settings.onboarded)
        XCTAssertEqual(settings.dailyPracticeMinutes, 20)
    }

    func testGetAllContactsIncludesDefaults() {
        let contacts = sut.getAllContacts()
        XCTAssertEqual(contacts.count, 2)
        XCTAssertTrue(contacts.allSatisfy { $0.isDefault })
    }

    func testAddContact() {
        let contact = sut.addContact(name: "Test", role: "Tester", phone: "000")
        XCTAssertFalse(contact.isDefault)
        XCTAssertFalse(contact.id.isEmpty)

        let contacts = sut.getAllContacts()
        // 2 defaults + 1 user
        XCTAssertEqual(contacts.count, 3)
    }

    func testRemoveContactOnlyRemovesUserContacts() {
        let contact = sut.addContact(name: "Test", role: "Tester", phone: "000")
        sut.removeContact(id: contact.id)

        let contacts = sut.getAllContacts()
        XCTAssertEqual(contacts.count, 2)
    }

    func testRemoveDefaultContactDoesNothing() {
        // Try to remove a default contact by its ID
        sut.removeContact(id: "default-spiritual-1")
        // Defaults are not stored in settings.spiritualContacts, so this is a no-op
        let contacts = sut.getAllContacts()
        XCTAssertEqual(contacts.count, 2)
    }

    func testClearAll() {
        sut.update { $0.onboarded = true }
        sut.clearAll()

        let settings = sut.get()
        XCTAssertEqual(settings, Settings.default)
    }

    func testUpdateDarkMode() {
        sut.update { $0.darkMode = false }
        XCTAssertFalse(sut.get().darkMode)
    }

    func testUpdateReminderDay() {
        sut.update { $0.reminderDay = 3 }
        XCTAssertEqual(sut.get().reminderDay, 3)
    }

    func testAudioLanguageByExercise() {
        sut.update { $0.setAudioLanguage(.ru, for: .breathing4_8) }
        let settings = sut.get()
        XCTAssertEqual(settings.audioLanguage(for: .breathing4_8), .ru)
        XCTAssertEqual(settings.audioLanguage(for: .pmrFull), .he) // fallback
    }
}
