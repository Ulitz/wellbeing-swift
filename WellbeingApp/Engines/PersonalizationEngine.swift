import Foundation

struct PracticeSuggestion: Equatable {
    let exerciseId: ExerciseId
    let reason: String
}

struct PracticeSection: Equatable {
    let titleHe: String
    let suggestions: [PracticeSuggestion]
}

enum PersonalizationEngine {
    /// Builds personalized practice sections.
    static func buildSections(
        todayCheckin: DailyCheckin?,
        preferredMinutes: Int,
        recentPractices: [PracticeLog],
        favoriteIds: [ExerciseId]
    ) -> [PracticeSection] {
        var sections: [PracticeSection] = []
        var taken: Set<ExerciseId> = []

        // Section 1: Today's State (from check-in)
        if let checkin = todayCheckin {
            let recs = CheckinEngine.buildRecommendations(mood: checkin.mood, shift: checkin.shiftCharacteristic)
            var suggestions: [PracticeSuggestion] = []
            for rec in recs {
                guard let id = rec.exerciseId else { continue }
                if !taken.contains(id) {
                    taken.insert(id)
                    suggestions.append(PracticeSuggestion(exerciseId: id, reason: rec.descriptionHe))
                }
                if suggestions.count >= 3 { break }
            }
            if !suggestions.isEmpty {
                sections.append(PracticeSection(titleHe: "לפי הבדיקה של היום", suggestions: suggestions))
            }
        }

        // Section 2: Time Fit
        let targetSeconds = preferredMinutes * 60
        let timeSorted = ExerciseData.all
            .filter { !taken.contains($0.id) }
            .sorted { abs($0.durationSeconds - targetSeconds) < abs($1.durationSeconds - targetSeconds) }

        var timeSuggestions: [PracticeSuggestion] = []
        for exercise in timeSorted {
            if taken.contains(exercise.id) { continue }
            let reason: String
            if exercise.durationSeconds <= targetSeconds {
                reason = "נכנס/ת במסגרת של כ-\(preferredMinutes) דקות."
            } else {
                reason = "קצת מעל היעד שלך, אבל עדיין תרגול קצר ופרקטי."
            }
            taken.insert(exercise.id)
            timeSuggestions.append(PracticeSuggestion(exerciseId: exercise.id, reason: reason))
            if timeSuggestions.count >= 3 { break }
        }
        if !timeSuggestions.isEmpty {
            sections.append(PracticeSection(titleHe: "לפי הזמן שביקשת לעצמך", suggestions: timeSuggestions))
        }

        // Section 3: Helpful History OR Favorites
        let completed = recentPractices.filter { $0.completed }
        let helpfulSuggestions = buildHelpfulHistory(completed: completed, taken: &taken)

        if !helpfulSuggestions.isEmpty {
            sections.append(PracticeSection(titleHe: "מה שכבר עזר לך", suggestions: helpfulSuggestions))
        } else {
            let favSuggestions = favoriteIds
                .filter { !taken.contains($0) }
                .prefix(3)
                .map { PracticeSuggestion(exerciseId: $0, reason: "סימנת אותו מראש לשימוש חוזר.") }
            if !favSuggestions.isEmpty {
                sections.append(PracticeSection(titleHe: "המועדפים שלך", suggestions: favSuggestions))
            }
        }

        return sections
    }

    private static func buildHelpfulHistory(
        completed: [PracticeLog],
        taken: inout Set<ExerciseId>
    ) -> [PracticeSuggestion] {
        guard !completed.isEmpty else { return [] }

        struct ExerciseStats {
            var totalRating: Int = 0
            var count: Int = 0
            var lastDate: Date = .distantPast
            var avgRating: Double { count > 0 ? Double(totalRating) / Double(count) : 0 }
        }

        var stats: [ExerciseId: ExerciseStats] = [:]
        for log in completed {
            var s = stats[log.exerciseId] ?? ExerciseStats()
            s.totalRating += log.rating
            s.count += 1
            if log.date > s.lastDate { s.lastDate = log.date }
            stats[log.exerciseId] = s
        }

        let sorted = stats
            .filter { !taken.contains($0.key) }
            .sorted { a, b in
                if a.value.avgRating != b.value.avgRating { return a.value.avgRating > b.value.avgRating }
                if a.value.count != b.value.count { return a.value.count > b.value.count }
                return a.value.lastDate > b.value.lastDate
            }

        var suggestions: [PracticeSuggestion] = []
        for (exerciseId, _) in sorted.prefix(3) {
            taken.insert(exerciseId)
            suggestions.append(PracticeSuggestion(
                exerciseId: exerciseId,
                reason: "מבוסס על תרגולים שכבר סיימת ודירגת כחיוביים."
            ))
        }
        return suggestions
    }
}
