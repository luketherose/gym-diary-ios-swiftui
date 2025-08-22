import SwiftUI

struct ExerciseConfigurationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: AddExerciseViewModel
    
    let workoutId: String
    let onAdd: (Exercise) -> Void
    let onAddCircuit: (Circuit, [Exercise]) -> Void
    let isReplacing: Bool
    
    private var navigationTitle: String {
        let action = isReplacing ? "Substitute" : "Add"
        if let exerciseName = viewModel.selectedArchetype?.displayName {
            return "\(action) Exercise \"\(exerciseName)\""
        } else {
            return "\(action) Exercise"
        }
    }
    
    var body: some View {
        ZStack {
            DesignSystem.Colors.background(for: colorScheme)
                .ignoresSafeArea()
            
            // Exercise configuration layout
            exerciseConfigurationView
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)

    }
    
    // MARK: - Exercise Configuration View
    private var exerciseConfigurationView: some View {
        VStack(spacing: 0) {
            // Scrollable attributes section
            ScrollView {
                attributesSection
                    .padding(.top, DesignSystem.Spacing.large)
                    .padding(.bottom, DesignSystem.Spacing.large)
            }
            
            // Fixed preview at bottom taking full width
            previewSection
                .background(DesignSystem.Colors.background(for: colorScheme))
        }
    }

    
    // MARK: - Attributes Section
    private var attributesSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            Text("Attributes")
                .font(.headline)
                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                .padding(.horizontal, DesignSystem.Spacing.large) // Padding for the title
            
            if let archetype = viewModel.selectedArchetype {
                LazyVStack(spacing: 0) {
                    ForEach(archetype.allowedAttributes, id: \.self) { attrKey in
                        if let attribute = ExerciseCatalog.shared.attributes.first(where: { $0.key == attrKey }) {
                            attributeField(for: attribute)
                        }
                    }
                    
                    // Add Exercise button at the end of attributes - centered with modal styling
                    VStack(spacing: 0) {
                        // Separator line before button
                        Divider()
                            .padding(.horizontal, DesignSystem.Spacing.large)
                        
                        // Centered Add Exercise button
                        GradientButton(
                            title: "Add Exercise",
                            gradient: LinearGradient(colors: [DesignSystem.Colors.primary, DesignSystem.Colors.primary.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        ) {
                            addExercise()
                        }
                        .padding(.horizontal, DesignSystem.Spacing.large)
                        .padding(.vertical, DesignSystem.Spacing.medium)
                    }
                }
                .background(DesignSystem.Colors.cardBackground(for: colorScheme))
                .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium))
                .padding(.horizontal, DesignSystem.Spacing.large)
            }
        }
    }
    
    // MARK: - Attribute Field
    private func attributeField(for attribute: AttributeDef) -> some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    // Show "Single Side" for single arm/leg attributes
                    let displayName = (attribute.key == "is_single_arm" || attribute.key == "is_single_leg") ? 
                        "Single Side" : 
                        attribute.key.replacingOccurrences(of: "_", with: " ").capitalized
                    
                    Text(displayName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                    
                    if attribute.type == "enum", let values = attribute.values {
                        let currentValue = viewModel.selectedAttrs[attribute.key] as? String ?? values.first ?? ""
                        // Special formatting for single side attributes
                        let displayValue = if attribute.key == "is_single_arm" || attribute.key == "is_single_leg" {
                            currentValue.capitalized
                        } else {
                            currentValue.replacingOccurrences(of: "_", with: " ").capitalized
                        }
                        Text(displayValue)
                            .font(.caption)
                            .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                    }
                }
                
                Spacer()
                
                if attribute.type == "boolean" {
                    Toggle("", isOn: Binding(
                        get: { viewModel.selectedAttrs[attribute.key] as? Bool ?? false },
                        set: { viewModel.onToggle(key: attribute.key, value: $0) }
                    ))
                    .toggleStyle(SwitchToggleStyle(tint: DesignSystem.Colors.primary))
                } else if attribute.type == "enum", let values = attribute.values {
                    // Special handling for single side attributes - use toggle instead of picker
                    if attribute.key == "is_single_arm" || attribute.key == "is_single_leg" {
                        Toggle("", isOn: Binding(
                            get: { 
                                let currentValue = viewModel.selectedAttrs[attribute.key] as? String ?? "no"
                                return currentValue == "yes"
                            },
                            set: { isOn in
                                viewModel.onPick(key: attribute.key, value: isOn ? "yes" : "no")
                            }
                        ))
                        .toggleStyle(SwitchToggleStyle(tint: DesignSystem.Colors.primary))
                        .disabled(viewModel.allowedValues(for: attribute.key).isEmpty)
                    } else {
                        Picker("", selection: Binding(
                            get: { viewModel.selectedAttrs[attribute.key] as? String ?? values.first ?? "" },
                            set: { viewModel.onPick(key: attribute.key, value: $0) }
                        )) {
                            ForEach(viewModel.allowedValues(for: attribute.key), id: \.self) { value in
                                Text(value.replacingOccurrences(of: "_", with: " ").capitalized)
                                    .tag(value)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .disabled(viewModel.allowedValues(for: attribute.key).isEmpty)
                    }
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.large)
            .padding(.vertical, DesignSystem.Spacing.medium)
            
            // Separator line (except for last item)
            if let archetype = viewModel.selectedArchetype,
               let currentIndex = archetype.allowedAttributes.firstIndex(of: attribute.key),
               currentIndex < archetype.allowedAttributes.count - 1 {
                Divider()
                    .padding(.horizontal, DesignSystem.Spacing.large)
            }
        }
    }
    
    // MARK: - Preview Section
    private var previewSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            Text("Preview")
                .font(.headline)
                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                .frame(maxWidth: .infinity, alignment: .center)
            
            CardContainer {
                VStack(alignment: .center, spacing: DesignSystem.Spacing.small) {
                    Text(viewModel.previewName)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.horizontal, DesignSystem.Spacing.large)
                .padding(.vertical, DesignSystem.Spacing.medium)
            }
        }
    }
    
    // MARK: - Actions
    private func addExercise() {
        guard let exercise = viewModel.createExercise(workoutId: workoutId) else { return }
        
        onAdd(exercise)
        dismiss()
    }
}

// MARK: - Preview
#Preview {
    let viewModel = AddExerciseViewModel()
    NavigationView {
        ExerciseConfigurationView(
            viewModel: viewModel,
            workoutId: "preview",
            onAdd: { _ in },
            onAddCircuit: { _, _ in },
            isReplacing: false
        )
    }
}
