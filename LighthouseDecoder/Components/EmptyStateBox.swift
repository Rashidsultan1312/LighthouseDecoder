import SwiftUI

struct EmptyStateBox: View {
    let symbol: String
    let titleKey: LocalizedStringKey
    let messageKey: LocalizedStringKey

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: symbol)
                .font(.system(size: 38, weight: .regular))
                .foregroundStyle(Palette.accent.opacity(0.55))
            Text(titleKey)
                .font(.headline)
            Text(messageKey)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 32)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Palette.cardFill.opacity(0.5))
        )
    }
}
