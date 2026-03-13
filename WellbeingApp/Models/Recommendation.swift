import Foundation

struct Recommendation: Codable, Identifiable, Equatable, Sendable {
    let id: String
    let type: RecommendationType
    let titleHe: String
    let descriptionHe: String
    let exerciseId: ExerciseId?
    let priority: Int
    let actionType: ActionType
    let actionTarget: String
}
