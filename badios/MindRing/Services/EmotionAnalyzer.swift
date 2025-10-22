import Foundation

struct EmotionAnalyzer {
  func dominantEmotion(from transcript: String) -> Capture.Emotion {
    let lowercased = transcript.lowercased()
    if lowercased.contains("risk") || lowercased.contains("worry") {
      return .uncertain
    }
    if lowercased.contains("excited") || lowercased.contains("energy") {
      return .energized
    }
    if lowercased.contains("focus") {
      return .focused
    }
    if lowercased.contains("reflect") {
      return .reflective
    }
    return .calm
  }
}

struct GrowthAnalyticsService {
  let emotionAnalyzer: EmotionAnalyzer

  func topEmotion(from captures: [Capture]) -> Capture.Emotion? {
    let counts = captures.reduce(into: [Capture.Emotion: Int]()) { partialResult, capture in
      partialResult[capture.emotion, default: 0] += 1
    }
    return counts.max(by: { $0.value < $1.value })?.key
  }

  func trend(for metrics: [GrowthMetric]) -> Double {
    guard metrics.count > 1 else { return 0 }
    let sorted = metrics.sorted(by: { $0.score < $1.score })
    guard let first = sorted.first?.score, let last = sorted.last?.score else { return 0 }
    return last - first
  }
}
