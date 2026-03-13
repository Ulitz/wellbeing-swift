import XCTest

@MainActor
final class SettingsUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launchArguments = ["-reset-state", "-onboarded"]
        app.launch()
    }

    func testSettingsShowsAllSections() {
        app.tabBars.buttons["הגדרות"].tap()

        XCTAssertTrue(app.staticTexts["תזכורת שבועית"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["יעד תרגול יומי"].exists)
        XCTAssertTrue(app.staticTexts["שפת שמע"].exists)
        XCTAssertTrue(app.staticTexts["מצב כהה"].exists)
    }

    func testSettingsShowsDataManagement() {
        app.tabBars.buttons["הגדרות"].tap()

        // Scroll down to find data management
        let dataManagement = app.staticTexts["ניהול נתונים"]
        XCTAssertTrue(dataManagement.waitForExistence(timeout: 5))
    }

    func testClearAssessmentsRequiresConfirmation() {
        app.tabBars.buttons["הגדרות"].tap()

        let clearButton = app.staticTexts["מחיקת כל השאלונים"]
        XCTAssertTrue(clearButton.waitForExistence(timeout: 5))
        clearButton.tap()

        // Alert should appear
        XCTAssertTrue(app.alerts["מחיקת שאלונים"].waitForExistence(timeout: 5))
    }

    func testClearAssessmentsCanBeCancelled() {
        app.tabBars.buttons["הגדרות"].tap()

        app.staticTexts["מחיקת כל השאלונים"].tap()

        let alert = app.alerts["מחיקת שאלונים"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))

        alert.buttons["ביטול"].tap()

        // Alert should dismiss
        XCTAssertFalse(alert.exists)
    }

    func testDisclaimerTextVisible() {
        app.tabBars.buttons["הגדרות"].tap()

        // The disclaimer should be visible somewhere
        let disclaimer = app.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", "כלי זה מיועד"))
        XCTAssertGreaterThan(disclaimer.count, 0)
    }
}
