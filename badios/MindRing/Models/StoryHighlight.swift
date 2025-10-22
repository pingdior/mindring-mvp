import Foundation

struct StoryHighlight: Identifiable, Hashable {
  let id: UUID
  var summary: String
  var tags: [String]

  init(id: UUID = UUID(), summary: String, tags: [String]) {
    self.id = id
    self.summary = summary
    self.tags = tags
  }
}
