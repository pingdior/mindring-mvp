import Foundation

protocol CompanionService {
  func prompts(for session: Session) async -> [AlexPrompt]
}

struct AlexPrompt: Identifiable, Hashable {
  let id = UUID()
  let text: String
}

struct LocalCompanionService: CompanionService {
  private let promptDeck: [String] = [
    "What part of this story feels most energised right now?",
    "Which partner can amplify this momentum today?",
    "If the risk landed tomorrow, what safeguard helps future you?",
    "How will today’s insight shape the next reflection?"
  ]

  func prompts(for session: Session) async -> [AlexPrompt] {
    let rotated = promptDeck.rotated(by: Int.random(in: 0..<promptDeck.count))
    return Array(rotated.prefix(3)).map { AlexPrompt(text: $0) }
  }
}

private extension Array {
  func rotated(by offset: Int) -> [Element] {
    guard !isEmpty else { return self }
    let index = offset % count
    return Array(self[index...] + self[..<index])
  }
}
