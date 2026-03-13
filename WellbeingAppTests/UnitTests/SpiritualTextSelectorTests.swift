import XCTest
@testable import WellbeingApp

final class SpiritualTextSelectorTests: XCTestCase {

    func testSelectsTextForGreenLevel() {
        let result = SpiritualTextSelector.select(level: .green, flags: [], history: [])
        XCTAssertNotNil(result)
        XCTAssertFalse(result!.title.isEmpty)
        XCTAssertFalse(result!.body.isEmpty)
    }

    func testSelectsTextForRedLevel() {
        let result = SpiritualTextSelector.select(level: .red, flags: [], history: [])
        XCTAssertNotNil(result)
    }

    func testPrefersTextWithMatchingTags() {
        let flags = [Flag(questionIndex: 0, questionKey: "Q1", category: "mental_overload", score: 3)]
        let result = SpiritualTextSelector.select(level: .yellow, flags: flags, history: [])
        XCTAssertNotNil(result)
        // yellow-burnout-1 has tag "mental_overload" and should be preferred
        XCTAssertEqual(result!.text.id, "yellow-burnout-1")
    }

    func testAvoidsRecentlyShownTexts() {
        let history = ["green-meaning-1"]
        let result = SpiritualTextSelector.select(level: .green, flags: [], history: history)
        XCTAssertNotNil(result)
        XCTAssertNotEqual(result!.text.id, "green-meaning-1")
    }

    func testFallsBackWhenAllInHistory() {
        let history = ["green-meaning-1", "green-general-1"]
        let result = SpiritualTextSelector.select(level: .green, flags: [], history: history)
        // Should still return something (fallback resets history filter)
        XCTAssertNotNil(result)
    }

    func testArabicTranslation() {
        let result = SpiritualTextSelector.select(level: .green, flags: [], history: [], language: .ar)
        XCTAssertNotNil(result)
        // Arabic translations exist for green texts
        XCTAssertFalse(result!.title.isEmpty)
    }

    func testRussianTranslation() {
        let result = SpiritualTextSelector.select(level: .red, flags: [], history: [], language: .ru)
        XCTAssertNotNil(result)
        XCTAssertFalse(result!.title.isEmpty)
    }

    func testHebrewIsDefault() {
        let result = SpiritualTextSelector.select(level: .green, flags: [], history: [])
        XCTAssertNotNil(result)
        // Hebrew title for green-general-1 or green-meaning-1
        let hebrewTitles = ["שמרת על עצמך", "רגע של יציבות"]
        XCTAssertTrue(hebrewTitles.contains(result!.title))
    }
}
