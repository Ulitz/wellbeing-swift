import SwiftUI

struct Badge: View {
    let text: String
    var color: Color = DesignTokens.Colors.accent

    var body: some View {
        Text(text)
            .font(AppFont.caption)
            .foregroundStyle(color)
            .padding(.horizontal, DesignTokens.Spacing.sm)
            .padding(.vertical, DesignTokens.Spacing.xs)
            .background(color.opacity(0.15))
            .clipShape(Capsule())
    }
}
