import Foundation

enum ScoringEngine {
    /// Adjusts raw answers: clamps to 0-4 range, reverse-scores questions at indices 8 and 9.
    static func adjustAnswers(_ rawAnswers: [Int]) -> [Int] {
        rawAnswers.enumerated().map { index, answer in
            let clamped = min(max(answer, 0), 4)
            return (index == 8 || index == 9) ? (4 - clamped) : clamped
        }
    }

    /// Determines the score level based on total score (0-40).
    static func level(for totalScore: Int) -> ScoreLevel {
        switch totalScore {
        case 0...10: return .green
        case 11...20: return .yellow
        case 21...30: return .orange
        default: return .red
        }
    }

    /// Scores a set of raw answers and produces a complete Assessment.
    /// Requires exactly 10 answers with values 0-4.
    static func score(rawAnswers: [Int]) -> Assessment {
        guard rawAnswers.count == 10 else {
            assertionFailure("Assessment requires exactly 10 answers, got \(rawAnswers.count)")
            let padded = Array((rawAnswers + Array(repeating: 0, count: 10)).prefix(10))
            return score(rawAnswers: padded)
        }
        let adjusted = adjustAnswers(rawAnswers)
        let total = adjusted.reduce(0, +)
        let scoreLevel = level(for: total)
        let flags = FlagDetector.detectFlags(rawAnswers: rawAnswers, adjustedAnswers: adjusted)

        return Assessment(
            id: UUID().uuidString,
            date: Date(),
            answers: rawAnswers,
            adjustedAnswers: adjusted,
            totalScore: total,
            level: scoreLevel,
            flags: flags
        )
    }
}
