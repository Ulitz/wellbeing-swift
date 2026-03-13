import Foundation

struct Settings: Codable, Equatable, Sendable {
    var onboarded: Bool
    var reminderDay: Int
    var reminderTime: String
    var dailyPracticeMinutes: Int
    var spiritualContacts: [SpiritualContact]
    var biweeklyReminderEnabled: Bool
    var lastReminderDate: Date?
    var language: AppLanguage
    var audioLanguage: AppLanguage
    var audioLanguageByExercise: [String: AppLanguage]
    var darkMode: Bool

    static let `default` = Settings(
        onboarded: false,
        reminderDay: 0,
        reminderTime: "18:00",
        dailyPracticeMinutes: 5,
        spiritualContacts: [],
        biweeklyReminderEnabled: true,
        lastReminderDate: nil,
        language: .he,
        audioLanguage: .he,
        audioLanguageByExercise: [:],
        darkMode: true
    )

    /// Get audio language for a specific exercise, falling back to global setting.
    func audioLanguage(for exerciseId: ExerciseId) -> AppLanguage {
        audioLanguageByExercise[exerciseId.rawValue] ?? audioLanguage
    }

    /// Set audio language for a specific exercise.
    mutating func setAudioLanguage(_ lang: AppLanguage, for exerciseId: ExerciseId) {
        audioLanguageByExercise[exerciseId.rawValue] = lang
    }
}
