import Foundation

enum CheckinEngine {
    private static let moodExercises: [MoodOption: [ExerciseId]] = [
        .stable: [.shiftProcessing],
        .exhausted: [.breathing4_6, .bodyStretchQuick],
        .overwhelmed: [.grounding54321, .boxBreathing],
        .apathetic: [.selfCompassion],
        .needsBreak: [.pmrMini, .breathing4_8],
    ]

    private static let moodContacts: [MoodOption: String] = [
        .overwhelmed: "spiritual",
        .apathetic: "psychologist",
    ]

    private static let shiftExercises: [ShiftCharacteristic: [ExerciseId]] = [
        .emotionalLoad: [.breathing4_6, .thoughtMindfulness],
        .fatigue: [.pmrMini, .bodyStretchQuick],
        .familyConflict: [.grounding54321],
        .patientDeath: [.shiftProcessing, .selfCompassion],
        .senseOfMeaning: [.shiftProcessing],
    ]

    private static let shiftContacts: [ShiftCharacteristic: String] = [
        .emotionalLoad: "support_line",
        .familyConflict: "spiritual",
        .patientDeath: "spiritual",
    ]

    /// Builds recommendations based on daily check-in mood and shift characteristic.
    static func buildRecommendations(mood: MoodOption, shift: ShiftCharacteristic) -> [Recommendation] {
        var exercises: [ExerciseId] = []
        var contactRoles: [String] = []

        // Mood exercises
        for id in moodExercises[mood] ?? [] {
            if !exercises.contains(id) {
                exercises.append(id)
            }
        }

        // Shift exercises (deduplicated)
        for id in shiftExercises[shift] ?? [] {
            if !exercises.contains(id) {
                exercises.append(id)
            }
        }

        // Mood contacts
        if let role = moodContacts[mood] {
            contactRoles.append(role)
        }

        // Shift contacts (deduplicated)
        if let role = shiftContacts[shift], !contactRoles.contains(role) {
            contactRoles.append(role)
        }

        var recs: [Recommendation] = []
        var priority = 0

        // Exercise recommendations (max 3)
        for id in exercises.prefix(3) {
            let exercise = ExerciseData.find(id)
            recs.append(Recommendation(
                id: "checkin-\(id.rawValue)",
                type: .exercise,
                titleHe: exercise?.nameHe ?? id.rawValue,
                descriptionHe: exercise?.subtitleHe ?? "",
                exerciseId: id,
                priority: priority,
                actionType: .navigate,
                actionTarget: "practice"
            ))
            priority += 1
        }

        // Contact recommendations
        for role in contactRoles {
            let (title, description, type) = contactInfo(for: role)
            recs.append(Recommendation(
                id: "checkin-contact-\(role)",
                type: type,
                titleHe: title,
                descriptionHe: description,
                exerciseId: nil,
                priority: priority,
                actionType: .navigate,
                actionTarget: "spiritual"
            ))
            priority += 1
        }

        return recs
    }

    private static func contactInfo(for role: String) -> (String, String, RecommendationType) {
        switch role {
        case "spiritual":
            return ("בחירת מלווה רוחני",
                    "כניסה למסך התמיכה האנושית לבחירת איש קשר מתאים",
                    .spiritualCare)
        case "psychologist":
            return ("בחירת פסיכולוג/ית",
                    "מעבר לרשימת אנשי הקשר כדי לבחור תמיכה מקצועית",
                    .professionalHelp)
        case "support_line":
            return ("בחירת איש קשר תומך",
                    "מעבר לרשימת התמיכה האנושית כדי לבחור למי לפנות",
                    .spiritualCare)
        default:
            return ("תמיכה", "פנה לתמיכה", .humanSupport)
        }
    }
}
