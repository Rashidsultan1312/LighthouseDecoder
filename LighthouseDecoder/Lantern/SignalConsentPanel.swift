import SwiftUI

struct SignalConsentPanel: View {
    let notice: URL
    let onLight: () -> Void
    @State private var lit = false

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            VStack(spacing: 16) {
                VStack(spacing: 6) {
                    Text("gate.welcome.title")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                    Text("gate.welcome.subtitle")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 26)
                }
                .padding(.top, 28)

                SignalFrame(glow: notice, ephemeral: true)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                    )
                    .padding(.horizontal, 16)

                Button(action: { lit.toggle() }) {
                    HStack(spacing: 10) {
                        Image(systemName: lit ? "checkmark.square.fill" : "square")
                            .font(.system(size: 22))
                            .foregroundStyle(lit ? Color.accentColor : Color.secondary)
                        Text("gate.privacy.agree")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.primary)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 16)

                Button(action: onLight) {
                    Text("gate.privacy.continue")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
                .disabled(!lit)
                .opacity(lit ? 1 : 0.4)
                .padding(.horizontal, 16)
                .padding(.bottom, 22)
            }
        }
        .interactiveDismissDisabled(true)
    }
}
