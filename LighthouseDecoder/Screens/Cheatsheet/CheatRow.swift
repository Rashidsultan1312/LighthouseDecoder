import SwiftUI

struct CheatLineRow: View {
    let labelKey: LocalizedStringKey
    let value: String

    var body: some View {
        HStack {
            Text(labelKey).font(.subheadline)
            Spacer()
            Text(value).font(.subheadline.weight(.semibold))
        }
    }
}
