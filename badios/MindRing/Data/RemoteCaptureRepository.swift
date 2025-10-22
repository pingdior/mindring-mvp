import Foundation

final class RemoteCaptureRepository: CaptureRepository {
  private let client: BackendClient

  init(baseURL: URL) {
    self.client = BackendClient(baseURL: baseURL)
  }

  func load() -> [Capture] {
    // Not used in current flow; keep local store
    return []
  }

  func save(_ capture: Capture) {
    Task { await client.recordSave(from: capture) }
  }
}