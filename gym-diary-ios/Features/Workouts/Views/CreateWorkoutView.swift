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
    @FocusState private var isWorkoutNameFocused: Bool
    
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
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: DesignSystem.Spacing.large) {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text("Workout Name")
                            .font(.headline)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        
                        TextField("Enter workout name", text: $newWorkoutName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($isWorkoutNameFocused)
                    }
                    
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text("Section")
                            .font(.headline)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        
                        Picker("Section", selection: $selectedSectionId) {
                            ForEach(availableSections, id: \.id) { section in
                                Text(section.name)
                                    .tag(section.id)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                .fill(DesignSystem.Colors.cardBackground(for: colorScheme))
                        )
                    }
                }
                .padding(DesignSystem.Spacing.large)
            }
            .navigationTitle(isEditing ? "Edit Workout" : "Create Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if isEditing {
                    // For editing: only Close button on the right
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Save") {
                            onCreate()
                        }
                        .disabled(newWorkoutName.isEmpty || selectedSectionId.isEmpty)
                        .foregroundColor(DesignSystem.Colors.primary)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Close") {
                            onCancel()
                        }
                        .foregroundColor(DesignSystem.Colors.primary)
                    }
                } else {
                    // For creation: Cancel left, Create right
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            onCancel()
                        }
                        .foregroundColor(DesignSystem.Colors.primary)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Create") {
                            onCreate()
                        }
                        .disabled(newWorkoutName.isEmpty || selectedSectionId.isEmpty)
                        .foregroundColor(DesignSystem.Colors.primary)
                    }
                }
            }
        }
        .onAppear {
            // Auto-focus the workout name field when the view appears (only for creation)
            if !isEditing {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isWorkoutNameFocused = true
                }
            }
            
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
