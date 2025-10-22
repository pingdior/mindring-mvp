import Foundation

protocol TranscriptService {
  func transcript(for url: URL) async throws -> String
}

struct LocalTranscriptService: TranscriptService {
  func transcript(for url: URL) async throws -> String {
    // Placeholder: integrate Speech framework when permissions allow.
    // Returning deterministic stub to keep flows unblocked.
    let filename = url.deletingPathExtension().lastPathComponent
    return "Transcript for \(filename) captured at \(DateFormatter.compact.string(from: Date()))"
  }
}
