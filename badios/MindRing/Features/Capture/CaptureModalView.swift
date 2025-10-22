import SwiftUI

struct CaptureModalView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var title: String = ""
  @State private var isRecording = false
  @State private var emotion: Capture.Emotion = .focused
  @State private var transcript: String = ""
  @State private var tags: Set<String> = []

  let audioManager: AudioCaptureManager
  let transcriptService: any TranscriptService
  let onSave: (Capture) -> Void

  var body: some View {
    VStack(spacing: 16) {
      Capsule()
        .frame(width: 44, height: 4)
        .foregroundColor(.secondary)
        .padding(.top, 8)

      Text("New Capture")
        .font(.title2)
        .fontWeight(.semibold)

      TextField("Title", text: $title)
        .textFieldStyle(.roundedBorder)

      emotionPicker

      Button(action: toggleRecording) {
        HStack {
          Image(systemName: isRecording ? "stop.fill" : "record.circle")
          Text(isRecording ? "Stop Recording" : "Start Recording")
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(isRecording ? Color.red.opacity(0.2) : MindRingPalette.moss.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 16))
      }

      if !transcript.isEmpty {
        TextEditor(text: $transcript)
          .frame(height: 120)
          .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.secondary.opacity(0.3)))
      }

      tagGrid

      Button(action: saveCapture) {
        Text("Save to Sessions")
          .frame(maxWidth: .infinity)
          .padding()
          .background(MindRingPalette.forest)
          .foregroundColor(.white)
          .clipShape(RoundedRectangle(cornerRadius: 16))
      }

      Spacer(minLength: 0)
    }
    .padding()
  }

  private func toggleRecording() {
    Task {
      if isRecording {
        do {
          let url = try await audioManager.stopRecording()
          transcript = (try? await transcriptService.transcript(for: url)) ?? transcript
        } catch {
          // handle error silently for prototype
        }
        isRecording = false
      } else {
        do {
          try await audioManager.requestPermissions()
          try audioManager.startRecording()
          isRecording = true
        } catch {
          isRecording = false
        }
      }
    }
  }

  private func saveCapture() {
    let capture = Capture(title: title.isEmpty ? "Untitled" : title,
                          createdAt: Date(),
                          duration: 120,
                          emotion: emotion,
                          transcript: transcript,
                          tags: Array(tags))
    onSave(capture)
    dismiss()
  }

  private var emotionPicker: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 12) {
        ForEach(Capture.Emotion.allCases) { item in
          Button {
            emotion = item
          } label: {
            Text(item.label)
              .padding(.horizontal, 12)
              .padding(.vertical, 8)
              .background(emotion == item ? MindRingPalette.moss.opacity(0.2) : Color.secondary.opacity(0.1))
              .clipShape(Capsule())
          }
        }
      }
    }
  }

  private var tagGrid: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Tags")
        .font(.subheadline)
        .fontWeight(.semibold)
      let options = ["Strategy", "Risk", "Reflection", "Alignment", "Momentum"]
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 96), spacing: 12)], spacing: 12) {
        ForEach(options, id: \.self) { tag in
          Button {
            if tags.contains(tag) {
              tags.remove(tag)
            } else {
              tags.insert(tag)
            }
          } label: {
            Text(tag)
              .font(.footnote)
              .fontWeight(.medium)
              .padding(.vertical, 8)
              .frame(maxWidth: .infinity)
              .background(tags.contains(tag) ? MindRingPalette.earth.opacity(0.2) : Color.secondary.opacity(0.08))
              .clipShape(RoundedRectangle(cornerRadius: 12))
          }
        }
      }
    }
  }
}
