import SwiftUI

struct GlossaryDetail: View {
    let term: IALATerm

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                heroBlock
                RoundedCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("glossary.detail.what").upperLabel()
                        Text(LocalizedStringKey(term.descriptionKey))
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                RoundedCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("glossary.detail.category").upperLabel()
                        Text(LocalizedStringKey(term.category.titleKey))
                            .font(.headline)
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
        }
        .background(LightCanvas(opacity: 0.32, imageName: "Backdrops/bd-lens"))
        .navigationTitle(Text(LocalizedStringKey(term.titleKey)))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var heroBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(term.abbreviation)
                .font(.system(size: 72, weight: .heavy, design: .rounded))
                .foregroundStyle(Palette.accent)
            Text(LocalizedStringKey(term.titleKey))
                .font(.title2.weight(.bold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Palette.accentSoft)
        )
    }
}
