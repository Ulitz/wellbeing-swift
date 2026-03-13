import SwiftUI

struct AppBackground: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        if colorScheme == .dark {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "264664"), Color(hex: "1b3752"), Color(hex: "152a41")],
                    startPoint: .top, endPoint: .bottom
                )
                RadialGradient(
                    colors: [Color(hex: "cfe4f4").opacity(0.18), .clear],
                    center: .topTrailing, startRadius: 0, endRadius: 400
                )
                RadialGradient(
                    colors: [Color(hex: "73a8d1").opacity(0.16), .clear],
                    center: .bottomLeading, startRadius: 0, endRadius: 350
                )
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)
        } else {
            DesignTokens.Colors.background
                .ignoresSafeArea()
                .allowsHitTesting(false)
        }
    }
}
