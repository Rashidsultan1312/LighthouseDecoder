import SwiftUI

struct ChipButton: View {
    enum Label {
        case key(LocalizedStringKey)
        case verbatim(String)
    }

    let label: Label
    let symbol: String?
    let selected: Bool
    let tint: Color
    let action: () -> Void

    init(_ titleKey: LocalizedStringKey,
         symbol: String? = nil,
         selected: Bool = false,
         tint: Color = Palette.accent,
         action: @escaping () -> Void) {
        self.label = .key(titleKey)
        self.symbol = symbol
        self.selected = selected
        self.tint = tint
        self.action = action
    }

    init(verbatim title: String,
         symbol: String? = nil,
         selected: Bool = false,
         tint: Color = Palette.accent,
         action: @escaping () -> Void) {
        self.label = .verbatim(title)
        self.symbol = symbol
        self.selected = selected
        self.tint = tint
        self.action = action
    }

    @ViewBuilder
    private var titleText: some View {
        switch label {
        case .key(let key): Text(key)
        case .verbatim(let s): Text(s)
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let symbol {
                    Image(systemName: symbol).font(.caption.weight(.semibold))
                }
                titleText
                    .font(.caption.weight(.semibold))
                    .lineLimit(1)
            }
            .padding(.horizontal, 13)
            .padding(.vertical, 8)
            .foregroundStyle(selected ? Color.white : tint)
            .background(
                Capsule().fill(selected ? tint : tint.opacity(0.12))
            )
        }
        .buttonStyle(.plain)
    }
}
