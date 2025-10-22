import SwiftUI

struct CoordinatorView: View {
  @EnvironmentObject private var coordinator: AppCoordinator

  var body: some View {
    NavigationStack(path: $coordinator.path) {
      HomeView(viewModel: HomeViewModel(store: coordinator.dataStore))
        .navigationDestination(for: AppCoordinator.Route.self) { route in
          switch route {
          case .sessionDetail(let id):
            if let session = coordinator.dataStore.session(with: id) {
              SessionDetailView(viewModel: SessionDetailViewModel(session: session))
            }
          case .alex:
            AlexCompanionView(viewModel: AlexCompanionViewModel())
          case .deepDive:
            DeepDiveView(viewModel: DeepDiveViewModel())
          case .growth:
            GrowthTrackingView(viewModel: GrowthTrackingViewModel(store: coordinator.dataStore))
          }
        }
    }
  }
}
