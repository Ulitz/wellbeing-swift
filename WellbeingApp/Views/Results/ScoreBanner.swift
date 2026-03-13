import SwiftUI

struct ScoreBanner: View {
    let score: Int
    let level: ScoreLevel

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            ZStack {
                Circle()
                    .stroke(DesignTokens.Colors.levelColor(for: level).opacity(0.3), lineWidth: 8)
                    .frame(width: 120, height: 120)
                Circle()
                    .trim(from: 0, to: CGFloat(score) / 40.0)
                    .stroke(DesignTokens.Colors.levelColor(for: level), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))

                Text("\(score)")
                    .font(AppFont.largeTitle)
                    .foregroundStyle(DesignTokens.Colors.levelColor(for: level))
            }

            Text(AppConstants.levelLabelsHe[level] ?? "")
                .font(AppFont.title3)
                .foregroundStyle(DesignTokens.Colors.foreground)

            Text(AppConstants.levelDescriptionsHe[level] ?? "")
                .font(AppFont.caption)
                .foregroundStyle(DesignTokens.Colors.foreground.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, DesignTokens.Spacing.xl)
        }
        .padding(DesignTokens.Spacing.lg)
        .background(DesignTokens.Colors.levelBackground(for: level).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Spacing.cardCorner, style: .continuous))
        .padding(.horizontal, DesignTokens.Spacing.md)
    }
}
