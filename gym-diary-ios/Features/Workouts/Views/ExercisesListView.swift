import SwiftUI

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
    @State private var showingAddCircuit = false
    @State private var editingExerciseIndex: Int? = nil

    var body: some View {
        VStack(spacing: 0) {
            exercisesList
        }
        .sheet(isPresented: $showingAddExercise) { addExerciseSheet }
        .sheet(isPresented: $showingAddCircuit) { addCircuitSheet }
        .sheet(isPresented: Binding<Bool>(
            get: { editingExerciseIndex != nil },
            set: { if !$0 { editingExerciseIndex = nil } }
        )) { editExerciseSheet }
    }

    private var addExerciseSheet: some View {
        AddExerciseView { newExercise in
            workout.exercises.append(newExercise)
        }
    }
    
    private var addCircuitSheet: some View {
        AddExerciseView(onAddCircuit: { exercises in
            // Create circuit and add exercises
            let circuitId = UUID().uuidString
            let circuit = Circuit(
                workoutId: workout.id,
                exerciseIds: exercises.map { $0.id },
                order: workout.exercises.count + workout.circuits.count
            )
            
            // Update exercises with circuit info
            var updatedExercises = exercises
            for i in 0..<updatedExercises.count {
                updatedExercises[i].circuitId = circuitId
                updatedExercises[i].order = i
            }
            
            // Add exercises and circuit to workout
            workout.exercises.append(contentsOf: updatedExercises)
            workout.circuits.append(circuit)
        })
    }

    private var exercisesList: some View {
        List {
            // Combine exercises and circuits in order
            ForEach(combinedItems, id: \.id) { item in
                switch item {
                case .exercise(_, let index):
                    exerciseSection(for: index)
                case .circuit(let circuit, let exercises):
                    circuitSection(for: circuit, exercises: exercises)
                }
            }
            addExerciseSection
        }
        .listStyle(.insetGrouped)
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
            CircuitView(circuit: circuit, exercises: exercises)
        }
    }

    private func exerciseSection(for eIdx: Int) -> some View {
        Section {
            ForEach(Array(workout.exercises[eIdx].sets.enumerated()), id: \.offset) { sTuple in
                let sIdx = sTuple.offset
                SetEditorRow(set: $workout.exercises[eIdx].sets[sIdx])
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            workout.exercises[eIdx].sets.remove(at: sIdx)
                        } label: { Label("Delete", systemImage: "trash") }
                    }
            }
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
            }
        } header: {
            HStack(spacing: 8) {
                let ex = workout.exercises[eIdx]
                Text(ex.variants.isEmpty ? ex.name : "\(ex.name) (\(ex.variants.map { $0.displayName }.joined(separator: ", "))) ")
                    .font(.headline)
                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                Spacer()
                Button {
                    editingExerciseIndex = eIdx
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
                Button {
                    workout.exercises.remove(at: eIdx)
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                }
            }
        }
    }

    private func allowedVariants(for exercise: Exercise) -> [ExerciseVariant] {
        switch exercise.name {
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
            VStack(spacing: DesignSystem.Spacing.small) {
                HStack {
                    Spacer()
                    Button { showingAddExercise = true } label: {
                        Label("Add Single Exercise", systemImage: "plus.circle.fill")
                    }
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Button { showingAddCircuit = true } label: {
                        Label("Create Circuit", systemImage: "figure.strengthtraining.traditional")
                            .foregroundColor(.orange)
                    }
                    Spacer()
                }
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


