import SwiftUI

// MARK: - Design System
struct DesignSystem {
    // MARK: - Colors
    struct Colors {
        static let forest = Color(red: 47/255, green: 93/255, blue: 62/255)
        static let moss = Color(red: 91/255, green: 138/255, blue: 114/255)
        static let earth = Color(red: 185/255, green: 122/255, blue: 60/255)
        static let fog = Color(red: 249/255, green: 246/255, blue: 239/255)
        static let ink = Color(red: 31/255, green: 42/255, blue: 36/255)
        static let muted = Color(red: 107/255, green: 112/255, blue: 104/255)
        static let card = Color.white
        static let border = Color(red: 60/255, green: 80/255, blue: 74/255).opacity(0.14)
        static let accent = Color(red: 241/255, green: 164/255, blue: 71/255)
    }
    
    // MARK: - Gradients
    struct Gradients {
        static let hero = LinearGradient(
            colors: [Colors.moss.opacity(0.96), Colors.earth.opacity(0.88)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let appBar = LinearGradient(
            colors: [Colors.forest, Colors.earth],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        static let background = RadialGradient(
            colors: [Colors.fog, Color(red: 240/255, green: 228/255, blue: 207/255), Color(red: 226/255, green: 210/255, blue: 179/255)],
            center: .topLeading,
            startRadius: 100,
            endRadius: 600
        )
        
        static let primaryButton = LinearGradient(
            colors: [Colors.forest, Colors.moss],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let secondaryButton = LinearGradient(
            colors: [Colors.fog.opacity(0.92), Color(red: 230/255, green: 239/255, blue: 229/255).opacity(0.86)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let deepDiveCard = LinearGradient(
            colors: [Colors.earth.opacity(0.08), Colors.earth.opacity(0.12)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Typography
    struct Typography {
        static let heroScore = Font.system(size: 32, weight: .bold, design: .default)
        static let cardTitle = Font.system(size: 16, weight: .semibold, design: .default)
        static let sessionTitle = Font.system(size: 14, weight: .semibold, design: .default)
        static let body = Font.system(size: 13, weight: .regular, design: .default)
        static let caption = Font.system(size: 11, weight: .regular, design: .default)
        static let tag = Font.system(size: 11, weight: .medium, design: .default)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 18
        static let pill: CGFloat = 999
    }
    
    // MARK: - Shadows
    struct Shadows {
        static let card = Color.black.opacity(0.12)
        static let fab = Color.black.opacity(0.15)
    }
}

// MARK: - Custom View Modifiers
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(DesignSystem.Colors.card)
            .cornerRadius(DesignSystem.CornerRadius.lg)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                    .stroke(DesignSystem.Colors.border, lineWidth: 1)
            )
            .shadow(color: DesignSystem.Shadows.card, radius: 10, x: 0, y: 8)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DesignSystem.Typography.body)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.vertical, DesignSystem.Spacing.sm)
            .background(DesignSystem.Gradients.primaryButton)
            .cornerRadius(DesignSystem.CornerRadius.md)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DesignSystem.Typography.body)
            .fontWeight(.semibold)
            .foregroundColor(DesignSystem.Colors.forest)
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.vertical, DesignSystem.Spacing.sm)
            .background(DesignSystem.Gradients.secondaryButton)
            .cornerRadius(DesignSystem.CornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                    .stroke(DesignSystem.Colors.moss.opacity(0.24), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardStyle())
    }
}