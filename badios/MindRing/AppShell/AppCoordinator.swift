import Combine
import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject {
  enum Route: Hashable {
    case sessionDetail(Session.ID)
    case alex
    case deepDive
    case growth
  }

  @Published var path: [Route] = []
  let dataStore: AppDataStore
  let dependencies: DependencyContainer

  init(dataStore: AppDataStore, dependencies: DependencyContainer) {
    self.dataStore = dataStore
    self.dependencies = dependencies
  }

  func openSession(_ session: Session) {
    path.append(.sessionDetail(session.id))
  }

  func openAlex() {
    path.append(.alex)
  }

  func openDeepDive() {
    path.append(.deepDive)
  }

  func openGrowth() {
    path.append(.growth)
  }
}
