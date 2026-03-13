import XCTest
@testable import WellbeingApp

final class TrendInsightEngineTests: XCTestCase {

    // MARK: - Score Insight

    func testScoreInsightNoAssessments() {
        let insight = TrendInsightEngine.scoreInsight(assessments: [])
        XCTAssertTrue(insight.titleHe.contains("עדיין אין"))
    }

    func testScoreInsightSingleAssessment() {
        let assessments = [makeAssessment(score: 15, daysAgo: 0)]
        let insight = TrendInsightEngine.scoreInsight(assessments: assessments)
        XCTAssertTrue(insight.titleHe.contains("15"))
        XCTAssertTrue(insight.titleHe.contains("בסיס"))
    }

    func testScoreInsightImprovement() {
        let assessments = [
            makeAssessment(score: 10, daysAgo: 0),
            makeAssessment(score: 15, daysAgo: 7),
        ]
        let insight = TrendInsightEngine.scoreInsight(assessments: assessments)
        XCTAssertTrue(insight.titleHe.contains("ירידה"))
        XCTAssertTrue(insight.titleHe.contains("5"))
    }

    func testScoreInsightWorsening() {
        let assessments = [
            makeAssessment(score: 20, daysAgo: 0),
            makeAssessment(score: 15, daysAgo: 7),
        ]
        let insight = TrendInsightEngine.scoreInsight(assessments: assessments)
        XCTAssertTrue(insight.titleHe.contains("עלייה"))
        XCTAssertTrue(insight.titleHe.contains("5"))
    }

    func testScoreInsightNoChange() {
        let assessments = [
            makeAssessment(score: 15, daysAgo: 0),
            makeAssessment(score: 15, daysAgo: 7),
        ]
        let insight = TrendInsightEngine.scoreInsight(assessments: assessments)
        XCTAssertTrue(insight.titleHe.contains("ללא שינוי"))
    }

    // MARK: - Focus Insight

    func testFocusInsightNoFlags() {
        let assessments = [makeAssessment(score: 5, daysAgo: 0)]
        let insight = TrendInsightEngine.focusInsight(assessments: assessments)
        XCTAssertTrue(insight.titleHe.contains("עדיין אין דפוס"))
    }

    func testFocusInsightFindsTopCategory() {
        let a1 = makeAssessmentWithFlags(categories: ["mental_overload", "body_tension"], daysAgo: 0)
        let a2 = makeAssessmentWithFlags(categories: ["mental_overload"], daysAgo: 7)
        let insight = TrendInsightEngine.focusInsight(assessments: [a1, a2])
        XCTAssertTrue(insight.titleHe.contains("עומס נפשי"))
    }

    // MARK: - Routine Insight

    func testRoutineInsightNoActivity() {
        let insight = TrendInsightEngine.routineInsight(practices: [], checkins: [])
        XCTAssertTrue(insight.titleHe.contains("עדיין אין"))
    }

    func testRoutineInsightWithActivity() {
        let practice = PracticeLog(
            id: "p1", date: Date(), exerciseId: .breathing4_6,
            durationSeconds: 180, completed: true, rating: 4, textResponses: nil
        )
        let checkin = DailyCheckin(
            id: "c1", date: Date(), mood: .stable, shiftCharacteristic: .fatigue
        )
        let insight = TrendInsightEngine.routineInsight(practices: [practice], checkins: [checkin])
        XCTAssertTrue(insight.titleHe.contains("1 תרגולים"))
        XCTAssertTrue(insight.titleHe.contains("1 בדיקות"))
    }

    func testRoutineInsightShowsDominantMood() {
        let checkins = [
            DailyCheckin(id: "c1", date: Date(), mood: .exhausted, shiftCharacteristic: .fatigue),
            DailyCheckin(id: "c2", date: Date().addingTimeInterval(-86400), mood: .exhausted, shiftCharacteristic: .fatigue),
            DailyCheckin(id: "c3", date: Date().addingTimeInterval(-172800), mood: .stable, shiftCharacteristic: .fatigue),
        ]
        let insight = TrendInsightEngine.routineInsight(practices: [], checkins: checkins)
        XCTAssertTrue(insight.bodyHe.contains("מותש/ת"))
    }

    // MARK: - Helpers

    private func makeAssessment(score: Int, daysAgo: Int) -> Assessment {
        let date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date())!
        return Assessment(
            id: UUID().uuidString, date: date,
            answers: [], adjustedAnswers: [],
            totalScore: score, level: ScoringEngine.level(for: score), flags: []
        )
    }

    private func makeAssessmentWithFlags(categories: [String], daysAgo: Int) -> Assessment {
        let date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date())!
        let flags = categories.enumerated().map { i, cat in
            Flag(questionIndex: i, questionKey: "Q\(i+1)", category: cat, score: 3)
        }
        return Assessment(
            id: UUID().uuidString, date: date,
            answers: [], adjustedAnswers: [],
            totalScore: 15, level: .yellow, flags: flags
        )
    }
}
