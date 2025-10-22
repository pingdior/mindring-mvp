import Combine
import Foundation

@MainActor
final class AppDataStore: ObservableObject {
  @Published private(set) var sessions: [Session]
  @Published private(set) var captures: [Capture]
  @Published private(set) var highlights: [StoryHighlight]
  @Published private(set) var growthMetrics: [GrowthMetric]
  @Published var topEmotion: Capture.Emotion

  private let repository: any CaptureRepository
  private let summaryService: any SummaryService
  private let compassService: GrowthAnalyticsService

  init(repository: any CaptureRepository, summaryService: any SummaryService, compassService: GrowthAnalyticsService) {
    self.repository = repository
    self.summaryService = summaryService
    self.compassService = compassService

    let seed = MockData.seed()
    sessions = seed.sessions
    captures = seed.captures
    highlights = seed.highlights
    growthMetrics = seed.metrics
    topEmotion = seed.topEmotion
  }

  func refreshHighlights() async {
    guard let capture = captures.first else { return }
    do {
      let highlight = try await summaryService.generateHighlight(for: capture)
      highlights = [highlight]
    } catch {
      // keep existing highlights
    }
  }

  func updateTopEmotion() {
    topEmotion = compassService.topEmotion(from: captures) ?? topEmotion
  }

  func session(with id: Session.ID) -> Session? {
    sessions.first(where: { $0.id == id })
  }

  func recordCapture(_ capture: Capture) {
    captures.insert(capture, at: 0)
    repository.save(capture)
    updateTopEmotion()
  }
}
