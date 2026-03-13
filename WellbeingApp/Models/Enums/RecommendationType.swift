import Foundation

enum RecommendationType: String, Codable, Sendable {
    case exercise
    case spiritualCare = "spiritual_care"
    case professionalHelp = "professional_help"
    case humanSupport = "human_support"
}
