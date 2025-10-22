import SwiftUI

struct ChatView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var messageText = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Hi! I'm Alex, your AI companion. How are you feeling today?", isUser: false),
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(DesignSystem.Colors.ink)
                }
                
                Text("Alex")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(DesignSystem.Colors.ink)
                
                Spacer()
                
                Text("AI Companion")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(DesignSystem.Colors.muted)
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.vertical, DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.card)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(DesignSystem.Colors.border)
                    .offset(y: 1),
                alignment: .bottom
            )
            
            // Messages
            ScrollView {
                LazyVStack(spacing: DesignSystem.Spacing.sm) {
                    ForEach(messages) { message in
                        ChatMessageView(message: message)
                    }
                }
                .padding(DesignSystem.Spacing.md)
            }
            
            // Input area
            HStack(spacing: DesignSystem.Spacing.sm) {
                TextField("Type a message...", text: $messageText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, DesignSystem.Spacing.md)
                    .padding(.vertical, DesignSystem.Spacing.sm)
                    .background(DesignSystem.Colors.card)
                    .cornerRadius(DesignSystem.CornerRadius.lg)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                            .stroke(DesignSystem.Colors.border, lineWidth: 1)
                    )
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(DesignSystem.Gradients.primaryButton)
                        .clipShape(Circle())
                }
                .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.card)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(DesignSystem.Colors.border)
                    .offset(y: -1),
                alignment: .top
            )
        }
        .background(DesignSystem.Colors.fog)
    }
    
    private func sendMessage() {
        let userMessage = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !userMessage.isEmpty else { return }
        
        // Add user message
        messages.append(ChatMessage(text: userMessage, isUser: true))
        messageText = ""
        
        // Simulate AI response after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let responses = [
                "That's interesting. Can you tell me more about how you're feeling?",
                "I understand. It sounds like you're processing a lot right now.",
                "Thank you for sharing that with me. How does that make you feel?",
                "That's a great insight. What do you think led to that feeling?",
                "I'm here to listen. Would you like to explore that feeling further?"
            ]
            let randomResponse = responses.randomElement() ?? responses[0]
            messages.append(ChatMessage(text: randomResponse, isUser: false))
        }
    }
}

struct ChatMessageView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                
                Text(message.text)
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(.white)
                    .padding(DesignSystem.Spacing.md)
                    .background(DesignSystem.Gradients.primaryButton)
                    .cornerRadius(DesignSystem.CornerRadius.lg)
                    .frame(maxWidth: 250, alignment: .trailing)
            } else {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        Text("A")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .background(
                                LinearGradient(
                                    colors: [DesignSystem.Colors.earth.opacity(0.9), DesignSystem.Colors.earth],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Circle())
                        
                        Text("Alex")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(DesignSystem.Colors.muted)
                    }
                    
                    Text(message.text)
                        .font(DesignSystem.Typography.body)
                        .foregroundColor(DesignSystem.Colors.ink)
                        .padding(DesignSystem.Spacing.md)
                        .background(DesignSystem.Colors.card)
                        .cornerRadius(DesignSystem.CornerRadius.lg)
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                                .stroke(DesignSystem.Colors.border, lineWidth: 1)
                        )
                        .frame(maxWidth: 250, alignment: .leading)
                }
                
                Spacer()
            }
        }
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}