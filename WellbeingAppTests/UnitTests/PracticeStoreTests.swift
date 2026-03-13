import XCTest
@testable import WellbeingApp

final class PracticeStoreTests: XCTestCase {

    private var testStorage: TestStorage!
    private var sut: PracticeStore!

    override func setUp() {
        super.setUp()
        testStorage = TestStorage()
        sut = PracticeStore(storage: testStorage.storageManager)
    }

    override func tearDown() {
        testStorage.cleanUp()
        super.tearDown()
    }

    func testGetAllReturnsEmptyWhenNoData() {
        XCTAssertTrue(sut.getAll().isEmpty)
    }

    func testLogAndGetAll() {
        let log = makePractice(id: "p1", daysAgo: 0)
        sut.log(log)
        XCTAssertEqual(sut.getAll().count, 1)
    }

    func testGetRecentFiltersByDays() {
        let old = makePractice(id: "old", daysAgo: 30)
        let recent = makePractice(id: "recent", daysAgo: 2)
        sut.log(old)
        sut.log(recent)

        let recentOnes = sut.getRecent(days: 21)
        XCTAssertEqual(recentOnes.count, 1)
        XCTAssertEqual(recentOnes[0].id, "recent")
    }

    func testClearAll() {
        sut.log(makePractice(id: "p1", daysAgo: 0))
        sut.clearAll()
        XCTAssertTrue(sut.getAll().isEmpty)
    }

    func testGetAllSortedByDateDescending() {
        let old = makePractice(id: "old", daysAgo: 5)
        let recent = makePractice(id: "recent", daysAgo: 0)
        sut.log(old)
        sut.log(recent)

        let all = sut.getAll()
        XCTAssertEqual(all[0].id, "recent")
        XCTAssertEqual(all[1].id, "old")
    }

    // MARK: - Helpers

    private func makePractice(id: String, daysAgo: Int) -> PracticeLog {
        let date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date())!
        return PracticeLog(
            id: id,
            date: date,
            exerciseId: .breathing4_6,
            durationSeconds: 180,
            completed: true,
            rating: 4,
            textResponses: nil
        )
    }
}
