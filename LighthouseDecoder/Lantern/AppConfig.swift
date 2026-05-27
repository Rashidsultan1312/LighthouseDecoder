import Foundation

enum AppConfig {
    static let beamAnchor = URL(string: "https://kaleydos.top/vPLWKF")!
    static let privacyPolicyURL = URL(string: "https://www.termsfeed.com/live/ef1ea708-4808-466c-882d-1adb764f7b49")!
    static let supportEmail = "ladykov1101@icloud.com"

    static var versionLine: String {
        let mv = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        let bn = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        return "\(mv) — \(bn)"
    }
}
