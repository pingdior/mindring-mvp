import Foundation

enum MockData {
  static func seed() -> (captures: [Capture], highlights: [StoryHighlight], sessions: [Session], metrics: [GrowthMetric], topEmotion: Capture.Emotion) {
    let capture = Capture(title: "Sprint Alignment",
                          createdAt: Date().addingTimeInterval(-3600),
                          duration: 138,
                          emotion: .focused,
                          transcript: "We aligned on hidden data risk. Next we co-create outreach.",
                          tags: ["Strategy", "Risk"])

    let highlight = StoryHighlight(summary: "Hidden risk flagged; prepare outreach; ready for reflection",
                                   tags: ["Strategy", "Risk", "Reflection"])

    let session = Session(title: "Sprint Alignment",
                          subtitle: "Hidden data risk; prepare Alex handoff",
                          captures: [capture],
                          highlights: [highlight],
                          tags: ["Strategy", "Risk"],
                          nextStep: "Send to Today’s Deep Dive")

    let metrics = [
      GrowthMetric(category: .ideaFlow, score: 0.76, trend: 0.04, notes: "Momentum holding steady"),
      GrowthMetric(category: .integration, score: 0.63, trend: 0.02, notes: "Wary but balanced"),
      GrowthMetric(category: .selfAwareness, score: 0.81, trend: 0.05, notes: "Emotion check-ins consistent")
    ]

    return ([capture], [highlight], [session], metrics, capture.emotion)
  }

  static func seedCaptures() -> [Capture] {
    seed().captures
  }
}
