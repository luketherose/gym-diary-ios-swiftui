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
    private let onAddCircuit: (([Exercise]) -> Void)? // NEW: Callback for circuit creation
    private let applyEdit: ((inout Exercise) -> Void)?
    @State private var searchText = ""
    @State private var selectedExerciseName: String? = nil
    @State private var selectedVariants: Set<ExerciseVariant> = []
    @State private var note: String = ""
    @State private var variantEnabled: Bool = false
    @State private var notesEnabled: Bool = false
    @State private var isCircuitMode: Bool = false // NEW: Circuit mode toggle
    @State private var selectedExercises: Set<String> = [] // NEW: Multi-selection for circuits
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
                    
                    // Circuit Mode Toggle
                    HStack {
                        Text("Mode")
                            .font(.headline)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        Spacer()
                        Picker("Circuit Mode", selection: $isCircuitMode) {
                            Text("Single Exercise").tag(false)
                            Text("Circuit").tag(true)
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 200)
                    }
                    .padding(.horizontal, DesignSystem.Spacing.large)
                    
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                            ForEach(filtered, id: \.self) { name in
                                Button(action: {
                                    if isCircuitMode {
                                        // Multi-selection for circuits
                                        if selectedExercises.contains(name) {
                                            selectedExercises.remove(name)
                                        } else {
                                            selectedExercises.insert(name)
                                        }
                                    } else {
                                        // Single selection for exercises
                                        selectedExerciseName = name
                                    }
                                }) {
                                    HStack {
                                        Text(name)
                                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                        Spacer()
                                        if isCircuitMode {
                                            // Show checkmark for selected exercises in circuit mode
                                            if selectedExercises.contains(name) {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.orange)
                                            }
                                        } else {
                                            // Show checkmark for selected exercise in single mode
                                            if selectedExerciseName == name {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(DesignSystem.Colors.primary)
                                            }
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
            .navigationTitle(mode == .add ? (isCircuitMode ? "Add Circuit" : "Add Exercise") : "Edit Exercise")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(mode == .add ? (isCircuitMode ? "Create Circuit" : "Add Exercise") : "Save") {
                        if mode == .add { finishAdd() } else { finishEdit() }
                    }
                    .disabled(isCircuitMode ? selectedExercises.isEmpty : selectedExerciseName == nil)
                }
            }
        }
        .onChange(of: variantEnabled) { oldValue, newValue in
            if !newValue { selectedVariants.removeAll() }
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
        if let name = selectedExerciseName, let list = mapping[name] { return list }
        return ExerciseVariant.allCases
    }
    
    private func finishAdd() {
        if isCircuitMode {
            // Create circuit with multiple exercises
            let circuitExercises = selectedExercises.compactMap { name -> Exercise? in
                let resolvedCategory = meta[name]?.type ?? selectedType ?? .other
                return Exercise(
                    workoutId: "temp",
                    name: name,
                    category: resolvedCategory,
                    variants: [], // No variants for circuit exercises initially
                    sets: [],
                    order: 0,
                    restTime: defaultRestTime,
                    notes: nil,
                    isCircuit: true,
                    circuitId: UUID().uuidString // Temporary ID, will be updated when added to workout
                )
            }
            onAddCircuit?(circuitExercises)
        } else {
            // Create single exercise
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
            onAdd?(exercise)
        }
        dismiss()
    }
    
    private func finishEdit() {
        guard var dummy = currentEditingExercise else { return }
        guard let name = selectedExerciseName else { return }
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
        self._selectedExerciseName = State(initialValue: nil)
        self._selectedVariants = State(initialValue: [])
        self._note = State(initialValue: "")
        self._variantEnabled = State(initialValue: false)
        self._notesEnabled = State(initialValue: false)
        self._isCircuitMode = State(initialValue: false)
        self._selectedExercises = State(initialValue: [])
        self._selectedBodyPart = State(initialValue: nil)
        self._selectedType = State(initialValue: nil)
        self.currentEditingExercise = nil
    }
    
    init(onAddCircuit: @escaping ([Exercise]) -> Void) {
        self.mode = .add
        self.onAdd = nil
        self.onAddCircuit = onAddCircuit
        self.applyEdit = nil
        self._searchText = State(initialValue: "")
        self._selectedExerciseName = State(initialValue: nil)
        self._selectedVariants = State(initialValue: [])
        self._note = State(initialValue: "")
        self._variantEnabled = State(initialValue: false)
        self._notesEnabled = State(initialValue: false)
        self._isCircuitMode = State(initialValue: true) // Start in circuit mode
        self._selectedExercises = State(initialValue: [])
        self._selectedBodyPart = State(initialValue: nil)
        self._selectedType = State(initialValue: nil)
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
        self._selectedExerciseName = State(initialValue: ex.name)
        self._selectedVariants = State(initialValue: Set(ex.variants))
        self._note = State(initialValue: ex.notes ?? "")
        self._variantEnabled = State(initialValue: !ex.variants.isEmpty)
        self._notesEnabled = State(initialValue: (ex.notes ?? "").isEmpty == false)
        self._isCircuitMode = State(initialValue: false)
        self._selectedExercises = State(initialValue: [])
        self._selectedBodyPart = State(initialValue: nil)
        self._selectedType = State(initialValue: nil)
        self.currentEditingExercise = ex
    }
    
    // Stored just to snapshot original when entering edit
    private var currentEditingExercise: Exercise?
}


