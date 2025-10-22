import SwiftUI

struct SessionDetailView: View {
    let session: SessionCard
    let audioPlayer: AudioPlayer
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                    // Source info card
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                        Text("Original recording · 02:18 · Transcription ready")
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
                    
                    // Main content pane
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                        // Key Takeaways
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                            HStack {
                                Text("Key Takeaways")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(DesignSystem.Colors.ink)
                                
                                Spacer()
                                
                                Button("Edit Summary") {
                                    // TODO: Implement edit functionality
                                }
                                .buttonStyle(SecondaryButtonStyle())
                            }
                            
                            Text("1) Hidden data risk. 2) Co‑create outreach. 3) Prepare for today's reflection.")
                                .font(DesignSystem.Typography.body)
                                .foregroundColor(DesignSystem.Colors.ink)
                        }
                        
                        // AI Tags
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                            HStack {
                                Text("AI Tags")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(DesignSystem.Colors.ink)
                                
                                Spacer()
                                
                                Button("Add Tag") {
                                    // TODO: Implement add tag functionality
                                }
                                .buttonStyle(SecondaryButtonStyle())
                            }
                            
                            HStack(spacing: 6) {
                                ForEach(session.tags, id: \.self) { tag in
                                    TagView(text: tag)
                                }
                                Spacer()
                            }
                        }
                        
                        // Source
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                            HStack {
                                Text("Source")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(DesignSystem.Colors.ink)
                                
                                Spacer()
                                
                                Button(action: {
                                    if audioPlayer.isPlaying {
                                        audioPlayer.stopPlaying()
                                    } else {
                                        if let audioURL = session.audioURL {
                                            audioPlayer.playAudio(from: audioURL)
                                        } else {
                                            audioPlayer.playMockAudio()
                                        }
                                    }
                                }) {
                                    Text(audioPlayer.isPlaying ? "Stop Audio" : "Play Original Audio")
                                }
                                .buttonStyle(PrimaryButtonStyle())
                            }
                            
                            Button("View Full Transcript") {
                                // TODO: Implement transcript view
                            }
                            .buttonStyle(SecondaryButtonStyle())
                            .frame(maxWidth: .infinity)
                        }
                        
                        // Next Step
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                            HStack {
                                Text("Next Step")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(DesignSystem.Colors.ink)
                                
                                Spacer()
                                
                                Button("Send to Today's Deep Dive") {
                                    // TODO: Implement deep dive integration
                                }
                                .buttonStyle(PrimaryButtonStyle())
                            }
                        }
                    }
                    .padding(DesignSystem.Spacing.lg)
                    .background(DesignSystem.Colors.card)
                    .cornerRadius(DesignSystem.CornerRadius.lg)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                            .stroke(DesignSystem.Colors.border, lineWidth: 1)
                    )
                    .shadow(color: DesignSystem.Shadows.card, radius: 10, x: 0, y: 8)
                }
                .padding(DesignSystem.Spacing.lg)
            }
            .background(DesignSystem.Gradients.background)
            .navigationTitle("Session Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}