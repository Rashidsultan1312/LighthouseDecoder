import SwiftUI

struct RootView: View {
    @AppStorage("lh.onboarding.seen") private var onboardingSeen = false

    var body: some View {
        SignalLaunchScaffold {
            if onboardingSeen {
                MainTabView()
            } else {
                OnboardingFlow()
            }
        }
    }
}
