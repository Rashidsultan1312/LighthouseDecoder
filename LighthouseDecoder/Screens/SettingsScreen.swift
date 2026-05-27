import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject private var log: LightLog
    @Environment(\.openURL) private var openURL
    @State private var confirmWipe = false

    var body: some View {
        NavigationStack {
            Form {
                Section("settings.section.preferences") {
                    Picker("settings.appearance", selection: $log.appearance) {
                        ForEach(AppearanceMode.allCases) { mode in
                            Text(mode.label).tag(mode)
                        }
                    }
                }

                Section("settings.section.data") {
                    HStack {
                        Label("settings.stats.sightings", systemImage: "binoculars")
                        Spacer()
                        Text("\(log.entries.count)").foregroundStyle(.secondary)
                    }
                    HStack {
                        Label("settings.stats.recent", systemImage: "clock.arrow.circlepath")
                        Spacer()
                        Text("\(log.recent.count)").foregroundStyle(.secondary)
                    }
                    Button(role: .destructive) {
                        confirmWipe = true
                    } label: {
                        Label("settings.wipe", systemImage: "trash")
                    }
                    .disabled(log.entries.isEmpty && log.recent.isEmpty)
                }

                Section("settings.section.about") {
                    Button {
                        if let url = supportMailURL() { openURL(url) }
                    } label: {
                        Label("settings.support", systemImage: "envelope")
                    }
                    .tint(.primary)

                    NavigationLink {
                        PrivacyWebView()
                    } label: {
                        Label("settings.privacy", systemImage: "hand.raised")
                    }

                    HStack {
                        Label("settings.version", systemImage: "info.circle")
                        Spacer()
                        Text(AppConfig.versionLine).foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("tab.settings")
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog("settings.wipe.confirm",
                                isPresented: $confirmWipe,
                                titleVisibility: .visible) {
                Button("settings.wipe", role: .destructive) { log.wipeAll() }
                Button("action.cancel", role: .cancel) {}
            }
        }
    }

    private func supportMailURL() -> URL? {
        let subject = NSLocalizedString("support.subject", comment: "")
        var c = URLComponents()
        c.scheme = "mailto"
        c.path = AppConfig.supportEmail
        c.queryItems = [URLQueryItem(name: "subject", value: subject)]
        return c.url
    }
}
