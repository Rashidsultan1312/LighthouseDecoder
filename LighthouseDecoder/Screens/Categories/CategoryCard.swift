import SwiftUI

struct GlossaryCard: View {
    let term: IALATerm

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Palette.accentSoft)
                    .frame(width: 44, height: 44)
                Text(term.abbreviation)
                    .font(.system(.subheadline, design: .monospaced).weight(.bold))
                    .foregroundStyle(Palette.accent)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(LocalizedStringKey(term.titleKey))
                    .font(.subheadline.weight(.semibold))
                Text(LocalizedStringKey(term.descriptionKey))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}
