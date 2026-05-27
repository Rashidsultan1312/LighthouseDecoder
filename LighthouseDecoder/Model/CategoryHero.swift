import Foundation

enum HeroBackdrop {
    static let names: [String] = [
        "Backdrops/bd-coastline",
        "Backdrops/bd-fresnel",
        "Backdrops/bd-keeper-house",
        "Backdrops/bd-foghorn",
        "Backdrops/bd-buoys",
        "Backdrops/bd-charting",
        "Backdrops/bd-lens",
        "Backdrops/bd-nightsea",
        "Backdrops/bd-binnacle",
        "Backdrops/bd-rigging",
        "Backdrops/bd-knotwork",
        "Backdrops/bd-compass",
        "Backdrops/bd-anchor",
        "Backdrops/bd-horizon"
    ]

    static let primary = "Backdrops/bd-coastline"

    static func named(forIndex index: Int) -> String {
        let safe = ((index % names.count) + names.count) % names.count
        return names[safe]
    }
}
