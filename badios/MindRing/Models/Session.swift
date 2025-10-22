import Foundation

struct Session: Identifiable, Hashable {
  let id: UUID
  var title: String
  var subtitle: String
  var captures: [Capture]
  var highlights: [StoryHighlight]
  var tags: [String]
  var nextStep: String

  init(id: UUID = UUID(),
       title: String,
       subtitle: String,
       captures: [Capture],
       highlights: [StoryHighlight],
       tags: [String],
       nextStep: String) {
    self.id = id
    self.title = title
    self.subtitle = subtitle
    self.captures = captures
    self.highlights = highlights
    self.tags = tags
    self.nextStep = nextStep
  }
}
