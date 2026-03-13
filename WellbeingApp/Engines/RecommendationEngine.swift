import Foundation

enum RecommendationEngine {
    /// Builds assessment-based recommendations. Returns max 5, sorted by priority.
    static func buildRecommendations(for assessment: Assessment) -> [Recommendation] {
        var recMap: [String: Recommendation] = [:]

        func add(_ rec: Recommendation) {
            if let existing = recMap[rec.id] {
                if rec.priority < existing.priority {
                    recMap[rec.id] = rec
                }
            } else {
                recMap[rec.id] = rec
            }
        }

        let answers = assessment.answers
        let total = assessment.totalScore

        // Critical overload (31-40) — highest precedence (negative priorities)
        if total >= 31 {
            add(rec("urgent-human-support", .humanSupport, "פנייה לתמיכה אנושית",
                     "כדאי לפנות כבר כעת למלווה רוחני או פסיכולוג/ית לבחירה", nil, -3, .navigate, "spiritual"))
            add(rec("urgent-pmr", .exercise, "הרפיית שרירים מתקדמת (PMR)",
                     "ויסות גופני מיידי יכול לעזור להוריד עוררות ולהכין לשיחה", .pmrFull, -2, .navigate, "practice"))
            add(rec("urgent-breathing", .exercise, "נשימת 4-6",
                     "מומלץ להתחיל עכשיו בנשימת 4-6 לכ-3 דקות", .breathing4_6, -1, .navigate, "practice"))
        }

        // Significant distress (21-30)
        if total >= 21 {
            add(rec("spiritual-first", .spiritualCare, "ליווי רוחני מומלץ כעת",
                     "שיחה קצרה יכולה לעזור בעיבוד עומס ומשמעות ולהחזיר יציבות", nil, 0, .navigate, "spiritual"))
            add(rec("body-regulation-score", .exercise, "הרפיית שרירים מתקדמת (PMR)",
                     "ויסות גופני יכול לעזור להוריד עוררות ולהכין לשיחה רגשית עמוקה יותר", .pmrFull, 1, .navigate, "practice"))
            add(rec("human-support", .humanSupport, "תמיכה אנושית לבחירה",
                     "ניתן לבחור מלווה רוחני, פסיכולוג/ית או איש קשר אישי", nil, 2, .navigate, "spiritual"))
        }

        // Emotional detachment (Q7, index 6)
        if answers.count > 6, answers[6] >= 3 {
            add(rec("values-reflection", .exercise, "חיבור לערכים במשמרת",
                     "תרגול עיבוד משמרת יכול להפחית ריחוק רגשי ולחזק משמעות", .shiftProcessing, 1, .navigate, "practice"))
            add(rec("spiritual-detachment", .spiritualCare, "שיחה עם מלווה רוחני",
                     "בליווי רוחני אפשר לעבד עומס רגשי ודילמות ערכיות", nil, 0, .navigate, "spiritual"))
        }

        // Low meaning (Q10, index 9) — raw answer
        if answers.count > 9, answers[9] <= 1 {
            add(rec("low-meaning-spiritual", .spiritualCare, "חיזוק משמעות דרך ליווי רוחני",
                     "שיחה ממוקדת ערכים ומשמעות יכולה לייצב ולתת כיוון", nil, 0, .navigate, "spiritual"))
        }

        // Self criticism (Q8, index 7)
        if answers.count > 7, answers[7] >= 3 {
            add(rec("self-compassion", .exercise, "מדיטציית חמלה עצמית",
                     "תרגול קצר של חמלה עצמית מפחית ביקורת פנימית", .selfCompassion, 1, .navigate, "practice"))
            add(rec("suggest-psych", .professionalHelp, "אפשרות לשיחה עם פסיכולוג/ית",
                     "אם הביקורת העצמית חוזרת, מומלץ לשקול שיחה מקצועית", nil, 2, .navigate, "spiritual"))
        }

        // Mental overload or recurring worries (Q1/Q2, indices 0/1)
        if answers.count > 1, answers[0] >= 3 || answers[1] >= 3 {
            add(rec("overload-breathing", .exercise, "נשימת 4-6",
                     "ל-3 דקות כדי להוריד דריכות מחשבתית", .breathing4_6, 1, .navigate, "practice"))
            add(rec("overload-mindfulness", .exercise, "מדיטציית מחשבות",
                     "התבוננות במחשבות עוזרת להפחית לופ של דאגות", .thoughtMindfulness, 2, .navigate, "practice"))
            add(rec("overload-grounding", .exercise, "קרקוע 5-4-3-2-1",
                     "מעביר קשב מהעומס אל הגוף והרגע הנוכחי", .grounding54321, 2, .navigate, "practice"))
        }

        // Body tension (Q4, index 3)
        if answers.count > 3, answers[3] >= 3 {
            add(rec("body-tension-stretch", .exercise, "שחרור עומס מהגוף",
                     "מתיחות מהירות לשחרור מתח שרירי שנצבר", .bodyStretchQuick, 1, .navigate, "practice"))
            add(rec("body-tension-pmr", .exercise, "הרפיית שרירים מתקדמת (PMR)",
                     "כיווץ-שחרור שרירים מסייע להוריד עומס גופני בצורה מעמיקה", .pmrFull, 2, .navigate, "practice"))
        }

        // Sleep difficulty (Q5, index 4)
        if answers.count > 4, answers[4] >= 3 {
            add(rec("sleep-breathing", .exercise, "נשימה 4-8 לפני שינה",
                     "נשיפה ארוכה תומכת בירידה בערנות לקראת שינה", .breathing4_8, 1, .navigate, "practice"))
        }

        // Low energy or loss of interest (Q3/Q6, indices 2/5)
        if answers.count > 5, answers[2] >= 3 || answers[5] >= 3 {
            add(rec("energy-morning-breathing", .exercise, "נשימה קצרה בבוקר",
                     "2-3 דקות נשימה יכולות לייצב פתיחת יום", .breathing4_6, 1, .navigate, "practice"))
            add(rec("energy-compassion", .exercise, "חמלה עצמית עדינה",
                     "תמיכה פנימית עוזרת כשיש עייפות ואובדן עניין", .selfCompassion, 2, .navigate, "practice"))
        }

        // Low support (Q9, index 8) — raw answer
        if answers.count > 8, answers[8] <= 1 {
            add(rec("low-support", .humanSupport, "לבחור תמיכה אנושית עכשיו",
                     "כשאין תחושת תמיכה זמינה, כדאי להפעיל קשר אנושי מיידי", nil, 0, .navigate, "spiritual"))
        }

        // No recommendations — maintenance fallback
        if recMap.isEmpty {
            add(rec("maintenance", .exercise, "תחזוקה יומית קלה",
                     "בחרו תרגול קצר אחד להמשך יציבות לאורך השבוע", nil, 2, .navigate, "practice"))
        }

        return Array(recMap.values
            .sorted { $0.priority < $1.priority }
            .prefix(5))
    }

    private static func rec(
        _ id: String, _ type: RecommendationType, _ title: String,
        _ description: String, _ exerciseId: ExerciseId?, _ priority: Int,
        _ actionType: ActionType, _ actionTarget: String
    ) -> Recommendation {
        Recommendation(
            id: id, type: type, titleHe: title, descriptionHe: description,
            exerciseId: exerciseId, priority: priority,
            actionType: actionType, actionTarget: actionTarget
        )
    }
}
