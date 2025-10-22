import Foundation

final class InMemoryCaptureRepository: CaptureRepository {
  private var storage: [Capture]

  init(seed: [Capture] = []) {
    storage = seed
  }

  func load() -> [Capture] {
    storage
  }

  func save(_ capture: Capture) {
    storage.removeAll(where: { $0.id == capture.id })
    storage.insert(capture, at: 0)
  }
}
