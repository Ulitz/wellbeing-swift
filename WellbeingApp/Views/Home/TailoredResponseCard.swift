import SwiftUI

struct TailoredResponseCard: View {
    let checkin: DailyCheckin

    private var recommendations: [Recommendation] {
        CheckinEngine.buildRecommendations(mood: checkin.mood, shift: checkin.shiftCharacteristic)
    }

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                HStack {
                    Image(systemName: AppConstants.moodIcons[checkin.mood] ?? "face.smiling")
                        .foregroundStyle(DesignTokens.Colors.accent)
                    Text(AppConstants.moodLabelsHe[checkin.mood] ?? "")
                        .font(AppFont.headline)
                        .foregroundStyle(DesignTokens.Colors.foreground)
                    Spacer()
                    Badge(text: "הושלם", color: DesignTokens.Colors.success)
                }

                ForEach(recommendations.prefix(4), id: \.id) { rec in
                    HStack(spacing: DesignTokens.Spacing.sm) {
                        Image(systemName: rec.exerciseId != nil ? "figure.mind.and.body" : "person.fill")
                            .foregroundStyle(DesignTokens.Colors.calm)
                            .frame(width: 24)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(rec.titleHe)
                                .font(AppFont.subheadline)
                                .foregroundStyle(DesignTokens.Colors.foreground)
                            Text(rec.descriptionHe)
                                .font(AppFont.caption2)
                                .foregroundStyle(DesignTokens.Colors.foreground.opacity(0.6))
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}
