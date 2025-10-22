import SwiftUI

struct FloatingActionBar: View {
  let onRecord: () -> Void
  let onAlex: () -> Void

  var body: some View {
    HStack(spacing: 16) {
      Button(action: onRecord) {
        Label("Capture", systemImage: "mic")
          .font(.headline)
          .padding(.horizontal, 16)
          .padding(.vertical, 12)
          .background(LinearGradient(gradient: Gradient(colors: [MindRingPalette.forest, MindRingPalette.moss]), startPoint: .leading, endPoint: .trailing))
          .foregroundColor(.white)
          .clipShape(Capsule())
      }

      Button(action: onAlex) {
        Label("Alex", systemImage: "sparkles")
          .font(.headline)
          .padding(.horizontal, 16)
          .padding(.vertical, 12)
          .background(.thinMaterial)
          .foregroundColor(MindRingPalette.ink)
          .clipShape(Capsule())
      }
    }
    .padding(16)
    .background(.ultraThinMaterial)
    .clipShape(Capsule())
    .shadow(radius: 12, x: 0, y: 6)
  }
}
