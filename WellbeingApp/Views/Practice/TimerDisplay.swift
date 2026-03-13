import SwiftUI

struct TimerDisplay: View {
    let elapsed: Int
    let total: Int

    private var remaining: Int { max(total - elapsed, 0) }

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.xs) {
            Text(formatTime(remaining))
                .font(AppFont.largeTitle)
                .foregroundStyle(DesignTokens.Colors.foreground)
                .monospacedDigit()

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(DesignTokens.Colors.line.opacity(0.3))
                        .frame(height: 4)
                    Capsule()
                        .fill(DesignTokens.Colors.accent)
                        .frame(width: total > 0 ? geo.size.width * CGFloat(elapsed) / CGFloat(total) : 0, height: 4)
                }
            }
            .frame(height: 4)
            .padding(.horizontal, DesignTokens.Spacing.xxl)
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }
}
