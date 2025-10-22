import SwiftUI

struct DeepDiveView: View {
  @EnvironmentObject private var coordinator: AppCoordinator
  @EnvironmentObject private var store: AppDataStore
  @EnvironmentObject private var dependencies: DependencyContainer
  @StateObject private var viewModel: DeepDiveViewModel

  init(viewModel: DeepDiveViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    Form {
      Section(header: Text("Today’s Deep Dive")) {
        TextEditor(text: $viewModel.reflectionNotes)
          .frame(minHeight: 160)
      }

      Section {
        Button("Complete Reflection") {
          Task { await dependencies.backendClient?.completeReflection(viewModel.reflectionNotes) }
          viewModel.markComplete()
          store.updateTopEmotion()
        }
      }
    }
  }
}
