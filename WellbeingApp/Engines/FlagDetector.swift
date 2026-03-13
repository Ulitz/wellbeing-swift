import Foundation

enum FlagDetector {
    private static let questionCategories = [
        "mental_overload",
        "recurring_worries",
        "low_energy",
        "body_tension",
        "sleep_difficulty",
        "loss_of_interest",
        "emotional_detachment",
        "self_criticism",
        "low_support",
        "low_meaning",
    ]

    /// Detects risk flags based on raw and adjusted answers.
    /// - Normal questions (0-7): flag if adjustedAnswer >= 3
    /// - Reverse questions (8-9): flag if rawAnswer <= 1
    static func detectFlags(rawAnswers: [Int], adjustedAnswers: [Int]) -> [Flag] {
        var flags: [Flag] = []

        for index in 0..<min(rawAnswers.count, 10) {
            let shouldFlag: Bool
            let score: Int

            if index == 8 || index == 9 {
                // Reverse questions: flag when raw answer is low (1 or 0)
                shouldFlag = rawAnswers[index] <= 1
                score = rawAnswers[index]
            } else {
                // Normal questions: flag when adjusted answer is high (3 or 4)
                shouldFlag = adjustedAnswers[index] >= 3
                score = adjustedAnswers[index]
            }

            if shouldFlag {
                flags.append(Flag(
                    questionIndex: index,
                    questionKey: "Q\(index + 1)",
                    category: questionCategories[index],
                    score: score
                ))
            }
        }

        return flags
    }
}
