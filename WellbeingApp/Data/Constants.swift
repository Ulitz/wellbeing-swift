import Foundation

enum AppConstants {
    static let appName = "מדד רווחה ותפקוד"
    static let appShortName = "מדד רווחה"

    static let disclaimerText = "כלי זה מיועד לניטור עצמי בלבד ואינו מהווה כלי אבחוני או תחליף לטיפול רפואי/נפשי. במצב של מצוקה משמעותית או החמרה יש לפנות לגורם מקצועי."

    static let welcomeText = "מרחב אישי לניטור רווחה ותרגול ויסות קצר לאורך השבוע. כל הנתונים נשמרים במכשיר שלך בלבד."

    static let spiritualCareIntro = "ליווי רוחני הוא מרחב שיח מקצועי, דיסקרטי ולא שיפוטי לעיבוד עומס, שחיקה ושאלות של משמעות בעבודה."

    static let spiritualCareSubtitle = "הפנייה לליווי רוחני זמינה גם בלי משבר חריף, כעוגן תמיכתי מתמשך לאורך התקופה."

    static let timeWindowPrompt = "ב-7 הימים האחרונים..."

    static let daysHe = ["ראשון", "שני", "שלישי", "רביעי", "חמישי", "שישי", "שבת"]

    static let tabLabels: [String: String] = [
        "home": "בית",
        "practice": "תרגול",
        "spiritual": "ליווי רוחני",
        "trends": "מגמות",
        "settings": "הגדרות",
    ]

    static let scaleLabels = ["בכלל לא", "מעט", "לפעמים", "הרבה", "כמעט תמיד"]

    static let levelLabelsHe: [ScoreLevel: String] = [
        .green: "מצב יציב",
        .yellow: "עומס מתגבר",
        .orange: "מצוקה משמעותית",
        .red: "עומס גבוה מאוד",
    ]

    static let levelDescriptionsHe: [ScoreLevel: String] = [
        .green: "מומלץ להמשיך בתחזוקה קלה ובמעקב שוטף.",
        .yellow: "מומלץ תרגול יומי קצר ובדיקה חוזרת בקרוב.",
        .orange: "מומלץ תרגול יומי ופנייה לתמיכה אנושית לבחירה.",
        .red: "מומלץ תרגול מיידי ופנייה לתמיכה בהקדם.",
    ]

    static let categoryLabelsHe: [String: String] = [
        "mental_overload": "עומס נפשי",
        "recurring_worries": "דאגות חוזרות",
        "low_energy": "ירידת אנרגיה",
        "body_tension": "מתח גופני",
        "sleep_difficulty": "קשיי שינה",
        "loss_of_interest": "אובדן עניין",
        "emotional_detachment": "ריחוק רגשי",
        "self_criticism": "ביקורת עצמית",
        "low_support": "תמיכה נמוכה",
        "low_meaning": "משמעות נמוכה",
    ]

    static let moodLabelsHe: [MoodOption: String] = [
        .stable: "יציב/ה",
        .exhausted: "מותש/ת",
        .overwhelmed: "מוצף/ת",
        .apathetic: "אדיש/ה",
        .needsBreak: "צריך/ה הפסקה",
    ]

    static let moodIcons: [MoodOption: String] = [
        .stable: "face.smiling",
        .exhausted: "battery.25",
        .overwhelmed: "water.waves",
        .apathetic: "face.dashed",
        .needsBreak: "cup.and.saucer",
    ]

    static let shiftLabelsHe: [ShiftCharacteristic: String] = [
        .emotionalLoad: "עומס רגשי",
        .fatigue: "עייפות",
        .familyConflict: "קונפליקט עם משפחה",
        .patientDeath: "מות מטופל",
        .senseOfMeaning: "תחושת משמעות",
    ]

    static let shiftIcons: [ShiftCharacteristic: String] = [
        .emotionalLoad: "heart.fill",
        .fatigue: "moon.fill",
        .familyConflict: "person.2.fill",
        .patientDeath: "cloud.rain.fill",
        .senseOfMeaning: "sparkles",
    ]

    static let meaningLabelsHe: [MeaningOption: String] = [
        .patientSmile: "חיוך של מטופל",
        .goodFamilyTalk: "שיחה טובה עם משפחה",
        .professionalism: "רגע של מקצועיות",
        .noMoment: "לא היה רגע כזה",
    ]

    static let meaningIcons: [MeaningOption: String] = [
        .patientSmile: "face.smiling",
        .goodFamilyTalk: "bubble.left.and.bubble.right",
        .professionalism: "star.fill",
        .noMoment: "minus.circle",
    ]
}
