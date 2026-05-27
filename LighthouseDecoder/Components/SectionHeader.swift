import SwiftUI

struct SectionHeader: View {
    let titleKey: LocalizedStringKey
    let captionKey: LocalizedStringKey?
    var trailing: AnyView? = nil

    init(_ titleKey: LocalizedStringKey,
         caption: LocalizedStringKey? = nil,
         trailing: AnyView? = nil) {
        self.titleKey = titleKey
        self.captionKey = caption
        self.trailing = trailing
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text(titleKey).upperLabel()
                if let caption = captionKey {
                    Text(caption)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                }
            }
            Spacer(minLength: 8)
            if let trailing { trailing }
        }
        .padding(.horizontal, 4)
    }
}
