import Foundation

struct SpiritualTextTranslation: Codable, Equatable, Sendable {
    let title: String
    let body: String
}

struct SpiritualText: Codable, Identifiable, Equatable, Sendable {
    let id: String
    let levels: [ScoreLevel]
    let tags: [String]
    let priority: Int
    let activeFrom: String?
    let activeTo: String?
    let translations: Translations

    struct Translations: Codable, Equatable, Sendable {
        let he: SpiritualTextTranslation
        let ar: SpiritualTextTranslation?
        let ru: SpiritualTextTranslation?
    }
}
