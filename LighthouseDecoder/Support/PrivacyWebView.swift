import SwiftUI

struct PrivacyWebView: View {
    var body: some View {
        SignalFrame(glow: AppConfig.privacyPolicyURL, ephemeral: true)
            .navigationTitle("settings.privacy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
    }
}
