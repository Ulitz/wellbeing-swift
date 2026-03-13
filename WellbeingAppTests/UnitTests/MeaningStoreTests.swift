import XCTest
@testable import WellbeingApp

final class MeaningStoreTests: XCTestCase {

    private var testStorage: TestStorage!
    private var sut: MeaningStore!

    override func setUp() {
        super.setUp()
        testStorage = TestStorage()
        sut = MeaningStore(storage: testStorage.storageManager)
    }

    override func tearDown() {
        testStorage.cleanUp()
        super.tearDown()
    }

    func testGetAllReturnsEmptyWhenNoData() {
        XCTAssertTrue(sut.getAll().isEmpty)
    }

    func testSaveAndGetAll() {
        let m = makeMoment(id: "m1", daysAgo: 0)
        sut.save(m)
        XCTAssertEqual(sut.getAll().count, 1)
    }

    func testGetTodayReturnsNilWhenEmpty() {
        XCTAssertNil(sut.getToday())
    }

    func testGetTodayReturnsTodaysMoment() {
        let today = makeMoment(id: "today", daysAgo: 0)
        sut.save(today)
        XCTAssertNotNil(sut.getToday())
    }

    func testGetTodayIgnoresYesterday() {
        let yesterday = makeMoment(id: "yesterday", daysAgo: 1)
        sut.save(yesterday)
        XCTAssertNil(sut.getToday())
    }

    func testGetAllSortedByDateDescending() {
        let old = makeMoment(id: "old", daysAgo: 3)
        let recent = makeMoment(id: "recent", daysAgo: 0)
        sut.save(old)
        sut.save(recent)

        let all = sut.getAll()
        XCTAssertEqual(all[0].id, "recent")
    }

    // MARK: - Helpers

    private func makeMoment(id: String, daysAgo: Int) -> MeaningMoment {
        let date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date())!
        return MeaningMoment(id: id, date: date, selection: .patientSmile)
    }
}
