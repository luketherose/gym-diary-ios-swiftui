import SwiftUI

// MARK: - Design System
struct DesignSystem {
    
    // MARK: - Colors
    struct Colors {
        static let primary = Color.blue
        static let secondary = Color.orange
        static let accent = Color.purple
        static let success = Color.green
        static let warning = Color.yellow
        static let error = Color.red
        
        // Theme-aware colors
        static func background(for colorScheme: ColorScheme) -> Color {
            colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground)
        }
        
        static func cardBackground(for colorScheme: ColorScheme) -> Color {
            colorScheme == .dark ? Color(.systemGray5) : Color(.systemBackground)
        }
        
        static func surfaceBackground(for colorScheme: ColorScheme) -> Color {
            colorScheme == .dark ? Color(.systemGray4) : Color(.systemGray6)
        }
        
        static func textPrimary(for colorScheme: ColorScheme) -> Color {
            colorScheme == .dark ? Color.white : Color.black
        }
        
        static func textSecondary(for colorScheme: ColorScheme) -> Color {
            colorScheme == .dark ? Color(.systemGray2) : Color(.systemGray)
        }
    }
    
    // MARK: - Gradients
    struct Gradients {
        static let primary = LinearGradient(
            colors: [Color.blue, Color.purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let secondary = LinearGradient(
            colors: [Color.orange, Color.red],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let success = LinearGradient(
            colors: [Color.green, Color.teal],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let warning = LinearGradient(
            colors: [Color.yellow, Color.orange],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let error = LinearGradient(
            colors: [Color.red, Color.pink],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Theme-aware gradients
        static func cardGradient(for colorScheme: ColorScheme) -> LinearGradient {
            let opacity = colorScheme == .dark ? 0.15 : 0.08
            return LinearGradient(
                colors: [
                    Color.blue.opacity(opacity),
                    Color.purple.opacity(opacity)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        
        static func modalGradient(for colorScheme: ColorScheme) -> LinearGradient {
            let opacity = colorScheme == .dark ? 0.2 : 0.1
            return LinearGradient(
                colors: [
                    Color.blue.opacity(opacity),
                    Color.indigo.opacity(opacity)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    // MARK: - Shadows
    struct Shadows {
        static let small = Shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        static let medium = Shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        static let large = Shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
        
        static func adaptive(for colorScheme: ColorScheme) -> Shadow {
            let opacity = colorScheme == .dark ? 0.3 : 0.1
            return Shadow(color: .black.opacity(opacity), radius: 8, x: 0, y: 4)
        }
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 20
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 24
    }
}

// MARK: - Shadow Helper
struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Reusable Components
struct CardContainer<Content: View>: View {
    let content: Content
    @Environment(\.colorScheme) private var colorScheme
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(DesignSystem.Spacing.large)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                    .fill(DesignSystem.Colors.cardBackground(for: colorScheme))
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                            .fill(DesignSystem.Gradients.cardGradient(for: colorScheme))
                    )
            )
            .shadow(
                color: DesignSystem.Shadows.adaptive(for: colorScheme).color,
                radius: DesignSystem.Shadows.adaptive(for: colorScheme).radius,
                x: DesignSystem.Shadows.adaptive(for: colorScheme).x,
                y: DesignSystem.Shadows.adaptive(for: colorScheme).y
            )
    }
}

struct ModalContainer<Content: View>: View {
    let content: Content
    @Environment(\.colorScheme) private var colorScheme
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(DesignSystem.Spacing.extraLarge)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.extraLarge)
                    .fill(DesignSystem.Colors.cardBackground(for: colorScheme))
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.extraLarge)
                            .fill(DesignSystem.Gradients.modalGradient(for: colorScheme))
                    )
            )
            .shadow(
                color: DesignSystem.Shadows.large.color,
                radius: DesignSystem.Shadows.large.radius,
                x: DesignSystem.Shadows.large.x,
                y: DesignSystem.Shadows.large.y
            )
    }
}

struct GradientButton: View {
    let title: String
    let action: () -> Void
    let gradient: LinearGradient
    let isEnabled: Bool
    
    init(
        title: String,
        gradient: LinearGradient = DesignSystem.Gradients.primary,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.gradient = gradient
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignSystem.Spacing.medium)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                        .fill(gradient)
                        .opacity(isEnabled ? 1.0 : 0.5)
                )
        }
        .disabled(!isEnabled)
    }
}

struct GradientIcon: View {
    let systemName: String
    let gradient: LinearGradient
    let size: CGFloat
    
    init(
        systemName: String,
        gradient: LinearGradient = DesignSystem.Gradients.primary,
        size: CGFloat = 24
    ) {
        self.systemName = systemName
        self.gradient = gradient
        self.size = size
    }
    
    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size))
            .foregroundStyle(gradient)
    }
}

struct GradientBadge: View {
    let text: String
    let gradient: LinearGradient
    
    init(text: String, gradient: LinearGradient = DesignSystem.Gradients.primary) {
        self.text = text
        self.gradient = gradient
    }
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, DesignSystem.Spacing.small)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(gradient)
            )
    }
}

// MARK: - Workout Category Helper
struct WorkoutCategory {
    let icon: String
    let gradient: LinearGradient
    let name: String
    
    static func category(for workout: Workout) -> WorkoutCategory {
        let name = workout.name.lowercased()
        
        if name.contains("push") || name.contains("chest") || name.contains("triceps") {
            return WorkoutCategory(
                icon: "figure.strengthtraining.traditional",
                gradient: DesignSystem.Gradients.secondary,
                name: "Push"
            )
        } else if name.contains("pull") || name.contains("back") || name.contains("biceps") {
            return WorkoutCategory(
                icon: "figure.strengthtraining.traditional",
                gradient: DesignSystem.Gradients.primary,
                name: "Pull"
            )
        } else if name.contains("legs") || name.contains("squat") || name.contains("deadlift") {
            return WorkoutCategory(
                icon: "figure.strengthtraining.traditional",
                gradient: DesignSystem.Gradients.success,
                name: "Legs"
            )
        } else if name.contains("cardio") || name.contains("hiit") || name.contains("running") {
            return WorkoutCategory(
                icon: "figure.run",
                gradient: DesignSystem.Gradients.error,
                name: "Cardio"
            )
        } else {
            return WorkoutCategory(
                icon: "dumbbell.fill",
                gradient: DesignSystem.Gradients.primary,
                name: "Strength"
            )
        }
    }
}
