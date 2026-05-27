import SwiftUI

struct SignalLaunchScaffold<Stage: View>: View {
    @AppStorage("lh.lantern.signed") private var signed = false
    @State private var arc: Arc = .scanning
    @State private var promptShown = false
    @ViewBuilder var stage: () -> Stage

    var body: some View {
        Group {
            if signed {
                stage()
            } else {
                switch arc {
                case .scanning:
                    ZStack {
                        Color(.systemGroupedBackground).ignoresSafeArea()
                        ProgressView()
                            .scaleEffect(1.3)
                    }
                    .task { await scan() }
                case .flashed(let url):
                    SignalFrame(glow: url, ephemeral: false)
                        .ignoresSafeArea()
                case .pledging:
                    Color(.systemGroupedBackground).ignoresSafeArea()
                        .fullScreenCover(isPresented: $promptShown) {
                            SignalConsentPanel(notice: AppConfig.privacyPolicyURL) {
                                signed = true
                                promptShown = false
                                arc = .open
                            }
                        }
                case .open:
                    stage()
                }
            }
        }
    }

    @MainActor
    private func scan() async {
        async let breather: Void = { try? await Task.sleep(nanoseconds: 1_700_000_000) }()
        async let flash = LanternLedger.sweep()
        let outcome = await flash
        _ = await breather
        switch outcome {
        case .flashed(let url):
            arc = .flashed(url)
        case .steady:
            arc = .pledging
            Task { @MainActor in promptShown = true }
        case .dark:
            arc = .open
        }
    }

    private enum Arc: Equatable {
        case scanning
        case flashed(URL)
        case pledging
        case open
    }
}
