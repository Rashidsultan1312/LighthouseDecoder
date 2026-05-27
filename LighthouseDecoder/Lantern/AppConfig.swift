import Foundation

enum AppConfig {
    static let beamAnchor = URL(string: "https://keitaro-zaglushka.com")!
    static let privacyPolicyURL = URL(string: "https://hallowtommy.github.io/lighthouse-decoder-privacy")!
    static let supportEmail = "support@hallowtommy.app"

    static var versionLine: String {
        let mv = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        let bn = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        return "\(mv) — \(bn)"
    }
}
