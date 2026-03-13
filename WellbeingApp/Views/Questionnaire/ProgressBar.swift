import SwiftUI

struct ProgressBar: View {
    let current: Int
    let total: Int

    private var progress: CGFloat {
        total > 0 ? CGFloat(current) / CGFloat(total) : 0
    }

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.xs) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(DesignTokens.Colors.line.opacity(0.3))
                        .frame(height: 6)
                    Capsule()
                        .fill(DesignTokens.Colors.accent)
                        .frame(width: geo.size.width * progress, height: 6)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: progress)
                }
            }
            .frame(height: 6)

            Text("\(current) מתוך \(total)")
                .font(AppFont.caption)
                .foregroundStyle(DesignTokens.Colors.foreground.opacity(0.5))
        }
    }
}
