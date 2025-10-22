import Foundation

struct BackendClient {
  let baseURL: URL
  private let session: URLSession = .shared

  func health() async -> Bool {
    let url = baseURL.appendingPathComponent("health")
    do {
      let (data, _) = try await session.data(from: url)
      return (try? JSONSerialization.jsonObject(with: data)) != nil
    } catch { return false }
  }

  func recordSave(from capture: Capture) async {
    let url = baseURL.appendingPathComponent("record/save")
    let body: [String: Any] = [
      "title": capture.title,
      "summary": capture.transcript,
      "source": "recording",
      "emotions": [[capture.emotion.label]],
      "timestamp": ISO8601DateFormatter().string(from: capture.createdAt)
    ]
    await postJSON(url: url, body: body)
  }

  func logEmotion(labels: [String]) async {
    let url = baseURL.appendingPathComponent("emotion/log")
    let body: [String: Any] = [
      "labels": labels,
      "timestamp": ISO8601DateFormatter().string(from: Date())
    ]
    await postJSON(url: url, body: body)
  }

  func completeReflection(_ notes: String) async {
    let url = baseURL.appendingPathComponent("reflection/complete")
    let body: [String: Any] = [
      "notes": notes,
      "date": DateFormatter.yyyyMMdd.string(from: Date())
    ]
    await postJSON(url: url, body: body)
  }

  func fetchSnapshot() async -> (Int, [String])? {
    let url = baseURL.appendingPathComponent("score/snapshot")
    do {
      let (data, _) = try await session.data(from: url)
      if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
         let snapshot = json["snapshot"] as? [String: Any],
         let score = snapshot["selfAwareness"] as? Int,
         let adviceObj = json["advice"] as? [String: Any],
         let chips = adviceObj["chips"] as? [String] {
        return (score, chips)
      }
    } catch { }
    return nil
  }

  private func postJSON(url: URL, body: [String: Any]) async {
    do {
      var req = URLRequest(url: url)
      req.httpMethod = "POST"
      req.addValue("application/json", forHTTPHeaderField: "Content-Type")
      req.httpBody = try JSONSerialization.data(withJSONObject: body)
      _ = try await session.data(for: req)
    } catch {
      // ignore errors in MVP prototype
    }
  }
}

private extension DateFormatter {
  static let yyyyMMdd: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd"
    df.locale = Locale(identifier: "en_US_POSIX")
    df.timeZone = .current
    return df
  }()
}