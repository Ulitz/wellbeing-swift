import SwiftUI

struct RecommendationList: View {
    let recommendations: [Recommendation]

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            Text("המלצות")
                .font(AppFont.headline)
                .foregroundStyle(DesignTokens.Colors.foreground)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(recommendations, id: \.id) { rec in
                GlassCard(cornerRadius: DesignTokens.Spacing.nestedCorner) {
                    HStack(spacing: DesignTokens.Spacing.md) {
                        Image(systemName: iconFor(rec.type))
                            .font(.title2)
                            .foregroundStyle(DesignTokens.Colors.accent)
                            .frame(width: 32)

                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                            Text(rec.titleHe)
                                .font(AppFont.subheadline)
                                .foregroundStyle(DesignTokens.Colors.foreground)
                            Text(rec.descriptionHe)
                                .font(AppFont.caption2)
                                .foregroundStyle(DesignTokens.Colors.foreground.opacity(0.6))
                        }

                        Spacer()

                        Image(systemName: "chevron.left")
                            .font(.caption)
                            .foregroundStyle(DesignTokens.Colors.line)
                    }
                }
            }
        }
    }

    private func iconFor(_ type: RecommendationType) -> String {
        switch type {
        case .exercise: "figure.mind.and.body"
        case .spiritualCare: "heart.circle"
        case .professionalHelp: "person.fill.questionmark"
        case .humanSupport: "person.2.fill"
        }
    }
}
