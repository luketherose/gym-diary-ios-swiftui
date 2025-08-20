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
    
    private enum Mode { case add, edit }
    private let mode: Mode
    private let onAdd: ((Exercise) -> Void)?
    private let onAddCircuit: ((Circuit, [Exercise]) -> Void)? // NEW: Callback for circuit creation
    private let applyEdit: ((inout Exercise) -> Void)?
    @State private var searchText = ""
    @State private var selectedExerciseNames: Set<String> = [] // Multiple selection support
    @State private var selectedVariants: Set<ExerciseVariant> = []
    @State private var note: String = ""

    @State private var notesEnabled: Bool = false
    @AppStorage("defaultRestTime") private var defaultRestTime: Int = 60
    @State private var selectedBodyPart: BodyPart? = nil
    @State private var selectedType: ExerciseCategory = .dumbbells // Default type that will be prepended
    
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
        // Type is no longer a filter, it will be prepended to the exercise name
        if q.isEmpty { return items }
        return items.filter { $0.localizedCaseInsensitiveContains(q) }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Fixed header section
                    VStack(spacing: DesignSystem.Spacing.medium) {
                        TextField("Search exercises", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, DesignSystem.Spacing.large)
                        
                        // Selection info
                        HStack {
                            if !selectedExerciseNames.isEmpty {
                                Text("\(selectedExerciseNames.count) exercise\(selectedExerciseNames.count == 1 ? "" : "s") selected")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(DesignSystem.Colors.primary)
                            }
                            
                            Spacer()
                        }
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
                            // Type (now prepended to exercise name)
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Type")
                                    .font(.headline)
                                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                Menu {
                                    ForEach(ExerciseCategory.allCases, id: \.self) { cat in
                                        Button(cat.displayName) { selectedType = cat }
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedType.displayName)
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
                    }
                    .padding(.top, DesignSystem.Spacing.medium)
                    .padding(.bottom, DesignSystem.Spacing.small)
                    
                    // Main scrollable content
                    ScrollView {
                        VStack(spacing: DesignSystem.Spacing.large) {
                            // Exercise list
                            LazyVStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                                ForEach(filtered, id: \.self) { name in
                                    VStack(spacing: 0) {
                                        // Exercise selection button
                                        Button(action: {
                                            if selectedExerciseNames.contains(name) {
                                                selectedExerciseNames.remove(name)
                                            } else {
                                                selectedExerciseNames.insert(name)
                                            }
                                        }) {
                                            HStack {
                                                Text("\(selectedType.displayName) \(name)")
                                                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                                Spacer()
                                                // Show checkmark for selected exercise(s)
                                                if selectedExerciseNames.contains(name) {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .foregroundColor(DesignSystem.Colors.primary)
                                                }
                                            }
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        .padding(.horizontal, DesignSystem.Spacing.large)
                                        .padding(.vertical, 6)
                                        
                                        // Show variants directly under selected exercise
                                        if selectedExerciseNames.contains(name) {
                                            exerciseVariantSection(for: name)
                                        }
                                    }
                                }
                            }
                            
                            // Notes section
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                                HStack {
                                    HStack(spacing: 8) {
                                        Text("Notes")
                                            .font(.headline)
                                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                        Image(systemName: "pencil")
                                            .foregroundColor(.blue)
                                            .font(.caption)
                                    }
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
                                        .frame(minHeight: 120)
                                        .padding(12)
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
                }
            }
            .frame(maxHeight: .infinity)
            .navigationTitle(mode == .add ? "Add Exercise" : "Edit Exercise")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(mode == .add ? (selectedExerciseNames.count > 1 ? "Create Circuit" : "Add Exercise") : "Save") {
                        if mode == .add { finishAdd() } else { finishEdit() }
                    }
                    .disabled(selectedExerciseNames.isEmpty)
                }
            }
        }

        .onChange(of: notesEnabled) { oldValue, newValue in
            if !newValue { note = "" }
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
        // For now, return all variants since we're in multi-select mode
        // TODO: Implement variant filtering for selected exercises
        return ExerciseVariant.allCases
    }
    

    
    private func exerciseVariantSection(for exerciseName: String) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            // Variant selection
            HStack {
                Text("Variants")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                Spacer()
            }
            .padding(.horizontal, DesignSystem.Spacing.large)
            .padding(.top, 8)
            
            // Variant options
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    // None option (preselected)
                    let noneSelected = selectedVariants.isEmpty
                    
                    Button(action: {
                        selectedVariants.removeAll()
                    }) {
                        Text("None")
                            .foregroundColor(noneSelected ? .white : DesignSystem.Colors.textPrimary(for: colorScheme))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(noneSelected ? DesignSystem.Colors.primary : Color(.systemGray5))
                            )
                    }
                    
                    // Available variants
                    ForEach(allowedVariants(), id: \.self) { variant in
                        let isSelected = selectedVariants.contains(variant)
                        
                        Button(action: {
                            if isSelected {
                                selectedVariants.remove(variant)
                            } else {
                                selectedVariants.insert(variant)
                            }
                        }) {
                            Text(variant.displayName)
                                .foregroundColor(isSelected ? .white : DesignSystem.Colors.textPrimary(for: colorScheme))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(isSelected ? DesignSystem.Colors.primary : Color(.systemGray5))
                                )
                        }
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.large)
                .padding(.bottom, 8)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small)
                .fill(DesignSystem.Colors.surfaceBackground(for: colorScheme))
        )
        .padding(.horizontal, DesignSystem.Spacing.large)
        .padding(.bottom, 8)
    }
    
    private func finishAdd() {
        if selectedExerciseNames.count > 1 {
            // Create circuit with multiple exercises
            let exercises = selectedExerciseNames.map { name in
                let resolvedCategory = meta[name]?.type ?? selectedType ?? .other
                let fullName = "\(selectedType.displayName) \(name)"
                return Exercise(
                    workoutId: "temp",
                    name: fullName,
                    category: resolvedCategory,
                    variants: [], // No variants for circuit exercises
                    sets: [],
                    order: 0,
                    restTime: defaultRestTime,
                    notes: nil
                )
            }
            
            let circuit = Circuit(
                workoutId: "temp",
                exerciseIds: exercises.map { $0.id },
                order: 0
            )
            
            onAddCircuit?(circuit, exercises)
        } else {
            // Create single exercise
            let name = selectedExerciseNames.first!
            let resolvedCategory = meta[name]?.type ?? selectedType ?? .other
            let fullName = "\(selectedType.displayName) \(name)"
            let exercise = Exercise(
                workoutId: "temp",
                name: fullName,
                category: resolvedCategory,
                variants: Array(selectedVariants),
                sets: [],
                order: 0,
                restTime: defaultRestTime,
                notes: notesEnabled ? (note.isEmpty ? nil : note) : nil
            )
            onAdd?(exercise)
        }
        dismiss()
    }
    
    private func finishEdit() {
        guard var dummy = currentEditingExercise else { return }
        guard let name = selectedExerciseNames.first else { return }
        dummy.name = name
        dummy.variants = Array(selectedVariants)
        dummy.notes = notesEnabled ? (note.isEmpty ? nil : note) : nil
        var toApply = dummy
        applyEdit?(&toApply)
        dismiss()
    }
    
    // MARK: - Init
    init(onAdd: @escaping (Exercise) -> Void) {
        self.mode = .add
        self.onAdd = onAdd
        self.onAddCircuit = nil
        self.applyEdit = nil
        self._searchText = State(initialValue: "")
        self._selectedExerciseNames = State(initialValue: [])
        self._selectedVariants = State(initialValue: [])
        self._note = State(initialValue: "")

        self._notesEnabled = State(initialValue: false)
        self._selectedBodyPart = State(initialValue: nil)
        self._selectedType = State(initialValue: .dumbbells)
        self.currentEditingExercise = nil
    }
    
    init(onAddCircuit: @escaping (Circuit, [Exercise]) -> Void) {
        self.mode = .add
        self.onAdd = nil
        self.onAddCircuit = onAddCircuit
        self.applyEdit = nil
        self._searchText = State(initialValue: "")
        self._selectedExerciseNames = State(initialValue: [])
        self._selectedVariants = State(initialValue: [])
        self._note = State(initialValue: "")

        self._notesEnabled = State(initialValue: false)
        self._selectedBodyPart = State(initialValue: nil)
        self._selectedType = State(initialValue: .dumbbells)
        self.currentEditingExercise = nil
    }

    // New initializer that accepts both single exercise and circuit callbacks
    init(onAdd: @escaping (Exercise) -> Void,
         onAddCircuit: @escaping (Circuit, [Exercise]) -> Void) {
        self.mode = .add
        self.onAdd = onAdd
        self.onAddCircuit = onAddCircuit
        self.applyEdit = nil
        self._searchText = State(initialValue: "")
        self._selectedExerciseNames = State(initialValue: [])
        self._selectedVariants = State(initialValue: [])
        self._note = State(initialValue: "")

        self._notesEnabled = State(initialValue: false)
        self._selectedBodyPart = State(initialValue: nil)
        self._selectedType = State(initialValue: .dumbbells)
        self.currentEditingExercise = nil
    }
    
    init(exercise: Binding<Exercise>) {
        self.mode = .edit
        self.onAdd = nil
        self.onAddCircuit = nil
        self.applyEdit = { updated in
            exercise.wrappedValue.name = updated.name
            exercise.wrappedValue.variants = updated.variants
            exercise.wrappedValue.notes = updated.notes
        }
        let ex = exercise.wrappedValue
        self._searchText = State(initialValue: ex.name)
        self._selectedExerciseNames = State(initialValue: [ex.name])
        self._selectedVariants = State(initialValue: Set(ex.variants))
        self._note = State(initialValue: ex.notes ?? "")

        self._notesEnabled = State(initialValue: (ex.notes ?? "").isEmpty == false)
        self._selectedBodyPart = State(initialValue: nil)
        self._selectedType = State(initialValue: .dumbbells)
        self.currentEditingExercise = ex
    }
    
    // Stored just to snapshot original when entering edit
    private var currentEditingExercise: Exercise?
}



