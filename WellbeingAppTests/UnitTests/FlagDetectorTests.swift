import XCTest
@testable import WellbeingApp

final class FlagDetectorTests: XCTestCase {

    func testNoFlagsWhenAllLow() {
        let raw = [0, 0, 0, 0, 0, 0, 0, 0, 4, 4]
        let adjusted = ScoringEngine.adjustAnswers(raw)
        let flags = FlagDetector.detectFlags(rawAnswers: raw, adjustedAnswers: adjusted)
        XCTAssertTrue(flags.isEmpty)
    }

    func testNormalQuestionFlagsAtThresholdThree() {
        let raw = [3, 0, 0, 0, 0, 0, 0, 0, 4, 4]
        let adjusted = ScoringEngine.adjustAnswers(raw)
        let flags = FlagDetector.detectFlags(rawAnswers: raw, adjustedAnswers: adjusted)
        XCTAssertEqual(flags.count, 1)
        XCTAssertEqual(flags[0].questionIndex, 0)
        XCTAssertEqual(flags[0].questionKey, "Q1")
        XCTAssertEqual(flags[0].category, "mental_overload")
        XCTAssertEqual(flags[0].score, 3)
    }

    func testNormalQuestionFlagsAtFour() {
        let raw = [0, 0, 0, 4, 0, 0, 0, 0, 4, 4]
        let adjusted = ScoringEngine.adjustAnswers(raw)
        let flags = FlagDetector.detectFlags(rawAnswers: raw, adjustedAnswers: adjusted)
        XCTAssertEqual(flags.count, 1)
        XCTAssertEqual(flags[0].category, "body_tension")
    }

    func testNormalQuestionDoesNotFlagAtTwo() {
        let raw = [2, 2, 2, 2, 2, 2, 2, 2, 4, 4]
        let adjusted = ScoringEngine.adjustAnswers(raw)
        let flags = FlagDetector.detectFlags(rawAnswers: raw, adjustedAnswers: adjusted)
        XCTAssertTrue(flags.isEmpty)
    }

    func testReverseQuestionFlagsAtZero() {
        let raw = [0, 0, 0, 0, 0, 0, 0, 0, 0, 4]
        let adjusted = ScoringEngine.adjustAnswers(raw)
        let flags = FlagDetector.detectFlags(rawAnswers: raw, adjustedAnswers: adjusted)
        XCTAssertEqual(flags.count, 1)
        XCTAssertEqual(flags[0].questionIndex, 8)
        XCTAssertEqual(flags[0].questionKey, "Q9")
        XCTAssertEqual(flags[0].category, "low_support")
        XCTAssertEqual(flags[0].score, 0)
    }

    func testReverseQuestionFlagsAtOne() {
        let raw = [0, 0, 0, 0, 0, 0, 0, 0, 4, 1]
        let adjusted = ScoringEngine.adjustAnswers(raw)
        let flags = FlagDetector.detectFlags(rawAnswers: raw, adjustedAnswers: adjusted)
        XCTAssertEqual(flags.count, 1)
        XCTAssertEqual(flags[0].category, "low_meaning")
    }

    func testReverseQuestionDoesNotFlagAtTwo() {
        let raw = [0, 0, 0, 0, 0, 0, 0, 0, 2, 2]
        let adjusted = ScoringEngine.adjustAnswers(raw)
        let flags = FlagDetector.detectFlags(rawAnswers: raw, adjustedAnswers: adjusted)
        XCTAssertTrue(flags.isEmpty)
    }

    func testMultipleFlags() {
        let raw = [4, 0, 0, 3, 0, 0, 0, 4, 0, 0]
        let adjusted = ScoringEngine.adjustAnswers(raw)
        let flags = FlagDetector.detectFlags(rawAnswers: raw, adjustedAnswers: adjusted)
        // Q1(4>=3), Q4(3>=3), Q8(4>=3), Q9(0<=1), Q10(0<=1) = 5 flags
        XCTAssertEqual(flags.count, 5)
        let categories = Set(flags.map(\.category))
        XCTAssertTrue(categories.contains("mental_overload"))
        XCTAssertTrue(categories.contains("body_tension"))
        XCTAssertTrue(categories.contains("self_criticism"))
        XCTAssertTrue(categories.contains("low_support"))
        XCTAssertTrue(categories.contains("low_meaning"))
    }

    func testAllQuestionsFlagged() {
        let raw = [4, 4, 4, 4, 4, 4, 4, 4, 0, 0]
        let adjusted = ScoringEngine.adjustAnswers(raw)
        let flags = FlagDetector.detectFlags(rawAnswers: raw, adjustedAnswers: adjusted)
        XCTAssertEqual(flags.count, 10)
    }
}
