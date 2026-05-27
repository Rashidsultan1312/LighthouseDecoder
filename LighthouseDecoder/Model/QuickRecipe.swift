import Foundation

struct FamousLighthouse: Identifiable, Hashable {
    var id: String { slug }
    let slug: String
    let nameKey: String
    let country: String
    let region: Region
    let approxYear: Int
    let heightMeters: Int
    let characterCode: String
    let storyKey: String

    enum Region: String, CaseIterable, Identifiable {
        case atlantic
        case mediterranean
        case pacific
        case baltic
        case arctic
        case southern

        var id: String { rawValue }
        var titleKey: String { "region.\(rawValue)" }
    }
}

enum FamousLighthousesCatalog {
    static let all: [FamousLighthouse] = [
        .init(slug: "eddystone",          nameKey: "lh.eddystone.name",    country: "United Kingdom", region: .atlantic,      approxYear: 1882, heightMeters: 49, characterCode: "Fl(2) W 10s",      storyKey: "lh.eddystone.story"),
        .init(slug: "fastnet",            nameKey: "lh.fastnet.name",      country: "Ireland",        region: .atlantic,      approxYear: 1904, heightMeters: 54, characterCode: "Fl W 5s",          storyKey: "lh.fastnet.story"),
        .init(slug: "bell-rock",          nameKey: "lh.bellrock.name",     country: "Scotland",       region: .atlantic,      approxYear: 1811, heightMeters: 35, characterCode: "Fl W 5s",          storyKey: "lh.bellrock.story"),
        .init(slug: "tour-de-cordouan",   nameKey: "lh.cordouan.name",     country: "France",         region: .atlantic,      approxYear: 1611, heightMeters: 67, characterCode: "Oc(2+1) WRG 12s",  storyKey: "lh.cordouan.story"),
        .init(slug: "creach",             nameKey: "lh.creach.name",       country: "France",         region: .atlantic,      approxYear: 1863, heightMeters: 54, characterCode: "Fl(2) W 10s",      storyKey: "lh.creach.story"),
        .init(slug: "la-jument",          nameKey: "lh.jument.name",       country: "France",         region: .atlantic,      approxYear: 1911, heightMeters: 47, characterCode: "Fl(3) R 15s",      storyKey: "lh.jument.story"),
        .init(slug: "tower-of-hercules",  nameKey: "lh.hercules.name",     country: "Spain",          region: .atlantic,      approxYear: 100,  heightMeters: 55, characterCode: "Fl(4) W 20s",      storyKey: "lh.hercules.story"),
        .init(slug: "cabo-sao-vicente",   nameKey: "lh.saovicente.name",   country: "Portugal",       region: .atlantic,      approxYear: 1846, heightMeters: 28, characterCode: "Fl W 5s",          storyKey: "lh.saovicente.story"),
        .init(slug: "alexandria-pharos",  nameKey: "lh.pharos.name",       country: "Egypt",          region: .mediterranean, approxYear: -280, heightMeters: 100, characterCode: "F W",             storyKey: "lh.pharos.story"),
        .init(slug: "messina",            nameKey: "lh.messina.name",      country: "Italy",          region: .mediterranean, approxYear: 1934, heightMeters: 35, characterCode: "Fl(3) W 10s",      storyKey: "lh.messina.story"),
        .init(slug: "genova",             nameKey: "lh.genova.name",       country: "Italy",          region: .mediterranean, approxYear: 1543, heightMeters: 77, characterCode: "Fl(2) W 20s",      storyKey: "lh.genova.story"),
        .init(slug: "cape-spartel",       nameKey: "lh.spartel.name",      country: "Morocco",        region: .mediterranean, approxYear: 1864, heightMeters: 24, characterCode: "Oc(4) W 20s",      storyKey: "lh.spartel.story"),
        .init(slug: "yaquina-head",       nameKey: "lh.yaquina.name",      country: "United States",  region: .pacific,       approxYear: 1873, heightMeters: 28, characterCode: "Fl W 14s",         storyKey: "lh.yaquina.story"),
        .init(slug: "point-reyes",        nameKey: "lh.pointreyes.name",   country: "United States",  region: .pacific,       approxYear: 1870, heightMeters: 11, characterCode: "Fl W 5s",          storyKey: "lh.pointreyes.story"),
        .init(slug: "split-point",        nameKey: "lh.splitpoint.name",   country: "Australia",      region: .pacific,       approxYear: 1891, heightMeters: 34, characterCode: "Fl(2) W 12s",      storyKey: "lh.splitpoint.story"),
        .init(slug: "cape-reinga",        nameKey: "lh.reinga.name",       country: "New Zealand",    region: .pacific,       approxYear: 1941, heightMeters: 10, characterCode: "Fl W 12s",         storyKey: "lh.reinga.story"),
        .init(slug: "kjeungskjaer",       nameKey: "lh.kjeungskjaer.name", country: "Norway",         region: .baltic,        approxYear: 1880, heightMeters: 21, characterCode: "Oc(2) WRG 6s",     storyKey: "lh.kjeungskjaer.story"),
        .init(slug: "kopu",               nameKey: "lh.kopu.name",         country: "Estonia",        region: .baltic,        approxYear: 1531, heightMeters: 35, characterCode: "Fl W 10s",         storyKey: "lh.kopu.story"),
        .init(slug: "rubjerg-knude",      nameKey: "lh.rubjerg.name",      country: "Denmark",        region: .baltic,        approxYear: 1900, heightMeters: 23, characterCode: "F W",              storyKey: "lh.rubjerg.story"),
        .init(slug: "svalbard",           nameKey: "lh.svalbard.name",     country: "Norway",         region: .arctic,        approxYear: 1932, heightMeters: 5,  characterCode: "Fl W 3s",          storyKey: "lh.svalbard.story"),
        .init(slug: "cabo-virgenes",      nameKey: "lh.virgenes.name",     country: "Argentina",      region: .southern,      approxYear: 1904, heightMeters: 24, characterCode: "Fl(2) W 10s",      storyKey: "lh.virgenes.story"),
        .init(slug: "cape-agulhas",       nameKey: "lh.agulhas.name",      country: "South Africa",   region: .southern,      approxYear: 1848, heightMeters: 27, characterCode: "Fl W 5s",          storyKey: "lh.agulhas.story")
    ]

    static func byRegion(_ region: FamousLighthouse.Region) -> [FamousLighthouse] {
        all.filter { $0.region == region }
    }

    static func search(_ query: String) -> [FamousLighthouse] {
        let trimmed = query.trimmingCharacters(in: .whitespaces).lowercased()
        guard !trimmed.isEmpty else { return all }
        return all.filter { lh in
            NSLocalizedString(lh.nameKey, comment: "").lowercased().contains(trimmed)
                || lh.country.lowercased().contains(trimmed)
        }
    }
}
