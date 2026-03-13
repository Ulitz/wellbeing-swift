import SwiftUI

enum DesignTokens {

    // MARK: - Colors

    enum Colors {
        static let background    = Color.adaptive(light: "edf4ff", dark: "152a41")
        static let foreground    = Color.adaptive(light: "16314e", dark: "e7f0fa")
        static let surface       = Color.adaptive(light: "f9fbff", dark: "1f3956")
        static let surfaceStrong = Color.adaptive(light: "e2ecfb", dark: "2b4b6c")
        static let line          = Color.adaptive(light: "c6d6ee", dark: "5a7897")
        static let accent        = Color.adaptive(light: "2f679d", dark: "73a8d1")
        static let accentStrong  = Color.adaptive(light: "234f7c", dark: "284a68")
        static let accentSoft    = Color.adaptive(light: "dceafa", dark: "9fc7e5")
        static let accentGlow    = Color.adaptive(light: "7baee0", dark: "cfe4f4")
        static let calm          = Color.adaptive(light: "5c9ccf", dark: "86b0c8")
        static let danger        = Color.adaptive(light: "b54d64", dark: "dfa5b6")
        static let warning       = Color.adaptive(light: "6e5421", dark: "d8bc87")
        static let success       = Color.adaptive(light: "3f8a95", dark: "8ebeb8")

        // Assessment level indicator colors (same in both modes)
        static let levelGreen  = Color(hex: "2e9e6b")
        static let levelYellow = Color(hex: "c9920a")
        static let levelOrange = Color(hex: "d96b2d")
        static let levelRed    = Color(hex: "c0392b")

        // Assessment level background colors
        static let levelGreenBg  = Color.adaptive(light: "eaf7f1", dark: "173028")
        static let levelYellowBg = Color.adaptive(light: "fdf6e3", dark: "342b19")
        static let levelOrangeBg = Color.adaptive(light: "fef1e8", dark: "392718")
        static let levelRedBg    = Color.adaptive(light: "fde8e8", dark: "39222b")

        static func levelColor(for level: ScoreLevel) -> Color {
            switch level {
            case .green: levelGreen
            case .yellow: levelYellow
            case .orange: levelOrange
            case .red: levelRed
            }
        }

        static func levelBackground(for level: ScoreLevel) -> Color {
            switch level {
            case .green: levelGreenBg
            case .yellow: levelYellowBg
            case .orange: levelOrangeBg
            case .red: levelRedBg
            }
        }
    }

    // MARK: - Spacing

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48

        static let cardCorner: CGFloat = 32
        static let nestedCorner: CGFloat = 24
    }

    // MARK: - Animation

    enum Anim {
        static let buttonSpring = Animation.spring(response: 0.3, dampingFraction: 0.6)
        @MainActor static let pageTransition = AnyTransition.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
        @MainActor static let slideUp = AnyTransition.move(edge: .bottom).combined(with: .opacity)
    }
}
