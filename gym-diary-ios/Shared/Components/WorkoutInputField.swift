import SwiftUI

// MARK: - Workout Input Field Component
struct WorkoutInputField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let autoFocus: Bool
    @FocusState private var isFocused: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            Text(label)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
            
            HStack(spacing: DesignSystem.Spacing.small) {
                TextField(placeholder, text: $text)
                    .font(.body)
                    .focused($isFocused)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.medium)
            .padding(.vertical, DesignSystem.Spacing.medium)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(DesignSystem.Colors.cardBackground(for: colorScheme))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isFocused ? DesignSystem.Colors.primary : Color(.systemGray4),
                                lineWidth: isFocused ? 2 : 1
                            )
                    )
            )
            .onAppear {
                if autoFocus {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isFocused = true
                    }
                }
            }
        }
    }
}

// MARK: - Workout Section Picker Component
struct WorkoutSectionPicker: View {
    let label: String
    let sections: [WorkoutSection]
    @Binding var selectedSectionId: String
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            Text(label)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
            
            Picker("Section", selection: $selectedSectionId) {
                ForEach(sections, id: \.id) { section in
                    Text(section.name)
                        .tag(section.id)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, DesignSystem.Spacing.medium)
            .padding(.vertical, DesignSystem.Spacing.medium)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(DesignSystem.Colors.cardBackground(for: colorScheme))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
            )
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VStack(spacing: DesignSystem.Spacing.large) {
            WorkoutInputField(
                label: "Workout Name",
                placeholder: "Enter workout name",
                text: .constant(""),
                autoFocus: false
            )
            
            WorkoutSectionPicker(
                label: "Section",
                sections: [
                    WorkoutSection(userId: "user1", name: "My Workouts", workouts: []),
                    WorkoutSection(userId: "user2", name: "Strength", workouts: [])
                ],
                selectedSectionId: .constant("user1")
            )
        }
        .padding()
    }
}
