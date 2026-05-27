import SwiftUI

enum Palette {
    static let accent = Color("AccentColor")
    static let accentSoft = Color("AccentColor").opacity(0.14)

    static var cardFill: Color {
        Color(uiColor: .secondarySystemGroupedBackground)
    }

    static var chipFill: Color {
        Color(uiColor: .tertiarySystemFill)
    }

    static var canvas: Color {
        Color(uiColor: .systemGroupedBackground)
    }

    static let nightSea = Color(red: 0.07, green: 0.13, blue: 0.20)
    static let coolWhite = Color(red: 0.92, green: 0.94, blue: 0.96)
}
