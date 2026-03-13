import SwiftUI

struct MeaningMomentCard: View {
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            GlassCard {
                HStack(spacing: DesignTokens.Spacing.md) {
                    Image(systemName: "sparkles")
                        .font(.title)
                        .foregroundStyle(DesignTokens.Colors.calm)

                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                        Text("רגע של משמעות")
                            .font(AppFont.headline)
                            .foregroundStyle(DesignTokens.Colors.foreground)
                        Text("היה היום רגע שנתן לך כוח?")
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
    }
}
