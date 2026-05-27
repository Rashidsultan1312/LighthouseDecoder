import Foundation
import UIKit
@preconcurrency import WebKit

enum LanternFlash: Equatable {
    case flashed(URL)
    case steady
    case dark
}

enum LanternLedger {
    @MainActor
    static func sweep() async -> LanternFlash {
        await KeeperWatch().beam()
    }

    static func bare(_ url: URL) -> String {
        var carve = URLComponents(url: url, resolvingAgainstBaseURL: true) ?? URLComponents()
        carve.fragment = nil
        carve.scheme = (carve.scheme ?? "https").lowercased()
        carve.host = carve.host?.lowercased()
        var lane = carve.path
        while lane.count > 1 && lane.hasSuffix("/") { lane.removeLast() }
        carve.path = lane
        return carve.url?.absoluteString ?? url.absoluteString.lowercased()
    }
}

@MainActor
final class KeeperWatch: NSObject, WKNavigationDelegate {
    private var pending: CheckedContinuation<LanternFlash, Never>?
    private var glass: WKWebView?
    private var sealed = false
    private var horizon: Task<Void, Never>?

    func beam() async -> LanternFlash {
        await withCheckedContinuation { gate in
            pending = gate
            let cfg = WKWebViewConfiguration()
            cfg.websiteDataStore = .nonPersistent()
            let lens = WKWebView(frame: CGRect(x: 0, y: 0, width: 5, height: 5), configuration: cfg)
            lens.alpha = 0.025
            lens.navigationDelegate = self
            lens.load(URLRequest(url: AppConfig.beamAnchor))
            glass = lens
            horizon = Task { [weak self] in
                try? await Task.sleep(nanoseconds: 9_500_000_000)
                await MainActor.run { self?.cap(.dark) }
            }
        }
    }

    private func cap(_ flash: LanternFlash) {
        if sealed { return }
        sealed = true
        horizon?.cancel()
        glass?.navigationDelegate = nil
        glass?.stopLoading()
        glass = nil
        pending?.resume(returning: flash)
        pending = nil
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let target = navigationAction.request.url else {
            decisionHandler(.allow); return
        }
        let mark = AppConfig.beamAnchor
        if LanternLedger.bare(target) != LanternLedger.bare(mark) {
            decisionHandler(.cancel)
            cap(.flashed(target))
            return
        }
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Task { @MainActor [weak self] in
            try? await Task.sleep(nanoseconds: 2_500_000_000)
            guard let self = self, !self.sealed else { return }
            self.cap(.steady)
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        _ = error; cap(.dark)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        _ = error; cap(.dark)
    }
}
