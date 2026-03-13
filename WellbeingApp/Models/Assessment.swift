import Foundation

struct Flag: Codable, Equatable, Sendable {
    let questionIndex: Int
    let questionKey: String
    let category: String
    let score: Int
}

struct Assessment: Codable, Identifiable, Equatable, Sendable {
    let id: String
    let date: Date
    let answers: [Int]
    let adjustedAnswers: [Int]
    let totalScore: Int
    let level: ScoreLevel
    let flags: [Flag]
}
