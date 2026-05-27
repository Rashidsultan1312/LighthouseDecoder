import SwiftUI

struct GlossaryScreen: View {
    @State private var query: String = ""
    @State private var selected: IALATerm.Category = .rhythm

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(IALATerm.Category.allCases) { cat in
                            ChipButton(LocalizedStringKey(cat.titleKey),
                                       selected: cat == selected,
                                       tint: Palette.accent) {
                                selected = cat
                            }
                        }
                    }
                    .padding(.horizontal, 18)
                }
                List {
                    Section {
                        ForEach(results) { term in
                            NavigationLink(destination: GlossaryDetail(term: term)) {
                                GlossaryCard(term: term)
                            }
                        }
                    } header: {
                        if !query.isEmpty {
                            Text("glossary.results.title").upperLabel()
                        } else {
                            Text(LocalizedStringKey(selected.titleKey)).upperLabel()
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .searchable(text: $query, prompt: Text("glossary.search.prompt"))
            }
            .background(LightCanvas(opacity: 0.30, imageName: "Backdrops/bd-charting"))
            .navigationTitle("tab.glossary")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var results: [IALATerm] {
        if !query.isEmpty {
            return IALACatalog.search(query)
        }
        return IALACatalog.by(selected)
    }
}
