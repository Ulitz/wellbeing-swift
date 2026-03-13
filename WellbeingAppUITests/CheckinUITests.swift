import XCTest

@MainActor
final class CheckinUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launchArguments = ["-reset-state", "-onboarded"]
        app.launch()
    }

    func testCheckinCardExists() {
        let card = app.buttons["daily-checkin-card"]
        XCTAssertTrue(card.waitForExistence(timeout: 5))
    }

    func testTappingCheckinOpensModal() {
        let card = app.buttons["daily-checkin-card"]
        XCTAssertTrue(card.waitForExistence(timeout: 5))
        card.tap()

        // Modal should show mood question
        XCTAssertTrue(app.staticTexts["איך את/ה מרגיש/ה?"].waitForExistence(timeout: 5))
    }

    func testCanSelectMoodAndShift() {
        let card = app.buttons["daily-checkin-card"]
        XCTAssertTrue(card.waitForExistence(timeout: 5))
        card.tap()

        // Wait for mood step
        XCTAssertTrue(app.staticTexts["איך את/ה מרגיש/ה?"].waitForExistence(timeout: 5))

        // Select stable mood
        let stableMood = app.buttons["checkin-option-יציב/ה"]
        XCTAssertTrue(stableMood.waitForExistence(timeout: 3))
        stableMood.tap()

        // Should advance to shift step
        XCTAssertTrue(app.staticTexts["מה מאפיין את המשמרת?"].waitForExistence(timeout: 5))

        // Select a shift
        let fatigueShift = app.buttons["checkin-option-עייפות"]
        XCTAssertTrue(fatigueShift.waitForExistence(timeout: 3))
        fatigueShift.tap()

        // Modal should dismiss — check-in card should be gone, tailored response visible
        XCTAssertTrue(app.staticTexts["הושלם"].waitForExistence(timeout: 5))
    }
}
