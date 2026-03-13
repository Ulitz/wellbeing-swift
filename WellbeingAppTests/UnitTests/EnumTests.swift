import XCTest
@testable import WellbeingApp

final class EnumTests: XCTestCase {

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    // MARK: - ScoreLevel

    func testScoreLevelCaseCount() {
        XCTAssertEqual(ScoreLevel.allCases.count, 4)
    }

    func testScoreLevelRoundTrip() throws {
        for level in ScoreLevel.allCases {
            let data = try encoder.encode(level)
            let decoded = try decoder.decode(ScoreLevel.self, from: data)
            XCTAssertEqual(decoded, level)
        }
    }

    func testScoreLevelRawValues() {
        XCTAssertEqual(ScoreLevel.green.rawValue, "green")
        XCTAssertEqual(ScoreLevel.yellow.rawValue, "yellow")
        XCTAssertEqual(ScoreLevel.orange.rawValue, "orange")
        XCTAssertEqual(ScoreLevel.red.rawValue, "red")
    }

    // MARK: - MoodOption

    func testMoodOptionCaseCount() {
        XCTAssertEqual(MoodOption.allCases.count, 5)
    }

    func testMoodOptionRoundTrip() throws {
        for mood in MoodOption.allCases {
            let data = try encoder.encode(mood)
            let decoded = try decoder.decode(MoodOption.self, from: data)
            XCTAssertEqual(decoded, mood)
        }
    }

    func testMoodOptionNeedsBreakRawValue() {
        XCTAssertEqual(MoodOption.needsBreak.rawValue, "needs_break")
    }

    func testMoodOptionDecodesFromSnakeCase() throws {
        let json = Data("\"needs_break\"".utf8)
        let decoded = try decoder.decode(MoodOption.self, from: json)
        XCTAssertEqual(decoded, .needsBreak)
    }

    // MARK: - ShiftCharacteristic

    func testShiftCharacteristicCaseCount() {
        XCTAssertEqual(ShiftCharacteristic.allCases.count, 5)
    }

    func testShiftCharacteristicRawValues() {
        XCTAssertEqual(ShiftCharacteristic.emotionalLoad.rawValue, "emotional_load")
        XCTAssertEqual(ShiftCharacteristic.fatigue.rawValue, "fatigue")
        XCTAssertEqual(ShiftCharacteristic.familyConflict.rawValue, "family_conflict")
        XCTAssertEqual(ShiftCharacteristic.patientDeath.rawValue, "patient_death")
        XCTAssertEqual(ShiftCharacteristic.senseOfMeaning.rawValue, "sense_of_meaning")
    }

    func testShiftCharacteristicRoundTrip() throws {
        for shift in ShiftCharacteristic.allCases {
            let data = try encoder.encode(shift)
            let decoded = try decoder.decode(ShiftCharacteristic.self, from: data)
            XCTAssertEqual(decoded, shift)
        }
    }

    // MARK: - MeaningOption

    func testMeaningOptionCaseCount() {
        XCTAssertEqual(MeaningOption.allCases.count, 4)
    }

    func testMeaningOptionRawValues() {
        XCTAssertEqual(MeaningOption.patientSmile.rawValue, "patient_smile")
        XCTAssertEqual(MeaningOption.goodFamilyTalk.rawValue, "good_family_talk")
        XCTAssertEqual(MeaningOption.professionalism.rawValue, "professionalism")
        XCTAssertEqual(MeaningOption.noMoment.rawValue, "no_moment")
    }

    func testMeaningOptionRoundTrip() throws {
        for option in MeaningOption.allCases {
            let data = try encoder.encode(option)
            let decoded = try decoder.decode(MeaningOption.self, from: data)
            XCTAssertEqual(decoded, option)
        }
    }

    // MARK: - ExerciseCategory

    func testExerciseCategoryCaseCount() {
        XCTAssertEqual(ExerciseCategory.allCases.count, 4)
    }

    func testExerciseCategoryRoundTrip() throws {
        for cat in ExerciseCategory.allCases {
            let data = try encoder.encode(cat)
            let decoded = try decoder.decode(ExerciseCategory.self, from: data)
            XCTAssertEqual(decoded, cat)
        }
    }

    // MARK: - ExerciseId

    func testExerciseIdCaseCount() {
        XCTAssertEqual(ExerciseId.allCases.count, 11)
    }

    func testExerciseIdRawValues() {
        XCTAssertEqual(ExerciseId.breathing4_6.rawValue, "breathing-4-6")
        XCTAssertEqual(ExerciseId.boxBreathing.rawValue, "box-breathing")
        XCTAssertEqual(ExerciseId.breathing4_8.rawValue, "breathing-4-8")
        XCTAssertEqual(ExerciseId.grounding54321.rawValue, "grounding-5-4-3-2-1")
        XCTAssertEqual(ExerciseId.pmrShort.rawValue, "pmr-short")
        XCTAssertEqual(ExerciseId.pmrFull.rawValue, "pmr-full")
        XCTAssertEqual(ExerciseId.bodyStretchQuick.rawValue, "body-stretch-quick")
        XCTAssertEqual(ExerciseId.pmrMini.rawValue, "pmr-mini")
        XCTAssertEqual(ExerciseId.thoughtMindfulness.rawValue, "thought-mindfulness")
        XCTAssertEqual(ExerciseId.selfCompassion.rawValue, "self-compassion")
        XCTAssertEqual(ExerciseId.shiftProcessing.rawValue, "shift-processing")
    }

    func testExerciseIdRoundTrip() throws {
        for id in ExerciseId.allCases {
            let data = try encoder.encode(id)
            let decoded = try decoder.decode(ExerciseId.self, from: data)
            XCTAssertEqual(decoded, id)
        }
    }

    func testExerciseIdDecodesFromHyphenatedString() throws {
        let json = Data("\"grounding-5-4-3-2-1\"".utf8)
        let decoded = try decoder.decode(ExerciseId.self, from: json)
        XCTAssertEqual(decoded, .grounding54321)
    }

    // MARK: - StepAnimation

    func testStepAnimationRoundTrip() throws {
        let cases: [StepAnimation] = [.inhale, .exhale, .hold, .idle]
        for anim in cases {
            let data = try encoder.encode(anim)
            let decoded = try decoder.decode(StepAnimation.self, from: data)
            XCTAssertEqual(decoded, anim)
        }
    }

    // MARK: - AppLanguage

    func testAppLanguageCaseCount() {
        XCTAssertEqual(AppLanguage.allCases.count, 3)
    }

    func testAppLanguageRoundTrip() throws {
        for lang in AppLanguage.allCases {
            let data = try encoder.encode(lang)
            let decoded = try decoder.decode(AppLanguage.self, from: data)
            XCTAssertEqual(decoded, lang)
        }
    }

    // MARK: - RecommendationType

    func testRecommendationTypeRawValues() {
        XCTAssertEqual(RecommendationType.exercise.rawValue, "exercise")
        XCTAssertEqual(RecommendationType.spiritualCare.rawValue, "spiritual_care")
        XCTAssertEqual(RecommendationType.professionalHelp.rawValue, "professional_help")
        XCTAssertEqual(RecommendationType.humanSupport.rawValue, "human_support")
    }

    func testRecommendationTypeRoundTrip() throws {
        let cases: [RecommendationType] = [.exercise, .spiritualCare, .professionalHelp, .humanSupport]
        for type in cases {
            let data = try encoder.encode(type)
            let decoded = try decoder.decode(RecommendationType.self, from: data)
            XCTAssertEqual(decoded, type)
        }
    }

    // MARK: - ActionType

    func testActionTypeRoundTrip() throws {
        let cases: [ActionType] = [.navigate, .call, .external]
        for type in cases {
            let data = try encoder.encode(type)
            let decoded = try decoder.decode(ActionType.self, from: data)
            XCTAssertEqual(decoded, type)
        }
    }

    // MARK: - Invalid decoding

    func testInvalidEnumDecodingThrows() {
        let json = Data("\"invalid_value\"".utf8)
        XCTAssertThrowsError(try decoder.decode(ScoreLevel.self, from: json))
        XCTAssertThrowsError(try decoder.decode(MoodOption.self, from: json))
        XCTAssertThrowsError(try decoder.decode(ExerciseId.self, from: json))
    }
}
