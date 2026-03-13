import XCTest
@testable import WellbeingApp

final class CheckinEngineTests: XCTestCase {

    func testStableMoodRecommendations() {
        let recs = CheckinEngine.buildRecommendations(mood: .stable, shift: .senseOfMeaning)
        let exerciseIds = recs.compactMap(\.exerciseId)
        XCTAssertTrue(exerciseIds.contains(.shiftProcessing))
    }

    func testExhaustedMoodRecommendations() {
        let recs = CheckinEngine.buildRecommendations(mood: .exhausted, shift: .fatigue)
        let exerciseIds = recs.compactMap(\.exerciseId)
        XCTAssertTrue(exerciseIds.contains(.breathing4_6))
        XCTAssertTrue(exerciseIds.contains(.bodyStretchQuick))
    }

    func testOverwhelmedMoodIncludesSpiritualContact() {
        let recs = CheckinEngine.buildRecommendations(mood: .overwhelmed, shift: .senseOfMeaning)
        let contactRecs = recs.filter { $0.exerciseId == nil }
        XCTAssertFalse(contactRecs.isEmpty)
        XCTAssertTrue(contactRecs.contains { $0.type == .spiritualCare })
    }

    func testApatheticMoodIncludesPsychologist() {
        let recs = CheckinEngine.buildRecommendations(mood: .apathetic, shift: .senseOfMeaning)
        let contactRecs = recs.filter { $0.exerciseId == nil }
        XCTAssertTrue(contactRecs.contains { $0.type == .professionalHelp })
    }

    func testNeedsBreakMoodRecommendations() {
        let recs = CheckinEngine.buildRecommendations(mood: .needsBreak, shift: .fatigue)
        let exerciseIds = recs.compactMap(\.exerciseId)
        XCTAssertTrue(exerciseIds.contains(.pmrMini))
        XCTAssertTrue(exerciseIds.contains(.breathing4_8))
    }

    func testPatientDeathShiftIncludesSpiritualContact() {
        let recs = CheckinEngine.buildRecommendations(mood: .stable, shift: .patientDeath)
        let contactRecs = recs.filter { $0.exerciseId == nil }
        XCTAssertTrue(contactRecs.contains { $0.type == .spiritualCare })
    }

    func testExerciseDeduplication() {
        // Both stable mood and senseOfMeaning shift recommend shiftProcessing
        let recs = CheckinEngine.buildRecommendations(mood: .stable, shift: .senseOfMeaning)
        let shiftProcessingCount = recs.filter { $0.exerciseId == .shiftProcessing }.count
        XCTAssertEqual(shiftProcessingCount, 1)
    }

    func testMaxThreeExercises() {
        let recs = CheckinEngine.buildRecommendations(mood: .exhausted, shift: .emotionalLoad)
        let exerciseRecs = recs.filter { $0.exerciseId != nil }
        XCTAssertTrue(exerciseRecs.count <= 3)
    }

    func testPriorityIsIncreasing() {
        let recs = CheckinEngine.buildRecommendations(mood: .overwhelmed, shift: .patientDeath)
        for i in 1..<recs.count {
            XCTAssertGreaterThanOrEqual(recs[i].priority, recs[i - 1].priority)
        }
    }

    func testContactDeduplication() {
        // overwhelmed mood → spiritual contact, patientDeath shift → spiritual contact
        let recs = CheckinEngine.buildRecommendations(mood: .overwhelmed, shift: .patientDeath)
        let spiritualContacts = recs.filter { $0.id.contains("contact-spiritual") }
        XCTAssertEqual(spiritualContacts.count, 1)
    }
}
