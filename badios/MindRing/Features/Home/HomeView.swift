import SwiftUI

struct HomeView: View {
  @EnvironmentObject private var coordinator: AppCoordinator
  @EnvironmentObject private var store: AppDataStore
  @EnvironmentObject private var dependencies: DependencyContainer
  @StateObject private var viewModel: HomeViewModel
  @State private var showCapture = false

  init(viewModel: HomeViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    ZStack(alignment: .bottom) {
      ScrollView {
        VStack(alignment: .leading, spacing: 24) {
          header
          growthCompass
          sessionsStream
        }
        .padding()
      }

      FloatingActionBar {
        showCapture.toggle()
      } onAlex: {
        coordinator.openAlex()
      }
      .padding(.bottom, 24)
    }
    .sheet(isPresented: $showCapture) {
      CaptureModalView(audioManager: dependencies.audioManager,
                       transcriptService: dependencies.transcriptService) { capture in
        store.recordCapture(capture)
      }
      .presentationDetents([.medium, .large])
    }
    .navigationTitle("Today’s Growth Compass")
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(action: coordinator.openGrowth) {
          Image(systemName: "leaf.fill")
        }
      }
    }
  }

  private var header: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Top Emotion: \(viewModel.topEmotion.label)")
        .font(.footnote)
        .foregroundColor(MindRingPalette.muted)
      Text("Capture in 2s → Instant feedback → Today’s Deep Dive")
        .font(.headline)
    }
  }

  private var growthCompass: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Growth Compass")
        .font(.title3)
        .fontWeight(.bold)

      ForEach(viewModel.growthMetrics) { metric in
        CompassGauge(metric: metric)
      }
    }
    .padding()
    .background(.ultraThinMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 20))
  }

  private var sessionsStream: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Text("Recent Sessions")
          .font(.title3)
          .fontWeight(.bold)
        Spacer()
        Text("\(viewModel.sessions.count)")
          .font(.subheadline)
          .padding(.horizontal, 12)
          .padding(.vertical, 6)
          .background(MindRingPalette.fog)
          .clipShape(Capsule())
      }

      ForEach(viewModel.sessions) { session in
        Button {
          coordinator.openSession(session)
        } label: {
          sessionCard(session)
        }
        .buttonStyle(PlainButtonStyle())
      }
    }
  }

  private func sessionCard(_ session: Session) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(session.title)
        .font(.headline)
      Text(session.subtitle)
        .font(.subheadline)
        .foregroundColor(MindRingPalette.muted)

      HStack {
        ForEach(session.tags.prefix(3), id: \.self) { tag in
          Text(tag)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(MindRingPalette.fog)
            .clipShape(Capsule())
        }
      }

      Divider()

      HStack {
        Image(systemName: "arrow.up.right")
        Text(session.nextStep)
          .font(.subheadline)
        Spacer()
        Image(systemName: "chevron.right")
      }
      .foregroundColor(MindRingPalette.moss)
    }
    .padding()
    .background(.regularMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 18))
    .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
  }
}
