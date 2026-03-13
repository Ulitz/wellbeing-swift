import XCTest
@testable import WellbeingApp

final class ModelTests: XCTestCase {

    private let encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        return e
    }()

    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()

    // MARK: - Flag

    func testFlagRoundTrip() throws {
        let flag = Flag(questionIndex: 2, questionKey: "Q3", category: "low_energy", score: 3)
        let data = try encoder.encode(flag)
        let decoded = try decoder.decode(Flag.self, from: data)
        XCTAssertEqual(decoded, flag)
    }

    // MARK: - Assessment

    func testAssessmentRoundTrip() throws {
        let assessment = makeAssessment()
        let data = try encoder.encode(assessment)
        let decoded = try decoder.decode(Assessment.self, from: data)
        XCTAssertEqual(decoded, assessment)
    }

    func testAssessmentIdentifiable() {
        let a = makeAssessment()
        XCTAssertEqual(a.id, "test-assessment-1")
    }

    // MARK: - DailyCheckin

    func testDailyCheckinRoundTrip() throws {
        let checkin = DailyCheckin(
            id: "checkin-1",
            date: fixedDate,
            mood: .exhausted,
            shiftCharacteristic: .emotionalLoad
        )
        let data = try encoder.encode(checkin)
        let decoded = try decoder.decode(DailyCheckin.self, from: data)
        XCTAssertEqual(decoded, checkin)
    }

    func testDailyCheckinEncodesEnumsAsRawStrings() throws {
        let checkin = DailyCheckin(
            id: "c1",
            date: fixedDate,
            mood: .needsBreak,
            shiftCharacteristic: .patientDeath
        )
        let data = try encoder.encode(checkin)
        let json = String(data: data, encoding: .utf8)!
        XCTAssertTrue(json.contains("needs_break"))
        XCTAssertTrue(json.contains("patient_death"))
    }

    // MARK: - MeaningMoment

    func testMeaningMomentRoundTrip() throws {
        let moment = MeaningMoment(id: "m1", date: fixedDate, selection: .patientSmile)
        let data = try encoder.encode(moment)
        let decoded = try decoder.decode(MeaningMoment.self, from: data)
        XCTAssertEqual(decoded, moment)
    }

    // MARK: - PracticeLog

    func testPracticeLogWithTextResponsesRoundTrip() throws {
        let log = PracticeLog(
            id: "p1",
            date: fixedDate,
            exerciseId: .shiftProcessing,
            durationSeconds: 180,
            completed: true,
            rating: 4,
            textResponses: [
                ExerciseTextResponse(prompt: "?מה הרגשת", response: "שלווה")
            ]
        )
        let data = try encoder.encode(log)
        let decoded = try decoder.decode(PracticeLog.self, from: data)
        XCTAssertEqual(decoded, log)
        XCTAssertEqual(decoded.textResponses?.count, 1)
    }

    func testPracticeLogWithNilTextResponses() throws {
        let log = PracticeLog(
            id: "p2",
            date: fixedDate,
            exerciseId: .breathing4_6,
            durationSeconds: 180,
            completed: true,
            rating: 5,
            textResponses: nil
        )
        let data = try encoder.encode(log)
        let decoded = try decoder.decode(PracticeLog.self, from: data)
        XCTAssertEqual(decoded, log)
        XCTAssertNil(decoded.textResponses)
    }

    // MARK: - SpiritualContact

    func testSpiritualContactRoundTrip() throws {
        let contact = SpiritualContact(
            id: "sc1",
            name: "נירית",
            role: "מתאמת",
            phone: "050-123-4567",
            isDefault: true
        )
        let data = try encoder.encode(contact)
        let decoded = try decoder.decode(SpiritualContact.self, from: data)
        XCTAssertEqual(decoded, contact)
    }

    // MARK: - Settings

    func testSettingsDefaultValues() {
        let settings = Settings.default
        XCTAssertFalse(settings.onboarded)
        XCTAssertEqual(settings.reminderDay, 0)
        XCTAssertEqual(settings.reminderTime, "18:00")
        XCTAssertEqual(settings.dailyPracticeMinutes, 5)
        XCTAssertTrue(settings.spiritualContacts.isEmpty)
        XCTAssertTrue(settings.biweeklyReminderEnabled)
        XCTAssertNil(settings.lastReminderDate)
        XCTAssertEqual(settings.language, .he)
        XCTAssertEqual(settings.audioLanguage, .he)
        XCTAssertTrue(settings.audioLanguageByExercise.isEmpty)
        XCTAssertTrue(settings.darkMode)
    }

    func testSettingsRoundTrip() throws {
        var settings = Settings.default
        settings.onboarded = true
        settings.dailyPracticeMinutes = 10
        settings.setAudioLanguage(.ar, for: .breathing4_6)

        let data = try encoder.encode(settings)
        let decoded = try decoder.decode(Settings.self, from: data)
        XCTAssertEqual(decoded, settings)
        XCTAssertEqual(decoded.audioLanguage(for: .breathing4_6), .ar)
        XCTAssertEqual(decoded.audioLanguage(for: .pmrFull), .he)
    }

    func testSettingsAudioLanguageByExerciseDictionaryKeys() throws {
        var settings = Settings.default
        settings.setAudioLanguage(.ru, for: .breathing4_8)

        let data = try encoder.encode(settings)
        let json = String(data: data, encoding: .utf8)!
        XCTAssertTrue(json.contains("breathing-4-8"))
    }

    // MARK: - Exercise & ExerciseStep

    func testExerciseRoundTrip() throws {
        let exercise = Exercise(
            id: .breathing4_6,
            nameHe: "נשימת 4-6",
            subtitleHe: "איזון מהיר",
            durationSeconds: 180,
            category: .breathing,
            steps: [
                ExerciseStep(instruction: "שאפו", durationSeconds: 4, animation: .inhale, responseMode: nil),
                ExerciseStep(instruction: "נשפו", durationSeconds: 6, animation: .exhale, responseMode: nil),
            ],
            icon: "wind"
        )
        let data = try encoder.encode(exercise)
        let decoded = try decoder.decode(Exercise.self, from: data)
        XCTAssertEqual(decoded, exercise)
    }

    func testExerciseStepWithResponseMode() throws {
        let step = ExerciseStep(
            instruction: "מה עוזר לך?",
            durationSeconds: 60,
            animation: nil,
            responseMode: "text"
        )
        let data = try encoder.encode(step)
        let decoded = try decoder.decode(ExerciseStep.self, from: data)
        XCTAssertEqual(decoded, step)
        XCTAssertEqual(decoded.responseMode, "text")
        XCTAssertNil(decoded.animation)
    }

    // MARK: - Recommendation

    func testRecommendationRoundTrip() throws {
        let rec = Recommendation(
            id: "urgent-breathing",
            type: .exercise,
            titleHe: "תרגול נשימה",
            descriptionHe: "נשימה לייצוב מיידי",
            exerciseId: .breathing4_6,
            priority: 2,
            actionType: .navigate,
            actionTarget: "practice"
        )
        let data = try encoder.encode(rec)
        let decoded = try decoder.decode(Recommendation.self, from: data)
        XCTAssertEqual(decoded, rec)
    }

    func testRecommendationWithNilExerciseId() throws {
        let rec = Recommendation(
            id: "human-support",
            type: .humanSupport,
            titleHe: "תמיכה אנושית",
            descriptionHe: "פנה לתמיכה",
            exerciseId: nil,
            priority: 0,
            actionType: .call,
            actionTarget: "contacts"
        )
        let data = try encoder.encode(rec)
        let decoded = try decoder.decode(Recommendation.self, from: data)
        XCTAssertEqual(decoded, rec)
        XCTAssertNil(decoded.exerciseId)
    }

    // MARK: - QuestionDef

    func testQuestionDefRoundTrip() throws {
        let q = QuestionDef(
            index: 0,
            textHe: "עד כמה הרגשת עומס נפשי?",
            isReverse: false,
            category: "mental_overload"
        )
        let data = try encoder.encode(q)
        let decoded = try decoder.decode(QuestionDef.self, from: data)
        XCTAssertEqual(decoded, q)
    }

    // MARK: - SpiritualText

    func testSpiritualTextRoundTrip() throws {
        let text = SpiritualText(
            id: "st-1",
            levels: [.green, .yellow],
            tags: ["mental_overload"],
            priority: 1,
            activeFrom: nil,
            activeTo: nil,
            translations: .init(
                he: SpiritualTextTranslation(title: "כותרת", body: "גוף טקסט"),
                ar: nil,
                ru: nil
            )
        )
        let data = try encoder.encode(text)
        let decoded = try decoder.decode(SpiritualText.self, from: data)
        XCTAssertEqual(decoded, text)
    }

    // MARK: - Helpers

    /// Fixed date with no sub-second precision (ISO 8601 round-trip safe)
    private let fixedDate = Date(timeIntervalSince1970: 1_700_000_000)

    private func makeAssessment() -> Assessment {
        Assessment(
            id: "test-assessment-1",
            date: Date(timeIntervalSince1970: 1_700_000_000),
            answers: [1, 2, 1, 0, 1, 0, 2, 1, 3, 4],
            adjustedAnswers: [1, 2, 1, 0, 1, 0, 2, 1, 1, 0],
            totalScore: 9,
            level: .green,
            flags: []
        )
    }
}
