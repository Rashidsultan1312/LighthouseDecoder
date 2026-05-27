import Foundation

enum NumberFormatting {
    static func compact(_ value: Double, precision: Int = 2) -> String {
        let abs = Swift.abs(value)
        if abs == 0 { return "0" }
        if abs >= 1e9 { return String(format: "%.\(precision)fB", value / 1e9) }
        if abs >= 1e6 { return String(format: "%.\(precision)fM", value / 1e6) }
        if abs >= 1e3 { return String(format: "%.\(precision)fK", value / 1e3) }
        return String(format: "%.\(precision)f", value)
    }

    static func plain(_ value: Double, fraction: Int = 4) -> String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 0
        f.maximumFractionDigits = fraction
        f.usesGroupingSeparator = true
        return f.string(from: NSNumber(value: value)) ?? String(value)
    }

    static func ordinal(_ index: Int) -> String {
        let f = NumberFormatter()
        f.numberStyle = .ordinal
        return f.string(from: NSNumber(value: index + 1)) ?? "#\(index + 1)"
    }
}
