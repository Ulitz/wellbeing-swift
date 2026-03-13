import SwiftUI

struct WeeklySummaryCard: View {
    let practiceCount: Int
    let checkinCount: Int
    let meaningCount: Int

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                Text("סיכום שבועי")
                    .font(AppFont.headline)
                    .foregroundStyle(DesignTokens.Colors.foreground)

                HStack(spacing: DesignTokens.Spacing.lg) {
                    summaryItem(count: practiceCount, label: "תרגולים", icon: "figure.mind.and.body")
                    summaryItem(count: checkinCount, label: "בדיקות", icon: "heart.text.clipboard")
                    summaryItem(count: meaningCount, label: "רגעי משמעות", icon: "sparkles")
                }
            }
        }
    }

    private func summaryItem(count: Int, label: String, icon: String) -> some View {
        VStack(spacing: DesignTokens.Spacing.xs) {
            Image(systemName: icon)
                .foregroundStyle(DesignTokens.Colors.calm)
            Text("\(count)")
                .font(AppFont.title2)
                .foregroundStyle(DesignTokens.Colors.foreground)
            Text(label)
                .font(AppFont.caption2)
                .foregroundStyle(DesignTokens.Colors.foreground.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
}
