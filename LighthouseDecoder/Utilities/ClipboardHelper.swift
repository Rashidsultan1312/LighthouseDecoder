import UIKit

enum ClipboardHelper {
    static func copy(_ text: String) {
        UIPasteboard.general.string = text
        Haptics.success()
    }

    static func paste() -> String? {
        UIPasteboard.general.string
    }

    static func clear() {
        UIPasteboard.general.items = []
    }
}
