import AVFoundation
import Foundation

@MainActor
final class AudioCaptureManager: ObservableObject {
  enum State {
    case idle
    case recording(startedAt: Date)
    case finishing
  }

  @Published private(set) var state: State = .idle
  private var recorder: AVAudioRecorder?

  func requestPermissions() async throws {
    let session = AVAudioSession.sharedInstance()
    try session.setCategory(.playAndRecord, mode: .spokenAudio, options: [.allowBluetooth, .defaultToSpeaker])
    try await session.setActive(true)
    let granted = await withCheckedContinuation { continuation in
      session.requestRecordPermission { granted in
        continuation.resume(returning: granted)
      }
    }
    guard granted else {
      throw AudioError.permissionDenied
    }
  }

  func startRecording() throws {
    guard case .idle = state else { return }
    let url = try recordingURL()
    let settings: [String: Any] = [AVFormatIDKey: kAudioFormatMPEG4AAC,
                                   AVSampleRateKey: 44100,
                                   AVNumberOfChannelsKey: 1,
                                   AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
    recorder = try AVAudioRecorder(url: url, settings: settings)
    recorder?.isMeteringEnabled = true
    recorder?.record()
    state = .recording(startedAt: Date())
  }

  func stopRecording() async throws -> URL {
    guard case .recording = state, let recorder else {
      throw AudioError.invalidState
    }
    state = .finishing
    recorder.stop()
    self.recorder = nil
    state = .idle
    return recorder.url
  }

  private func recordingURL() throws -> URL {
    let directory = try FileManager.default.applicationSupportDirectory()
    let filename = "capture_" + UUID().uuidString + ".m4a"
    return directory.appendingPathComponent(filename)
  }

  enum AudioError: Error {
    case permissionDenied
    case invalidState
  }
}

private extension FileManager {
  func applicationSupportDirectory() throws -> URL {
    let url = try url(for: .applicationSupportDirectory,
                      in: .userDomainMask,
                      appropriateFor: nil,
                      create: true).appendingPathComponent("MindRing", isDirectory: true)
    if !fileExists(atPath: url.path) {
      try createDirectory(at: url, withIntermediateDirectories: true)
    }
    return url
  }
}
