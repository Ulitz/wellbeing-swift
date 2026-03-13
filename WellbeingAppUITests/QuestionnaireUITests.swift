import XCTest

@MainActor
final class QuestionnaireUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launchArguments = ["-reset-state", "-onboarded"]
        app.launch()
    }

    private func openQuestionnaire() {
        let card = app.buttons["assessment-status-card"]
        XCTAssertTrue(card.waitForExistence(timeout: 5))
        card.tap()
        XCTAssertTrue(app.staticTexts["1 מתוך 10"].waitForExistence(timeout: 5))
    }

    private func selectFirstOption() {
        let option = app.buttons["likert-option-0"]
        XCTAssertTrue(option.waitForExistence(timeout: 3))
        option.tap()
    }

    private func waitForButtonEnabled(_ label: String) {
        let btn = app.buttons[label]
        let deadline = Date().addingTimeInterval(5)
        while !btn.isEnabled, Date() < deadline {
            Thread.sleep(forTimeInterval: 0.1)
        }
        XCTAssertTrue(btn.isEnabled, "Button '\(label)' should be enabled")
    }

    func testCanOpenQuestionnaire() {
        openQuestionnaire()
    }

    func testCanSelectLikertOption() {
        openQuestionnaire()
        selectFirstOption()
        waitForButtonEnabled("הבא")
        app.buttons["הבא"].tap()
        XCTAssertTrue(app.staticTexts["2 מתוך 10"].waitForExistence(timeout: 5))
    }

    func testCanNavigateBackward() {
        openQuestionnaire()
        selectFirstOption()
        waitForButtonEnabled("הבא")
        app.buttons["הבא"].tap()
        XCTAssertTrue(app.staticTexts["2 מתוך 10"].waitForExistence(timeout: 5))
        app.buttons["הקודם"].tap()
        XCTAssertTrue(app.staticTexts["1 מתוך 10"].waitForExistence(timeout: 5))
    }

    func testCanCompleteFullQuestionnaire() {
        openQuestionnaire()

        for i in 0..<10 {
            XCTAssertTrue(app.staticTexts["\(i + 1) מתוך 10"].waitForExistence(timeout: 5))

            selectFirstOption()

            if i < 9 {
                waitForButtonEnabled("הבא")
                app.buttons["הבא"].tap()
            }
        }

        waitForButtonEnabled("סיום")
        app.buttons["סיום"].tap()

        XCTAssertTrue(app.staticTexts["מצב יציב"].waitForExistence(timeout: 5))
    }
}
