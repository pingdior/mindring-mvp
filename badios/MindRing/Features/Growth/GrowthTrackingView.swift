import SwiftUI

struct GrowthTrackingView: View {
  @StateObject private var viewModel: GrowthTrackingViewModel

  init(viewModel: GrowthTrackingViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    List {
      Section(header: Text("24h Metrics")) {
        ForEach(viewModel.metrics) { metric in
          CompassGauge(metric: metric)
            .listRowInsets(EdgeInsets())
        }
      }
    }
    .listStyle(.insetGrouped)
    .navigationTitle("Growth Tracking")
  }
}
