import SwiftUI
import UIKit

struct SessionDetailView: View {
  @EnvironmentObject private var coordinator: AppCoordinator
  @StateObject private var viewModel: SessionDetailViewModel

  init(viewModel: SessionDetailViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    List {
      Section(header: Text("Key Takeaways")) {
        ForEach(viewModel.session.highlights) { highlight in
          Text(highlight.summary)
        }
        Button("Edit Summary") {}
      }

      Section(header: Text("AI Tags")) {
        FlowLayout(items: viewModel.session.tags) { tag in
          Text(tag)
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(MindRingPalette.fog)
            .clipShape(Capsule())
        }
        Button("Add Tag") {}
      }

      Section(header: Text("Next Step")) {
        Button(viewModel.session.nextStep) {
          coordinator.openDeepDive()
        }
      }
    }
    .navigationTitle(viewModel.session.title)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("Play") {}
      }
    }
  }
}

struct FlowLayout<Items: RandomAccessCollection, Content: View>: View where Items.Element: Hashable {
  private let items: Items
  private let content: (Items.Element) -> Content

  init(items: Items, @ViewBuilder content: @escaping (Items.Element) -> Content) {
    self.items = items
    self.content = content
  }

  var body: some View {
    FlexibleView(items: Array(items), spacing: 8, alignment: .leading, content: content)
  }
}

struct FlexibleView<Items: Collection, Content: View>: View where Items.Element: Hashable {
  let items: [Items.Element]
  let spacing: CGFloat
  let alignment: HorizontalAlignment
  let content: (Items.Element) -> Content

  var body: some View {
    VStack(alignment: alignment, spacing: spacing) {
      ForEach(computeRows(), id: \.self) { row in
        HStack(spacing: spacing) {
          ForEach(row, id: \.self) { element in
            content(element)
          }
        }
      }
    }
  }

  private func computeRows() -> [[Items.Element]] {
    var rows: [[Items.Element]] = [[]]
    var currentWidth: CGFloat = 0
    let maxWidth: CGFloat = UIScreen.main.bounds.width - 64

    for element in items {
      let elementWidth = CGFloat((String(describing: element).count * 8) + 32)
      if currentWidth + elementWidth > maxWidth {
        rows.append([])
        currentWidth = 0
      }
      rows[rows.count - 1].append(element)
      currentWidth += elementWidth + spacing
    }

    return rows
  }
}
