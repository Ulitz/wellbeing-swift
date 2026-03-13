import SwiftUI

struct ResultsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState
    let assessment: Assessment

    private var recommendations: [Recommendation] {
        RecommendationEngine.buildRecommendations(for: assessment)
    }

    private var spiritualText: (text: SpiritualText, title: String, body: String)? {
        SpiritualTextSelector.select(level: assessment.level, flags: assessment.flags, history: [])
    }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: DesignTokens.Spacing.lg) {
                    // Score banner
                    ScoreBanner(score: assessment.totalScore, level: assessment.level)
                        .padding(.top, DesignTokens.Spacing.lg)

                    // Flags
                    if !assessment.flags.isEmpty {
                        FlagsList(flags: assessment.flags)
                            .padding(.horizontal, DesignTokens.Spacing.md)
                    }

                    // Recommendations
                    RecommendationList(recommendations: recommendations)
                        .padding(.horizontal, DesignTokens.Spacing.md)

                    // Spiritual text
                    if let text = spiritualText {
                        SpiritualTextCard(title: text.title, bodyText: text.body)
                            .padding(.horizontal, DesignTokens.Spacing.md)
                    }

                    // Return button
                    PrimaryButton(title: "חזרה לבית") {
                        dismiss()
                    }
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                    .padding(.bottom, DesignTokens.Spacing.xxl)
                }
            }
        }
    }
}
