import XCTest
@testable import WellbeingApp

final class AssessmentStoreTests: XCTestCase {

    private var testStorage: TestStorage!
    private var sut: AssessmentStore!

    override func setUp() {
        super.setUp()
        testStorage = TestStorage()
        sut = AssessmentStore(storage: testStorage.storageManager)
    }

    override func tearDown() {
        testStorage.cleanUp()
        super.tearDown()
    }

    func testGetAllReturnsEmptyWhenNoData() {
        XCTAssertTrue(sut.getAll().isEmpty)
    }

    func testSaveAndGetAll() {
        let a = makeAssessment(id: "a1", daysAgo: 0)
        sut.save(a)
        let all = sut.getAll()
        XCTAssertEqual(all.count, 1)
        XCTAssertEqual(all[0].id, "a1")
    }

    func testGetAllSortedByDateDescending() {
        let old = makeAssessment(id: "old", daysAgo: 7)
        let recent = makeAssessment(id: "recent", daysAgo: 0)
        sut.save(old)
        sut.save(recent)

        let all = sut.getAll()
        XCTAssertEqual(all[0].id, "recent")
        XCTAssertEqual(all[1].id, "old")
    }

    func testGetById() {
        let a = makeAssessment(id: "find-me", daysAgo: 0)
        sut.save(a)
        XCTAssertNotNil(sut.getById("find-me"))
        XCTAssertNil(sut.getById("not-found"))
    }

    func testGetLatest() {
        XCTAssertNil(sut.getLatest())

        let old = makeAssessment(id: "old", daysAgo: 7)
        let recent = makeAssessment(id: "recent", daysAgo: 0)
        sut.save(old)
        sut.save(recent)

        XCTAssertEqual(sut.getLatest()?.id, "recent")
    }

    func testGetRecentFiltersByWeeks() {
        let old = makeAssessment(id: "old", daysAgo: 30)
        let recent = makeAssessment(id: "recent", daysAgo: 3)
        sut.save(old)
        sut.save(recent)

        let recentOnes = sut.getRecent(weeks: 1)
        XCTAssertEqual(recentOnes.count, 1)
        XCTAssertEqual(recentOnes[0].id, "recent")
    }

    func testClearAll() {
        sut.save(makeAssessment(id: "a1", daysAgo: 0))
        sut.clearAll()
        XCTAssertTrue(sut.getAll().isEmpty)
    }

    // MARK: - Helpers

    private func makeAssessment(id: String, daysAgo: Int) -> Assessment {
        let date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date())!
        return Assessment(
            id: id,
            date: date,
            answers: [1, 2, 1, 0, 1, 0, 2, 1, 3, 4],
            adjustedAnswers: [1, 2, 1, 0, 1, 0, 2, 1, 1, 0],
            totalScore: 9,
            level: .green,
            flags: []
        )
    }
}
