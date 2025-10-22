import SwiftUI

enum MindRingPalette {
  static let forest = Color(hex: 0x2f5d3e)
  static let moss = Color(hex: 0x5b8a72)
  static let earth = Color(hex: 0xb97a3c)
  static let fog = Color(hex: 0xf9f6ef)
  static let ink = Color(hex: 0x1f2a24)
  static let muted = Color(hex: 0x6b7068)
}

extension Color {
  init(hex: UInt32, alpha: Double = 1.0) {
    let red = Double((hex & 0xFF0000) >> 16) / 255.0
    let green = Double((hex & 0x00FF00) >> 8) / 255.0
    let blue = Double(hex & 0x0000FF) / 255.0
    self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
  }
}
