import Foundation

enum LightParser {

    enum Failure: Error, LocalizedError {
        case empty
        case unknownRhythm(String)
        case malformedGroup(String)
        case unknownColor(String)
        case missingPeriod
        case invalid

        var errorDescription: String? {
            switch self {
            case .empty:                return NSLocalizedString("parser.error.empty", comment: "")
            case .unknownRhythm(let s): return NSLocalizedString("parser.error.rhythm", comment: "") + " " + s
            case .malformedGroup(let s):return NSLocalizedString("parser.error.group", comment: "") + " " + s
            case .unknownColor(let s):  return NSLocalizedString("parser.error.color", comment: "") + " " + s
            case .missingPeriod:        return NSLocalizedString("parser.error.period", comment: "")
            case .invalid:              return NSLocalizedString("parser.error.invalid", comment: "")
            }
        }
    }

    private static let rhythmKeys: [String: LightRhythm] = [
        "FL": .flashing, "FFL": .flashing,
        "LFL": .longFlash,
        "Q": .quickFlash,
        "VQ": .veryQuickFlash,
        "ISO": .isophase,
        "OC": .occulting,
        "MO": .morse,
        "F": .fixed,
        "AL": .alternating
    ]

    static func parse(_ raw: String) throws -> LightCharacter {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw Failure.empty }

        let working = trimmed.uppercased().replacingOccurrences(of: ",", with: ".")
        var tokens = tokenize(working)
        guard !tokens.isEmpty else { throw Failure.invalid }

        let head = tokens.removeFirst().uppercased()
        guard let rhythm = matchRhythm(head) else { throw Failure.unknownRhythm(head) }

        var group: [Int] = []
        if let next = tokens.first, next.hasPrefix("("), next.hasSuffix(")") {
            let inside = String(next.dropFirst().dropLast())
            let parts = inside.split(whereSeparator: { $0 == "+" })
            for part in parts {
                guard let value = Int(part) else { throw Failure.malformedGroup(String(part)) }
                group.append(value)
            }
            tokens.removeFirst()
        }

        var colors: [LightColor] = []
        if let next = tokens.first, next.allSatisfy({ "WRGYBV".contains($0) }) {
            for char in next {
                guard let color = LightColor.from(char) else { throw Failure.unknownColor(String(char)) }
                colors.append(color)
            }
            tokens.removeFirst()
        }
        if colors.isEmpty { colors = [.white] }

        var period: Double = 0
        if let periodToken = tokens.first {
            let cleaned = periodToken.replacingOccurrences(of: "S", with: "")
            if let value = Double(cleaned) {
                period = value
                tokens.removeFirst()
            }
        }
        if period <= 0 && rhythm != .fixed { throw Failure.missingPeriod }

        let phases = synthesizePhases(rhythm: rhythm, group: group, period: period)
        return LightCharacter(rawCode: trimmed,
                              rhythm: rhythm,
                              group: group,
                              colors: colors,
                              periodSeconds: period,
                              phases: phases)
    }

    static func describe(_ ch: LightCharacter) -> [String] {
        var lines: [String] = []
        let groupText = ch.group.isEmpty ? "" : ch.group.map(String.init).joined(separator: "+")
        if ch.rhythm == .fixed {
            lines.append(NSLocalizedString("describe.fixed", comment: ""))
        } else {
            let templateKey: String
            if ch.group.isEmpty {
                templateKey = "describe.simple.\(ch.rhythm.rawValue)"
            } else if ch.group.count == 1 {
                templateKey = "describe.group.\(ch.rhythm.rawValue)"
            } else {
                templateKey = "describe.composite.\(ch.rhythm.rawValue)"
            }
            let template = NSLocalizedString(templateKey, comment: "")
            let filled = template
                .replacingOccurrences(of: "{count}", with: groupText)
                .replacingOccurrences(of: "{period}", with: formatNumber(ch.periodSeconds))
            lines.append(filled)
        }

        let colorList = ch.colors.map { NSLocalizedString($0.titleKey, comment: "") }
        if colorList.count == 1 {
            let tmpl = NSLocalizedString("describe.color.one", comment: "")
            lines.append(tmpl.replacingOccurrences(of: "{color}", with: colorList[0]))
        } else if colorList.count > 1 {
            let tmpl = NSLocalizedString("describe.color.many", comment: "")
            lines.append(tmpl.replacingOccurrences(of: "{colors}", with: colorList.joined(separator: ", ")))
        }
        return lines
    }

    private static func tokenize(_ text: String) -> [String] {
        var tokens: [String] = []
        var current = ""
        var depth = 0
        for char in text {
            if char == "(" { depth += 1; current.append(char); continue }
            if char == ")" { depth -= 1; current.append(char); continue }
            if char.isWhitespace && depth == 0 {
                if !current.isEmpty { tokens.append(current); current = "" }
                continue
            }
            current.append(char)
        }
        if !current.isEmpty { tokens.append(current) }
        return tokens
    }

    private static func matchRhythm(_ key: String) -> LightRhythm? {
        if let direct = rhythmKeys[key] { return direct }
        if key.hasPrefix("LFL") { return .longFlash }
        if key.hasPrefix("FFL") { return .flashing }
        if key.hasPrefix("FL")  { return .flashing }
        if key.hasPrefix("VQ")  { return .veryQuickFlash }
        if key.hasPrefix("Q")   { return .quickFlash }
        if key.hasPrefix("ISO") { return .isophase }
        if key.hasPrefix("OC")  { return .occulting }
        if key.hasPrefix("MO")  { return .morse }
        if key.hasPrefix("AL")  { return .alternating }
        if key == "F"           { return .fixed }
        return nil
    }

    private static func synthesizePhases(rhythm: LightRhythm, group: [Int], period: Double) -> [LightPhase] {
        var phases: [LightPhase] = []
        switch rhythm {
        case .fixed:
            return [LightPhase(kind: .on, duration: max(period, 1))]
        case .isophase:
            let half = period / 2
            return [LightPhase(kind: .on, duration: half), LightPhase(kind: .off, duration: half)]
        case .flashing, .longFlash, .quickFlash, .veryQuickFlash:
            let flashOn: Double = rhythm == .longFlash ? 2.0
                : (rhythm == .veryQuickFlash ? 0.15
                : (rhythm == .quickFlash ? 0.3 : 0.6))
            let bursts = group.isEmpty ? [1] : group
            var elapsed: Double = 0
            for (idx, count) in bursts.enumerated() {
                for _ in 0..<max(count, 1) {
                    phases.append(LightPhase(kind: .on, duration: flashOn))
                    phases.append(LightPhase(kind: .off, duration: flashOn))
                    elapsed += flashOn * 2
                }
                if idx < bursts.count - 1 {
                    let pause = flashOn * 2
                    phases.append(LightPhase(kind: .off, duration: pause))
                    elapsed += pause
                }
            }
            let trailing = max(period - elapsed, flashOn)
            phases.append(LightPhase(kind: .off, duration: trailing))
            return phases
        case .occulting:
            let bursts = group.isEmpty ? [1] : group
            let darkOff: Double = 0.5
            var elapsed: Double = 0
            for (idx, count) in bursts.enumerated() {
                for _ in 0..<max(count, 1) {
                    phases.append(LightPhase(kind: .off, duration: darkOff))
                    phases.append(LightPhase(kind: .on, duration: 1.0))
                    elapsed += darkOff + 1.0
                }
                if idx < bursts.count - 1 {
                    phases.append(LightPhase(kind: .on, duration: 1.0))
                    elapsed += 1.0
                }
            }
            let trailing = max(period - elapsed, 1.0)
            phases.append(LightPhase(kind: .on, duration: trailing))
            return phases
        case .morse:
            return [LightPhase(kind: .on, duration: 0.3),
                    LightPhase(kind: .off, duration: 0.3),
                    LightPhase(kind: .on, duration: 0.9),
                    LightPhase(kind: .off, duration: max(period - 1.5, 1.0))]
        case .alternating:
            let slice = period / 2
            return [LightPhase(kind: .on, duration: slice),
                    LightPhase(kind: .off, duration: slice)]
        }
    }

    private static func formatNumber(_ value: Double) -> String {
        if value == floor(value) { return String(Int(value)) }
        return String(format: "%.1f", value)
    }
}
