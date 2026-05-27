import SwiftUI

struct MainTabView: View {
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            DecodeScreen()
                .tabItem { Label("tab.decode", systemImage: "waveform") }
                .tag(0)
            JournalScreen()
                .tabItem { Label("tab.journal", systemImage: "book.pages.fill") }
                .tag(1)
            GlossaryScreen()
                .tabItem { Label("tab.glossary", systemImage: "text.book.closed.fill") }
                .tag(2)
            MapScreen()
                .tabItem { Label("tab.map", systemImage: "map.fill") }
                .tag(3)
            SettingsScreen()
                .tabItem { Label("tab.settings", systemImage: "gearshape.fill") }
                .tag(4)
        }
        .tint(Palette.accent)
    }
}
