import SwiftUI

struct LightCanvas: View {
    var opacity: Double = 0.55
    var imageName: String = HeroBackdrop.primary

    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.97, blue: 0.99)
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(opacity)
                .ignoresSafeArea()
            LinearGradient(colors: [Color.white.opacity(0.78), Color.white.opacity(0.86)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            LinearGradient(colors: [Palette.accent.opacity(0.05), Color.clear],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }
}

struct LightScrim: View {
    let rhythm: LightRhythm

    var body: some View {
        LightAccent.tint(for: rhythm)
            .opacity(0.08)
            .ignoresSafeArea()
    }
}

struct LanternHalo: View {
    let rhythm: LightRhythm

    var body: some View {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .stroke(LightAccent.tint(for: rhythm).opacity(0.22), lineWidth: 1)
    }
}
