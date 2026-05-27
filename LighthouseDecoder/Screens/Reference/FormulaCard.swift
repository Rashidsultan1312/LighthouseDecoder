import SwiftUI

struct LighthouseCard: View {
    let lighthouse: FamousLighthouse

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Palette.accentSoft)
                    .frame(width: 44, height: 44)
                Image(systemName: "lighthouse.fill")
                    .foregroundStyle(Palette.accent)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(LocalizedStringKey(lighthouse.nameKey))
                    .font(.subheadline.weight(.semibold))
                Text(lighthouse.country)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(lighthouse.characterCode)
                .font(.system(.caption, design: .monospaced).weight(.semibold))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Capsule().fill(Palette.chipFill))
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
