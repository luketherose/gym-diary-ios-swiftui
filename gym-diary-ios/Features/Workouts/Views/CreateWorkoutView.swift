import SwiftUI

// MARK: - Create/Edit Workout View
struct CreateWorkoutView: View {
    let sections: [WorkoutSection]
    @Binding var newWorkoutName: String
    @Binding var selectedSectionId: String
    let onCancel: () -> Void
    let onCreate: () -> Void
    let isEditing: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    // Computed property to handle sections and default selection
    private var availableSections: [WorkoutSection] {
        if sections.isEmpty {
            // If no sections exist, create a default "My Workouts" section
            let defaultSection = WorkoutSection(
                userId: "user123",
                name: "My Workouts",
                workouts: []
            )
            return [defaultSection]
        }
        return sections
    }
    
    var body: some View {
        ZStack {
            DesignSystem.Colors.background(for: colorScheme)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with title and buttons
                HStack {
                    Button(isEditing ? "Close" : "Cancel") {
                        onCancel()
                    }
                    .foregroundColor(DesignSystem.Colors.primary)
                    .font(.body)
                    
                    Spacer()
                    
                    Text(isEditing ? "Edit Workout" : "Create Workout")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                    
                    Spacer()
                    
                    Button(isEditing ? "Save" : "Create") {
                        onCreate()
                    }
                    .foregroundColor(DesignSystem.Colors.primary)
                    .font(.body)
                    .disabled(newWorkoutName.isEmpty || selectedSectionId.isEmpty)
                }
                .padding(.horizontal, DesignSystem.Spacing.large)
                .padding(.top, DesignSystem.Spacing.large)
                .padding(.bottom, DesignSystem.Spacing.large)
                
                // Content
                VStack(spacing: DesignSystem.Spacing.large) {
                    WorkoutInputField(
                        label: "Workout Name",
                        placeholder: "Enter workout name",
                        text: $newWorkoutName,
                        autoFocus: true
                    )
                    
                    WorkoutSectionPicker(
                        label: "Section",
                        sections: availableSections,
                        selectedSectionId: $selectedSectionId
                    )
                }
                .padding(.horizontal, DesignSystem.Spacing.large)
                
                Spacer()
            }
        }
        .onAppear {
            // Preselect section if not already selected (only for creation, not editing)
            if !isEditing && selectedSectionId.isEmpty {
                if let myWorkoutsSection = availableSections.first(where: { $0.name == "My Workouts" }) {
                    selectedSectionId = myWorkoutsSection.id
                } else if !availableSections.isEmpty {
                    selectedSectionId = availableSections[0].id
                }
            }
        }
    }
}
