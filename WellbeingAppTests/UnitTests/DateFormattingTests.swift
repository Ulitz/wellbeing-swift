import XCTest
@testable import WellbeingApp

final class DateFormattingTests: XCTestCase {

    func testLocalDateKeyFormat() {
        // Jan 15, 2026, noon UTC
        let date = Date(timeIntervalSince1970: 1_768_521_600)
        let key = DateFormatting.localDateKey(for: date)
        // Should be in YYYY-MM-DD format
        XCTAssertTrue(key.matches(of: /\d{4}-\d{2}-\d{2}/).count == 1)
    }

    func testIsSameDayTrue() {
        let date1 = Date()
        let date2 = Date().addingTimeInterval(60) // 1 minute later
        XCTAssertTrue(DateFormatting.isSameDay(date1, date2))
    }

    func testIsSameDayFalse() {
        let date1 = Date()
        let date2 = Calendar.current.date(byAdding: .day, value: -1, to: date1)!
        XCTAssertFalse(DateFormatting.isSameDay(date1, date2))
    }

    func testDaysAgo() {
        let now = Date()
        let result = DateFormatting.daysAgo(7, from: now)
        let diff = Calendar.current.dateComponents([.day], from: result, to: now).day
        XCTAssertEqual(diff, 7)
    }

    func testWeeksAgo() {
        let now = Date()
        let result = DateFormatting.weeksAgo(2, from: now)
        let diff = Calendar.current.dateComponents([.day], from: result, to: now).day
        XCTAssertEqual(diff, 14)
    }
}
