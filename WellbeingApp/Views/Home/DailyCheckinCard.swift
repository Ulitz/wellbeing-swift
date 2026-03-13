import SwiftUI

struct DailyCheckinCard: View {
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            GlassCard {
                HStack(spacing: DesignTokens.Spacing.md) {
                    Image(systemName: "heart.text.clipboard")
                        .font(.title)
                        .foregroundStyle(DesignTokens.Colors.accent)

                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                        Text("בדיקה יומית")
                            .font(AppFont.headline)
                            .foregroundStyle(DesignTokens.Colors.foreground)
                        Text("איך את/ה מרגיש/ה היום?")
                            .font(AppFont.caption)
                            .foregroundStyle(DesignTokens.Colors.foreground.opacity(0.6))
                    }

                    Spacer()

                    Image(systemName: "chevron.left")
                        .foregroundStyle(DesignTokens.Colors.accent)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("daily-checkin-card")
    }
}
