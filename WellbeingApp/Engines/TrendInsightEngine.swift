import Foundation

struct TrendInsight: Equatable {
    let titleHe: String
    let bodyHe: String
}

enum TrendInsightEngine {
    /// Score comparison insight between latest two assessments.
    static func scoreInsight(assessments: [Assessment]) -> TrendInsight {
        guard let latest = assessments.first else {
            return TrendInsight(
                titleHe: "עדיין אין מגמת שבועות",
                bodyHe: "אחרי שני שאלונים לפחות תופיע כאן תמונת שינוי קצרה וברורה."
            )
        }

        guard assessments.count >= 2 else {
            return TrendInsight(
                titleHe: "זהו בסיס ההשוואה הראשון שלך: \(latest.totalScore) נק׳",
                bodyHe: "בשאלון הבא יהיה קל יותר לראות אם יש תנועה למעלה או למטה."
            )
        }

        let previous = assessments[1]
        let delta = latest.totalScore - previous.totalScore

        if delta < 0 {
            return TrendInsight(
                titleHe: "ירידה של \(abs(delta)) נק׳ לעומת השבוע הקודם",
                bodyHe: "זו אינדיקציה חיובית יחסית. שווה לשמר את מה שעזר לך גם השבוע."
            )
        } else if delta > 0 {
            return TrendInsight(
                titleHe: "עלייה של \(delta) נק׳ לעומת השבוע הקודם",
                bodyHe: "כדאי לבחור פעולה קצרה אחת לייצוב ולשים לב אם העומס נמשך."
            )
        } else {
            return TrendInsight(
                titleHe: "ללא שינוי משמעותי לעומת השבוע הקודם",
                bodyHe: "כשהציון יציב, המיקוד עובר לשמירה על רצף ולזיהוי מוקדם של החמרה."
            )
        }
    }

    /// Focus area insight from recurring flags across recent assessments.
    static func focusInsight(assessments: [Assessment]) -> TrendInsight {
        let recent = Array(assessments.prefix(4))
        var categoryCounts: [String: Int] = [:]

        for assessment in recent {
            for flag in assessment.flags {
                categoryCounts[flag.category, default: 0] += 1
            }
        }

        guard let topCategory = categoryCounts.max(by: { $0.value < $1.value })?.key else {
            return TrendInsight(
                titleHe: "עדיין אין דפוס בולט מהשאלונים",
                bodyHe: "אחרי עוד שבוע-שבועיים של שימוש יתחילו להופיע כאן דפוסים חוזרים."
            )
        }

        let label = AppConstants.categoryLabelsHe[topCategory] ?? topCategory

        return TrendInsight(
            titleHe: "הנושא שחזר הכי הרבה: \(label)",
            bodyHe: "זהו האזור שכדאי להתייחס אליו קודם בתרגול או בשיחה עם אדם תומך."
        )
    }

    /// Routine consistency insight from last 7 days of activity.
    static func routineInsight(
        practices: [PracticeLog],
        checkins: [DailyCheckin]
    ) -> TrendInsight {
        let weekAgo = DateFormatting.daysAgo(7)
        let recentPractices = practices.filter { $0.date >= weekAgo }
        let recentCheckins = checkins.filter { $0.date >= weekAgo }

        guard !recentPractices.isEmpty || !recentCheckins.isEmpty else {
            return TrendInsight(
                titleHe: "עדיין אין מספיק שימוש יומי",
                bodyHe: "כדי לזהות מה עובד, שווה לתרגל או למלא בדיקה קצרה כמה פעמים במהלך השבוע."
            )
        }

        let title = "השבוע נשמרו \(recentPractices.count) תרגולים ו-\(recentCheckins.count) בדיקות יומיות"

        if let dominantMood = findDominantMood(in: recentCheckins) {
            let moodLabel = AppConstants.moodLabelsHe[dominantMood] ?? dominantMood.rawValue
            return TrendInsight(
                titleHe: title,
                bodyHe: "המצב שחזר הכי הרבה היה \(moodLabel). זה רמז טוב לבחירת התרגול הבא."
            )
        }

        return TrendInsight(
            titleHe: title,
            bodyHe: "גם מעט שמירות יוצרות בסיס טוב יותר להמלצות אישיות ולזיהוי דפוסים."
        )
    }

    private static func findDominantMood(in checkins: [DailyCheckin]) -> MoodOption? {
        guard !checkins.isEmpty else { return nil }
        var moodCounts: [MoodOption: Int] = [:]
        for checkin in checkins {
            moodCounts[checkin.mood, default: 0] += 1
        }
        return moodCounts.max(by: { $0.value < $1.value })?.key
    }
}
