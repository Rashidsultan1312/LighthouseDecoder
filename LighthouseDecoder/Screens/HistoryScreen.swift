import SwiftUI

struct JournalScreen: View {
    @EnvironmentObject private var log: LightLog
    @State private var showingAdd = false
    @State private var filterCountry: String? = nil
    @State private var editing: LighthouseEntry? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    summaryRow
                    countryStrip
                    if filtered.isEmpty {
                        EmptyStateBox(symbol: "book.closed",
                                      titleKey: "journal.empty.title",
                                      messageKey: "journal.empty.body")
                    } else {
                        VStack(spacing: 12) {
                            ForEach(filtered) { entry in
                                JournalRow(entry: entry)
                                    .onTapGesture { editing = entry }
                            }
                        }
                    }
                    if !log.entries.isEmpty {
                        exportButton
                    }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 16)
            }
            .background(LightCanvas(opacity: 0.32, imageName: "Backdrops/bd-buoys"))
            .navigationTitle("tab.journal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showingAdd = true } label: {
                        Image(systemName: "plus.circle.fill").foregroundStyle(Palette.accent)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAdd) {
            JournalEditor(entry: nil) { saved in
                log.appendSighting(saved)
            }
        }
        .sheet(item: $editing) { entry in
            JournalEditor(entry: entry) { saved in
                log.update(saved)
            }
        }
    }

    private var filtered: [LighthouseEntry] {
        log.filteredByCountry(filterCountry)
    }

    private var summaryRow: some View {
        HStack(spacing: 12) {
            StatBadge(titleKey: "journal.stats.sightings",
                      value: "\(log.entries.count)",
                      symbol: "binoculars.fill",
                      tint: Palette.accent)
            StatBadge(titleKey: "journal.stats.countries",
                      value: "\(log.distinctCountries.count)",
                      symbol: "globe.europe.africa.fill",
                      tint: Color(red: 0.27, green: 0.55, blue: 0.74))
        }
    }

    private var countryStrip: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !log.distinctCountries.isEmpty {
                SectionHeader("journal.filter.title")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ChipButton("journal.filter.all",
                                   symbol: filterCountry == nil ? "checkmark" : nil,
                                   selected: filterCountry == nil) {
                            filterCountry = nil
                        }
                        ForEach(log.distinctCountries, id: \.self) { country in
                            ChipButton(verbatim: country,
                                       symbol: filterCountry == country ? "checkmark" : nil,
                                       selected: filterCountry == country) {
                                filterCountry = filterCountry == country ? nil : country
                            }
                        }
                    }
                }
            }
        }
    }

    private var exportButton: some View {
        Button {
            ClipboardHelper.copy(log.exportText())
        } label: {
            Label("journal.export", systemImage: "square.and.arrow.up")
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Palette.accentSoft, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                .foregroundStyle(Palette.accent)
        }
    }
}

private struct JournalRow: View {
    let entry: LighthouseEntry

    var body: some View {
        RoundedCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "lighthouse.fill")
                        .foregroundStyle(Palette.accent)
                        .padding(8)
                        .background(Palette.accentSoft, in: Circle())
                    VStack(alignment: .leading, spacing: 2) {
                        Text(entry.name).font(.headline)
                        Text(entry.country).font(.subheadline).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(entry.sightingDate, style: .date)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                if let code = entry.rawCode, !code.isEmpty {
                    Text(code)
                        .font(.system(.subheadline, design: .monospaced).weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Palette.accentSoft, in: Capsule())
                        .foregroundStyle(Palette.accent)
                }
                if !entry.note.isEmpty {
                    Text(entry.note).font(.subheadline).foregroundStyle(.primary)
                }
            }
        }
    }
}

private struct JournalEditor: View {
    let entry: LighthouseEntry?
    let onSave: (LighthouseEntry) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var country: String
    @State private var sightingDate: Date
    @State private var note: String
    @State private var rawCode: String

    init(entry: LighthouseEntry?, onSave: @escaping (LighthouseEntry) -> Void) {
        self.entry = entry
        self.onSave = onSave
        _name = State(initialValue: entry?.name ?? "")
        _country = State(initialValue: entry?.country ?? "")
        _sightingDate = State(initialValue: entry?.sightingDate ?? Date())
        _note = State(initialValue: entry?.note ?? "")
        _rawCode = State(initialValue: entry?.rawCode ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("journal.field.name") {
                    TextField("journal.field.name.placeholder", text: $name)
                }
                Section("journal.field.country") {
                    TextField("journal.field.country.placeholder", text: $country)
                        .textInputAutocapitalization(.words)
                }
                Section("journal.field.date") {
                    DatePicker("journal.field.date", selection: $sightingDate, displayedComponents: .date)
                        .labelsHidden()
                }
                Section("journal.field.code") {
                    TextField("journal.field.code.placeholder", text: $rawCode)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                        .font(.system(.body, design: .monospaced))
                }
                Section("journal.field.note") {
                    TextEditor(text: $note).frame(minHeight: 80)
                }
            }
            .navigationTitle(entry == nil ? "journal.add" : "journal.edit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("action.cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("action.save") {
                        let saved = LighthouseEntry(id: entry?.id ?? UUID(),
                                                    name: name.trimmingCharacters(in: .whitespaces),
                                                    country: country.trimmingCharacters(in: .whitespaces),
                                                    sightingDate: sightingDate,
                                                    note: note,
                                                    rawCode: rawCode.isEmpty ? nil : rawCode)
                        onSave(saved)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
