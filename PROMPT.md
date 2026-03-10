# Wellbeing App - Native Swift/SwiftUI Rewrite

## Project Overview

Build a **native iOS app in Swift/SwiftUI** that is a faithful, high-quality rewrite of an existing Next.js/React wellbeing web app designed for medical teams (nurses, doctors, caregivers). The app is a **clinical-grade, privacy-first** self-monitoring tool for burnout, stress, and emotional wellbeing.

**Key principles:**
- Zero cloud/backend — all data stays on-device (UserDefaults / SwiftData)
- Hebrew RTL as primary language (Arabic + Russian text support)
- Evidence-based: 10-question validated assessment, 11 guided exercises, personalized recommendations
- Privacy-by-design: no analytics, no tracking, no data leaves the device
- Mobile-first with premium design quality (glass-morphism, animations, haptics)

---

## Sub-Agent Strategy

**IMPORTANT: Use Claude Code sub-agents extensively throughout this project.** The following agent assignments should be used:

### Agent Assignments

| Agent | Responsibility |
|-------|---------------|
| **everything-claude-code:planner** | Before ANY implementation phase, create a detailed plan. Use at project start and before each major feature. |
| **everything-claude-code:architect** | Design the overall architecture: module boundaries, data flow, dependency graph. Run before writing any code. |
| **everything-claude-code:tdd-guide** | Enforce test-driven development. Write tests FIRST for every model, view model, engine, and view. Target 80%+ coverage. |
| **everything-claude-code:e2e-runner** | After each screen/flow is complete, generate and run E2E UI tests using XCUITest. |
| **everything-claude-code:code-reviewer** | After EVERY file is written or modified, run the code reviewer. No exceptions. |
| **everything-claude-code:security-reviewer** | Run after implementing storage, contacts (phone numbers), notification permissions, and any user input handling. |
| **everything-claude-code:frontend-patterns** | Consult for SwiftUI best practices, state management patterns, animation techniques. |
| **everything-claude-code:build-error-resolver** | When builds fail or type errors occur, use this agent to resolve quickly with minimal diffs. |
| **everything-claude-code:refactor-cleaner** | After each major phase, run dead code analysis and consolidation. |
| **everything-claude-code:doc-updater** | Update documentation and codemaps after each phase completion. |
| **frontend-design:frontend-design** | Consult for UI/UX design decisions, color palettes, spacing, typography, and ensuring premium visual quality. |

### Parallel Agent Execution

Launch agents in parallel wherever possible:
- **Planning phase:** Run `planner` + `architect` concurrently
- **Implementation phase:** Run `tdd-guide` (write tests) while `frontend-design` reviews design specs
- **Post-implementation:** Run `code-reviewer` + `security-reviewer` + `build-error-resolver` concurrently
- **Phase completion:** Run `refactor-cleaner` + `doc-updater` concurrently

---

## Implementation Phases

### Phase 1: Project Setup & Architecture

1. Create Xcode project with SwiftUI App lifecycle
2. Configure for iOS 17+ minimum deployment target
3. Set up folder structure:

```
WellbeingApp/
├── App/
│   ├── WellbeingApp.swift          # @main entry point
│   └── AppState.swift              # Global app state
├── Models/
│   ├── Assessment.swift
│   ├── DailyCheckin.swift
│   ├── Exercise.swift
│   ├── PracticeLog.swift
│   ├── MeaningMoment.swift
│   ├── Settings.swift
│   ├── SpiritualContact.swift
│   ├── Recommendation.swift
│   └── Enums/
│       ├── ScoreLevel.swift
│       ├── MoodOption.swift
│       ├── ShiftCharacteristic.swift
│       ├── MeaningOption.swift
│       ├── ExerciseCategory.swift
│       └── ExerciseId.swift
├── Storage/
│   ├── StorageManager.swift        # UserDefaults + SwiftData abstraction
│   ├── AssessmentStore.swift
│   ├── CheckinStore.swift
│   ├── PracticeStore.swift
│   ├── SettingsStore.swift
│   ├── MeaningStore.swift
│   └── FavoritesStore.swift
├── Engines/
│   ├── ScoringEngine.swift         # Assessment scoring + normalization
│   ├── FlagDetector.swift          # Risk flag detection
│   ├── RecommendationEngine.swift  # Assessment-based recommendations
│   ├── CheckinEngine.swift         # Mood/shift-based recommendations
│   ├── PersonalizationEngine.swift # Practice suggestions
│   ├── TrendInsightEngine.swift    # 8-week trend analysis
│   └── SpiritualTextSelector.swift # Contextual guidance text selection
├── Views/
│   ├── Launch/
│   │   ├── SplashView.swift
│   │   ├── WelcomeView.swift
│   │   └── OnboardingView.swift
│   ├── TabBar/
│   │   ├── MainTabView.swift
│   │   └── CustomTabBar.swift
│   ├── Home/
│   │   ├── HomeView.swift
│   │   ├── DailyCheckinCard.swift
│   │   ├── TailoredResponseCard.swift
│   │   ├── AssessmentStatusCard.swift
│   │   ├── WeeklySummaryCard.swift
│   │   └── StateGraphic.swift
│   ├── Checkin/
│   │   ├── DailyCheckinModal.swift
│   │   ├── MoodSelectionStep.swift
│   │   ├── ShiftSelectionStep.swift
│   │   └── CheckinOptionButton.swift
│   ├── Questionnaire/
│   │   ├── QuestionnaireView.swift
│   │   ├── QuestionCard.swift
│   │   ├── LikertSlider.swift
│   │   └── ProgressBar.swift
│   ├── Results/
│   │   ├── ResultsView.swift
│   │   ├── ScoreBanner.swift
│   │   ├── RecommendationList.swift
│   │   └── FlagsList.swift
│   ├── Practice/
│   │   ├── PracticeLibraryView.swift
│   │   ├── PracticeCard.swift
│   │   ├── PracticePlayerView.swift
│   │   ├── BreathingCircle.swift
│   │   ├── TimerDisplay.swift
│   │   ├── GuidanceView.swift
│   │   ├── AudioPlayerView.swift
│   │   ├── PostExerciseRating.swift
│   │   └── SnapFeedView.swift
│   ├── Spiritual/
│   │   ├── SpiritualCareView.swift
│   │   ├── ContactListView.swift
│   │   ├── AddContactForm.swift
│   │   └── SpiritualTextCard.swift
│   ├── Trends/
│   │   ├── TrendsView.swift
│   │   ├── TrendChartView.swift
│   │   └── InsightCards.swift
│   ├── Settings/
│   │   ├── SettingsView.swift
│   │   └── DataManagementView.swift
│   └── Meaning/
│       ├── MeaningMomentCard.swift
│       └── MeaningMomentModal.swift
├── Components/
│   ├── GlassCard.swift             # Glass-morphism card
│   ├── PrimaryButton.swift         # Animated button
│   ├── Badge.swift                 # Category/duration tag
│   ├── SegmentedControl.swift      # Tab switcher
│   ├── ScrollHints.swift           # Scroll indicators
│   └── PageTransition.swift        # View transition wrapper
├── Theme/
│   ├── DesignTokens.swift          # All color/spacing/shadow tokens
│   ├── Typography.swift            # Font definitions (Heebo)
│   └── ColorScheme+Extensions.swift
├── Utilities/
│   ├── DateFormatting.swift
│   ├── HapticManager.swift
│   └── NotificationManager.swift
├── Data/
│   ├── ExerciseData.swift          # 11 exercise definitions
│   ├── QuestionData.swift          # 10 assessment questions
│   ├── SpiritualTextData.swift     # Multi-language guidance texts
│   ├── DefaultContacts.swift       # Pre-loaded contacts
│   └── Constants.swift             # App-wide string constants
├── Resources/
│   ├── Assets.xcassets/
│   ├── Audio/                      # Guided exercise audio files
│   └── Localizable.strings         # (future) localization
└── Tests/
    ├── UnitTests/
    │   ├── ScoringEngineTests.swift
    │   ├── FlagDetectorTests.swift
    │   ├── RecommendationEngineTests.swift
    │   ├── CheckinEngineTests.swift
    │   ├── PersonalizationEngineTests.swift
    │   ├── TrendInsightEngineTests.swift
    │   ├── StorageManagerTests.swift
    │   └── ModelTests.swift
    ├── IntegrationTests/
    │   ├── AssessmentFlowTests.swift
    │   ├── CheckinFlowTests.swift
    │   └── PracticeFlowTests.swift
    └── UITests/
        ├── OnboardingUITests.swift
        ├── HomeUITests.swift
        ├── QuestionnaireUITests.swift
        ├── PracticePlayerUITests.swift
        └── SettingsUITests.swift
```

4. Set up SwiftData schema or UserDefaults-based persistence
5. Configure RTL support (Hebrew as primary)

---

### Phase 2: Data Models & Storage

Port all TypeScript types to Swift. Use `Codable` structs/enums.

#### Enums

```swift
enum ScoreLevel: String, Codable, CaseIterable {
    case green, yellow, orange, red
}

enum MoodOption: String, Codable, CaseIterable {
    case stable, exhausted, overwhelmed, apathetic, needs_break
}

enum ShiftCharacteristic: String, Codable, CaseIterable {
    case emotional_load, fatigue, family_conflict, patient_death, sense_of_meaning
}

enum MeaningOption: String, Codable, CaseIterable {
    case patient_smile, good_family_talk, professionalism, no_moment
}

enum ExerciseCategory: String, Codable, CaseIterable {
    case breathing, meditation, body, grounding
}

enum ExerciseId: String, Codable, CaseIterable {
    case breathing_4_6 = "breathing-4-6"
    case box_breathing = "box-breathing"
    case breathing_4_8 = "breathing-4-8"
    case grounding_5_4_3_2_1 = "grounding-5-4-3-2-1"
    case pmr_short = "pmr-short"
    case pmr_full = "pmr-full"
    case body_stretch_quick = "body-stretch-quick"
    case pmr_mini = "pmr-mini"
    case thought_mindfulness = "thought-mindfulness"
    case self_compassion = "self-compassion"
    case shift_processing = "shift-processing"
}

enum StepAnimation: String, Codable {
    case inhale, exhale, hold, none
}

enum AppLanguage: String, Codable, CaseIterable {
    case he, ar, ru
}
```

#### Models

```swift
struct Assessment: Codable, Identifiable {
    let id: String // UUID
    let date: Date
    let answers: [Int]           // raw 0-4 per question
    let adjustedAnswers: [Int]   // reverse-scored for Q9-10
    let totalScore: Int          // 0-40
    let level: ScoreLevel
    let flags: [Flag]
}

struct Flag: Codable {
    let questionIndex: Int
    let questionKey: String
    let category: String
    let score: Int
}

struct DailyCheckin: Codable, Identifiable {
    let id: String
    let date: Date
    let mood: MoodOption
    let shiftCharacteristic: ShiftCharacteristic
}

struct MeaningMoment: Codable, Identifiable {
    let id: String
    let date: Date
    let selection: MeaningOption
}

struct PracticeLog: Codable, Identifiable {
    let id: String
    let date: Date
    let exerciseId: ExerciseId
    let durationSeconds: Int
    let completed: Bool
    let rating: Int // 1-5
    let textResponses: [ExerciseTextResponse]?
}

struct ExerciseTextResponse: Codable {
    let prompt: String
    let response: String
}

struct SpiritualContact: Codable, Identifiable {
    let id: String
    var name: String
    var role: String
    var phone: String
    let isDefault: Bool
}

struct Settings: Codable {
    var onboarded: Bool = false
    var reminderDay: Int = 0        // 0=Sunday
    var reminderTime: String = "18:00"
    var dailyPracticeMinutes: Int = 5
    var spiritualContacts: [SpiritualContact] = []
    var biweeklyReminderEnabled: Bool = true
    var lastReminderDate: Date? = nil
    var language: AppLanguage = .he
    var audioLanguage: AppLanguage = .he
    var audioLanguageByExercise: [ExerciseId: AppLanguage] = [:]
    var darkMode: Bool = true
}

struct ExerciseStep: Codable {
    let instruction: String
    let durationSeconds: Int
    let animation: StepAnimation?
    let responseMode: String?   // "text" for reflective exercises
}

struct Exercise: Codable, Identifiable {
    let id: ExerciseId
    let nameHe: String
    let subtitleHe: String
    let durationSeconds: Int
    let category: ExerciseCategory
    let steps: [ExerciseStep]
    let icon: String            // SF Symbol name (mapped from Lucide)
}

struct Recommendation: Codable, Identifiable {
    let id: String
    let type: RecommendationType
    let titleHe: String
    let descriptionHe: String
    let exerciseId: ExerciseId?
    let priority: Int
    let actionType: ActionType
    let actionTarget: String
}

enum RecommendationType: String, Codable {
    case exercise, spiritual_care, professional_help, human_support
}

enum ActionType: String, Codable {
    case navigate, call, external
}

struct QuestionDef: Codable {
    let index: Int
    let textHe: String
    let isReverse: Bool
    let category: String
}
```

---

### Phase 3: Business Logic Engines

#### 3.1 Scoring Engine

```
Input:  rawAnswers: [Int] (10 values, 0-4 each)
Output: Assessment with totalScore, level, flags

Rules:
- Q9 (index 8) and Q10 (index 9) are REVERSE scored: adjustedScore = 4 - rawAnswer
- All other questions: adjustedScore = rawAnswer
- totalScore = sum of all adjustedAnswers
- Level thresholds:
    0-10  → green  ("מצב יציב" / Stable)
    11-20 → yellow ("עומס מתגבר" / Rising stress)
    21-30 → orange ("מצוקה משמעותית" / Significant distress)
    31-40 → red    ("עומס גבוה מאוד" / Critical overload)
```

#### 3.2 Flag Detection

```
For each question:
- Reverse questions (index 8, 9): flag if rawAnswer <= 1
- Normal questions: flag if adjustedScore >= 3
Each flag records: questionIndex, questionKey ("Q1"-"Q10"), category, score
```

#### 3.3 Assessment Recommendation Engine

Priority-based rules (lower number = higher priority):

| Condition | Recommendations (id, title, priority, type, exerciseId) |
|-----------|--------------------------------------------------------|
| totalScore >= 31 | "urgent-human-support" (P0, human_support) + "urgent-pmr" (P1, exercise, pmr-full) + "urgent-breathing" (P2, exercise, breathing-4-6) |
| totalScore >= 21 | "spiritual-first" (P0, spiritual_care) + "body-regulation-score" (P1, exercise, pmr-full) + "human-support" (P2, human_support) |
| Q7 (answers[6]) >= 3 | "values-reflection" (P1, exercise, shift-processing) + "spiritual-detachment" (P0, spiritual_care) |
| Q10 (answers[9]) <= 1 | "low-meaning-spiritual" (P0, spiritual_care) |
| Q8 (answers[7]) >= 3 | "self-compassion" (P1, exercise, self-compassion) + "suggest-psych" (P2, professional_help) |
| Q1/Q2 (answers[0]/[1]) >= 3 | "overload-breathing" (P1, breathing-4-6) + "overload-mindfulness" (P2, thought-mindfulness) + "overload-grounding" (P2, grounding-5-4-3-2-1) |
| Q4 (answers[3]) >= 3 | "body-tension-stretch" (P1, body-stretch-quick) + "body-tension-pmr" (P2, pmr-full) |
| Q5 (answers[4]) >= 3 | "sleep-breathing" (P1, breathing-4-8) |
| Q3/Q6 (answers[2]/[5]) >= 3 | "energy-morning-breathing" (P1, breathing-4-6) + "energy-compassion" (P2, self-compassion) |
| Q9 (answers[8]) <= 1 | "low-support" (P0, human_support) |
| No recommendations | "maintenance" (P2, exercise, general practice) |

Deduplication: if same ID appears multiple times, keep lowest priority number. Return sorted by priority, max 5.

#### 3.4 Daily Check-in Engine

Mood-based exercise mapping:
```
stable      → [shift-processing]
exhausted   → [breathing-4-6, body-stretch-quick]
overwhelmed → [grounding-5-4-3-2-1, box-breathing] + spiritual contact
apathetic   → [self-compassion] + psychologist contact
needs_break → [pmr-mini, breathing-4-8]
```

Shift-based exercise mapping:
```
emotional_load   → [breathing-4-6, thought-mindfulness] + support_line
fatigue          → [pmr-mini, body-stretch-quick]
family_conflict  → [grounding-5-4-3-2-1] + spiritual contact
patient_death    → [shift-processing, self-compassion] + spiritual contact
sense_of_meaning → [shift-processing]
```

Combine mood + shift exercises (deduplicated), cap at 3 exercises + contact recommendations.

#### 3.5 Practice Personalization Engine

Build suggestion sections in order:
1. **Today's State** — from daily check-in recommendations (if check-in exists)
2. **Time Fit** — exercises closest to user's daily practice target (default 5 min)
3. **Helpful History** — top-rated exercises from last 21 completed practices (avg rating, then count, then recency)
4. **Favorites** — user-starred exercises (fallback if no helpful history)

Each section: max 3 suggestions, no duplicate exercises across sections.

#### 3.6 Trend Insight Engine

Given assessments (sorted newest first), practices, and check-ins:
- **Score comparison**: delta vs previous assessment (positive = worse, negative = better)
- **Focus area**: most frequently flagged category across last 4 assessments
- **Routine consistency**: count of practices + check-ins in last 7 days, dominant mood

---

### Phase 4: Static Data

#### 4.1 Exercises (11 total)

| ID | Name (He) | Subtitle | Duration | Category | Steps | Has Audio |
|----|-----------|----------|----------|----------|-------|-----------|
| breathing-4-6 | נשימת 4-6 | איזון מהיר | 180s | breathing | inhale 4s, exhale 6s | No |
| box-breathing | נשימת קופסה | ייצוב מיידי | 120s | breathing | inhale 4s, hold 4s, exhale 4s, hold 4s | No |
| breathing-4-8 | נשימה 4-8 | לפני שינה | 259s | breathing | inhale 4s, exhale 8s | Yes (He) |
| grounding-5-4-3-2-1 | קרקוע 5-4-3-2-1 | כשמוצף | 150s | grounding | 5 sights 30s, 4 touches 30s, 3 sounds 30s, 2 smells 30s, 1 taste 30s | No |
| pmr-short | הרפיית שרירים PMR | שחרור גוף | 360s | body | 6 body-part steps (hands, shoulders, jaw, belly, legs, deep breath) 60s each | No |
| body-stretch-quick | שחרור עומס מהגוף | מתיחות שחרור מהיר | 240s | body | 6 stretching steps 20-30s each | No |
| pmr-full | הרפיית שרירים מתקדמת | PMR — שיטת ג׳קובסון | 420s | body | 8 Jacobson technique steps 30-60s each | No |
| pmr-mini | איפוס מהיר | מיני-ג׳קובסון בין מטופלים | 120s | body | 4 quick reset steps 30s each | No |
| thought-mindfulness | מדיטציית מחשבות | התבוננות עדינה | 300s | meditation | 3 steps: breath focus 60s, thought observation 120s, return to breath 120s | No |
| self-compassion | מדיטציית חמלה עצמית | רכות פנימית | 300s | meditation | 3 phrases 100s each | No |
| shift-processing | עיבוד משמרת | חיבור למשמעות | 180s | meditation | 3 reflective text prompts 60s each (responseMode: text) | No |

**Full exercise step data** — see `ExerciseData.swift` in Phase 2. Copy ALL Hebrew instructions exactly from the reference.

**Lucide → SF Symbol mapping:**
```
Wind → wind
SquareDashed → square.dashed
MoonStar → moon.stars
Anchor → anchor
Activity → waveform.path.ecg
PersonStanding → figure.stand
Cloud → cloud
HeartHandshake → heart.circle
Sparkles → sparkles
Zap → bolt.fill
```

#### 4.2 Assessment Questions (10)

```
Q1  (mental_overload):      "עד כמה הרגשת עומס נפשי שמקשה עלייך ״לכבות את הראש״ אחרי משמרת?"
Q2  (recurring_worries):    "עד כמה היו לך דאגות חוזרות שקשה היה להרגיע גם אחרי שהנושא ״נסגר״?"
Q3  (low_energy):           "עד כמה הרגשת ירידה באנרגיה או עייפות שלא חולפת גם אחרי מנוחה?"
Q4  (body_tension):         "עד כמה הרגשת דריכות/מתח בגוף (למשל כתפיים, לסת, בטן) במהלך היום?"
Q5  (sleep_difficulty):     "עד כמה היה לך קושי להירדם או שהתעוררת עם מחשבות מטרידות?"
Q6  (loss_of_interest):     "עד כמה הרגשת אובדן הנאה/עניין בדברים שבדרך כלל כן נותנים לך כוח?"
Q7  (emotional_detachment): "עד כמה הרגשת ריחוק רגשי או ״אוטומט״ בזמן עבודה עם אנשים?"
Q8  (self_criticism):       "עד כמה חווית רגשות אשמה/ביקורת עצמית סביב התפקוד שלך?"
Q9  (low_support, REVERSE): "עד כמה הרגשת שיש לך תמיכה זמינה מאדם/צוות כשאת/ה צריך/ה?"
Q10 (low_meaning, REVERSE): "עד כמה הרגשת תחושת משמעות/ערך במה שאת/ה עושה?"
```

Scale labels (0-4): `["בכלל לא", "מעט", "לפעמים", "הרבה", "כמעט תמיד"]`
Time window prompt: `"ב-7 הימים האחרונים..."`

#### 4.3 Mood & Shift Options

**Moods:**
```
stable      → "יציב/ה"     (SF: face.smiling)
exhausted   → "מותש/ת"     (SF: battery.25)
overwhelmed → "מוצף/ת"     (SF: water.waves)
apathetic   → "אדיש/ה"     (SF: face.dashed)
needs_break → "צריך/ה הפסקה" (SF: cup.and.saucer)
```

**Shift Characteristics:**
```
emotional_load   → "עומס רגשי"           (SF: heart.fill)
fatigue          → "עייפות"              (SF: moon.fill)
family_conflict  → "קונפליקט עם משפחה"   (SF: person.2.fill)
patient_death    → "מות מטופל"           (SF: cloud.rain.fill)
sense_of_meaning → "תחושת משמעות"        (SF: sparkles)
```

**Meaning Moments:**
```
patient_smile    → "חיוך של מטופל"        (SF: face.smiling)
good_family_talk → "שיחה טובה עם משפחה"  (SF: bubble.left.and.bubble.right)
professionalism  → "רגע של מקצועיות"     (SF: star.fill)
no_moment        → "לא היה רגע כזה"      (SF: minus.circle)
```

#### 4.4 Spiritual Texts

10 multi-language guidance texts organized by level and tags. Each has Hebrew, Arabic, and Russian translations. See reference `SpiritualTextData.swift`.

Levels: green (2 texts), yellow (3 texts), orange (3 texts), red (2 texts)

Selection algorithm: filter by current assessment level, then by matching flag categories, sort by priority.

#### 4.5 Default Contacts

```swift
[
    SpiritualContact(id: "default-spiritual-1", name: "נירית אוליצור", role: "מתאמת ליווי רוחני", phone: "050-662-2791", isDefault: true),
    SpiritualContact(id: "default-psych-1", name: "ליאת אריאל", role: "מענה פסיכולוגי", phone: "050-206-4049", isDefault: true),
]
```

#### 4.6 Constants

```swift
let APP_NAME = "מדד רווחה ותפקוד"
let APP_SHORT_NAME = "מדד רווחה"

let DISCLAIMER_TEXT = "כלי זה מיועד לניטור עצמי בלבד ואינו מהווה כלי אבחוני או תחליף לטיפול רפואי/נפשי. במצב של מצוקה משמעותית או החמרה יש לפנות לגורם מקצועי."

let WELCOME_TEXT = "מרחב אישי לניטור רווחה ותרגול ויסות קצר לאורך השבוע. כל הנתונים נשמרים במכשיר שלך בלבד."

let SPIRITUAL_CARE_INTRO = "ליווי רוחני הוא מרחב שיח מקצועי, דיסקרטי ולא שיפוטי לעיבוד עומס, שחיקה ושאלות של משמעות בעבודה."

let SPIRITUAL_CARE_SUBTITLE = "הפנייה לליווי רוחני זמינה גם בלי משבר חריף, כעוגן תמיכתי מתמשך לאורך התקופה."

let DAYS_HE = ["ראשון", "שני", "שלישי", "רביעי", "חמישי", "שישי", "שבת"]

let TAB_LABELS = ["home": "בית", "practice": "תרגול", "spiritual": "ליווי רוחני", "trends": "מגמות", "settings": "הגדרות"]

let LEVEL_LABELS_HE: [ScoreLevel: String] = [.green: "מצב יציב", .yellow: "עומס מתגבר", .orange: "מצוקה משמעותית", .red: "עומס גבוה מאוד"]

let LEVEL_DESCRIPTIONS_HE: [ScoreLevel: String] = [
    .green: "מומלץ להמשיך בתחזוקה קלה ובמעקב שוטף.",
    .yellow: "מומלץ תרגול יומי קצר ובדיקה חוזרת בקרוב.",
    .orange: "מומלץ תרגול יומי ופנייה לתמיכה אנושית לבחירה.",
    .red: "מומלץ תרגול מיידי ופנייה לתמיכה בהקדם.",
]

let CATEGORY_LABELS_HE: [String: String] = [
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
```

---

### Phase 5: Design System

#### 5.1 Color Palette

**Light Mode:**
```swift
background:       Color(hex: "edf4ff")   // soft sky blue
foreground:       Color(hex: "16314e")   // deep navy
surface:          Color(hex: "f9fbff")
surfaceStrong:    Color(hex: "e2ecfb")
line:             Color(hex: "c6d6ee")
accent:           Color(hex: "2f679d")   // primary blue
accentStrong:     Color(hex: "234f7c")
accentSoft:       Color(hex: "dceafa")
accentGlow:       Color(hex: "7baee0")
calm:             Color(hex: "5c9ccf")
danger:           Color(hex: "b54d64")
warning:          Color(hex: "6e5421")
success:          Color(hex: "3f8a95")
```

**Dark Mode:**
```swift
background:       Color(hex: "152a41")   // deep night blue
foreground:       Color(hex: "e7f0fa")
surface:          Color(hex: "1f3956")
surfaceStrong:    Color(hex: "2b4b6c")
line:             Color(hex: "5a7897")
accent:           Color(hex: "73a8d1")
accentStrong:     Color(hex: "284a68")
accentSoft:       Color(hex: "9fc7e5")
accentGlow:       Color(hex: "cfe4f4")
calm:             Color(hex: "86b0c8")
danger:           Color(hex: "dfa5b6")
warning:          Color(hex: "d8bc87")
success:          Color(hex: "8ebeb8")
```

**Assessment Level Colors:**
```swift
// Score level indicator colors
levelGreen:  Color(hex: "2e9e6b")
levelYellow: Color(hex: "c9920a")
levelOrange: Color(hex: "d96b2d")
levelRed:    Color(hex: "c0392b")

// Score level background colors
Light:  green=#eaf7f1  yellow=#fdf6e3  orange=#fef1e8  red=#fde8e8
Dark:   green=#173028  yellow=#342b19  orange=#392718  red=#39222b
```

#### 5.2 Typography

- **Primary font:** Heebo (import via custom font files, supports Hebrew + Latin)
- **Weights:** 300 (light), 400 (regular), 500 (medium), 700 (bold), 900 (black)
- **Fallback:** system sans-serif (San Francisco)

#### 5.3 Spacing & Corners

- Cards: cornerRadius 32
- Nested cards: cornerRadius 24
- Pills/buttons: cornerRadius 999 (capsule)
- Glass-morphism: `.background(.ultraThinMaterial)` with `.overlay(RoundedRectangle.stroke(lineColor.opacity(0.6), lineWidth: 1))`

#### 5.4 Animations

- **Button press:** `.scaleEffect(isPressed ? 0.97 : 1.0)` with `.spring()`
- **Page transitions:** Slide + fade, asymmetric
- **Breathing circle:** Scale animation synchronized with inhale/exhale/hold timing
- **Tab bar indicator:** Spring layout animation on tab change
- **Modal sheets:** Custom slide-up with drag-to-dismiss
- **Haptics:** Use `UIImpactFeedbackGenerator` for button taps, selections, completions

#### 5.5 Dark Mode Background

Dark mode uses layered radial gradients:
```swift
// Approximate with SwiftUI:
ZStack {
    LinearGradient(colors: [Color(hex: "264664"), Color(hex: "1b3752"), Color(hex: "152a41")],
                   startPoint: .top, endPoint: .bottom)
    // Overlay subtle radial highlights
    RadialGradient(colors: [Color(hex: "cfe4f4").opacity(0.18), .clear],
                   center: .topTrailing, startRadius: 0, endRadius: 400)
    RadialGradient(colors: [Color(hex: "73a8d1").opacity(0.16), .clear],
                   center: .bottomLeading, startRadius: 0, endRadius: 350)
}
.ignoresSafeArea()
```

---

### Phase 6: Screens & Navigation

#### Navigation Structure

```
App Entry → SplashView → (onboarded ? MainTabView : WelcomeView)

WelcomeView → OnboardingView → MainTabView

MainTabView (5 tabs):
├── HomeView
├── PracticeLibraryView → PracticePlayerView(exerciseId)
├── SpiritualCareView
├── TrendsView
└── SettingsView

Standalone (presented modally / full screen):
├── QuestionnaireView → ResultsView
├── DailyCheckinModal (sheet)
└── MeaningMomentModal (sheet)
```

#### 6.1 Welcome & Onboarding

**WelcomeView:**
- App name + disclaimer text
- Privacy badge ("כל הנתונים נשמרים במכשיר שלך בלבד")
- Feature highlights (3-4 cards)
- "התחל" (Start) primary button → OnboardingView

**OnboardingView (multi-step):**
1. Reminder setup (day picker + time picker)
2. Daily practice target (slider: 2-30 min, default 5)
3. Contacts review (show defaults, allow adding)
4. Dark mode preference
→ Mark settings.onboarded = true → Navigate to HomeView

#### 6.2 Home Dashboard

- **Daily check-in prompt card** (if not completed today)
  - Tap → present DailyCheckinModal
  - After check-in → show TailoredResponseCard with recommendations
- **Assessment status card** (countdown to next weekly assessment or "ready" state)
  - Tap → navigate to QuestionnaireView
- **Weekly activity summary** (practices count, check-ins count, meaning moments)
- **Meaning moment card** (appears after 14:00 if not completed today)
- **Spiritual care quick-access card**

#### 6.3 Daily Check-in Modal

Two-step flow with slide animation:
1. **Step 1 - Mood:** "איך את/ה מרגיש/ה?" — 5 mood option buttons (icon + Hebrew label)
2. **Step 2 - Shift Characteristic:** "מה מאפיין את המשמרת?" — 5 shift option buttons

After both selections → save DailyCheckin → dismiss modal → show tailored response with up to 4 recommendations.

#### 6.4 Questionnaire

- Full-screen, one question at a time
- Progress bar (X of 10)
- Question text (Hebrew, RTL)
- 5-point Likert grid (0-4) with Hebrew scale labels
- Previous / Next navigation buttons
- On final question → Submit → create Assessment → navigate to ResultsView

#### 6.5 Results

- **Score banner:** Large circular score display, color-coded by level
  - Level label + description text
- **Flags list:** Highlighted risk indicators with category labels
- **Recommendation cards:** Prioritized list (max 5)
  - Each card: title, description, action button (navigate to exercise or spiritual care)
- **Spiritual text card:** Contextually selected guidance text
- "חזרה לבית" (Return home) button

#### 6.6 Practice Library

Three view modes via SegmentedControl:
1. **Flow** — Vertical snap scroll (each exercise as full-width card)
2. **List** — Traditional scrollable list
3. **Favorites** — Only starred exercises

Personalized sections (in list/flow mode):
- "לפי הבדיקה של היום" (from today's check-in)
- "לפי הזמן שביקשת לעצמך" (time-fit)
- "מה שכבר עזר לך" (helpful history) OR "המועדפים שלך" (favorites)

Each exercise card shows: icon, name, subtitle, duration badge, category badge, favorite star toggle.

#### 6.7 Practice Player

Three exercise types with different UIs:

**Timer-based (breathing/body/grounding):**
- Breathing circle animation (scales with inhale/exhale/hold)
- Large timer countdown display
- Current step instruction text
- Step progress indicator
- Play / Pause / Restart controls
- Duration adjustment (+/- buttons)

**Audio-based (breathing-4-8 with audio):**
- Audio player controls (play/pause/seek)
- Language selector for audio
- Timer display synced to audio
- Step guidance text

**Reflective/Text-based (shift-processing):**
- Step prompt displayed
- Multi-line text input field
- Next step button
- All responses collected and saved

**Post-exercise:**
- 1-5 star rating (tap to select)
- "סיימתי" (Finished) → save PracticeLog → return to library

#### 6.8 Spiritual Care

- **Intro text** (SPIRITUAL_CARE_INTRO + SPIRITUAL_CARE_SUBTITLE)
- **Contact list** (default + user-added)
  - Each contact: name, role, phone, tap-to-call button
  - Delete button for non-default contacts
- **Add contact form** (name, role, phone fields)
- **Spiritual text card** (if recent assessment exists, show contextual text)

#### 6.9 Trends

- **Trend chart** (Swift Charts LineChart)
  - X-axis: assessment dates (last 8)
  - Y-axis: total score (0-40)
  - Color-coded segments by level thresholds
  - Hebrew axis labels
- **Insight cards** (3 cards):
  1. Score comparison (vs previous week)
  2. Focus area (most flagged category)
  3. Routine consistency (practice + check-in counts, dominant mood)
- **Empty state** when < 2 assessments

#### 6.10 Settings

- **Reminder timing** (day of week picker + time picker)
- **Daily practice target** (stepper: 2-30 min)
- **Audio language** (picker: He/Ar/Ru)
- **Dark mode toggle**
- **Biweekly reminder toggle**
- **Data management section:**
  - Clear all assessments
  - Clear all practice logs
  - Reset all settings
  - Each with confirmation alert

---

### Phase 7: End-to-End Testing

Use XCUITest framework. Test every critical user flow:

#### Test Suites

**1. Onboarding Flow (OnboardingUITests.swift)**
- Fresh launch shows WelcomeView
- Can navigate through all onboarding steps
- Completing onboarding navigates to Home
- Settings are persisted after onboarding

**2. Home Dashboard (HomeUITests.swift)**
- Home shows check-in prompt when no check-in today
- Check-in prompt disappears after completing check-in
- Assessment card shows correct state
- Meaning moment card appears after 14:00
- Tailored recommendations display after check-in

**3. Daily Check-in (CheckinUITests.swift)**
- Modal presents on card tap
- Can select mood option
- Selecting mood advances to shift step
- Can select shift characteristic
- Completing both steps saves check-in and dismisses modal
- Tailored response shows correct number of recommendations

**4. Questionnaire (QuestionnaireUITests.swift)**
- Shows first question on launch
- Progress bar updates with each question
- Can navigate forward and backward
- All 5 Likert options are tappable
- Submitting creates assessment and navigates to results
- Score displays correctly based on answers

**5. Results (ResultsUITests.swift)**
- Score banner shows correct level color
- Recommendations list has correct count
- Can navigate to recommended exercise
- Can navigate to spiritual care from recommendation
- Return home button works

**6. Practice Library (PracticeLibraryUITests.swift)**
- All 11 exercises visible in list mode
- Can switch between Flow/List/Favorites modes
- Favorite toggle works
- Favorites mode shows only favorited exercises
- Personalized sections display correctly

**7. Practice Player (PracticePlayerUITests.swift)**
- Timer starts and counts down
- Play/Pause controls work
- Step instructions update as timer progresses
- Breathing circle animates (accessibility check)
- Text input works for shift-processing exercise
- Post-exercise rating appears when timer completes
- Rating submission saves practice log

**8. Spiritual Care (SpiritualCareUITests.swift)**
- Default contacts are displayed
- Can add a new contact
- Can delete non-default contact
- Tap-to-call button opens phone dialer (test the intent)
- Spiritual text displays when assessment exists

**9. Trends (TrendsUITests.swift)**
- Empty state shows with < 2 assessments
- Chart renders with 2+ assessments
- Insight cards display correct content
- Score comparison text is accurate

**10. Settings (SettingsUITests.swift)**
- All controls are accessible
- Changing reminder day persists
- Changing practice target persists
- Dark mode toggle switches appearance
- Clear data requires confirmation
- Clear data actually clears data

#### Unit Test Coverage Targets

| Module | Target |
|--------|--------|
| ScoringEngine | 100% |
| FlagDetector | 100% |
| RecommendationEngine | 95%+ |
| CheckinEngine | 95%+ |
| PersonalizationEngine | 90%+ |
| TrendInsightEngine | 90%+ |
| StorageManager | 90%+ |
| All Models (encoding/decoding) | 100% |

---

### Phase 8: Quality Standards

#### Accessibility
- All interactive elements have `.accessibilityLabel()` in Hebrew
- VoiceOver navigation order matches visual layout (RTL)
- Minimum touch target: 44x44pt
- Dynamic Type support for all text
- Reduce Motion support (disable animations when enabled)
- High contrast mode support

#### Performance
- App launch to interactive: < 1 second
- Tab switch: < 100ms
- Assessment submission: < 200ms
- No dropped frames during breathing circle animation (60fps)
- Memory: < 50MB typical usage

#### Security & Privacy
- No network calls whatsoever
- No analytics or tracking SDKs
- All data in app sandbox (UserDefaults or SwiftData)
- No clipboard access
- Phone numbers stored locally only
- App Transport Security: default (irrelevant since no network)

#### Code Quality
- Swift strict concurrency checking enabled
- No force unwraps in production code
- All public APIs documented with /// comments
- Consistent naming: camelCase properties, PascalCase types
- Maximum file length: 300 lines (split into extensions if needed)
- Every engine method is pure (no side effects) where possible

---

## Reference Repository

The original web app is at: `https://github.com/Ulitz/wellbeing-app/tree/codex/UI-Redesign`

Key reference files:
- `src/lib/storage/types.ts` — All data types
- `src/lib/exercises/data.ts` — Complete exercise definitions with Hebrew text
- `src/lib/questionnaire/questions.ts` — All 10 questions
- `src/lib/scoring/calculator.ts` + `flags.ts` — Scoring logic
- `src/lib/recommendations/engine.ts` — Assessment recommendation rules
- `src/lib/checkin/engine.ts` — Daily check-in recommendation rules
- `src/lib/checkin/constants.ts` — Mood/shift/meaning option definitions
- `src/lib/spiritual-texts/data.ts` — Multi-language spiritual guidance texts
- `src/lib/contacts/defaults.ts` — Default contacts
- `src/lib/constants.ts` — All Hebrew string constants
- `src/lib/trends/insights.ts` — Trend analysis logic
- `src/lib/practice/personalization.ts` — Practice suggestion algorithm
- `src/app/globals.css` — Complete design token definitions

---

## Execution Checklist

- [ ] Phase 1: Xcode project created, folder structure established
- [ ] Phase 2: All models, enums, and storage layer implemented + tested
- [ ] Phase 3: All 7 engines implemented + unit tested (80%+ coverage)
- [ ] Phase 4: All static data ported with exact Hebrew text
- [ ] Phase 5: Design system (colors, typography, glass cards, animations) implemented
- [ ] Phase 6: All 10 screens + modals implemented with full navigation
- [ ] Phase 7: E2E UI tests passing for all critical flows
- [ ] Phase 8: Accessibility audit, performance check, security review
- [ ] Code review agent run on every file
- [ ] Security review agent run on storage + contacts + notifications
- [ ] Dead code cleanup agent run at project completion
- [ ] Documentation updated with final architecture
