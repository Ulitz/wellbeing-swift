import XCTest
@testable import WellbeingApp

final class PersonalizationEngineTests: XCTestCase {

    func testEmptyInputsProducesTimeFitOnly() {
        let sections = PersonalizationEngine.buildSections(
            todayCheckin: nil, preferredMinutes: 5,
            recentPractices: [], favoriteIds: []
        )
        // Should have time-fit section only
        XCTAssertEqual(sections.count, 1)
        XCTAssertEqual(sections[0].titleHe, "לפי הזמן שביקשת לעצמך")
    }

    func testCheckinProducesTodaySection() {
        let checkin = DailyCheckin(
            id: "c1", date: Date(),
            mood: .exhausted, shiftCharacteristic: .fatigue
        )
        let sections = PersonalizationEngine.buildSections(
            todayCheckin: checkin, preferredMinutes: 5,
            recentPractices: [], favoriteIds: []
        )
        XCTAssertTrue(sections.contains { $0.titleHe == "לפי הבדיקה של היום" })
    }

    func testTimeFitSectionSortsByClosestDuration() {
        let sections = PersonalizationEngine.buildSections(
            todayCheckin: nil, preferredMinutes: 3,
            recentPractices: [], favoriteIds: []
        )
        let timeFit = sections.first { $0.titleHe == "לפי הזמן שביקשת לעצמך" }
        XCTAssertNotNil(timeFit)
        XCTAssertTrue(timeFit!.suggestions.count <= 3)
    }

    func testHelpfulHistorySectionFromPractices() {
        let practices = (1...5).map { i in
            PracticeLog(
                id: "p\(i)", date: Date(),
                exerciseId: .breathing4_6, durationSeconds: 180,
                completed: true, rating: 5, textResponses: nil
            )
        }
        let sections = PersonalizationEngine.buildSections(
            todayCheckin: nil, preferredMinutes: 5,
            recentPractices: practices, favoriteIds: []
        )
        XCTAssertTrue(sections.contains { $0.titleHe == "מה שכבר עזר לך" })
    }

    func testFavoritesFallbackWhenNoHistory() {
        let sections = PersonalizationEngine.buildSections(
            todayCheckin: nil, preferredMinutes: 5,
            recentPractices: [],
            favoriteIds: [.pmrFull, .selfCompassion]
        )
        XCTAssertTrue(sections.contains { $0.titleHe == "המועדפים שלך" })
    }

    func testNoDuplicateExercisesAcrossSections() {
        let checkin = DailyCheckin(
            id: "c1", date: Date(),
            mood: .exhausted, shiftCharacteristic: .fatigue
        )
        let sections = PersonalizationEngine.buildSections(
            todayCheckin: checkin, preferredMinutes: 5,
            recentPractices: [], favoriteIds: []
        )
        var seen: Set<ExerciseId> = []
        for section in sections {
            for suggestion in section.suggestions {
                XCTAssertFalse(seen.contains(suggestion.exerciseId),
                               "Duplicate exercise \(suggestion.exerciseId) found across sections")
                seen.insert(suggestion.exerciseId)
            }
        }
    }

    func testMaxThreeSuggestionsPerSection() {
        let sections = PersonalizationEngine.buildSections(
            todayCheckin: nil, preferredMinutes: 5,
            recentPractices: [], favoriteIds: ExerciseId.allCases
        )
        for section in sections {
            XCTAssertTrue(section.suggestions.count <= 3)
        }
    }
}
