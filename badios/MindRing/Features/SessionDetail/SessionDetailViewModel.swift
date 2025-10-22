import Foundation

@MainActor
final class SessionDetailViewModel: ObservableObject {
  @Published private(set) var session: Session

  init(session: Session) {
    self.session = session
  }
}
