import XCTest
@testable import WellbeingApp

final class CheckinStoreTests: XCTestCase {

    private var testStorage: TestStorage!
    private var sut: CheckinStore!

    override func setUp() {
        super.setUp()
        testStorage = TestStorage()
        sut = CheckinStore(storage: testStorage.storageManager)
    }

    override func tearDown() {
        testStorage.cleanUp()
        super.tearDown()
    }

    func testGetAllReturnsEmptyWhenNoData() {
        XCTAssertTrue(sut.getAll().isEmpty)
    }

    func testSaveAndGetAll() {
        let c = makeCheckin(id: "c1", daysAgo: 0)
        sut.save(c)
        XCTAssertEqual(sut.getAll().count, 1)
    }

    func testGetTodayReturnsNilWhenNoCheckin() {
        XCTAssertNil(sut.getToday())
    }

    func testGetTodayReturnsCheckinFromToday() {
        let today = makeCheckin(id: "today", daysAgo: 0)
        sut.save(today)
        XCTAssertNotNil(sut.getToday())
        XCTAssertEqual(sut.getToday()?.id, "today")
    }

    func testGetTodayIgnoresYesterday() {
        let yesterday = makeCheckin(id: "yesterday", daysAgo: 1)
        sut.save(yesterday)
        XCTAssertNil(sut.getToday())
    }

    func testGetRecentFiltersByDays() {
        let old = makeCheckin(id: "old", daysAgo: 10)
        let recent = makeCheckin(id: "recent", daysAgo: 2)
        sut.save(old)
        sut.save(recent)

        let recentOnes = sut.getRecent(days: 7)
        XCTAssertEqual(recentOnes.count, 1)
        XCTAssertEqual(recentOnes[0].id, "recent")
    }

    func testGetAllSortedByDateDescending() {
        let old = makeCheckin(id: "old", daysAgo: 3)
        let recent = makeCheckin(id: "recent", daysAgo: 0)
        sut.save(old)
        sut.save(recent)

        let all = sut.getAll()
        XCTAssertEqual(all[0].id, "recent")
        XCTAssertEqual(all[1].id, "old")
    }

    // MARK: - Helpers

    private func makeCheckin(id: String, daysAgo: Int) -> DailyCheckin {
        let date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date())!
        return DailyCheckin(
            id: id,
            date: date,
            mood: .stable,
            shiftCharacteristic: .fatigue
        )
    }
}
