import SwiftUI

struct MapScreen: View {
    @State private var region: FamousLighthouse.Region = .atlantic
    @State private var query: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(FamousLighthouse.Region.allCases) { reg in
                            ChipButton(LocalizedStringKey(reg.titleKey),
                                       selected: reg == region,
                                       tint: Palette.accent) {
                                region = reg
                            }
                        }
                    }
                    .padding(.horizontal, 18)
                }
                List {
                    Section {
                        ForEach(results) { lh in
                            NavigationLink(destination: LighthouseDetailView(lighthouse: lh)) {
                                LighthouseCard(lighthouse: lh)
                            }
                        }
                    } header: {
                        Text(LocalizedStringKey(region.titleKey)).upperLabel()
                    }
                }
                .listStyle(.insetGrouped)
                .searchable(text: $query, prompt: Text("map.search.prompt"))
            }
            .background(LightCanvas(opacity: 0.32, imageName: "Backdrops/bd-compass"))
            .navigationTitle("tab.map")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var results: [FamousLighthouse] {
        if !query.isEmpty {
            return FamousLighthousesCatalog.search(query)
        }
        return FamousLighthousesCatalog.byRegion(region)
    }
}

private struct LighthouseDetailView: View {
    let lighthouse: FamousLighthouse

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                heroPhotoBlock
                titleBlock
                statsBlock
                RoundedCard {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("map.story").upperLabel()
                        Text(LocalizedStringKey(lighthouse.storyKey))
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
        }
        .background(LightCanvas(opacity: 0.32, imageName: LightAccent.backdropName(for: lighthouse.region)))
        .navigationTitle(Text(LocalizedStringKey(lighthouse.nameKey)))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var heroPhotoBlock: some View {
        ZStack(alignment: .bottomLeading) {
            Image(LightAccent.regionHero(for: lighthouse.region))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            LinearGradient(colors: [.clear, Color.black.opacity(0.55)],
                           startPoint: .center, endPoint: .bottom)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStringKey(lighthouse.region.titleKey))
                    .font(.system(.caption, design: .serif).weight(.bold))
                    .textCase(.uppercase)
                    .kerning(1.2)
                    .foregroundStyle(.white.opacity(0.85))
                Text(lighthouse.country)
                    .font(.system(.headline, design: .serif).weight(.semibold))
                    .foregroundStyle(.white)
            }
            .padding(18)
        }
        .frame(maxWidth: .infinity)
    }

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(LocalizedStringKey(lighthouse.nameKey))
                .font(.system(.largeTitle, design: .serif).weight(.bold))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var statsBlock: some View {
        VStack(spacing: 10) {
            StatBadge(titleKey: "map.stat.code",
                      value: lighthouse.characterCode,
                      symbol: "waveform",
                      tint: Palette.accent)
            HStack(spacing: 12) {
                StatBadge(titleKey: "map.stat.year",
                          value: lighthouse.approxYear < 0 ? "\(abs(lighthouse.approxYear)) BCE" : "\(lighthouse.approxYear)",
                          symbol: "clock.arrow.circlepath",
                          tint: Color(red: 0.45, green: 0.55, blue: 0.78))
                StatBadge(titleKey: "map.stat.height",
                          value: "\(lighthouse.heightMeters) m",
                          symbol: "ruler",
                          tint: Color(red: 0.50, green: 0.66, blue: 0.42))
            }
        }
    }
}
