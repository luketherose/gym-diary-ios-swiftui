import SwiftUI

struct AddExerciseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel = AddExerciseViewModel()
    @FocusState private var isSearchFieldFocused: Bool
    @State private var showingExerciseConfiguration = false
    
    let workoutId: String
    let onAdd: (Exercise) -> Void
    let onAddCircuit: (Circuit, [Exercise]) -> Void
    let isReplacing: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search and results - always shown
                    searchSection
                    resultsList
                }
            }
            .navigationTitle(isReplacing ? "Substitute Exercise" : "Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.Colors.primary)
                }
            }
        }
        .onAppear {
            // Focus the search field when the view appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isSearchFieldFocused = true
            }
        }
        .onChange(of: viewModel.query) { _, _ in
            viewModel.onQueryChanged()
        }
    }
    
    // MARK: - Search Section
    private var searchSection: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            // Search field with enhanced visibility
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text("Search Exercises")
                    .font(.headline)
                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                    .padding(.horizontal, DesignSystem.Spacing.large)
                
                HStack(spacing: DesignSystem.Spacing.small) {
                    // Search icon
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        .font(.system(size: 16))
                    
                    // Search text field
                    TextField("Search by name or muscle (e.g. bench, chest)", text: $viewModel.query)
                        .textFieldStyle(PlainTextFieldStyle())
                        .focused($isSearchFieldFocused)
                    
                    // Clear button
                    if !viewModel.query.isEmpty {
                        Button(action: {
                            viewModel.query = ""
                            viewModel.onQueryChanged()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
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
                                    isSearchFieldFocused ? DesignSystem.Colors.primary : Color(.systemGray4),
                                    lineWidth: isSearchFieldFocused ? 2 : 1
                                )
                        )
                )
                .padding(.horizontal, DesignSystem.Spacing.large)
                .onChange(of: viewModel.query) { _, _ in
                    viewModel.onQueryChanged()
                }
            }
            
            // Muscle group filter
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text("Filter by Muscle Group")
                    .font(.headline)
                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                    .padding(.horizontal, DesignSystem.Spacing.large)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DesignSystem.Spacing.small) {
                        // "All" option
                        Button(action: {
                            viewModel.selectedMuscleGroup = ""
                            viewModel.onMuscleGroupChanged()
                        }) {
                            Text("All")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .padding(.horizontal, DesignSystem.Spacing.medium)
                                .padding(.vertical, DesignSystem.Spacing.small)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small)
                                        .fill(viewModel.selectedMuscleGroup.isEmpty ? 
                                              DesignSystem.Colors.primary : 
                                              DesignSystem.Colors.cardBackground(for: colorScheme))
                                )
                                .foregroundColor(viewModel.selectedMuscleGroup.isEmpty ? 
                                               .white : 
                                               DesignSystem.Colors.textPrimary(for: colorScheme))
                        }
                        
                        // Muscle group options
                        ForEach(ExerciseCatalog.shared.muscleGroups, id: \.self) { muscleGroup in
                            Button(action: {
                                viewModel.selectedMuscleGroup = muscleGroup
                                viewModel.onMuscleGroupChanged()
                            }) {
                                Text(muscleGroup.capitalized)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, DesignSystem.Spacing.medium)
                                    .padding(.vertical, DesignSystem.Spacing.small)
                                    .background(
                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small)
                                            .fill(viewModel.selectedMuscleGroup == muscleGroup ? 
                                                  DesignSystem.Colors.primary : 
                                                  DesignSystem.Colors.cardBackground(for: colorScheme))
                                    )
                                    .foregroundColor(viewModel.selectedMuscleGroup == muscleGroup ? 
                                                   .white : 
                                                   DesignSystem.Colors.textPrimary(for: colorScheme))
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.large)
                }
            }
        }
        .padding(.top, DesignSystem.Spacing.medium)
        .padding(.bottom, DesignSystem.Spacing.large)
    }
    
    // MARK: - Results List
    private var resultsList: some View {
        ScrollView {
            LazyVStack(spacing: DesignSystem.Spacing.small) {
                // Add padding between search and results
                Spacer()
                    .frame(height: DesignSystem.Spacing.medium)
                ForEach(viewModel.filtered) { archetype in
                    Button(action: {
                        viewModel.selectArchetype(archetype)
                        showingExerciseConfiguration = true
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(archetype.displayName)
                                    .font(.headline)
                                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                
                                // Show secondary muscles if available
                                if !archetype.secondaryMuscles.isEmpty {
                                    Text(archetype.secondaryMuscles.joined(separator: ", ").capitalized)
                                        .font(.caption)
                                        .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                                        .lineLimit(2)
                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        }
                        .padding(DesignSystem.Spacing.medium)
                        .background(
                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                .fill(DesignSystem.Colors.cardBackground(for: colorScheme))
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.large)
            .padding(.bottom, DesignSystem.Spacing.large)
        }
        .fullScreenCover(isPresented: $showingExerciseConfiguration) {
            ExerciseConfigurationView(
                viewModel: viewModel,
                workoutId: workoutId,
                onAdd: onAdd,
                onAddCircuit: onAddCircuit,
                isReplacing: isReplacing
            )
        }
    }

}

// MARK: - Preview
#Preview {
    AddExerciseView(
        workoutId: "preview",
        onAdd: { _ in },
        onAddCircuit: { _, _ in },
        isReplacing: false
    )
} 
