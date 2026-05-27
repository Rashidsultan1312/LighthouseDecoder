import SwiftUI

struct PocketTipCard: View {
    let titleKey: LocalizedStringKey
    let bodyKey: LocalizedStringKey
    let symbol: String

    var body: some View {
        RoundedCard(tinted: Palette.accentSoft) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: symbol)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Palette.accent)
                VStack(alignment: .leading, spacing: 4) {
                    Text(titleKey).font(.subheadline.weight(.bold))
                    Text(bodyKey)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}
