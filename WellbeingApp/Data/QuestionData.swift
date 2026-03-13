import Foundation

enum QuestionData {
    static let questions: [QuestionDef] = [
        QuestionDef(
            index: 0,
            textHe: "עד כמה הרגשת עומס נפשי שמקשה עלייך ״לכבות את הראש״ אחרי משמרת?",
            isReverse: false,
            category: "mental_overload"
        ),
        QuestionDef(
            index: 1,
            textHe: "עד כמה היו לך דאגות חוזרות שקשה היה להרגיע גם אחרי שהנושא ״נסגר״?",
            isReverse: false,
            category: "recurring_worries"
        ),
        QuestionDef(
            index: 2,
            textHe: "עד כמה הרגשת ירידה באנרגיה או עייפות שלא חולפת גם אחרי מנוחה?",
            isReverse: false,
            category: "low_energy"
        ),
        QuestionDef(
            index: 3,
            textHe: "עד כמה הרגשת דריכות/מתח בגוף (למשל כתפיים, לסת, בטן) במהלך היום?",
            isReverse: false,
            category: "body_tension"
        ),
        QuestionDef(
            index: 4,
            textHe: "עד כמה היה לך קושי להירדם או שהתעוררת עם מחשבות מטרידות?",
            isReverse: false,
            category: "sleep_difficulty"
        ),
        QuestionDef(
            index: 5,
            textHe: "עד כמה הרגשת אובדן הנאה/עניין בדברים שבדרך כלל כן נותנים לך כוח?",
            isReverse: false,
            category: "loss_of_interest"
        ),
        QuestionDef(
            index: 6,
            textHe: "עד כמה הרגשת ריחוק רגשי או ״אוטומט״ בזמן עבודה עם אנשים?",
            isReverse: false,
            category: "emotional_detachment"
        ),
        QuestionDef(
            index: 7,
            textHe: "עד כמה חווית רגשות אשמה/ביקורת עצמית סביב התפקוד שלך?",
            isReverse: false,
            category: "self_criticism"
        ),
        QuestionDef(
            index: 8,
            textHe: "עד כמה הרגשת שיש לך תמיכה זמינה מאדם/צוות כשאת/ה צריך/ה?",
            isReverse: true,
            category: "low_support"
        ),
        QuestionDef(
            index: 9,
            textHe: "עד כמה הרגשת תחושת משמעות/ערך במה שאת/ה עושה?",
            isReverse: true,
            category: "low_meaning"
        ),
    ]
}
