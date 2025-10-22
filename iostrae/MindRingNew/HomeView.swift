import SwiftUI

struct HomeView: View {
    @StateObject private var audioRecorder = AudioRecorder()
    @StateObject private var audioPlayer = AudioPlayer()
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var score: Int? = nil
    @State private var advice: [String] = []
    @State private var sessions: [SessionCard] = []
    @State private var showRecordingPanel = false
    @State private var showChatView = false
    @State private var isLoading = false
    
    private let client = BackendClient(baseURL: URL(string: (ProcessInfo.processInfo.environment["LOCAL_BACKEND_URL"] ?? "http://localhost:8001/"))!)

    var body: some View {
        ZStack {
            // Background gradient
            DesignSystem.Gradients.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // App Bar
                HStack {
                    Text("Home")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("MindRing")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.85))
                }
                .padding(.horizontal, DesignSystem.Spacing.md)
                .padding(.vertical, DesignSystem.Spacing.md)
                .background(DesignSystem.Gradients.appBar)
                
                // Content
                ScrollView {
                    VStack(spacing: DesignSystem.Spacing.lg) {
                        // Hero Section
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                            Text("Today's Self‑Awareness Compass")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            
                            Text("\(score ?? 72)")
                                .font(DesignSystem.Typography.heroScore)
                                .foregroundColor(.white)
                            
                            HStack {
                                Text("24h view · emotion granularity + today's reflection.")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(DesignSystem.Colors.earth.opacity(0.9))
                                    .padding(.horizontal, DesignSystem.Spacing.sm)
                                    .padding(.vertical, 6)
                                    .background(DesignSystem.Colors.earth.opacity(0.16))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                            .stroke(DesignSystem.Colors.earth.opacity(0.26), lineWidth: 1)
                                    )
                                    .cornerRadius(DesignSystem.CornerRadius.md)
                                
                                Spacer()
                            }
                        }
                        .padding(DesignSystem.Spacing.lg)
                        .background(DesignSystem.Gradients.hero)
                        .cornerRadius(DesignSystem.CornerRadius.lg)
                        
                        // Recent Sessions
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                            HStack {
                                Text("Recent Sessions")
                                    .font(DesignSystem.Typography.cardTitle)
                                    .foregroundColor(DesignSystem.Colors.ink)
                                
                                Spacer()
                                
                                Text("5 today")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(DesignSystem.Colors.muted)
                                    .padding(.horizontal, DesignSystem.Spacing.sm)
                                    .padding(.vertical, 3)
                                    .background(DesignSystem.Colors.moss.opacity(0.1))
                                    .cornerRadius(DesignSystem.CornerRadius.md)
                            }
                            
                            // Today's Deep Dive Card
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Today · Deep Dive")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(DesignSystem.Colors.muted)
                                
                                Text("Today's Deep Dive")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(DesignSystem.Colors.ink)
                                
                                Text("Reflect on your emotional patterns and insights.")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(DesignSystem.Colors.ink)
                                    .lineLimit(2)
                                
                                HStack(spacing: 6) {
                                    TagView(text: "Reflection")
                                    TagView(text: "Self-Awareness")
                                    Spacer()
                                }
                            }
                            .padding(DesignSystem.Spacing.md)
                            .background(DesignSystem.Gradients.deepDiveCard)
                            .cornerRadius(DesignSystem.CornerRadius.lg)
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                                    .stroke(DesignSystem.Colors.earth.opacity(0.28), lineWidth: 1)
                            )
                            .shadow(color: DesignSystem.Shadows.card, radius: 6, x: 0, y: 4)
                            
                            // Other Session Cards
                            ForEach(sessions, id: \.id) { session in
                                SessionCardView(session: session)
                            }
                        }
                    }
                    .padding(DesignSystem.Spacing.lg)
                }
                
                Spacer()
            }
            
            // Floating Action Buttons
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    HStack(spacing: DesignSystem.Spacing.md) {
                        // Record Button
                        Button(action: {
                            showRecordingPanel.toggle()
                        }) {
                            Image(systemName: "mic.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(DesignSystem.Gradients.primaryButton)
                                .clipShape(Circle())
                        }
                        
                        // Alex Button
                        Button(action: {
                            showChatView = true
                        }) {
                            Text("A")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(
                                    LinearGradient(
                                        colors: [DesignSystem.Colors.earth.opacity(0.9), DesignSystem.Colors.earth],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(Circle())
                        }
                    }
                    .padding(DesignSystem.Spacing.sm)
                    .background(DesignSystem.Colors.card)
                    .cornerRadius(28)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(DesignSystem.Colors.border, lineWidth: 1)
                    )
                    .shadow(color: DesignSystem.Shadows.fab, radius: 13, x: 0, y: 6)
                    
                    Spacer()
                }
                .padding(.bottom, DesignSystem.Spacing.lg)
            }
        }
        .task { await refresh() }
        .sheet(isPresented: $showRecordingPanel) {
            RecordingPanelView(client: client) {
                await refresh()
            }
        }
        .fullScreenCover(isPresented: $showChatView) {
            ChatView()
        }
    }

    private func refresh() async {
        if let (s, chips) = await client.fetchSnapshot() {
            await MainActor.run {
                score = s
                advice = chips
            }
        }
        
        // Fetch sessions from backend
        let fetchedSessions = await client.fetchSessions()
        await MainActor.run {
            // Always show fetched sessions if available, otherwise show mock data
            sessions = fetchedSessions.isEmpty ? mockSessions : fetchedSessions
            print("Refreshed sessions: \(sessions.count) sessions loaded")
        }
    }
}

// MARK: - Supporting Views
struct TagView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(DesignSystem.Typography.tag)
            .foregroundColor(DesignSystem.Colors.forest)
            .padding(.horizontal, DesignSystem.Spacing.sm)
            .padding(.vertical, DesignSystem.Spacing.xs)
            .background(DesignSystem.Colors.moss.opacity(0.16))
            .cornerRadius(DesignSystem.CornerRadius.pill)
    }
}

struct SessionCardView: View {
    let session: SessionCard
    @StateObject private var audioPlayer = AudioPlayer()
    @State private var showSessionDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(session.metadata)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(DesignSystem.Colors.muted)
                
                Spacer()
                
                // Play button for recordings with audio
                if session.metadata.contains("Ring") {
                    Button(action: {
                        if audioPlayer.isPlaying {
                            audioPlayer.stopPlaying()
                        } else {
                            // Try to play actual audio if available, otherwise mock
                            if let audioURL = session.audioURL {
                                audioPlayer.playAudio(from: audioURL)
                            } else {
                                audioPlayer.playMockAudio()
                            }
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: audioPlayer.isPlaying ? "stop.circle.fill" : "play.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(DesignSystem.Colors.forest)
                            
                            Text(audioPlayer.isPlaying ? "Stop" : "Play")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(DesignSystem.Colors.forest)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            Text(session.title)
                .font(DesignSystem.Typography.sessionTitle)
                .foregroundColor(DesignSystem.Colors.ink)
            
            Text(session.summary)
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Colors.ink)
                .lineLimit(2)
            
            HStack(spacing: 6) {
                ForEach(session.tags, id: \.self) { tag in
                    TagView(text: tag)
                }
                Spacer()
            }
        }
        .padding(DesignSystem.Spacing.md)
        .cardStyle()
        .onTapGesture {
            showSessionDetail = true
        }
        .sheet(isPresented: $showSessionDetail) {
            SessionDetailView(session: session, audioPlayer: audioPlayer)
        }
    }
}

struct RecordingPanelView: View {
    let client: BackendClient
    let onSave: () async -> Void
    @Environment(\.dismiss) private var dismiss
    @StateObject private var audioRecorder = AudioRecorder()
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            HStack {
                Text("Recording")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(DesignSystem.Colors.forest)
                
                Spacer()
                
                Button("×") {
                    if audioRecorder.isRecording {
                        audioRecorder.stopRecording()
                    }
                    dismiss()
                }
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(DesignSystem.Colors.muted)
            }
            
            Text(audioRecorder.formatTime(audioRecorder.recordingTime))
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(DesignSystem.Colors.ink)
            
            HStack(spacing: DesignSystem.Spacing.lg) {
                Button(action: {
                    if audioRecorder.isRecording {
                        audioRecorder.stopRecording()
                    } else {
                        audioRecorder.startRecording()
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: audioRecorder.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                            .font(.title)
                            .foregroundColor(audioRecorder.isRecording ? .red : .blue)
                        
                        Text(audioRecorder.isRecording ? "Stop Recording" : "Start Recording")
                            .font(.headline)
                            .foregroundColor(audioRecorder.isRecording ? .red : .blue)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(!audioRecorder.hasPermission)
                
                if audioRecorder.recordingTime > 0 && !audioRecorder.isRecording {
                    Button(action: {
                        if audioRecorder.isPlaying {
                            audioRecorder.stopPlaying()
                        } else {
                            audioRecorder.playRecording()
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: audioRecorder.isPlaying ? "stop.circle.fill" : "play.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                            
                            Text(audioRecorder.isPlaying ? "Stop Playback" : "Play Recording")
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            if !audioRecorder.hasPermission {
                Text("Microphone permission required")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.red)
                    .padding(DesignSystem.Spacing.sm)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(DesignSystem.CornerRadius.md)
            }
            
            HStack(spacing: DesignSystem.Spacing.sm) {
                Button("Discard") {
                    if audioRecorder.isRecording {
                        audioRecorder.stopRecording()
                    }
                    if audioRecorder.isPlaying {
                        audioRecorder.stopPlaying()
                    }
                    dismiss()
                }
                .buttonStyle(SecondaryButtonStyle())
                
                Button("Save to feed") {
                    Task {
                        await saveRecording()
                        await onSave()
                        dismiss()
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(audioRecorder.recordingTime == 0 || audioRecorder.isRecording)
            }
            
            Text("Mic captures a real audio note. Saving adds a new session card at the top.")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(DesignSystem.Colors.earth)
                .padding(DesignSystem.Spacing.sm)
                .background(DesignSystem.Colors.earth.opacity(0.16))
                .cornerRadius(DesignSystem.CornerRadius.md)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                        .stroke(DesignSystem.Colors.earth.opacity(0.26), lineWidth: 1)
                )
        }
        .padding(DesignSystem.Spacing.lg)
        .background(DesignSystem.Colors.card)
        .cornerRadius(DesignSystem.CornerRadius.lg)
        .shadow(color: DesignSystem.Shadows.card, radius: 10, x: 0, y: 8)
        .padding(DesignSystem.Spacing.lg)
    }
    
    private func saveRecording() async {
        let capture = Capture(
            title: "Audio Recording",
            createdAt: Date(),
            duration: audioRecorder.recordingTime,
            emotion: .focused,
            transcript: "Audio recording (\(audioRecorder.formatTime(audioRecorder.recordingTime)))",
            tags: ["Self‑Awareness", "Recording"],
            audioURL: audioRecorder.getRecordingURL()
        )
        await client.recordSave(from: capture)
    }
}

// MARK: - Mock Data
struct SessionCard: Identifiable {
    let id = UUID()
    let metadata: String
    let title: String
    let summary: String
    let tags: [String]
    let audioURL: URL?
}

let mockSessions = [
    SessionCard(
        metadata: "Today · 10:24 · Office · Ring",
        title: "Sprint Alignment",
        summary: "Confirmed rhythm, surfaced data gap.",
        tags: ["Self‑Awareness", "Energized + Wary"],
        audioURL: nil
    ),
    SessionCard(
        metadata: "Yesterday · 9:03 PM · Home",
        title: "Alex Follow‑up",
        summary: "Named blind spots, emotion shifts tracked.",
        tags: ["Curious", "Focused"],
        audioURL: nil
    )
]

// Lightweight capture model to match BackendClient needs
struct Capture: Identifiable, Hashable {
    enum Emotion: String, CaseIterable, Identifiable {
        case focused
        var id: String { rawValue }
        var label: String { rawValue.capitalized }
    }
    let id: UUID = UUID()
    var title: String
    var createdAt: Date
    var duration: TimeInterval
    var emotion: Emotion
    var transcript: String
    var tags: [String]
    var audioURL: URL?
}