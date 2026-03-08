import SwiftUI

struct EurLabel: View {
    let value: Double
    let fontSize: Font

    init(_ value: Double, fontSize: Font = .body) {
        self.value = value
        self.fontSize = fontSize
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 2) {
            Text(String(format: "%.2f", value))
                .font(fontSize)
                .fontWeight(.semibold)
            Text("€")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        EurLabel(12.50)
        EurLabel(145.80, fontSize: .title)
        EurLabel(0.35, fontSize: .caption)
    }
    .padding()
}
