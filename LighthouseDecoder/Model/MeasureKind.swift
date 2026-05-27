import SwiftUI

enum LightRhythm: String, CaseIterable, Codable, Identifiable {
    case flashing
    case longFlash
    case quickFlash
    case veryQuickFlash
    case isophase
    case occulting
    case morse
    case fixed
    case alternating

    var id: String { rawValue }

    var abbreviation: String {
        switch self {
        case .flashing:        return "Fl"
        case .longFlash:       return "LFl"
        case .quickFlash:      return "Q"
        case .veryQuickFlash:  return "VQ"
        case .isophase:        return "Iso"
        case .occulting:       return "Oc"
        case .morse:           return "Mo"
        case .fixed:           return "F"
        case .alternating:     return "Al"
        }
    }

    var titleKey: String { "rhythm.\(rawValue)" }
    var explanationKey: String { "rhythm.\(rawValue).explain" }
}

enum LightColor: String, CaseIterable, Codable, Identifiable {
    case white
    case red
    case green
    case yellow
    case blue
    case violet

    var id: String { rawValue }

    var code: String {
        switch self {
        case .white:  return "W"
        case .red:    return "R"
        case .green:  return "G"
        case .yellow: return "Y"
        case .blue:   return "B"
        case .violet: return "V"
        }
    }

    var swiftColor: Color {
        switch self {
        case .white:  return Color(red: 0.98, green: 0.96, blue: 0.85)
        case .red:    return Color(red: 0.92, green: 0.28, blue: 0.24)
        case .green:  return Color(red: 0.27, green: 0.78, blue: 0.43)
        case .yellow: return Color(red: 0.96, green: 0.78, blue: 0.20)
        case .blue:   return Color(red: 0.28, green: 0.49, blue: 0.93)
        case .violet: return Color(red: 0.65, green: 0.36, blue: 0.85)
        }
    }

    var titleKey: String { "color.\(rawValue)" }

    static func from(_ letter: Character) -> LightColor? {
        switch letter {
        case "W": return .white
        case "R": return .red
        case "G": return .green
        case "Y": return .yellow
        case "B": return .blue
        case "V": return .violet
        default: return nil
        }
    }
}
