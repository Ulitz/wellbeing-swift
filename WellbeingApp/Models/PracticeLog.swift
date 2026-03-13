import Foundation

struct ExerciseTextResponse: Codable, Equatable, Sendable {
    let prompt: String
    let response: String
}

struct PracticeLog: Codable, Identifiable, Equatable, Sendable {
    let id: String
    let date: Date
    let exerciseId: ExerciseId
    let durationSeconds: Int
    let completed: Bool
    let rating: Int
    let textResponses: [ExerciseTextResponse]?
}
