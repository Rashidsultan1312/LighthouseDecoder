import SwiftUI

enum Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 18
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 36
    static let cardCorner: CGFloat = 22
    static let pillCorner: CGFloat = 14
    static let chipCorner: CGFloat = 11
}

enum Shadow {
    static func card<V: View>(_ content: V) -> some View {
        content.shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}
