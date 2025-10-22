import Foundation

@MainActor
final class AlexCompanionViewModel: ObservableObject {
  @Published var prompts: [AlexPrompt] = []
  @Published var feelings: [Capture.Emotion] = Capture.Emotion.allCases
  @Published var selectedFeeling: Capture.Emotion?

  func loadPrompts(using service: any CompanionService, session: Session) async {
    let items = await service.prompts(for: session)
    prompts = items
  }
}
