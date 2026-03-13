import Foundation

enum ExerciseData {
    static let all: [Exercise] = [
        Exercise(
            id: .breathing4_6, nameHe: "נשימת 4-6", subtitleHe: "איזון מהיר",
            durationSeconds: 180, category: .breathing,
            steps: [
                ExerciseStep(instruction: "שאיפה דרך האף ל-4 שניות", durationSeconds: 4, animation: .inhale, responseMode: nil),
                ExerciseStep(instruction: "נשיפה איטית ל-6 שניות", durationSeconds: 6, animation: .exhale, responseMode: nil),
            ],
            icon: "wind"
        ),
        Exercise(
            id: .boxBreathing, nameHe: "נשימת קופסה", subtitleHe: "ייצוב מיידי",
            durationSeconds: 120, category: .breathing,
            steps: [
                ExerciseStep(instruction: "שאיפה 4", durationSeconds: 4, animation: .inhale, responseMode: nil),
                ExerciseStep(instruction: "החזקה 4", durationSeconds: 4, animation: .hold, responseMode: nil),
                ExerciseStep(instruction: "נשיפה 4", durationSeconds: 4, animation: .exhale, responseMode: nil),
                ExerciseStep(instruction: "החזקה 4", durationSeconds: 4, animation: .hold, responseMode: nil),
            ],
            icon: "square.dashed"
        ),
        Exercise(
            id: .breathing4_8, nameHe: "נשימה 4-8", subtitleHe: "לפני שינה",
            durationSeconds: 259, category: .breathing,
            steps: [
                ExerciseStep(instruction: "שאיפה 4", durationSeconds: 4, animation: .inhale, responseMode: nil),
                ExerciseStep(instruction: "נשיפה 8", durationSeconds: 8, animation: .exhale, responseMode: nil),
            ],
            icon: "moon.stars"
        ),
        Exercise(
            id: .grounding54321, nameHe: "קרקוע 5-4-3-2-1", subtitleHe: "כשמוצף",
            durationSeconds: 150, category: .grounding,
            steps: [
                ExerciseStep(instruction: "מצאו 5 דברים שאתם רואים", durationSeconds: 30, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "4 דברים שאתם מרגישים במגע", durationSeconds: 30, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "3 קולות שאתם שומעים", durationSeconds: 30, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "2 ריחות בסביבה", durationSeconds: 30, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "1 טעם או תחושה בפה", durationSeconds: 30, animation: .idle, responseMode: nil),
            ],
            icon: "anchor"
        ),
        Exercise(
            id: .pmrShort, nameHe: "הרפיית שרירים PMR", subtitleHe: "שחרור גוף",
            durationSeconds: 360, category: .body,
            steps: [
                ExerciseStep(instruction: "כווצו ושחררו כפות ידיים", durationSeconds: 60, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "כווצו ושחררו כתפיים", durationSeconds: 60, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "כווצו ושחררו לסת ופנים", durationSeconds: 60, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "כווצו ושחררו בטן וגב", durationSeconds: 60, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "כווצו ושחררו רגליים", durationSeconds: 60, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "נשימה עמוקה והרפיה מלאה", durationSeconds: 60, animation: .exhale, responseMode: nil),
            ],
            icon: "waveform.path.ecg"
        ),
        Exercise(
            id: .bodyStretchQuick, nameHe: "שחרור עומס מהגוף", subtitleHe: "מתיחות שחרור מהיר",
            durationSeconds: 240, category: .body,
            steps: [
                ExerciseStep(instruction: "עמדו או שבו זקוף. קחו נשימה עמוקה אחת.", durationSeconds: 20, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "הרימו כתפיים לכיוון האוזניים — החזיקו 5 שניות — שחררו לאט.", durationSeconds: 30, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "סובבו כתפיים לאחור 5 פעמים באיטיות.", durationSeconds: 25, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "שלבו אצבעות, מתחו ידיים קדימה והאריכו את הגב העליון.", durationSeconds: 25, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "הטו ראש בעדינות לצד ימין — החזיקו 5 שניות — חזרו למרכז — צד שמאל.", durationSeconds: 30, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "נשמו עמוק. הרגישו את ההבדל בין מתח להרפיה.", durationSeconds: 30, animation: .exhale, responseMode: nil),
            ],
            icon: "figure.stand"
        ),
        Exercise(
            id: .pmrFull, nameHe: "הרפיית שרירים מתקדמת", subtitleHe: "PMR — שיטת ג׳קובסון",
            durationSeconds: 420, category: .body,
            steps: [
                ExerciseStep(instruction: "שכבו או שבו בנוחות. סגרו עיניים ונשמו עמוק.", durationSeconds: 30, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "כווצו כפות ידיים ל-5 שניות… שחררו. הרגישו את ההרפיה.", durationSeconds: 60, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "כווצו זרועות ל-5 שניות… שחררו.", durationSeconds: 60, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "כווצו כתפיים — הרימו אותן לאוזניים ל-5 שניות… שחררו.", durationSeconds: 60, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "לחצו שיניים ל-5 שניות… שחררו לסת לחלוטין.", durationSeconds: 60, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "כווצו שרירי בטן ל-5 שניות… שחררו.", durationSeconds: 60, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "כווצו ירכיים ל-5 שניות… שחררו. נשמו עמוק.", durationSeconds: 60, animation: .exhale, responseMode: nil),
                ExerciseStep(instruction: "שימו לב להבדל בין מתח להרפיה בכל הגוף.", durationSeconds: 30, animation: .idle, responseMode: nil),
            ],
            icon: "waveform.path.ecg"
        ),
        Exercise(
            id: .pmrMini, nameHe: "איפוס מהיר", subtitleHe: "מיני-ג׳קובסון בין מטופלים",
            durationSeconds: 120, category: .body,
            steps: [
                ExerciseStep(instruction: "כווצו כתפיים ל-3 שניות… שחררו לגמרי.", durationSeconds: 30, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "כווצו כפות ידיים… שחררו.", durationSeconds: 30, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "נשיפה ארוכה ואיטית.", durationSeconds: 30, animation: .exhale, responseMode: nil),
                ExerciseStep(instruction: "חזרו למשימה הבאה רגועים יותר.", durationSeconds: 30, animation: .idle, responseMode: nil),
            ],
            icon: "bolt.fill"
        ),
        Exercise(
            id: .thoughtMindfulness, nameHe: "מדיטציית מחשבות", subtitleHe: "התבוננות עדינה",
            durationSeconds: 300, category: .meditation,
            steps: [
                ExerciseStep(instruction: "שבו בנוחות והפנו קשב לנשימה", durationSeconds: 60, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "כשמופיעה מחשבה: ״יש מחשבה ש...״", durationSeconds: 120, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "חזרו בעדינות לנשימה", durationSeconds: 120, animation: .idle, responseMode: nil),
            ],
            icon: "cloud"
        ),
        Exercise(
            id: .selfCompassion, nameHe: "מדיטציית חמלה עצמית", subtitleHe: "רכות פנימית",
            durationSeconds: 300, category: .meditation,
            steps: [
                ExerciseStep(instruction: "״זה רגע של קושי״", durationSeconds: 100, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "״קושי הוא חלק מהאנושיות״", durationSeconds: 100, animation: .idle, responseMode: nil),
                ExerciseStep(instruction: "״מי ייתן ואהיה עדינ/ה עם עצמי״", durationSeconds: 100, animation: .idle, responseMode: nil),
            ],
            icon: "heart.circle"
        ),
        Exercise(
            id: .shiftProcessing, nameHe: "עיבוד משמרת", subtitleHe: "חיבור למשמעות",
            durationSeconds: 180, category: .meditation,
            steps: [
                ExerciseStep(instruction: "מה היה קשה במיוחד במשמרת?", durationSeconds: 60, animation: nil, responseMode: "text"),
                ExerciseStep(instruction: "מה נתן לי כוח למרות הקושי?", durationSeconds: 60, animation: nil, responseMode: "text"),
                ExerciseStep(instruction: "מה חשוב לי לקחת איתי להמשך? ניתן לפנות גם לליווי רוחני.", durationSeconds: 60, animation: nil, responseMode: "text"),
            ],
            icon: "sparkles"
        ),
    ]

    static func find(_ id: ExerciseId) -> Exercise? {
        all.first { $0.id == id }
    }
}
