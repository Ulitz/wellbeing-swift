import XCTest
@testable import WellbeingApp

final class StorageManagerTests: XCTestCase {

    private var testStorage: TestStorage!
    private var sut: StorageManager!

    override func setUp() {
        super.setUp()
        testStorage = TestStorage()
        sut = testStorage.storageManager
    }

    override func tearDown() {
        testStorage.cleanUp()
        super.tearDown()
    }

    func testSaveAndLoad() throws {
        let flag = Flag(questionIndex: 0, questionKey: "Q1", category: "test", score: 3)
        sut.save(flag, forKey: "test_flag")

        let loaded = sut.load(Flag.self, forKey: "test_flag")
        XCTAssertEqual(loaded, flag)
    }

    func testLoadReturnsNilWhenEmpty() {
        let loaded = sut.load(Flag.self, forKey: "nonexistent")
        XCTAssertNil(loaded)
    }

    func testSaveThenRemove() {
        sut.save("hello", forKey: "test_string")
        sut.remove(forKey: "test_string")
        let loaded = sut.load(String.self, forKey: "test_string")
        XCTAssertNil(loaded)
    }

    func testOverwriteExistingValue() {
        sut.save(42, forKey: "number")
        sut.save(99, forKey: "number")
        let loaded = sut.load(Int.self, forKey: "number")
        XCTAssertEqual(loaded, 99)
    }

    func testSaveAndLoadArray() throws {
        let items = [
            Flag(questionIndex: 0, questionKey: "Q1", category: "a", score: 1),
            Flag(questionIndex: 1, questionKey: "Q2", category: "b", score: 2),
        ]
        sut.save(items, forKey: "flags")
        let loaded = sut.load([Flag].self, forKey: "flags")
        XCTAssertEqual(loaded, items)
    }

    func testDateEncodingWithISO8601() throws {
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let checkin = DailyCheckin(
            id: "c1",
            date: date,
            mood: .stable,
            shiftCharacteristic: .fatigue
        )
        sut.save(checkin, forKey: "checkin")
        let loaded = sut.load(DailyCheckin.self, forKey: "checkin")
        XCTAssertEqual(loaded, checkin)
    }
}
