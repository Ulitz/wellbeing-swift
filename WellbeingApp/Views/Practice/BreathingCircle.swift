import SwiftUI

struct BreathingCircle: View {
    let animation: StepAnimation
    let durationSeconds: Int

    @State private var scale: CGFloat = 0.6

    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [DesignTokens.Colors.accentGlow.opacity(0.6), DesignTokens.Colors.accent.opacity(0.3)],
                    center: .center, startRadius: 20, endRadius: 80
                )
            )
            .frame(width: 160, height: 160)
            .scaleEffect(scale)
            .onChange(of: animation, initial: true) {
                animateCircle()
            }
    }

    private func animateCircle() {
        let duration = Double(durationSeconds)
        switch animation {
        case .inhale:
            withAnimation(.easeInOut(duration: duration)) { scale = 1.0 }
        case .exhale:
            withAnimation(.easeInOut(duration: duration)) { scale = 0.6 }
        case .hold:
            break
        case .idle:
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                scale = scale == 0.6 ? 0.8 : 0.6
            }
        }
    }
}
