import SwiftUI

struct SpiritualTextCard: View {
    let title: String
    let bodyText: String

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                HStack {
                    Image(systemName: "text.book.closed.fill")
                        .foregroundStyle(DesignTokens.Colors.calm)
                    Text(title)
                        .font(AppFont.headline)
                        .foregroundStyle(DesignTokens.Colors.foreground)
                }

                Text(bodyText)
                    .font(AppFont.callout)
                    .foregroundStyle(DesignTokens.Colors.foreground.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
