import XCTest
@testable import WellbeingApp

final class StaticDataTests: XCTestCase {

    // MARK: - Exercise Data

    func testAllElevenExercisesExist() {
        XCTAssertEqual(ExerciseData.all.count, 11)
    }

    func testEveryExerciseIdHasData() {
        for id in ExerciseId.allCases {
            XCTAssertNotNil(ExerciseData.find(id), "Missing exercise data for \(id)")
        }
    }

    func testExercisesHaveSteps() {
        for exercise in ExerciseData.all {
            XCTAssertFalse(exercise.steps.isEmpty, "Exercise \(exercise.id) has no steps")
        }
    }

    func testExercisesHavePositiveDuration() {
        for exercise in ExerciseData.all {
            XCTAssertGreaterThan(exercise.durationSeconds, 0)
        }
    }

    func testShiftProcessingHasTextResponseMode() {
        let exercise = ExerciseData.find(.shiftProcessing)!
        for step in exercise.steps {
            XCTAssertEqual(step.responseMode, "text")
        }
    }

    func testBreathingExercisesHaveAnimations() {
        let exercise = ExerciseData.find(.breathing4_6)!
        XCTAssertEqual(exercise.steps[0].animation, .inhale)
        XCTAssertEqual(exercise.steps[1].animation, .exhale)
    }

    func testBoxBreathingHasFourSteps() {
        let exercise = ExerciseData.find(.boxBreathing)!
        XCTAssertEqual(exercise.steps.count, 4)
    }

    // MARK: - Question Data

    func testTenQuestionsExist() {
        XCTAssertEqual(QuestionData.questions.count, 10)
    }

    func testQuestionsHaveCorrectIndices() {
        for (i, q) in QuestionData.questions.enumerated() {
            XCTAssertEqual(q.index, i)
        }
    }

    func testReverseQuestionsAreQ9Q10() {
        for q in QuestionData.questions {
            if q.index == 8 || q.index == 9 {
                XCTAssertTrue(q.isReverse, "Q\(q.index + 1) should be reverse")
            } else {
                XCTAssertFalse(q.isReverse, "Q\(q.index + 1) should not be reverse")
            }
        }
    }

    func testAllQuestionsHaveHebrewText() {
        for q in QuestionData.questions {
            XCTAssertFalse(q.textHe.isEmpty)
        }
    }

    // MARK: - Spiritual Text Data

    func testSpiritualTextsExist() {
        XCTAssertEqual(SpiritualTextData.all.count, 10)
    }

    func testAllLevelsHaveTexts() {
        for level in ScoreLevel.allCases {
            let texts = SpiritualTextData.all.filter { $0.levels.contains(level) }
            XCTAssertFalse(texts.isEmpty, "No spiritual texts for level \(level)")
        }
    }

    func testAllTextsHaveHebrewTranslation() {
        for text in SpiritualTextData.all {
            XCTAssertFalse(text.translations.he.title.isEmpty)
            XCTAssertFalse(text.translations.he.body.isEmpty)
        }
    }

    // MARK: - Constants

    func testScaleLabelCount() {
        XCTAssertEqual(AppConstants.scaleLabels.count, 5)
    }

    func testAllLevelsHaveLabels() {
        for level in ScoreLevel.allCases {
            XCTAssertNotNil(AppConstants.levelLabelsHe[level])
            XCTAssertNotNil(AppConstants.levelDescriptionsHe[level])
        }
    }

    func testAllMoodsHaveLabelsAndIcons() {
        for mood in MoodOption.allCases {
            XCTAssertNotNil(AppConstants.moodLabelsHe[mood])
            XCTAssertNotNil(AppConstants.moodIcons[mood])
        }
    }

    func testAllShiftsHaveLabelsAndIcons() {
        for shift in ShiftCharacteristic.allCases {
            XCTAssertNotNil(AppConstants.shiftLabelsHe[shift])
            XCTAssertNotNil(AppConstants.shiftIcons[shift])
        }
    }

    func testAllMeaningOptionsHaveLabels() {
        for option in MeaningOption.allCases {
            XCTAssertNotNil(AppConstants.meaningLabelsHe[option])
            XCTAssertNotNil(AppConstants.meaningIcons[option])
        }
    }

    func testDaysHaveSevenEntries() {
        XCTAssertEqual(AppConstants.daysHe.count, 7)
    }
}
