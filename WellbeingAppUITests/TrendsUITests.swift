import XCTest

@MainActor
final class TrendsUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launchArguments = ["-reset-state", "-onboarded"]
        app.launch()
    }

    func testTrendsShowsEmptyState() {
        app.tabBars.buttons["מגמות"].tap()
        XCTAssertTrue(app.staticTexts["צריך לפחות 2 שאלונים כדי לראות מגמות"].waitForExistence(timeout: 5))
    }
}
