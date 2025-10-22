import Foundation

protocol CaptureRepository {
  func load() -> [Capture]
  func save(_ capture: Capture)
}
