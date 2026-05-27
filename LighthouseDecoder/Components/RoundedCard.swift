import SwiftUI

struct RoundedCard<Content: View>: View {
    var padding: CGFloat = 18
    var corner: CGFloat = 22
    var tinted: Color? = nil
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .fill(tinted ?? Palette.cardFill)
            )
    }
}

struct InsetSeparator: View {
    var body: some View {
        Rectangle()
            .fill(Color.primary.opacity(0.06))
            .frame(height: 1)
    }
}
