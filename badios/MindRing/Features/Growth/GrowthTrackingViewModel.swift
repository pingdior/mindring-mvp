import Combine
import Foundation

@MainActor
final class GrowthTrackingViewModel: ObservableObject {
  @Published private(set) var metrics: [GrowthMetric] = []

  private var cancellables = Set<AnyCancellable>()

  init(store: AppDataStore) {
    store.$growthMetrics
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in self?.metrics = $0 }
      .store(in: &cancellables)
  }
}
