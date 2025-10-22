import Foundation

struct Capture: Identifiable, Hashable {
  enum Emotion: String, CaseIterable, Identifiable {
    case focused
    case energized
    case reflective
    case uncertain
    case calm

    var id: String { rawValue }
    var label: String {
      rawValue.capitalized
    }
  }

  let id: UUID
  var title: String
  var createdAt: Date
  var duration: TimeInterval
  var emotion: Emotion
  var transcript: String
  var tags: [String]

  init(id: UUID = UUID(), title: String, createdAt: Date, duration: TimeInterval, emotion: Emotion, transcript: String, tags: [String]) {
    self.id = id
    self.title = title
    self.createdAt = createdAt
    self.duration = duration
    self.emotion = emotion
    self.transcript = transcript
    self.tags = tags
  }
}
