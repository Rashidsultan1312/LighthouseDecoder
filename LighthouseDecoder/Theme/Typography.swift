import SwiftUI

enum Typography {
    static let displayLarge = Font.system(size: 38, weight: .bold, design: .rounded)
    static let displayMedium = Font.system(size: 28, weight: .bold, design: .rounded)
    static let titleStrong = Font.system(.title2, design: .rounded).weight(.bold)
    static let titleSoft = Font.system(.title3, design: .rounded).weight(.semibold)
    static let sectionLabel = Font.footnote.weight(.bold)
    static let bodyEmphasis = Font.body.weight(.semibold)
    static let captionEmphasis = Font.caption.weight(.semibold)
    static let monoNumber = Font.system(.title3, design: .monospaced).weight(.semibold)
}

extension Text {
    func upperLabel() -> some View {
        self.font(Typography.sectionLabel)
            .textCase(.uppercase)
            .foregroundStyle(.secondary)
            .kerning(0.6)
    }
}
