import SwiftUI

@main
struct MindRingApp: App {
  @StateObject private var coordinator: AppCoordinator

  init() {
    let dependencies = DependencyContainer.bootstrap()
    let store = AppDataStore(repository: dependencies.captureRepository,
                              summaryService: dependencies.summaryService,
                              compassService: dependencies.growthAnalyticsService)
    _coordinator = StateObject(wrappedValue: AppCoordinator(dataStore: store,
                                                            dependencies: dependencies))
  }

  var body: some Scene {
    WindowGroup {
      CoordinatorView()
        .environmentObject(coordinator)
        .environmentObject(coordinator.dataStore)
        .environmentObject(coordinator.dependencies)
    }
  }
}
