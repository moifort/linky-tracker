import SwiftUI

struct KwhLabel: View {
    let value: Double
    let fontSize: Font

    init(_ value: Double, fontSize: Font = .body) {
        self.value = value
        self.fontSize = fontSize
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 2) {
            Text(String(format: "%.1f", value))
                .font(fontSize)
                .fontWeight(.semibold)
            Text("kWh")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        KwhLabel(12.5)
        KwhLabel(345.8, fontSize: .title)
        KwhLabel(0.3, fontSize: .caption)
    }
    .padding()
}
