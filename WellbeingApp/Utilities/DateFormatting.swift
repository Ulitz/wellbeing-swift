import Foundation

enum DateFormatting {
    private static let dateKeyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        return formatter
    }()

    /// Returns a local date key string like "2026-03-10" for the given date.
    static func localDateKey(for date: Date = Date()) -> String {
        dateKeyFormatter.string(from: date)
    }

    /// Checks if two dates fall on the same calendar day in the current timezone.
    static func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }

    /// Returns a date N days ago from the given reference date.
    static func daysAgo(_ days: Int, from reference: Date = Date()) -> Date {
        Calendar.current.date(byAdding: .day, value: -days, to: reference) ?? reference
    }

    /// Returns a date N weeks ago from the given reference date.
    static func weeksAgo(_ weeks: Int, from reference: Date = Date()) -> Date {
        Calendar.current.date(byAdding: .day, value: -weeks * 7, to: reference) ?? reference
    }
}
