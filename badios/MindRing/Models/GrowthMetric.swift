import Foundation

struct GrowthMetric: Identifiable, Hashable {
  enum Category: String, CaseIterable, Identifiable {
    case ideaFlow
    case integration
    case selfAwareness

    var id: String { rawValue }
    var title: String {
      switch self {
      case .ideaFlow: return "Idea Flow"
      case .integration: return "Integration"
      case .selfAwareness: return "Self-Awareness"
      }
    }
  }

  let id: UUID
  var category: Category
  var score: Double
  var trend: Double
  var notes: String

  init(id: UUID = UUID(), category: Category, score: Double, trend: Double, notes: String) {
    self.id = id
    self.category = category
    self.score = score
    self.trend = trend
    self.notes = notes
  }
}
