import Combine
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
  @Published private(set) var sessions: [Session] = []
  @Published private(set) var captures: [Capture] = []
  @Published private(set) var growthMetrics: [GrowthMetric] = []
  @Published private(set) var topEmotion: Capture.Emotion = .focused

  private let store: AppDataStore
  private var cancellables = Set<AnyCancellable>()

  init(store: AppDataStore) {
    self.store = store
    sessions = store.sessions
    captures = store.captures
    growthMetrics = store.growthMetrics
    topEmotion = store.topEmotion
    bind()
  }

  func bind() {
    store.$sessions
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in self?.sessions = $0 }
      .store(in: &cancellables)

    store.$captures
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in self?.captures = $0 }
      .store(in: &cancellables)

    store.$growthMetrics
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in self?.growthMetrics = $0 }
      .store(in: &cancellables)

    store.$topEmotion
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in self?.topEmotion = $0 }
      .store(in: &cancellables)
  }
}
