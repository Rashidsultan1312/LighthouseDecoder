import SwiftUI

enum AppearanceMode: String, CaseIterable, Identifiable, Codable {
    case system
    case dark
    case light

    var id: String { rawValue }

    var label: LocalizedStringKey {
        switch self {
        case .system: return "appearance.system"
        case .dark:   return "appearance.dark"
        case .light:  return "appearance.light"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .dark:   return .dark
        case .light:  return .light
        }
    }
}

struct LighthouseEntry: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var country: String
    var sightingDate: Date
    var note: String
    var rawCode: String?

    init(id: UUID = UUID(),
         name: String,
         country: String,
         sightingDate: Date = Date(),
         note: String = "",
         rawCode: String? = nil) {
        self.id = id
        self.name = name
        self.country = country
        self.sightingDate = sightingDate
        self.note = note
        self.rawCode = rawCode
    }
}

struct DecodeMemo: Identifiable, Codable, Hashable {
    let id: UUID
    let rawCode: String
    let when: Date

    init(id: UUID = UUID(), rawCode: String, when: Date = Date()) {
        self.id = id
        self.rawCode = rawCode
        self.when = when
    }
}

@MainActor
final class LightLog: ObservableObject {
    @Published var appearance: AppearanceMode = .system { didSet { persistAppearance() } }
    @Published var entries: [LighthouseEntry] = [] { didSet { persistEntries() } }
    @Published var recent: [DecodeMemo] = [] { didSet { persistMemos() } }

    private let defaults = UserDefaults.standard
    private let entriesKey = "lh.log.entries"
    private let recentKey  = "lh.log.recent"
    private let appearanceKey = "lh.pref.appearance"

    init() { restore() }

    func rememberDecode(_ raw: String) {
        let memo = DecodeMemo(rawCode: raw)
        var bag = recent.filter { $0.rawCode != raw }
        bag.insert(memo, at: 0)
        if bag.count > 20 { bag = Array(bag.prefix(20)) }
        recent = bag
    }

    func clearRecent() { recent = [] }

    func appendSighting(_ entry: LighthouseEntry) {
        var bag = entries
        bag.insert(entry, at: 0)
        entries = bag
    }

    func update(_ entry: LighthouseEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
    }

    func remove(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
    }

    func wipeAll() {
        entries = []
        recent = []
    }

    var distinctCountries: [String] {
        Array(Set(entries.map { $0.country.trimmingCharacters(in: .whitespaces) }))
            .filter { !$0.isEmpty }
            .sorted()
    }

    func filteredByCountry(_ country: String?) -> [LighthouseEntry] {
        guard let country, !country.isEmpty else { return entries }
        return entries.filter { $0.country == country }
    }

    func exportText() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        var lines: [String] = [NSLocalizedString("export.header", comment: "")]
        for entry in entries {
            let date = formatter.string(from: entry.sightingDate)
            lines.append("• \(entry.name) — \(entry.country) — \(date)")
            if let code = entry.rawCode, !code.isEmpty {
                lines.append("  [\(code)]")
            }
            if !entry.note.isEmpty {
                lines.append("  \(entry.note)")
            }
        }
        return lines.joined(separator: "\n")
    }

    private func persistAppearance() {
        defaults.set(appearance.rawValue, forKey: appearanceKey)
    }

    private func persistEntries() {
        if let data = try? JSONEncoder().encode(entries) {
            defaults.set(data, forKey: entriesKey)
        }
    }

    private func persistMemos() {
        if let data = try? JSONEncoder().encode(recent) {
            defaults.set(data, forKey: recentKey)
        }
    }

    private func restore() {
        if let raw = defaults.string(forKey: appearanceKey),
           let mode = AppearanceMode(rawValue: raw) {
            appearance = mode
        }
        if let data = defaults.data(forKey: entriesKey),
           let decoded = try? JSONDecoder().decode([LighthouseEntry].self, from: data) {
            entries = decoded
        }
        if let data = defaults.data(forKey: recentKey),
           let decoded = try? JSONDecoder().decode([DecodeMemo].self, from: data) {
            recent = decoded
        }
    }
}
