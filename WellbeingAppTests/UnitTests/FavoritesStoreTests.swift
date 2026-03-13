import XCTest
@testable import WellbeingApp

final class FavoritesStoreTests: XCTestCase {

    private var testStorage: TestStorage!
    private var sut: FavoritesStore!

    override func setUp() {
        super.setUp()
        testStorage = TestStorage()
        sut = FavoritesStore(storage: testStorage.storageManager)
    }

    override func tearDown() {
        testStorage.cleanUp()
        super.tearDown()
    }

    func testGetAllReturnsEmptyInitially() {
        XCTAssertTrue(sut.getAll().isEmpty)
    }

    func testToggleAddsFavorite() {
        sut.toggle(.breathing4_6)
        XCTAssertTrue(sut.isFavorite(.breathing4_6))
        XCTAssertEqual(sut.getAll().count, 1)
    }

    func testToggleTwiceRemovesFavorite() {
        sut.toggle(.breathing4_6)
        sut.toggle(.breathing4_6)
        XCTAssertFalse(sut.isFavorite(.breathing4_6))
        XCTAssertTrue(sut.getAll().isEmpty)
    }

    func testMultipleFavorites() {
        sut.toggle(.breathing4_6)
        sut.toggle(.pmrFull)
        sut.toggle(.selfCompassion)

        XCTAssertEqual(sut.getAll().count, 3)
        XCTAssertTrue(sut.isFavorite(.breathing4_6))
        XCTAssertTrue(sut.isFavorite(.pmrFull))
        XCTAssertTrue(sut.isFavorite(.selfCompassion))
        XCTAssertFalse(sut.isFavorite(.boxBreathing))
    }

    func testClearAll() {
        sut.toggle(.breathing4_6)
        sut.toggle(.pmrFull)
        sut.clearAll()
        XCTAssertTrue(sut.getAll().isEmpty)
    }
}
