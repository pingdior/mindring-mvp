import Foundation

@MainActor
final class DeepDiveViewModel: ObservableObject {
  @Published var reflectionNotes: String = ""
  @Published var completed = false

  func markComplete() {
    completed = true
  }
}
