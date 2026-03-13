import XCTest

@MainActor
final class HomeUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launchArguments = ["-reset-state", "-onboarded"]
        app.launch()
    }

    func testHomeShowsCheckinPrompt() {
        XCTAssertTrue(app.staticTexts["בדיקה יומית"].waitForExistence(timeout: 5))
    }

    func testHomeShowsAssessmentCard() {
        XCTAssertTrue(app.staticTexts["שאלון רווחה שבועי"].waitForExistence(timeout: 5))
    }

    func testHomeShowsWeeklySummary() {
        XCTAssertTrue(app.staticTexts["סיכום שבועי"].waitForExistence(timeout: 5))
    }

    func testTabBarHasFiveTabs() {
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 5))
        XCTAssertEqual(tabBar.buttons.count, 5)
    }

    func testCanSwitchToPracticeTab() {
        app.tabBars.buttons["תרגול"].tap()
        XCTAssertTrue(app.navigationBars["תרגול"].waitForExistence(timeout: 5))
    }

    func testCanSwitchToSpiritualTab() {
        app.tabBars.buttons["ליווי רוחני"].tap()
        XCTAssertTrue(app.navigationBars["ליווי רוחני"].waitForExistence(timeout: 5))
    }

    func testCanSwitchToTrendsTab() {
        app.tabBars.buttons["מגמות"].tap()
        XCTAssertTrue(app.navigationBars["מגמות"].waitForExistence(timeout: 5))
    }

    func testCanSwitchToSettingsTab() {
        app.tabBars.buttons["הגדרות"].tap()
        XCTAssertTrue(app.navigationBars["הגדרות"].waitForExistence(timeout: 5))
    }
}
