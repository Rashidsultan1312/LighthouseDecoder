import Foundation

struct IALATerm: Identifiable, Hashable {
    var id: String { abbreviation }
    let abbreviation: String
    let titleKey: String
    let descriptionKey: String
    let category: Category

    enum Category: String, CaseIterable, Identifiable {
        case rhythm
        case color
        case visibility
        case structure
        case buoyage

        var id: String { rawValue }
        var titleKey: String { "iala.cat.\(rawValue)" }
    }
}

enum IALACatalog {
    static let all: [IALATerm] = [
        .init(abbreviation: "Fl",   titleKey: "iala.fl.title",   descriptionKey: "iala.fl.body",   category: .rhythm),
        .init(abbreviation: "LFl",  titleKey: "iala.lfl.title",  descriptionKey: "iala.lfl.body",  category: .rhythm),
        .init(abbreviation: "Iso",  titleKey: "iala.iso.title",  descriptionKey: "iala.iso.body",  category: .rhythm),
        .init(abbreviation: "Oc",   titleKey: "iala.oc.title",   descriptionKey: "iala.oc.body",   category: .rhythm),
        .init(abbreviation: "Q",    titleKey: "iala.q.title",    descriptionKey: "iala.q.body",    category: .rhythm),
        .init(abbreviation: "VQ",   titleKey: "iala.vq.title",   descriptionKey: "iala.vq.body",   category: .rhythm),
        .init(abbreviation: "UQ",   titleKey: "iala.uq.title",   descriptionKey: "iala.uq.body",   category: .rhythm),
        .init(abbreviation: "Mo",   titleKey: "iala.mo.title",   descriptionKey: "iala.mo.body",   category: .rhythm),
        .init(abbreviation: "F",    titleKey: "iala.f.title",    descriptionKey: "iala.f.body",    category: .rhythm),
        .init(abbreviation: "Al",   titleKey: "iala.al.title",   descriptionKey: "iala.al.body",   category: .rhythm),

        .init(abbreviation: "W",    titleKey: "iala.color.w.title", descriptionKey: "iala.color.w.body", category: .color),
        .init(abbreviation: "R",    titleKey: "iala.color.r.title", descriptionKey: "iala.color.r.body", category: .color),
        .init(abbreviation: "G",    titleKey: "iala.color.g.title", descriptionKey: "iala.color.g.body", category: .color),
        .init(abbreviation: "Y",    titleKey: "iala.color.y.title", descriptionKey: "iala.color.y.body", category: .color),
        .init(abbreviation: "B",    titleKey: "iala.color.b.title", descriptionKey: "iala.color.b.body", category: .color),
        .init(abbreviation: "V",    titleKey: "iala.color.v.title", descriptionKey: "iala.color.v.body", category: .color),

        .init(abbreviation: "M",    titleKey: "iala.vis.m.title",   descriptionKey: "iala.vis.m.body",   category: .visibility),
        .init(abbreviation: "nm",   titleKey: "iala.vis.nm.title",  descriptionKey: "iala.vis.nm.body",  category: .visibility),
        .init(abbreviation: "Sec",  titleKey: "iala.vis.sec.title", descriptionKey: "iala.vis.sec.body", category: .visibility),
        .init(abbreviation: "Hor",  titleKey: "iala.vis.hor.title", descriptionKey: "iala.vis.hor.body", category: .visibility),

        .init(abbreviation: "Lt",   titleKey: "iala.struct.lt.title", descriptionKey: "iala.struct.lt.body", category: .structure),
        .init(abbreviation: "Tr",   titleKey: "iala.struct.tr.title", descriptionKey: "iala.struct.tr.body", category: .structure),
        .init(abbreviation: "Bn",   titleKey: "iala.struct.bn.title", descriptionKey: "iala.struct.bn.body", category: .structure),
        .init(abbreviation: "Ra",   titleKey: "iala.struct.ra.title", descriptionKey: "iala.struct.ra.body", category: .structure),
        .init(abbreviation: "RW",   titleKey: "iala.struct.rw.title", descriptionKey: "iala.struct.rw.body", category: .structure),

        .init(abbreviation: "BY",   titleKey: "iala.buoy.by.title",   descriptionKey: "iala.buoy.by.body",   category: .buoyage),
        .init(abbreviation: "RG",   titleKey: "iala.buoy.rg.title",   descriptionKey: "iala.buoy.rg.body",   category: .buoyage),
        .init(abbreviation: "Card", titleKey: "iala.buoy.card.title", descriptionKey: "iala.buoy.card.body", category: .buoyage),
        .init(abbreviation: "PA",   titleKey: "iala.buoy.pa.title",   descriptionKey: "iala.buoy.pa.body",   category: .buoyage),
        .init(abbreviation: "Wk",   titleKey: "iala.buoy.wk.title",   descriptionKey: "iala.buoy.wk.body",   category: .buoyage)
    ]

    static func by(_ category: IALATerm.Category) -> [IALATerm] {
        all.filter { $0.category == category }
    }

    static func search(_ query: String) -> [IALATerm] {
        let trimmed = query.trimmingCharacters(in: .whitespaces).lowercased()
        guard !trimmed.isEmpty else { return all }
        return all.filter { term in
            term.abbreviation.lowercased().contains(trimmed)
                || NSLocalizedString(term.titleKey, comment: "").lowercased().contains(trimmed)
        }
    }
}
