import SwiftUI
import UniformTypeIdentifiers

// MARK: - Workout Item Enum
enum WorkoutItem: Identifiable {
    case exercise(Exercise, Int) // Exercise and its index
    case circuit(Circuit, [Exercise]) // Circuit and its exercises
    
    var id: String {
        switch self {
        case .exercise(let exercise, _):
            return exercise.id
        case .circuit(let circuit, _):
            return circuit.id
        }
    }
    
    var order: Int {
        switch self {
        case .exercise(let exercise, _):
            return exercise.order
        case .circuit(let circuit, _):
            return circuit.order
        }
    }
}

struct ExercisesListView: View {
    @Binding var workout: Workout
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingAddExercise = false
    @State private var editingExerciseIndex: Int? = nil
    @State private var collapsedExerciseIds: Set<String> = []
    
    enum ExerciseDragState: Equatable { case none, dragging, overIndex(Int) }
    @State private var exerciseDragState: ExerciseDragState = .none

    var body: some View {
        VStack(spacing: 0) {
            exercisesList
        }
        .sheet(isPresented: $showingAddExercise) { addExerciseSheet }
        .sheet(isPresented: Binding<Bool>(
            get: { editingExerciseIndex != nil },
            set: { if !$0 { editingExerciseIndex = nil } }
        )) { editExerciseSheet }
    }

    private var addExerciseSheet: some View {
        AddExerciseView(onAdd: { newExercise in
            // Single exercise path
            workout.exercises.append(newExercise)
            showingAddExercise = false
        }, onAddCircuit: { circuit, exercises in
            // Circuit path: append circuit and its exercises
            var circuitWithOrder = circuit
            circuitWithOrder.order = (workout.circuits.map { $0.order }.max() ?? workout.exercises.filter { !$0.isCircuit }.map { $0.order }.max() ?? -1) + 1
            workout.circuits.append(circuitWithOrder)
            
            // Add the circuit exercises to the workout with proper order
            let baseOrder = circuitWithOrder.order
            var orderCounter = baseOrder + 1
            let taggedExercises = exercises.map { ex -> Exercise in
                var e = ex
                e.circuitId = circuitWithOrder.id
                e.isCircuit = true
                e.order = orderCounter
                orderCounter += 1
                return e
            }
            workout.exercises.append(contentsOf: taggedExercises)
            showingAddExercise = false
        })
    }
    


    private var exercisesList: some View {
        VStack(spacing: 0) {
            ForEach(Array(combinedItems.enumerated()), id: \.element.id) { pair in
                let index = pair.offset
                let item = pair.element
                VStack(spacing: 0) {
                    // Top drop indicator
                    if case .overIndex(let i) = exerciseDragState, i == index {
                        Rectangle()
                            .fill(DesignSystem.Colors.primary)
                            .frame(height: 3)
                            .padding(.horizontal, DesignSystem.Spacing.small)
                            .transition(.scale.combined(with: .opacity))
                    }

                    // Row content
                    HStack(spacing: 0) {
                        switch item {
                        case .exercise(_, let eIdx):
                            exerciseSection(for: eIdx)
                        case .circuit(let circuit, let exercises):
                            circuitSection(for: circuit, exercises: exercises)
                        }
                    }
                    .background(Color.clear)
                    .onDrag {
                        exerciseDragState = .dragging
                        let provider = NSItemProvider()
                        let payload: String
                        switch item {
                        case .exercise(let ex, _):
                            payload = "ex:\(ex.id)"
                        case .circuit(let c, _):
                            payload = "ci:\(c.id)"
                        }
                        provider.registerDataRepresentation(forTypeIdentifier: UTType.plainText.identifier, visibility: .all) { completion in
                            completion(Data(payload.utf8), nil)
                            return nil
                        }
                        return provider
                    }
                    .onDrop(of: [.plainText], delegate: ExerciseDropDelegate(
                        toIndex: index,
                        onReorder: { fromPayload, toIndex in reorderItems(fromPayload: fromPayload, toIndex: toIndex) },
                        dragState: $exerciseDragState
                    ))
                }
            }

            // End-of-list indicator
            if case .overIndex(let i) = exerciseDragState, i == combinedItems.count {
                Rectangle()
                    .fill(DesignSystem.Colors.primary)
                    .frame(height: 3)
                    .padding(.horizontal, DesignSystem.Spacing.small)
                    .transition(.scale.combined(with: .opacity))
            }

            // End-of-list drop area
            Rectangle()
                .fill(Color.clear)
                .frame(height: 24)
                .onDrop(of: [.plainText], delegate: ExerciseDropDelegate(
                    toIndex: combinedItems.count,
                    onReorder: { fromPayload, toIndex in reorderItems(fromPayload: fromPayload, toIndex: toIndex) },
                    dragState: $exerciseDragState
                ))

            // Add Exercise button
            HStack {
                Spacer()
                Button { showingAddExercise = true } label: {
                    Label("Add Exercise", systemImage: "plus.circle.fill")
                }
                Spacer()
            }
            .padding(.vertical, DesignSystem.Spacing.medium)
        }
    }
    
    // Helper to reorder items given a payload and target index
    private func reorderItems(fromPayload payload: String, toIndex: Int) {
        // Build current linear sequence
        var sequence: [(type: String, id: String)] = combinedItems.map { item in
            switch item {
            case .exercise(let ex, _): return ("ex", ex.id)
            case .circuit(let c, _): return ("ci", c.id)
            }
        }
        // Find source index
        let parts = payload.split(separator: ":")
        guard parts.count == 2 else { exerciseDragState = .none; return }
        let type = String(parts[0])
        let id = String(parts[1])
        guard let fromIndex = sequence.firstIndex(where: { $0.type == type && $0.id == id }) else { exerciseDragState = .none; return }

        // Remove and insert
        let moving = sequence.remove(at: fromIndex)
        let clamped = max(0, min(toIndex, sequence.count))
        sequence.insert(moving, at: clamped)

        // Apply new sequential orders to model
        for (order, element) in sequence.enumerated() {
            if element.type == "ex" {
                if let idx = workout.exercises.firstIndex(where: { $0.id == element.id && !$0.isCircuit }) {
                    workout.exercises[idx].order = order
                }
            } else if element.type == "ci" {
                if let idx = workout.circuits.firstIndex(where: { $0.id == element.id }) {
                    workout.circuits[idx].order = order
                }
            }
        }
        exerciseDragState = .none
    }
    
    // Helper computed property to combine exercises and circuits in order
    private var combinedItems: [WorkoutItem] {
        var items: [WorkoutItem] = []
        
        // Add exercises that are not part of circuits
        for (index, exercise) in workout.exercises.enumerated() {
            if !exercise.isCircuit {
                items.append(.exercise(exercise, index))
            }
        }
        
        // Add circuits with their exercises
        for circuit in workout.circuits {
            let circuitExercises = workout.exercises.filter { $0.circuitId == circuit.id }
            items.append(.circuit(circuit, circuitExercises))
        }
        
        // Sort by order
        return items.sorted { item1, item2 in
            let order1 = item1.order
            let order2 = item2.order
            return order1 < order2
        }
    }
    
    private func circuitSection(for circuit: Circuit, exercises: [Exercise]) -> some View {
        Section {
            CircuitView(
                circuit: circuit, 
                exercises: exercises,
                onEdit: {
                    // TODO: Implement circuit editing
                },
                onDelete: {
                    // Remove circuit and its exercises
                    if let circuitIndex = workout.circuits.firstIndex(where: { $0.id == circuit.id }) {
                        workout.circuits.remove(at: circuitIndex)
                        // Remove exercises that belong to this circuit
                        workout.exercises.removeAll { $0.circuitId == circuit.id }
                    }
                },
                workout: $workout
            )
        }
    }

    private func exerciseSection(for eIdx: Int) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Exercise header
            HStack(spacing: 8) {
                let ex = workout.exercises[eIdx]
                let isCollapsed = collapsedExerciseIds.contains(ex.id)
                Button {
                    if isCollapsed { collapsedExerciseIds.remove(ex.id) } else { collapsedExerciseIds.insert(ex.id) }
                } label: {
                    Image(systemName: isCollapsed ? "chevron.right" : "chevron.down")
                        .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                }
                .buttonStyle(.plain)

                // Edit button (moved to left)
                Button {
                    editingExerciseIndex = eIdx
                } label: {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())

                Text(ex.variants.isEmpty ? ex.name : "\(ex.name) (\(ex.variants.map { $0.displayName }.joined(separator: ", ")))")
                    .font(.headline)
                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))

                Spacer()

                Button {
                    workout.exercises.remove(at: eIdx)
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.large)
            .padding(.vertical, DesignSystem.Spacing.medium)
            .background(DesignSystem.Colors.background(for: colorScheme))
            
            // Sets list
            if !collapsedExerciseIds.contains(workout.exercises[eIdx].id) {
            VStack(spacing: 0) {
                // Notes section (if any)
                if let notes = workout.exercises[eIdx].notes, !notes.isEmpty {
                    HStack {
                        Text(notes)
                            .font(.subheadline)
                            .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                            .italic()
                        Spacer()
                    }
                    .padding(.horizontal, DesignSystem.Spacing.large)
                    .padding(.vertical, DesignSystem.Spacing.small)
                    .background(Color(.systemGray6))
                }
                
                ForEach(Array(workout.exercises[eIdx].sets.enumerated()), id: \.offset) { sTuple in
                    let sIdx = sTuple.offset
                    VStack(spacing: 0) {
                        SetEditorRow(set: $workout.exercises[eIdx].sets[sIdx])
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    workout.exercises[eIdx].sets.remove(at: sIdx)
                                } label: { Label("Delete", systemImage: "trash") }
                            }
                        
                        if sIdx < workout.exercises[eIdx].sets.count - 1 {
                            Divider()
                                .padding(.horizontal, DesignSystem.Spacing.large)
                        }
                    }
                }
                
                // Add Set button (centered, transparent)
                Button {
                    let def = UserDefaults.standard.integer(forKey: "defaultRestTime")
                    let rest = def == 0 ? 60 : def
                    workout.exercises[eIdx].sets.append(
                        ExerciseSet(
                            exerciseId: workout.exercises[eIdx].id,
                            reps: 10,
                            weight: 0,
                            restTime: rest
                        )
                    )
                } label: {
                    Label("Add Set", systemImage: "plus.circle")
                        .foregroundColor(.blue)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignSystem.Spacing.medium)
                .background(Color.clear)
            }
            .background(DesignSystem.Colors.background(for: colorScheme))
            }
        }
        .background(DesignSystem.Colors.background(for: colorScheme))
        .cornerRadius(8)
        .padding(.horizontal, DesignSystem.Spacing.large)
        .padding(.vertical, DesignSystem.Spacing.small)
    }

    private func allowedVariants(for exercise: Exercise) -> [ExerciseVariant] {
        // Extract base exercise name (remove type prefix)
        let baseName = exercise.name.components(separatedBy: " ").dropFirst().joined(separator: " ")
        
        switch baseName {
        case "Bench Press": return [.flat, .incline, .decline, .wideGrip, .closeGrip, .reverseGrip]
        case "Incline Bench Press": return [.incline, .wideGrip, .closeGrip]
        case "Overhead Press": return [.standing, .seated, .pushPress]
        case "Squat": return [.front, .backHighbar, .backLowbar, .pause, .box, .goblet, .safetyBar]
        case "Deadlift": return [.conventional, .sumo, .rdl, .stiffLeg, .trapBar]
        case "Barbell Row": return [.wideGrip, .closeGrip, .reverseGrip, .neutralGrip]
        case "Lat Pulldown": return [.wideGrip, .closeGrip, .neutralGrip, .reverseGrip]
        case "Bicep Curl": return [.ezBar, .preacher, .seated, .standing]
        case "Tricep Pushdown": return [.rope, .cable, .reverseGrip]
        case "Leg Press": return [.pause]
        default: return ExerciseVariant.allCases
        }
    }

    private var addExerciseSection: some View {
        Section {
            HStack {
                Spacer()
                Button { showingAddExercise = true } label: {
                    Label("Add Exercise", systemImage: "plus.circle.fill")
                }
                Spacer()
            }
        }
    }

    // Edit sheet
    @ViewBuilder
    private var editExerciseSheet: some View {
        if let idx = editingExerciseIndex, idx < workout.exercises.count {
            AddExerciseView(exercise: $workout.exercises[idx])
        }
    }
}

// Local DropDelegate for exercises/circuits reordering
private struct ExerciseDropDelegate: DropDelegate {
    let toIndex: Int
    let onReorder: (_ fromPayload: String, _ toIndex: Int) -> Void
    @Binding var dragState: ExercisesListView.ExerciseDragState

    func performDrop(info: DropInfo) -> Bool {
        guard let itemProvider = info.itemProviders(for: [.plainText]).first else { return false }
        itemProvider.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { (data, _) in
            DispatchQueue.main.async {
                guard let data = data as? Data, let payload = String(data: data, encoding: .utf8) else { dragState = .none; return }
                onReorder(payload, toIndex)
            }
        }
        return true
    }

    func dropUpdated(info: DropInfo) -> DropProposal? { DropProposal(operation: .move) }

    func dropEntered(info: DropInfo) {
        withAnimation(.easeInOut(duration: 0.2)) { dragState = .overIndex(toIndex) }
    }

    func dropExited(info: DropInfo) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if case .overIndex(let i) = dragState, i == toIndex { dragState = .dragging }
        }
    }
}


