import SwiftUI

struct CompassGauge: View {
  let metric: GrowthMetric

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text(metric.category.title)
          .font(.subheadline)
          .fontWeight(.semibold)
        Spacer()
        Text(metric.score, format: .percent.precision(.fractionLength(0)))
          .font(.headline)
      }

      GeometryReader { geometry in
        ZStack(alignment: .leading) {
          Capsule().fill(MindRingPalette.fog)
          Capsule()
            .fill(LinearGradient(colors: [MindRingPalette.moss, MindRingPalette.earth], startPoint: .leading, endPoint: .trailing))
            .frame(width: geometry.size.width * CGFloat(metric.score))
        }
      }
      .frame(height: 12)

      HStack {
        Image(systemName: metric.trend >= 0 ? "arrow.up" : "arrow.down")
          .foregroundColor(metric.trend >= 0 ? MindRingPalette.moss : .red)
        Text(metric.notes)
          .font(.footnote)
          .foregroundColor(MindRingPalette.muted)
      }
    }
    .padding()
    .background(.regularMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }
}
