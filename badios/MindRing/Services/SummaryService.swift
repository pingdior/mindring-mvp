import Foundation

protocol SummaryService {
  func generateHighlight(for capture: Capture) async throws -> StoryHighlight
}

struct LocalSummaryService: SummaryService {
  func generateHighlight(for capture: Capture) async throws -> StoryHighlight {
    let sentences = capture.transcript.split(separator: ".").map { String($0).trimmingCharacters(in: .whitespaces) }
    let summary = sentences.prefix(3).joined(separator: ". ")
    let tags = Array(Set(capture.tags)).prefix(4)
    return StoryHighlight(summary: summary.isEmpty ? capture.transcript : summary,
                          tags: Array(tags))
  }
}
