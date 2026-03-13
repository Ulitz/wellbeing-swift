import XCTest

@MainActor
final class SpiritualCareUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launchArguments = ["-reset-state", "-onboarded"]
        app.launch()
    }

    func testSpiritualCareShowsIntro() {
        app.tabBars.buttons["ליווי רוחני"].tap()
        XCTAssertTrue(app.staticTexts["ליווי רוחני"].waitForExistence(timeout: 5))
    }

    func testDefaultContactsDisplayed() {
        app.tabBars.buttons["ליווי רוחני"].tap()

        // Default contacts should be visible
        XCTAssertTrue(app.staticTexts["נירית אוליצור"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["ליאת אריאל"].waitForExistence(timeout: 5))
    }

    func testAddContactButtonExists() {
        app.tabBars.buttons["ליווי רוחני"].tap()
        XCTAssertTrue(app.staticTexts["הוספת איש קשר"].waitForExistence(timeout: 5))
    }

    func testCanOpenAddContactForm() {
        app.tabBars.buttons["ליווי רוחני"].tap()

        let addButton = app.staticTexts["הוספת איש קשר"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()

        // Form should appear
        XCTAssertTrue(app.navigationBars["הוספת איש קשר"].waitForExistence(timeout: 5))
    }
}
