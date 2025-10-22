import Foundation

final class DependencyContainer: ObservableObject {
  let backendMode: BackendMode
  let captureRepository: any CaptureRepository
  let audioManager: AudioCaptureManager
  let transcriptService: any TranscriptService
  let summaryService: any SummaryService
  let companionService: any CompanionService
  let emotionAnalyzer: EmotionAnalyzer
  let growthAnalyticsService: GrowthAnalyticsService
  var backendClient: BackendClient? = nil

  init(backendMode: BackendMode,
       captureRepository: any CaptureRepository,
       audioManager: AudioCaptureManager,
       transcriptService: any TranscriptService,
       summaryService: any SummaryService,
       companionService: any CompanionService,
       emotionAnalyzer: EmotionAnalyzer,
       growthAnalyticsService: GrowthAnalyticsService) {
    self.backendMode = backendMode
    self.captureRepository = captureRepository
    self.audioManager = audioManager
    self.transcriptService = transcriptService
    self.summaryService = summaryService
    self.companionService = companionService
    self.emotionAnalyzer = emotionAnalyzer
    self.growthAnalyticsService = growthAnalyticsService
    if case let .localServer(url) = backendMode {
      backendClient = BackendClient(baseURL: url)
    }
  }

  static func bootstrap() -> DependencyContainer {
    let audioManager = AudioCaptureManager()
    let transcript = LocalTranscriptService()
    let summary = LocalSummaryService()
    let companion = LocalCompanionService()
    let emotionAnalyzer = EmotionAnalyzer()
    let growthAnalytics = GrowthAnalyticsService(emotionAnalyzer: emotionAnalyzer)

    let env = ProcessInfo.processInfo.environment
    let urlString = env["LOCAL_BACKEND_URL"] ?? "http://localhost:8001/"
    let useRemote = URL(string: urlString) != nil

    if useRemote, let base = URL(string: urlString) {
      let repository = RemoteCaptureRepository(baseURL: base)
      return DependencyContainer(backendMode: BackendMode.localServer(base),
                                 captureRepository: repository,
                                 audioManager: audioManager,
                                 transcriptService: transcript,
                                 summaryService: summary,
                                 companionService: companion,
                                 emotionAnalyzer: emotionAnalyzer,
                                 growthAnalyticsService: growthAnalytics)
    } else {
      let repository = InMemoryCaptureRepository(seed: MockData.seedCaptures())
      return DependencyContainer(backendMode: BackendMode.embedded,
                                 captureRepository: repository,
                                 audioManager: audioManager,
                                 transcriptService: transcript,
                                 summaryService: summary,
                                 companionService: companion,
                                 emotionAnalyzer: emotionAnalyzer,
                                 growthAnalyticsService: growthAnalytics)
    }
  }
}
