import XCTest

@MainActor
final class OnboardingUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launchArguments = ["-reset-state"]
        app.launch()
    }

    func testFreshLaunchShowsWelcomeView() {
        XCTAssertTrue(app.staticTexts["מדד רווחה ותפקוד"].waitForExistence(timeout: 5))
    }

    func testWelcomeShowsPrivacyBadge() {
        XCTAssertTrue(app.staticTexts["כל הנתונים נשמרים במכשיר שלך בלבד"].waitForExistence(timeout: 5))
    }

    func testStartButtonExists() {
        XCTAssertTrue(app.buttons["התחל"].waitForExistence(timeout: 5))
    }

    func testCanNavigateThroughOnboarding() {
        // Tap Start
        let startButton = app.buttons["התחל"]
        XCTAssertTrue(startButton.waitForExistence(timeout: 5))
        startButton.tap()

        // Step 1: Reminder - tap Next
        let nextButton = app.buttons["הבא"]
        XCTAssertTrue(nextButton.waitForExistence(timeout: 5))
        nextButton.tap()

        // Step 2: Practice target - tap Next
        XCTAssertTrue(nextButton.waitForExistence(timeout: 5))
        nextButton.tap()

        // Step 3: Contacts - tap Next
        XCTAssertTrue(nextButton.waitForExistence(timeout: 5))
        nextButton.tap()

        // Step 4: Dark mode - tap Finish
        let finishButton = app.buttons["סיום"]
        XCTAssertTrue(finishButton.waitForExistence(timeout: 5))
        finishButton.tap()

        // Should now be on Home (tab bar visible) — allow extra time for state transition
        XCTAssertTrue(app.tabBars.firstMatch.waitForExistence(timeout: 10))
    }
}
