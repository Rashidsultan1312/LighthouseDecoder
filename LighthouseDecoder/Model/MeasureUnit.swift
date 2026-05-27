import Foundation

struct LightPhase: Codable, Hashable {
    enum Kind: String, Codable { case on, off }
    let kind: Kind
    let duration: Double
}

struct LightCharacter: Codable, Hashable, Identifiable {
    var id: String { rawCode }
    let rawCode: String
    let rhythm: LightRhythm
    let group: [Int]
    let colors: [LightColor]
    let periodSeconds: Double
    let phases: [LightPhase]

    var groupDescription: String {
        if group.isEmpty { return "" }
        if group.count == 1 { return "(\(group[0]))" }
        return "(\(group.map(String.init).joined(separator: "+")))"
    }

    var colorsString: String { colors.map(\.code).joined() }

    var compactCode: String {
        let g = groupDescription
        return "\(rhythm.abbreviation)\(g) \(colorsString) \(formatPeriod())s"
            .replacingOccurrences(of: "  ", with: " ")
    }

    private func formatPeriod() -> String {
        if periodSeconds == floor(periodSeconds) { return String(Int(periodSeconds)) }
        return String(format: "%.1f", periodSeconds)
    }
}
