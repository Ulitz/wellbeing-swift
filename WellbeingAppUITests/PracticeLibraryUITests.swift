import XCTest

@MainActor
final class PracticeLibraryUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launchArguments = ["-reset-state", "-onboarded"]
        app.launch()
    }

    func testPracticeTabShowsExercises() {
        app.tabBars.buttons["תרגול"].tap()
        XCTAssertTrue(app.navigationBars["תרגול"].waitForExistence(timeout: 5))
    }

    func testCanSwitchViewModes() {
        app.tabBars.buttons["תרגול"].tap()

        // Segmented control options are buttons
        XCTAssertTrue(app.buttons["רשימה"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["מועדפים"].exists)
    }

    func testFavoritesEmptyState() {
        app.tabBars.buttons["תרגול"].tap()

        // Switch to favorites mode
        let favoritesButton = app.buttons["מועדפים"]
        XCTAssertTrue(favoritesButton.waitForExistence(timeout: 5))
        favoritesButton.tap()

        // Should show empty state
        XCTAssertTrue(app.staticTexts["עדיין לא סימנת מועדפים"].waitForExistence(timeout: 5))
    }
}
