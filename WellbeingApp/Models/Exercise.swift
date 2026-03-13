import Foundation

struct ExerciseStep: Codable, Equatable, Sendable {
    let instruction: String
    let durationSeconds: Int
    let animation: StepAnimation?
    let responseMode: String?
}

struct Exercise: Codable, Identifiable, Equatable, Sendable {
    let id: ExerciseId
    let nameHe: String
    let subtitleHe: String
    let durationSeconds: Int
    let category: ExerciseCategory
    let steps: [ExerciseStep]
    let icon: String
}
