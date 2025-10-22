import SwiftUI

struct AlexCompanionView: View {
  @EnvironmentObject private var coordinator: AppCoordinator
  @EnvironmentObject private var dependencies: DependencyContainer
  @EnvironmentObject private var store: AppDataStore
  @StateObject private var viewModel: AlexCompanionViewModel

  init(viewModel: AlexCompanionViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        Text("Alex notices \(store.topEmotion.label) today.")
          .font(.headline)

        promptSection
        feelingsSection

        Button("Go to Today’s Deep Dive") {
          coordinator.openDeepDive()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(MindRingPalette.moss)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
      }
      .padding()
    }
    .navigationTitle("Alex Companion")
    .task {
      if let session = store.sessions.first {
        await viewModel.loadPrompts(using: dependencies.companionService, session: session)
      }
    }
  }

  private var promptSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Suggested Prompts")
        .font(.title3)
        .fontWeight(.semibold)

      ForEach(viewModel.prompts) { prompt in
        Text(prompt.text)
          .padding()
          .frame(maxWidth: .infinity, alignment: .leading)
          .background(.regularMaterial)
          .clipShape(RoundedRectangle(cornerRadius: 16))
      }
    }
  }

  private var feelingsSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Log Feelings")
        .font(.title3)
        .fontWeight(.semibold)

      WrapView(items: viewModel.feelings, spacing: 10) { feeling in
        ForEach(viewModel.feelings) { feeling in
          Button {
            viewModel.selectedFeeling = feeling
            Task { await dependencies.backendClient?.logEmotion(labels: [feeling.label]) }
            store.topEmotion = feeling
          } label: {
            Text(feeling.label)
              .padding(.horizontal, 12)
              .padding(.vertical, 8)
              .background(viewModel.selectedFeeling == feeling ? MindRingPalette.earth.opacity(0.2) : MindRingPalette.fog)
              .clipShape(Capsule())
          }
        }
      }
    }
  }
}

struct WrapView<Items: RandomAccessCollection, Content: View>: View where Items.Element: Hashable {
  let items: Items
  let spacing: CGFloat
  let content: (Items.Element) -> Content

  init(items: Items, spacing: CGFloat, @ViewBuilder content: @escaping (Items.Element) -> Content) {
    self.items = items
    self.spacing = spacing
    self.content = content
  }

  var body: some View {
    FlexibleView(items: Array(items), spacing: spacing, alignment: .leading, content: content)
  }
}
