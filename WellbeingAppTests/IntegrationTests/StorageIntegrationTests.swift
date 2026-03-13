import XCTest
@testable import WellbeingApp

final class StorageIntegrationTests: XCTestCase {

    private var testStorage: TestStorage!
    private var assessmentStore: AssessmentStore!
    private var checkinStore: CheckinStore!
    private var practiceStore: PracticeStore!
    private var settingsStore: SettingsStore!
    private var meaningStore: MeaningStore!
    private var favoritesStore: FavoritesStore!

    override func setUp() {
        super.setUp()
        testStorage = TestStorage()
        let sm = testStorage.storageManager
        assessmentStore = AssessmentStore(storage: sm)
        checkinStore = CheckinStore(storage: sm)
        practiceStore = PracticeStore(storage: sm)
        settingsStore = SettingsStore(storage: sm)
        meaningStore = MeaningStore(storage: sm)
        favoritesStore = FavoritesStore(storage: sm)
    }

    override func tearDown() {
        testStorage.cleanUp()
        super.tearDown()
    }

    func testStoresDoNotInterfereWithEachOther() {
        // Save data to all stores
        let assessment = Assessment(
            id: "a1", date: Date(),
            answers: [1, 2, 1, 0, 1, 0, 2, 1, 3, 4],
            adjustedAnswers: [1, 2, 1, 0, 1, 0, 2, 1, 1, 0],
            totalScore: 9, level: .green, flags: []
        )
        assessmentStore.save(assessment)

        let checkin = DailyCheckin(
            id: "c1", date: Date(),
            mood: .stable, shiftCharacteristic: .fatigue
        )
        checkinStore.save(checkin)

        let practice = PracticeLog(
            id: "p1", date: Date(),
            exerciseId: .breathing4_6, durationSeconds: 180,
            completed: true, rating: 5, textResponses: nil
        )
        practiceStore.log(practice)

        settingsStore.update { $0.onboarded = true }

        let moment = MeaningMoment(id: "m1", date: Date(), selection: .professionalism)
        meaningStore.save(moment)

        favoritesStore.toggle(.pmrFull)

        // Verify all stores read back correctly
        XCTAssertEqual(assessmentStore.getAll().count, 1)
        XCTAssertEqual(checkinStore.getAll().count, 1)
        XCTAssertEqual(practiceStore.getAll().count, 1)
        XCTAssertTrue(settingsStore.get().onboarded)
        XCTAssertEqual(meaningStore.getAll().count, 1)
        XCTAssertTrue(favoritesStore.isFavorite(.pmrFull))
    }

    func testClearOneStoreDoesNotAffectOthers() {
        assessmentStore.save(Assessment(
            id: "a1", date: Date(),
            answers: [0, 0, 0, 0, 0, 0, 0, 0, 4, 4],
            adjustedAnswers: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            totalScore: 0, level: .green, flags: []
        ))
        favoritesStore.toggle(.breathing4_6)

        assessmentStore.clearAll()

        XCTAssertTrue(assessmentStore.getAll().isEmpty)
        XCTAssertTrue(favoritesStore.isFavorite(.breathing4_6))
    }
}
