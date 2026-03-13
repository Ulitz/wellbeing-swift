import SwiftUI

enum AppFont {
    static let light: Font.Weight = .light       // 300
    static let regular: Font.Weight = .regular   // 400
    static let medium: Font.Weight = .medium     // 500
    static let bold: Font.Weight = .bold         // 700
    static let black: Font.Weight = .black       // 900

    private static func heebo(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .custom("Heebo", size: size).weight(weight)
    }

    static let largeTitle = heebo(34, weight: .bold)
    static let title = heebo(28, weight: .bold)
    static let title2 = heebo(22, weight: .medium)
    static let title3 = heebo(20, weight: .medium)
    static let headline = heebo(17, weight: .bold)
    static let body = heebo(17)
    static let callout = heebo(16)
    static let subheadline = heebo(15, weight: .medium)
    static let footnote = heebo(13)
    static let caption = heebo(12)
    static let caption2 = heebo(11, weight: .light)
}
