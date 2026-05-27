import SwiftUI

struct DecodeScreen: View {
    @EnvironmentObject private var log: LightLog
    @State private var raw: String = "Fl(2+1) W 15s"
    @State private var character: LightCharacter? = nil
    @State private var errorText: String? = nil

    @State private var pulseIndex: Int = 0
    @State private var pulseTimer: Timer? = nil

    private let suggestions: [String] = [
        "Fl(2+1) W 15s",
        "Iso R 6s",
        "Oc(3) WRG 10s",
        "VQ G 1s",
        "LFl W 12s",
        "Mo(K) W 8s"
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    inputCard
                    if let character {
                        decodedCard(character)
                        pulseCard(character)
                        descriptionCard(character)
                    } else if let errorText {
                        errorCard(errorText)
                    } else {
                        EmptyStateBox(symbol: "lightbulb",
                                      titleKey: "decode.empty.title",
                                      messageKey: "decode.empty.body")
                    }
                    suggestionsCard
                    if !log.recent.isEmpty { recentCard }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 16)
            }
            .background(LightCanvas(opacity: 0.32))
            .navigationTitle("tab.decode")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear { decode() }
        .onDisappear { stopPulse() }
    }

    private var inputCard: some View {
        RoundedCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("decode.input.label").upperLabel()
                HStack {
                    TextField("decode.input.placeholder", text: $raw)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                        .font(.system(.title3, design: .monospaced).weight(.semibold))
                        .onSubmit { decode() }
                    if !raw.isEmpty {
                        Button { raw = "" } label: {
                            Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                        }
                    }
                }
                HStack {
                    Button {
                        decode()
                        Haptics.tap(.soft)
                    } label: {
                        Label("decode.action", systemImage: "wand.and.stars")
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Palette.accent, in: Capsule())
                            .foregroundStyle(.white)
                    }
                    Spacer(minLength: 8)
                    if let pasted = ClipboardHelper.paste(), pasted.count < 60, !pasted.isEmpty {
                        Button {
                            raw = pasted
                            decode()
                        } label: {
                            Label("decode.paste", systemImage: "doc.on.clipboard")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Palette.accent)
                        }
                    }
                }
            }
        }
    }

    private func decodedCard(_ ch: LightCharacter) -> some View {
        RoundedCard(tinted: LightAccent.surface(for: ch.rhythm)) {
            VStack(alignment: .leading, spacing: 10) {
                Text("decode.parsed.title").upperLabel()
                HStack(spacing: 10) {
                    Text(ch.rhythm.abbreviation)
                        .font(.system(.title, design: .rounded).weight(.heavy))
                        .foregroundStyle(LightAccent.tint(for: ch.rhythm))
                    if !ch.group.isEmpty {
                        Text(ch.groupDescription)
                            .font(.title3.weight(.bold))
                            .foregroundStyle(.primary)
                    }
                    Spacer()
                    HStack(spacing: 6) {
                        ForEach(Array(ch.colors.enumerated()), id: \.offset) { _, color in
                            Circle()
                                .fill(color.swiftColor)
                                .frame(width: 16, height: 16)
                                .overlay(Circle().stroke(Color.black.opacity(0.15), lineWidth: 0.5))
                        }
                    }
                }
                HStack(spacing: 14) {
                    StatBadgePill(symbol: "timer", labelKey: "decode.period", value: formatPeriod(ch.periodSeconds))
                    StatBadgePill(symbol: "circle.dotted", labelKey: "decode.bursts", value: ch.group.isEmpty ? "1" : ch.group.map(String.init).joined(separator: "+"))
                }
                Button {
                    ClipboardHelper.copy(ch.compactCode)
                } label: {
                    Label("decode.copy", systemImage: "doc.on.doc")
                        .font(.caption.weight(.semibold))
                }
                .buttonStyle(.borderless)
                .padding(.top, 2)
            }
        }
    }

    private func pulseCard(_ ch: LightCharacter) -> some View {
        let active = ch.phases.indices.contains(pulseIndex) ? ch.phases[pulseIndex] : LightPhase(kind: .off, duration: 1)
        let dotColor = active.kind == .on ? ch.colors.first?.swiftColor ?? .white : Color.black.opacity(0.55)
        return RoundedCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("decode.pulse.title").upperLabel()
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Palette.nightSea)
                    Circle()
                        .fill(dotColor)
                        .frame(width: 56, height: 56)
                        .shadow(color: dotColor.opacity(active.kind == .on ? 0.8 : 0), radius: 24)
                        .animation(.easeInOut(duration: 0.16), value: pulseIndex)
                }
                .frame(height: 110)
                .onAppear { startPulse(for: ch) }
                .onChange(of: ch.rawCode) { _ in startPulse(for: ch) }
                Text(phaseHint(active))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func descriptionCard(_ ch: LightCharacter) -> some View {
        RoundedCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("decode.plain.title").upperLabel()
                ForEach(LightParser.describe(ch), id: \.self) { line in
                    HStack(alignment: .top, spacing: 8) {
                        Circle().fill(Palette.accent).frame(width: 6, height: 6).padding(.top, 7)
                        Text(line)
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }

    private func errorCard(_ message: String) -> some View {
        RoundedCard(tinted: Color.red.opacity(0.10)) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
                    .font(.title3)
                VStack(alignment: .leading, spacing: 4) {
                    Text("decode.error.title")
                        .font(.headline)
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var suggestionsCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader("decode.suggestions.title")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(suggestions, id: \.self) { code in
                        ChipButton(verbatim: code, symbol: "play.fill") {
                            raw = code
                            decode()
                        }
                    }
                }
            }
        }
    }

    private var recentCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader("decode.recent.title")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(log.recent) { memo in
                        ChipButton(verbatim: memo.rawCode, symbol: "clock") {
                            raw = memo.rawCode
                            decode()
                        }
                    }
                }
            }
        }
    }

    private func decode() {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            character = nil
            errorText = nil
            return
        }
        do {
            let parsed = try LightParser.parse(trimmed)
            character = parsed
            errorText = nil
            log.rememberDecode(trimmed)
        } catch let failure as LightParser.Failure {
            character = nil
            errorText = failure.errorDescription
        } catch {
            character = nil
            errorText = NSLocalizedString("parser.error.invalid", comment: "")
        }
    }

    private func startPulse(for ch: LightCharacter) {
        stopPulse()
        guard !ch.phases.isEmpty else { return }
        pulseIndex = 0
        scheduleNext(ch)
    }

    private func scheduleNext(_ ch: LightCharacter) {
        guard ch.phases.indices.contains(pulseIndex) else { return }
        let phase = ch.phases[pulseIndex]
        pulseTimer = Timer.scheduledTimer(withTimeInterval: max(0.05, phase.duration), repeats: false) { _ in
            DispatchQueue.main.async {
                pulseIndex = (pulseIndex + 1) % max(ch.phases.count, 1)
                scheduleNext(ch)
            }
        }
    }

    private func stopPulse() {
        pulseTimer?.invalidate()
        pulseTimer = nil
    }

    private func phaseHint(_ phase: LightPhase) -> String {
        let key = phase.kind == .on ? "decode.pulse.on" : "decode.pulse.off"
        return NSLocalizedString(key, comment: "")
    }

    private func formatPeriod(_ value: Double) -> String {
        if value == 0 { return "—" }
        if value == floor(value) { return "\(Int(value)) s" }
        return String(format: "%.1f s", value)
    }
}

private struct StatBadgePill: View {
    let symbol: String
    let labelKey: LocalizedStringKey
    let value: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: symbol).foregroundStyle(Palette.accent)
            VStack(alignment: .leading, spacing: 1) {
                Text(labelKey)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.subheadline.weight(.bold))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Capsule().fill(Palette.chipFill))
    }
}
