import SwiftUI

struct OnboardingFlow: View {
    @AppStorage("lh.onboarding.seen") private var seen = false
    @State private var page = 0

    private struct Slide {
        let glyph: String
        let title: LocalizedStringKey
        let body: LocalizedStringKey
    }

    private let slides: [Slide] = [
        .init(glyph: "lighthouse.fill",
              title: "lh.onb.1.title", body: "lh.onb.1.body"),
        .init(glyph: "book.closed.fill",
              title: "lh.onb.2.title", body: "lh.onb.2.body"),
        .init(glyph: "map.fill",
              title: "lh.onb.3.title", body: "lh.onb.3.body")
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                if page < slides.count - 1 {
                    Button("lh.onb.skip") { finish() }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .padding(.trailing, 20)
                }
            }
            .frame(height: 44)

            TabView(selection: $page) {
                ForEach(Array(slides.enumerated()), id: \.offset) { idx, slide in
                    slideView(slide).tag(idx)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            Button {
                if page < slides.count - 1 {
                    withAnimation(.easeInOut(duration: 0.25)) { page += 1 }
                } else {
                    finish()
                }
            } label: {
                Text(page < slides.count - 1 ? "lh.onb.next" : "lh.onb.start")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Palette.accent, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 36)
            .padding(.top, 8)
        }
        .background(LightCanvas(opacity: 0.35))
    }

    private func slideView(_ slide: Slide) -> some View {
        VStack(spacing: 22) {
            Spacer()
            Image(systemName: slide.glyph)
                .font(.system(size: 76, weight: .regular))
                .foregroundStyle(Palette.accent)
            Text(slide.title)
                .font(.title2.bold())
                .multilineTextAlignment(.center)
            Text(slide.body)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 36)
            Spacer()
            Spacer()
        }
    }

    private func finish() {
        withAnimation(.easeInOut(duration: 0.25)) { seen = true }
    }
}
