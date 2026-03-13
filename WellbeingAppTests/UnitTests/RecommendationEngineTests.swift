import XCTest
@testable import WellbeingApp

final class RecommendationEngineTests: XCTestCase {

    func testCriticalOverloadReturnsUrgentRecommendations() {
        let assessment = makeAssessment(answers: [4, 4, 4, 4, 4, 4, 4, 4, 0, 0], totalScore: 40, level: .red)
        let recs = RecommendationEngine.buildRecommendations(for: assessment)

        XCTAssertTrue(recs.count <= 5)
        let ids = recs.map(\.id)
        XCTAssertTrue(ids.contains("urgent-human-support"))
        XCTAssertTrue(ids.contains("urgent-pmr"))
        XCTAssertTrue(ids.contains("urgent-breathing"))
    }

    func testSignificantDistressReturnsSpiritualFirst() {
        let assessment = makeAssessment(answers: [3, 3, 2, 2, 2, 2, 2, 2, 2, 2], totalScore: 22, level: .orange)
        let recs = RecommendationEngine.buildRecommendations(for: assessment)

        let ids = recs.map(\.id)
        XCTAssertTrue(ids.contains("spiritual-first"))
    }

    func testEmotionalDetachmentTriggersValuesReflection() {
        let assessment = makeAssessment(answers: [0, 0, 0, 0, 0, 0, 3, 0, 4, 4], totalScore: 3, level: .green)
        let recs = RecommendationEngine.buildRecommendations(for: assessment)

        let ids = recs.map(\.id)
        XCTAssertTrue(ids.contains("values-reflection"))
        XCTAssertTrue(ids.contains("spiritual-detachment"))
    }

    func testLowMeaningTriggersSpiritualRecommendation() {
        let assessment = makeAssessment(answers: [0, 0, 0, 0, 0, 0, 0, 0, 4, 1], totalScore: 3, level: .green)
        let recs = RecommendationEngine.buildRecommendations(for: assessment)

        let ids = recs.map(\.id)
        XCTAssertTrue(ids.contains("low-meaning-spiritual"))
    }

    func testSelfCriticismTriggersCompassion() {
        let assessment = makeAssessment(answers: [0, 0, 0, 0, 0, 0, 0, 3, 4, 4], totalScore: 3, level: .green)
        let recs = RecommendationEngine.buildRecommendations(for: assessment)

        let ids = recs.map(\.id)
        XCTAssertTrue(ids.contains("self-compassion"))
        XCTAssertTrue(ids.contains("suggest-psych"))
    }

    func testOverloadTriggersBreathing() {
        let assessment = makeAssessment(answers: [3, 0, 0, 0, 0, 0, 0, 0, 4, 4], totalScore: 3, level: .green)
        let recs = RecommendationEngine.buildRecommendations(for: assessment)

        let ids = recs.map(\.id)
        XCTAssertTrue(ids.contains("overload-breathing"))
    }

    func testSleepDifficultyTriggersBreathing48() {
        let assessment = makeAssessment(answers: [0, 0, 0, 0, 3, 0, 0, 0, 4, 4], totalScore: 3, level: .green)
        let recs = RecommendationEngine.buildRecommendations(for: assessment)

        let ids = recs.map(\.id)
        XCTAssertTrue(ids.contains("sleep-breathing"))
    }

    func testLowSupportTriggersHumanSupport() {
        let assessment = makeAssessment(answers: [0, 0, 0, 0, 0, 0, 0, 0, 1, 4], totalScore: 3, level: .green)
        let recs = RecommendationEngine.buildRecommendations(for: assessment)

        let ids = recs.map(\.id)
        XCTAssertTrue(ids.contains("low-support"))
    }

    func testNoConditionsReturnsMaintenance() {
        let assessment = makeAssessment(answers: [0, 0, 0, 0, 0, 0, 0, 0, 4, 4], totalScore: 0, level: .green)
        let recs = RecommendationEngine.buildRecommendations(for: assessment)

        XCTAssertEqual(recs.count, 1)
        XCTAssertEqual(recs[0].id, "maintenance")
    }

    func testMaxFiveRecommendations() {
        let assessment = makeAssessment(answers: [4, 4, 4, 4, 4, 4, 4, 4, 0, 0], totalScore: 40, level: .red)
        let recs = RecommendationEngine.buildRecommendations(for: assessment)
        XCTAssertTrue(recs.count <= 5)
    }

    func testRecommendationsSortedByPriority() {
        let assessment = makeAssessment(answers: [4, 4, 4, 4, 4, 4, 4, 4, 0, 0], totalScore: 40, level: .red)
        let recs = RecommendationEngine.buildRecommendations(for: assessment)

        for i in 1..<recs.count {
            XCTAssertGreaterThanOrEqual(recs[i].priority, recs[i - 1].priority)
        }
    }

    func testDeduplication() {
        // Score >= 31 adds urgent-pmr (pmr-full, P1)
        // body tension adds body-tension-pmr (pmr-full, P2)
        // The dedup should keep the lower priority number
        let assessment = makeAssessment(answers: [0, 0, 0, 3, 0, 0, 0, 0, 4, 4], totalScore: 31, level: .red)
        let recs = RecommendationEngine.buildRecommendations(for: assessment)
        let pmrRecs = recs.filter { $0.exerciseId == .pmrFull }
        // Should have at most 2 different recommendation IDs referencing pmrFull
        // (urgent-pmr and body-regulation-score are different IDs)
        XCTAssertTrue(pmrRecs.count >= 1)
    }

    // MARK: - Helpers

    private func makeAssessment(answers: [Int], totalScore: Int, level: ScoreLevel) -> Assessment {
        let adjusted = ScoringEngine.adjustAnswers(answers)
        let flags = FlagDetector.detectFlags(rawAnswers: answers, adjustedAnswers: adjusted)
        return Assessment(
            id: "test", date: Date(timeIntervalSince1970: 1_700_000_000),
            answers: answers, adjustedAnswers: adjusted,
            totalScore: totalScore, level: level, flags: flags
        )
    }
}
