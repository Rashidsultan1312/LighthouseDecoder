import SwiftUI

enum LightAccent {
    static func tint(for rhythm: LightRhythm) -> Color {
        switch rhythm {
        case .flashing:       return Color(red: 0.94, green: 0.62, blue: 0.18)
        case .longFlash:      return Color(red: 0.88, green: 0.51, blue: 0.20)
        case .quickFlash:     return Color(red: 0.96, green: 0.74, blue: 0.20)
        case .veryQuickFlash: return Color(red: 0.94, green: 0.81, blue: 0.30)
        case .isophase:       return Color(red: 0.27, green: 0.67, blue: 0.86)
        case .occulting:      return Color(red: 0.38, green: 0.48, blue: 0.78)
        case .morse:          return Color(red: 0.71, green: 0.43, blue: 0.30)
        case .fixed:          return Color(red: 0.55, green: 0.62, blue: 0.70)
        case .alternating:    return Color(red: 0.74, green: 0.50, blue: 0.74)
        }
    }

    static func surface(for rhythm: LightRhythm) -> Color {
        tint(for: rhythm).opacity(0.12)
    }

    static func backdropName(for region: FamousLighthouse.Region) -> String {
        switch region {
        case .atlantic:      return "Backdrops/bd-coastline"
        case .mediterranean: return "Backdrops/bd-lens"
        case .pacific:       return "Backdrops/bd-horizon"
        case .baltic:        return "Backdrops/bd-buoys"
        case .arctic:        return "Backdrops/bd-anchor"
        case .southern:      return "Backdrops/bd-rigging"
        }
    }

    static func regionHero(for region: FamousLighthouse.Region) -> String {
        switch region {
        case .atlantic:      return "Regions/region-atlantic"
        case .mediterranean: return "Regions/region-mediterranean"
        case .pacific:       return "Regions/region-pacific"
        case .baltic:        return "Regions/region-baltic"
        case .arctic:        return "Regions/region-arctic"
        case .southern:      return "Regions/region-southern"
        }
    }
}
