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

  func fetchSessions() async -> [SessionCard] {
    let url = baseURL.appendingPathComponent("sessions")
    do {
      let (data, _) = try await session.data(from: url)
      if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
         let sessionsArray = json["sessions"] as? [[String: Any]] {
        print("Backend returned \(sessionsArray.count) sessions")
        return sessionsArray.compactMap { sessionData in
          guard let title = sessionData["title"] as? String,
                let summary = sessionData["summary"] as? String else { 
            print("Skipping session with missing title or summary")
            return nil 
          }
          
          let timestamp = sessionData["timestamp"] as? String ?? ""
          let source = sessionData["source"] as? String ?? ""
          let emotions = sessionData["emotions"] as? [[String]] ?? []
          
          // Format metadata
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
          let displayFormatter = DateFormatter()
          displayFormatter.dateFormat = "HH:mm"
          
          var metadata = "Today"
          if let date = dateFormatter.date(from: timestamp) {
            metadata += " · \(displayFormatter.string(from: date))"
          }
          if source == "recording" {
            metadata += " · Ring"
          }
          
          // Extract emotion tags
          let emotionTags = emotions.flatMap { $0 }
          let tags = ["Self‑Awareness"] + emotionTags
          
          print("Created session card: \(title)")
          return SessionCard(
            metadata: metadata,
            title: title,
            summary: summary,
            tags: tags,
            audioURL: nil
          )
        }
      } else {
        print("Failed to parse sessions JSON response")
      }
    } catch {
      print("Error fetching sessions: \(error)")
    }
    return []
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