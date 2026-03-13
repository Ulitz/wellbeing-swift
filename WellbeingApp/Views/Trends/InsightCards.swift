import SwiftUI

struct InsightCards: View {
    let assessments: [Assessment]
    let practices: [PracticeLog]
    let checkins: [DailyCheckin]

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            insightCard(TrendInsightEngine.scoreInsight(assessments: assessments))
            insightCard(TrendInsightEngine.focusInsight(assessments: assessments))
            insightCard(TrendInsightEngine.routineInsight(practices: practices, checkins: checkins))
        }
    }

    private func insightCard(_ insight: TrendInsight) -> some View {
        GlassCard(cornerRadius: DesignTokens.Spacing.nestedCorner) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                Text(insight.titleHe)
                    .font(AppFont.headline)
                    .foregroundStyle(DesignTokens.Colors.foreground)
                Text(insight.bodyHe)
                    .font(AppFont.caption)
                    .foregroundStyle(DesignTokens.Colors.foreground.opacity(0.7))
            }
        }
    }
}
