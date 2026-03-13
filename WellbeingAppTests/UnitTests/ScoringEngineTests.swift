import XCTest
@testable import WellbeingApp

final class ScoringEngineTests: XCTestCase {

    // MARK: - Adjust Answers

    func testAdjustAnswersReversesScoringForQ9Q10() {
        let raw = [0, 0, 0, 0, 0, 0, 0, 0, 4, 4]
        let adjusted = ScoringEngine.adjustAnswers(raw)
        // Q9 (index 8): 4 - 4 = 0
        // Q10 (index 9): 4 - 4 = 0
        XCTAssertEqual(adjusted, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    }

    func testAdjustAnswersLeavesNormalQuestionsUnchanged() {
        let raw = [3, 2, 1, 4, 0, 3, 2, 1, 0, 0]
        let adjusted = ScoringEngine.adjustAnswers(raw)
        XCTAssertEqual(adjusted[0], 3)
        XCTAssertEqual(adjusted[7], 1)
        // Reverse: index 8: 4-0=4, index 9: 4-0=4
        XCTAssertEqual(adjusted[8], 4)
        XCTAssertEqual(adjusted[9], 4)
    }

    // MARK: - Level Thresholds

    func testLevelGreen() {
        XCTAssertEqual(ScoringEngine.level(for: 0), .green)
        XCTAssertEqual(ScoringEngine.level(for: 5), .green)
        XCTAssertEqual(ScoringEngine.level(for: 10), .green)
    }

    func testLevelYellow() {
        XCTAssertEqual(ScoringEngine.level(for: 11), .yellow)
        XCTAssertEqual(ScoringEngine.level(for: 15), .yellow)
        XCTAssertEqual(ScoringEngine.level(for: 20), .yellow)
    }

    func testLevelOrange() {
        XCTAssertEqual(ScoringEngine.level(for: 21), .orange)
        XCTAssertEqual(ScoringEngine.level(for: 25), .orange)
        XCTAssertEqual(ScoringEngine.level(for: 30), .orange)
    }

    func testLevelRed() {
        XCTAssertEqual(ScoringEngine.level(for: 31), .red)
        XCTAssertEqual(ScoringEngine.level(for: 35), .red)
        XCTAssertEqual(ScoringEngine.level(for: 40), .red)
    }

    // MARK: - Full Scoring

    func testScoreAllZeros() {
        let raw = [0, 0, 0, 0, 0, 0, 0, 0, 4, 4]
        let result = ScoringEngine.score(rawAnswers: raw)
        XCTAssertEqual(result.totalScore, 0)
        XCTAssertEqual(result.level, .green)
        XCTAssertTrue(result.flags.isEmpty)
    }

    func testScoreAllMaxNormal() {
        // All normal questions max (4), reverse questions 0 (worst)
        let raw = [4, 4, 4, 4, 4, 4, 4, 4, 0, 0]
        let result = ScoringEngine.score(rawAnswers: raw)
        // adjusted: [4,4,4,4,4,4,4,4, 4-0=4, 4-0=4] = 40
        XCTAssertEqual(result.totalScore, 40)
        XCTAssertEqual(result.level, .red)
    }

    func testScoreYellowRange() {
        // totalScore = 15: some moderate answers
        let raw = [2, 2, 1, 1, 1, 1, 1, 1, 3, 3]
        let result = ScoringEngine.score(rawAnswers: raw)
        // adjusted: [2,2,1,1,1,1,1,1, 4-3=1, 4-3=1] = 12
        XCTAssertEqual(result.totalScore, 12)
        XCTAssertEqual(result.level, .yellow)
    }

    func testScoreProducesValidAssessment() {
        let raw = [1, 2, 1, 0, 1, 0, 2, 1, 3, 4]
        let result = ScoringEngine.score(rawAnswers: raw)
        XCTAssertFalse(result.id.isEmpty)
        XCTAssertEqual(result.answers, raw)
        XCTAssertEqual(result.adjustedAnswers.count, 10)
    }
}
