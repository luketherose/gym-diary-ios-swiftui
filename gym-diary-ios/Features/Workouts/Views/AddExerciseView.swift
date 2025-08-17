import SwiftUI

private enum BodyPart: String, CaseIterable, Identifiable {
    case chest, back, legs, shoulders, arms, core, glutes, other
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .chest: return "Chest"
        case .back: return "Back"
        case .legs: return "Legs"
        case .shoulders: return "Shoulders"
        case .arms: return "Arms"
        case .core: return "Core"
        case .glutes: return "Glutes"
        case .other: return "Other"
        }
    }
}

struct AddExerciseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var searchText = ""
    @State private var selectedExerciseName: String? = nil
    @State private var selectedVariants: Set<ExerciseVariant> = []
    @State private var note: String = ""
    @State private var variantEnabled: Bool = false
    @State private var notesEnabled: Bool = false
    @AppStorage("defaultRestTime") private var defaultRestTime: Int = 60
    @State private var selectedBodyPart: BodyPart? = nil
    @State private var selectedType: ExerciseCategory? = nil
    
    private let catalog: [String] = [
        "Bench Press", "Incline Bench Press", "Overhead Press",
        "Squat", "Deadlift", "Barbell Row", "Lat Pulldown",
        "Bicep Curl", "Tricep Pushdown", "Leg Press"
    ]
    
    private struct ExerciseMeta { let body: BodyPart; let type: ExerciseCategory }
    private let meta: [String: ExerciseMeta] = [
        "Bench Press": .init(body: .chest, type: .barbell),
        "Incline Bench Press": .init(body: .chest, type: .barbell),
        "Overhead Press": .init(body: .shoulders, type: .barbell),
        "Squat": .init(body: .legs, type: .barbell),
        "Deadlift": .init(body: .back, type: .barbell),
        "Barbell Row": .init(body: .back, type: .barbell),
        "Lat Pulldown": .init(body: .back, type: .machine),
        "Bicep Curl": .init(body: .arms, type: .dumbbells),
        "Tricep Pushdown": .init(body: .arms, type: .cable),
        "Leg Press": .init(body: .legs, type: .machine)
    ]
    
    private var filtered: [String] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        var items = catalog
        if let body = selectedBodyPart {
            items = items.filter { name in meta[name]?.body == body }
        }
        if let type = selectedType {
            items = items.filter { name in meta[name]?.type == type }
        }
        if q.isEmpty { return items }
        return items.filter { $0.localizedCaseInsensitiveContains(q) }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: DesignSystem.Spacing.large) {
                    TextField("Search exercises", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, DesignSystem.Spacing.large)
                    
                    // Filters
                    HStack(spacing: DesignSystem.Spacing.large) {
                        // Body Part
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Body Part")
                                .font(.headline)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            Menu {
                                Button("All") { selectedBodyPart = nil }
                                ForEach(BodyPart.allCases) { bp in
                                    Button(bp.displayName) { selectedBodyPart = bp }
                                }
                            } label: {
                                HStack {
                                    Text(selectedBodyPart?.displayName ?? "All")
                                    Image(systemName: "chevron.down")
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray5)))
                            }
                        }
                        // Type
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Type")
                                .font(.headline)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            Menu {
                                Button("All") { selectedType = nil }
                                ForEach(ExerciseCategory.allCases, id: \.self) { cat in
                                    Button(cat.displayName) { selectedType = cat }
                                }
                            } label: {
                                HStack {
                                    Text(selectedType?.displayName ?? "All")
                                    Image(systemName: "chevron.down")
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray5)))
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, DesignSystem.Spacing.large)
                    
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                            ForEach(filtered, id: \.self) { name in
                                Button(action: { selectedExerciseName = name }) {
                                    HStack {
                                        Text(name)
                                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                        Spacer()
                                        if selectedExerciseName == name {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(DesignSystem.Colors.primary)
                                        }
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.horizontal, DesignSystem.Spacing.large)
                                .padding(.vertical, 6)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        HStack {
                            Text("Variant")
                                .font(.headline)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            Spacer()
                            Picker("Variant Enabled", selection: $variantEnabled) {
                                Text("No").tag(false)
                                Text("Yes").tag(true)
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 140)
                        }
                        if variantEnabled {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(allowedVariants(), id: \.self) { v in
                                        let isSelected = selectedVariants.contains(v)
                                        Button(action: {
                                            if isSelected { selectedVariants.remove(v) } else { selectedVariants.insert(v) }
                                        }) {
                                            Text(v.displayName)
                                                .foregroundColor(isSelected ? .white : DesignSystem.Colors.textPrimary(for: colorScheme))
                                                .padding(8)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(isSelected ? DesignSystem.Colors.primary : Color(.systemGray5))
                                                )
                                        }
                                    }
                                }
                                .padding(.horizontal, 4)
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.large)
                    
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        HStack {
                            Text("Notes")
                                .font(.headline)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            Spacer()
                            Picker("Notes Enabled", selection: $notesEnabled) {
                                Text("No").tag(false)
                                Text("Yes").tag(true)
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 140)
                        }
                        if notesEnabled {
                            TextEditor(text: $note)
                                .frame(minHeight: 80)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                        .fill(DesignSystem.Colors.surfaceBackground(for: colorScheme))
                                )
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.large)
                    .padding(.bottom, DesignSystem.Spacing.large)
                }
            }
            .navigationTitle("Add Exercise")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") { finish() }
                        .disabled(selectedExerciseName == nil)
                }
            }
        }
        .onChange(of: variantEnabled) { enabled in
            if !enabled { selectedVariants.removeAll() }
        }
        .onChange(of: notesEnabled) { enabled in
            if !enabled { note = "" }
        }
    }
    
    private func allowedVariants() -> [ExerciseVariant] {
        let mapping: [String: [ExerciseVariant]] = [
            "Bench Press": [.flat, .incline, .decline, .wideGrip, .closeGrip, .reverseGrip],
            "Incline Bench Press": [.incline, .wideGrip, .closeGrip],
            "Overhead Press": [.standing, .seated, .pushPress],
            "Squat": [.front, .backHighbar, .backLowbar, .pause, .box, .goblet, .safetyBar],
            "Deadlift": [.conventional, .sumo, .rdl, .stiffLeg, .trapBar],
            "Barbell Row": [.wideGrip, .closeGrip, .reverseGrip, .neutralGrip],
            "Lat Pulldown": [.wideGrip, .closeGrip, .neutralGrip, .reverseGrip],
            "Bicep Curl": [.ezBar, .preacher, .seated, .standing],
            "Tricep Pushdown": [.rope, .cable, .reverseGrip],
            "Leg Press": [.pause]
        ]
        if let name = selectedExerciseName, let list = mapping[name] { return list }
        return ExerciseVariant.allCases
    }
    
    private func finish() {
        guard let name = selectedExerciseName else { return }
        let resolvedCategory = meta[name]?.type ?? selectedType ?? .other
        let exercise = Exercise(
            workoutId: "temp",
            name: name,
            category: resolvedCategory,
            variants: Array(selectedVariants),
            sets: [],
            order: 0,
            restTime: defaultRestTime,
            notes: notesEnabled ? (note.isEmpty ? nil : note) : nil
        )
        onAdd(exercise)
        dismiss()
    }
    
    let onAdd: (Exercise) -> Void
}


