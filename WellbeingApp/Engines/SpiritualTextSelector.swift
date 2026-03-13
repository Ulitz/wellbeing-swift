import Foundation

enum SpiritualTextSelector {
    /// Selects the most relevant spiritual text for the given assessment level and flags.
    /// - Parameters:
    ///   - level: The current assessment score level
    ///   - flags: The detected risk flags
    ///   - history: Recently shown text IDs (to avoid repetition)
    ///   - language: Preferred language
    /// - Returns: A tuple of (title, body) in the requested language, or nil
    static func select(
        level: ScoreLevel,
        flags: [Flag],
        history: [String],
        language: AppLanguage = .he
    ) -> (text: SpiritualText, title: String, body: String)? {
        let flagCategories = Set(flags.map(\.category))

        // Filter by level, excluding recently shown
        var candidates = SpiritualTextData.all.filter { text in
            text.levels.contains(level) && !history.contains(text.id)
        }

        // Fallback: if no candidates, reset history filter for this level
        if candidates.isEmpty {
            candidates = SpiritualTextData.all.filter { $0.levels.contains(level) }
        }

        guard !candidates.isEmpty else { return nil }

        // Score by tag overlap (descending), then priority (ascending)
        let scored = candidates.sorted { a, b in
            let aOverlap = Set(a.tags).intersection(flagCategories).count
            let bOverlap = Set(b.tags).intersection(flagCategories).count
            if aOverlap != bOverlap { return aOverlap > bOverlap }
            return a.priority < b.priority
        }

        guard let selected = scored.first else { return nil }

        // Get translation for requested language
        let translation: SpiritualTextTranslation
        switch language {
        case .he:
            translation = selected.translations.he
        case .ar:
            translation = selected.translations.ar ?? selected.translations.he
        case .ru:
            translation = selected.translations.ru ?? selected.translations.he
        }

        return (text: selected, title: translation.title, body: translation.body)
    }
}
