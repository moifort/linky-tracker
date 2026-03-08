import SwiftUI

struct TrendBadge: View {
    let percent: Double
    let showArrow: Bool

    init(percent: Double, showArrow: Bool = true) {
        self.percent = percent
        self.showArrow = showArrow
    }

    private var isPositive: Bool { percent > 0 }
    private var color: Color { isPositive ? .red : .green }
    private var arrow: String { isPositive ? "arrow.up.right" : "arrow.down.right" }

    var body: some View {
        HStack(spacing: 2) {
            if showArrow {
                Image(systemName: arrow)
                    .font(.caption2)
            }
            Text(String(format: "%+.1f%%", percent))
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundStyle(color)
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(color.opacity(0.12), in: Capsule())
    }
}

#Preview {
    VStack(spacing: 12) {
        TrendBadge(percent: 12.5)
        TrendBadge(percent: -8.3)
        TrendBadge(percent: 0)
        TrendBadge(percent: -15.2, showArrow: false)
    }
    .padding()
}
