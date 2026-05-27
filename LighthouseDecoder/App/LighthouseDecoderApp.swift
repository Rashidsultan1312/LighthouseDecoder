import SwiftUI

@main
struct LighthouseDecoderApp: App {
    @StateObject private var log = LightLog()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(log)
                .preferredColorScheme(log.appearance.colorScheme)
                .tint(Palette.accent)
        }
    }
}
