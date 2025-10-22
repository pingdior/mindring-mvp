import Foundation
import AVFoundation

class AudioPlayer: NSObject, ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    
    @Published var isPlaying = false
    
    override init() {
        super.init()
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    func playAudio(from url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            isPlaying = true
            print("Started playing audio from: \(url)")
        } catch {
            print("Could not play audio: \(error)")
        }
    }
    
    func playMockAudio() {
        // For demonstration purposes, we'll create a brief tone
        // In a real implementation, this would play the actual recorded audio
        print("Playing mock audio for demonstration")
        isPlaying = true
        
        // Simulate audio playback duration
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isPlaying = false
        }
    }
    
    func stopPlaying() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
        print("Stopped playing audio")
    }
}

// MARK: - AVAudioPlayerDelegate
extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        print("Audio playback finished")
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        isPlaying = false
        if let error = error {
            print("Audio decode error: \(error)")
        }
    }
}